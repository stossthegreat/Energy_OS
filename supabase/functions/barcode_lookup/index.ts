import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY  = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const NUT_ID       = Deno.env.get("NUTRITIONIX_APP_ID")!;
const NUT_KEY      = Deno.env.get("NUTRITIONIX_API_KEY")!;

const json=(s:number,d:unknown)=>new Response(JSON.stringify(d),{status:s,headers:{"Content-Type":"application/json"}});

Deno.serve(async (req)=>{
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

    const { upc, log } = await req.json();
    if(!upc) return json(400,{error:"upc required"});

    const resp = await fetch(`https://trackapi.nutritionix.com/v2/search/item?upc=${encodeURIComponent(upc)}`,{
      headers:{ "x-app-id": NUT_ID, "x-app-key": NUT_KEY }
    }).then(r=>r.json());

    const item = resp?.foods?.[0] || resp;
    if(!item) return json(404,{error:"not found"});

    const mealRow = {
      user_id: u.id,
      at: new Date().toISOString(),
      title: item.food_name || "Packaged Food",
      calories: item.nf_calories ?? null,
      protein_g: item.nf_protein ?? null,
      carbs_g: item.nf_total_carbohydrate ?? null,
      fat_g: item.nf_total_fat ?? null,
      macros: {item, upc, source:"barcode"},
      source: "barcode"
    };

    const result = log
      ? await admin.from("meals").insert(mealRow).select().single()
      : { data: { preview: mealRow }, error: null };

    if (log) {
      fetch(`${SUPABASE_URL}/functions/v1/energy_update`,{
        method:"POST", headers:{Authorization:`Bearer ${SERVICE_KEY}`,"Content-Type":"application/json"},
        body: JSON.stringify({source:"meal"})
      }).catch(()=>{});
    }

    if ("error" in result && result.error) return json(500,{error:result.error.message});
    return json(200, ("data" in result) ? (result as any).data : result);
  }catch(e){ return json(500,{error:(e as Error).message}); }
});

