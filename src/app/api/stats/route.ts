
import { OCItems, OCStats } from "@/types/oc";
import { CPUItem, CPURow, ParsedCPURow } from "@/types/supabase";
import { clean } from "@/util/supabase/clean";
import { createAdminClient } from "@/util/supabase/service_worker";
import { NextRequest, NextResponse } from "next/server";

function mapStringToItems(string: string): CPUItem[] {
    if (!string) return [];
    if (string == '') return [];

    // form = "item_name~quantity;"
    const items = string.split(";")?.map(item => {
        const [item_name, quantity] = item.split("~");
        return { item_name, quantity: parseInt(quantity) };
    }) ?? [];

    return items.filter(i => i.item_name);
}

export async function POST(req: NextRequest, res: NextResponse) {
    try {
        const body: OCStats = await req.json();

        const cpus = body.cpus;
        const avg_power_injection = body.avgPowerInjection;
        const stored_power = body.storedPower;
        const avg_power_use = body.avgPowerUsage;

        const client = await createAdminClient();

        const insert = await client.from("inserts").insert({ type: "stats" }).select("id");
        if (!insert.data) {
            return NextResponse.json('Failed to create insert', { status: 500 });
        }

        const insert_id = insert.data[0].id;

        await client.from("stats").insert({ avg_power_injection, stored_power, avg_power_use, insert_id });

        // truncate cpus
        await client.from("cpus").delete().neq("id", -1)

        // insert cpus
        await client.from("cpus").insert(cpus.map(cpu => ({
            name: cpu.name,
            busy: cpu.busy,
            final_output: typeof cpu.finalOutput === "string" ? mapStringToItems(cpu.finalOutput)[0] : cpu.finalOutput,
            pending_items: typeof cpu.pendingItems === "string" ? mapStringToItems(cpu.pendingItems) : cpu.pendingItems,
            active_items: typeof cpu.activeItems === "string" ? mapStringToItems(cpu.activeItems) : cpu.activeItems,
            stored_items: typeof cpu.storedItems === "string" ? mapStringToItems(cpu.storedItems) : cpu.storedItems,
            storage: cpu.storage,
        })));

        try {
            await clean()
        } catch(e) {
            console.error(e);
        }

        return NextResponse.json('ok');
    } catch(e: any) {
        return NextResponse.json(e?.message, { status: 500 });
    }
}
