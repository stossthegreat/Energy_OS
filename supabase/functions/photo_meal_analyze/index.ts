import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY  = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const VISION_KEY   = Deno.env.get("GOOGLE_VISION_API_KEY")!;
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

    const body = await req.json();
    // body: { image_url?: string, image_base64?: string }
    if(!body.image_url && !body.image_base64) return json(400,{error:"image required"});

    // 1) Google Vision label detection
    const visionReq = {
      requests:[{
        image: body.image_base64 ? { content: body.image_base64 } : { source:{ imageUri: body.image_url }},
        features:[{ type:"LABEL_DETECTION", maxResults:8 }]
      }]
    };
    const vRes = await fetch(`https://vision.googleapis.com/v1/images:annotate?key=${VISION_KEY}`,{
      method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify(visionReq)
    }).then(r=>r.json());
    const labels = vRes?.responses?.[0]?.labelAnnotations?.map((l:any)=>l.description) || [];
    if(!labels.length) return json(422,{error:"no food detected"});

    // Build a Nutritionix "natural language" string from labels
    const query = labels.slice(0,5).join(", ");

    // 2) Nutritionix natural language endpoint
    const nutRes = await fetch("https://trackapi.nutritionix.com/v2/natural/nutrients",{
      method:"POST",
      headers:{
        "x-app-id": NUT_ID,
        "x-app-key": NUT_KEY,
        "Content-Type":"application/json"
      },
      body: JSON.stringify({ query }) // e.g., "salmon, rice, broccoli"
    }).then(r=>r.json());

    // Aggregate macros
    const foods = nutRes?.foods || [];
    let calories=0, protein=0, carbs=0, fat=0, title="Meal";
    foods.forEach((f:any)=>{ calories+=f.nf_calories||0; protein+=f.nf_protein||0; carbs+=f.nf_total_carbohydrate||0; fat+=f.nf_total_fat||0;});
    if (foods[0]?.food_name) title = foods.map((f:any)=>f.food_name).join(" + ");

    // 3) Insert meal row
    const row = {
      user_id: u.id,
      at: new Date().toISOString(),
      title,
      photo_url: body.image_url || null,
      calories: Math.round(calories),
      protein_g: Math.round(protein),
      carbs_g: Math.round(carbs),
      fat_g: Math.round(fat),
      macros: { labels, foods, source: "vision+nutritionix" },
      source: "photo"
    };
    const { data: meal, error } = await admin.from("meals").insert(row).select().single();
    if (error) return json(500,{error:error.message});

    // trigger energy recalculation (fire and forget)
    fetch(`${SUPABASE_URL}/functions/v1/energy_update`,{
      method:"POST", headers:{Authorization:`Bearer ${SERVICE_KEY}`,"Content-Type":"application/json"},
      body: JSON.stringify({source:"meal"})
    }).catch(()=>{});

    return json(200, meal);
  }catch(e){ return json(500,{error:(e as Error).message}); }
});

