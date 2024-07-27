create table
    public.auth (
        id bigint generated by default as identity,
        created_at timestamp with time zone not null default now(),
        username text not null,
        constraint auth_pkey primary key (id)
    ) tablespace pg_default;



create table
    public.craftables (
        id bigint generated by default as identity,
        created_at timestamp with time zone not null default now(),
        item_name text not null,
        to_delete boolean not null default false,
        constraint craftables_pkey primary key (id)
    ) tablespace pg_default;

create table
    public.crafts (
        id bigint generated by default as identity,
        created_at timestamp with time zone not null default now(),
        ended_at timestamp with time zone null,
        started_by text null,
        save boolean not null default false,
        item_name text not null,
        quantity bigint not null,
        instruction_id bigint null,
        cpu_name text not null,
        constraint crafts_pkey primary key (id)
    ) tablespace pg_default;

create table
    public.inserts (
    id bigint generated by default as identity,
    created_at timestamp with time zone not null default now(),
    type text null,
    constraint insert_pkey primary key (id)
) tablespace pg_default;

create table
    public.cpus (
        id bigint generated by default as identity,
        name text not null,
        pending_items jsonb not null,
        stored_items jsonb not null,
        active_items jsonb not null,
        busy boolean not null,
        storage bigint not null,
        final_output jsonb null,
        insert_id bigint null,
        constraint cpus_pkey primary key (id),
        constraint cpus_insert_id_fkey foreign key (insert_id) references inserts (id) on delete cascade
    ) tablespace pg_default;

create index if not exists inserts_id_idx on public.inserts using btree (id) tablespace pg_default;

create table
        public.instructions (
        id bigint generated by default as identity,
        created_at timestamp with time zone not null default now(),
        updated_at timestamp with time zone not null default now(),
        sent_by text not null,
        status text not null,
        type text not null,
        data jsonb not null,
        message text null,
        started_at timestamp with time zone null,
        ended_at timestamp with time zone null,
        constraint instructions_pkey primary key (id)
    ) tablespace pg_default;

create table
    public.item_crafting_status (
        id bigint generated by default as identity,
        created_at timestamp with time zone not null default now(),
        item_name text not null,
        active_count bigint not null,
        pending_count bigint not null,
        stored_count bigint not null,
        craft_id bigint not null,
        constraint item_crafting_status_pkey primary key (id),
        constraint item_crafting_status_craft_id_fkey foreign key (craft_id) references crafts (id) on update cascade on delete cascade
    ) tablespace pg_default;

create table
    public.items (
        id integer generated by default as identity,
        quantity bigint not null default '0'::bigint,
        item_name text not null,
        insert_id bigint not null,
        constraint Items_pkey primary key (id),
        constraint items_insert_id_fkey foreign key (insert_id) references inserts (id) on delete cascade
    ) tablespace pg_default;

create index if not exists items_item_name_idx on public.items using btree (item_name) tablespace pg_default;

create table
    public.mc_auth (
        id bigint generated by default as identity,
        created_at timestamp with time zone not null default now(),
        uid uuid not null,
        username text not null,
        constraint mc_auth_pkey primary key (id)
    ) tablespace pg_default;

create table
    public.stats (
        id bigint generated by default as identity,
        tps double precision not null,
        mspt double precision not null,
        eu text not null,
        insert_id bigint not null,
        "euIn" double precision not null,
        "euOut" double precision not null,
        constraint stats_pkey primary key (id),
        constraint stats_insert_id_fkey foreign key (insert_id) references inserts (id) on delete cascade
    ) tablespace pg_default;

CREATE POLICY "Enable read access for all users"
ON "public"."cpus"
TO public
USING ( true );

CREATE POLICY "Enable read access for all users"
ON "public"."craftables"
TO public
USING ( true );

CREATE POLICY "Allow updates if user's uid is whitelisted"
ON "public"."crafts"
TO authenticated
USING ( (EXISTS ( SELECT 1
FROM (mc_auth
    JOIN auth ON ((mc_auth.username = auth.username)))
WHERE (mc_auth.uid = (((auth.jwt() -> 'user_metadata'::text) ->> 'uid'::text))::uuid))) );

CREATE POLICY "Enable read access for all users"
ON "public"."crafts"
TO public
USING ( true );

CREATE POLICY "Enable read access for all users"
ON "public"."inserts"
TO public
USING ( true );

CREATE POLICY "Enable read access for all users"
ON "public"."instructions"
TO public
USING ( true );

CREATE POLICY "Enable read access for all users"
ON "public"."item_crafting_status"
TO public
USING ( true );

CREATE POLICY "Enable read access for all users"
ON "public"."items"
TO public
USING ( true );


CREATE POLICY "Enable read access for all users"
ON "public"."mc_auth"
TO public
USING ( true );

CREATE POLICY "Enable read access for all users"
ON "public"."stats"
TO public
USING ( true );