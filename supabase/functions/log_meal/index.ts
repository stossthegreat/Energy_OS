import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY  = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const json=(s:number,d:unknown)=>new Response(JSON.stringify(d),{status:s,headers:{
  "Content-Type":"application/json","Access-Control-Allow-Origin":"*"}});

Deno.serve(async req=>{
  if (req.method==="OPTIONS") return new Response(null,{headers:{
    "Access-Control-Allow-Origin":"*",
    "Access-Control-Allow-Headers":"authorization, x-client-info, apikey, content-type",
    "Access-Control-Allow-Methods":"POST, OPTIONS"}});

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

    const body = await req.json();
    const row = {
      user_id: u.id,
      at: body.at || new Date().toISOString(),
      title: body.title || body.recipe_title || null,
      photo_url: body.photo_url || null,
      calories: body.calories ?? null,
      protein_g: body.protein_g ?? null,
      carbs_g: body.carbs_g ?? null,
      fat_g: body.fat_g ?? null,
      macros: body.macros || {},
      source: body.source || "manual"
    };

    const { data: inserted, error } = await admin.from("meals").insert(row).select().single();
    if (error) return json(500,{error:error.message});

    // Fire-and-forget recalc (service role → call energy_update)
    const fu = `${SUPABASE_URL}/functions/v1/energy_update`;
    fetch(fu,{method:"POST",headers:{
      Authorization:`Bearer ${SERVICE_KEY}`,
      "Content-Type":"application/json"
    },body:JSON.stringify({source:"meal"})}).catch(()=>{});

    return json(200, inserted);
  }catch(e){ return json(500,{error:(e as Error).message});}
});

