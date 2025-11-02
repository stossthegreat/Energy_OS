import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";
const SUPABASE_URL=Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY =Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const json=(s:number,d:unknown)=>new Response(JSON.stringify(d),{status:s,headers:{"Content-Type":"application/json"}});

// Add your admin check here if needed (e.g., users table 'is_admin' boolean)

Deno.serve(async req=>{
  try{
    if(req.method!=="POST") return json(405,{error:"POST only"});
    const token=req.headers.get("Authorization")?.replace("Bearer ","");
    if(!token) return json(401,{error:"no auth"});
    const authed=createClient(SUPABASE_URL, token);
    const { data: au } = await authed.auth.getUser();
    if(!au?.user) return json(401,{error:"invalid auth"});
    const admin=createClient(SUPABASE_URL, SERVICE_KEY);

    const body=await req.json();
    const row={
      name: body.name,
      mode: body.mode || null,
      duration_days: body.duration_days || 7,
      starts_at: body.starts_at || new Date().toISOString(),
      max_participants: body.max_participants || null,
      rules: body.rules || {}
    };
    const { data: challenge, error } = await admin.from("challenges").insert(row).select().single();
    if (error) return json(500,{error:error.message});
    return json(200, challenge);
  }catch(e){return json(500,{error:(e as Error).message});}
});

