import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL=Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY =Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const OS_APP      =Deno.env.get("ONESIGNAL_APP_ID")!;
const OS_KEY      =Deno.env.get("ONESIGNAL_REST_API_KEY")!;

const json=(s:number,d:unknown)=>new Response(JSON.stringify(d),{status:s,headers:{"Content-Type":"application/json"}});

Deno.serve(async _req=>{
  try{
    const admin=createClient(SUPABASE_URL, SERVICE_KEY);
    // pull users with low energy in last hour
    const since = new Date(Date.now()-60*60*1000).toISOString();
    const { data: logs } = await admin.rpc("get_low_energy_users", { since_ts: since }).catch(async ()=>{
      // create the RPC if not exists
      await admin.rpc("create_low_energy_rpc").catch(()=>{});
      return { data: [] as any[] };
    });

    // logs = [{ user_id, energy_level }]
    const targets = logs || [];
    for (const t of targets) {
      // You must map user->device/player IDs in your app; here we assume external_user_id is auth_id
      await fetch("https://api.onesignal.com/notifications",{
        method:"POST",
        headers:{ "Content-Type":"application/json", "Authorization":`Basic ${OS_KEY}` },
        body: JSON.stringify({
          app_id: OS_APP,
          include_external_user_ids: [String(t.user_id)],
          headings: { en: "Low Energy" },
          contents: { en: "Quick reset? 5-min breathing or a protein snack can bump your curve." }
        })
      }).catch(()=>{});
    }
    return json(200,{sent: targets.length});
  }catch(e){return json(500,{error:(e as Error).message});}
});

