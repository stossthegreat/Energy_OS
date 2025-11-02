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
    const type=body.type || "mode";
    const message=body.message || "";
    const emoji=body.emoji || null;
    const is_public= body.is_public !== false;

    const { data: post, error } = await admin.from("community_feed").insert({
      user_id:u.id, type, message, emoji, is_public
    }).select().single();
    if (error) return json(500,{error:error.message});

    return json(200, post);
  }catch(e){return json(500,{error:(e as Error).message});}
});

