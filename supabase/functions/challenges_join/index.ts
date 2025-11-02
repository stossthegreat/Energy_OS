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
    const action=body.action || "join"; // 'join' | 'checkin' | 'leaderboard'
    const challenge_id=body.challenge_id;

    if(action==="join"){
      const { data: joined, error } = await admin.from("challenge_entries").insert({
        challenge_id, user_id:u.id, progress:{}, score:0
      }).select().single();
      if (error) return json(500,{error:error.message});
      return json(200, joined);
    }

    if(action==="checkin"){
      // minimal scoring example: +1 per day if energy > 50 and 1 meal logged
      const today = new Date().toISOString().slice(0,10);

      // count today's meals
      const start = new Date(); start.setHours(0,0,0,0);
      const { data: meals } = await admin.from("meals").select("id").eq("user_id", u.id).gte("at", start.toISOString());
      // pull current energy
      const { data: usr } = await admin.from("users").select("energy_level").eq("id", u.id).single();
      const passed = (usr?.energy_level ?? 0) >= 50 && (meals?.length ?? 0) >= 1;

      const { data: entry, error: e1 } = await admin.from("challenge_entries")
        .select("id,progress,score").eq("challenge_id", challenge_id).eq("user_id", u.id).single();
      if (e1) return json(500,{error:e1.message});

      const progress = entry.progress || {};
      if (!progress[today]) progress[today] = { passed, meals: meals?.length ?? 0, energy: usr?.energy_level ?? null };
      const score = Number(entry.score || 0) + (passed ? 1 : 0);

      const { data: upd, error: e2 } = await admin.from("challenge_entries")
        .update({ progress, score }).eq("id", entry.id).select().single();
      if (e2) return json(500,{error:e2.message});
      return json(200, upd);
    }

    if(action==="leaderboard"){
      const { data: rows, error } = await admin
        .from("challenge_entries")
        .select("user_id,score")
        .eq("challenge_id", challenge_id)
        .order("score",{ascending:false})
        .limit(100);
      if (error) return json(500,{error:error.message});
      return json(200, rows);
    }

    return json(400,{error:"unknown action"});
  }catch(e){return json(500,{error:(e as Error).message});}
});

