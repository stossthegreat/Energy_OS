import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL=Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY =Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const json=(s:number,d:unknown)=>new Response(JSON.stringify(d),{status:s,headers:{"Content-Type":"application/json"}});

Deno.serve(async req=>{
  try{
    if(req.method!=="POST") return json(405,{error:"POST only"});
    const token=req.headers.get("Authorization")?.replace("Bearer ","");
    if(!token) return json(401,{error:"no auth"});
    const authed=createClient(SUPABASE_URL, token);
    const { data: au } = await authed.auth.getUser();
    if(!au?.user) return json(401,{error:"invalid auth"});
    const admin=createClient(SUPABASE_URL, SERVICE_KEY);
    const { data: u } = await admin.from("users").select("id").eq("auth_id", au.user.id).single();
    if(!u) return json(403,{error:"profile missing"});

    const body=await req.json();
    const row={
      user_id:u.id,
      at: body.at || new Date().toISOString(),
      type: body.type || "strength",
      intensity_rpe: body.intensity_rpe ?? 6,
      duration_min: body.duration_min ?? 45,
      notes: body.notes || null
    };

    const { data: ins, error } = await admin.from("workouts").insert(row).select().single();
    if (error) return json(500,{error:error.message});

    // trigger energy update
    const fu = `${SUPABASE_URL}/functions/v1/energy_update`;
    fetch(fu,{method:"POST",headers:{Authorization:`Bearer ${SERVICE_KEY}`,"Content-Type":"application/json"},body:JSON.stringify({source:"training"})}).catch(()=>{});

    return json(200, ins);
  }catch(e){return json(500,{error:(e as Error).message});}
});

