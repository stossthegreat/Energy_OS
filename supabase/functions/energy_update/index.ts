import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const json = (s: number, d: unknown) =>
  new Response(JSON.stringify(d), {
    status: s,
    headers: { "Content-Type": "application/json" },
  });

Deno.serve(async (req) => {
  try {
    const body = await req.json();
    const source = body.source || "recalc";

    const admin = createClient(SUPABASE_URL, SERVICE_KEY);

    // Get all users (or specific user if token provided)
    const token = req.headers.get("Authorization")?.replace("Bearer ", "");
    let targetUsers = [];

    if (token) {
      // User-specific recalc
      const authed = createClient(SUPABASE_URL, token);
      const { data: au } = await authed.auth.getUser();
      if (au?.user) {
        const { data: u } = await admin
          .from("users")
          .select("id")
          .eq("auth_id", au.user.id)
          .single();
        if (u) targetUsers = [u];
      }
    } else {
      // Recalc all users (for cron)
      const { data: users } = await admin.from("users").select("id");
      targetUsers = users || [];
    }

    // Call the SQL recalc function for each user
    for (const user of targetUsers) {
      await admin.rpc("recalc_energy", { user_uuid: user.id });
    }

    return json(200, { updated: targetUsers.length, source });
  } catch (e) {
    return json(500, { error: (e as Error).message });
  }
});

