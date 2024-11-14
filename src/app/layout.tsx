import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { ThemeProvider } from "next-themes";
import { ModeToggle } from "@/components/dark";
import Link from "next/link";
import cn from 'classnames';
import { Toaster } from "@/components/ui/sonner";
import dynamic from "next/dynamic";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
    title: "Toadbox AE2 Stats",
    description: "A website for viewing AE2 stats for the Box of Toads",
};

const DynamicAuth = dynamic(() => import('@/components/auth'), {
    ssr: false,
});

export default function RootLayout({
    children,
}: Readonly<{
    children: React.ReactNode;
}>) {
    return (
        <html lang="en">
            <body className={cn(inter.className, '')}>
                <ThemeProvider
                    attribute="class"
                    defaultTheme="system"
                    enableSystem
                    disableTransitionOnChange
                >
                    <main className="flex flex-col gap-8 py-24 container mx-auto min-h-screen">
                        <header className="flex justify-between flex-wrap gap-x-8 gap-y-2">
                            <Link href="/">
                                <h1 className="font-bold text-2xl">Box of Toads AE2 Status</h1>
                            </Link>
                            <ModeToggle />
                        </header>

                        <div className="flex flex-col gap-8 flex-grow">
                            <DynamicAuth />

                            {children}
                        </div>

                        <footer className="flex flex-col gap-4">
                            <a href="https://github.com/nzbasic" className="hover:underline">by nzbasic</a>
                            <a href="https://github.com/nzbasic/GTNH-AE2-OC-GOG" className="hover:underline">View on GitHub</a>
                            <p className="font-bold py-4">NOT AN OFFICIAL MINECRAFT SERVICE. NOT APPROVED BY OR ASSOCIATED WITH MOJANG OR MICROSOFT.</p>
                        </footer>

                        <Toaster richColors />
                    </main>
                </ThemeProvider>
            </body>
        </html>
    );
}
