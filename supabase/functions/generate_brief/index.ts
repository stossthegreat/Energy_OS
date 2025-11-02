import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const TTS_KEY = Deno.env.get("GOOGLE_TTS_KEY")!;
const OPENAI_KEY = Deno.env.get("OPENAI_KEY")!;

const json = (s: number, d: unknown) =>
  new Response(JSON.stringify(d), {
    status: s,
    headers: { "Content-Type": "application/json" },
  });

Deno.serve(async (req) => {
  try {
    const token = req.headers.get("Authorization")?.replace("Bearer ", "");
    if (!token) return json(401, { error: "no auth" });

    const authed = createClient(SUPABASE_URL, token);
    const { data: au } = await authed.auth.getUser();
    if (!au?.user) return json(401, { error: "invalid auth" });

    const admin = createClient(SUPABASE_URL, SERVICE_KEY);
    const { data: u } = await admin
      .from("users")
      .select("id,name,energy_level")
      .eq("auth_id", au.user.id)
      .single();
    if (!u) return json(403, { error: "profile missing" });

    const body = await req.json();
    const kind = body.kind || "morning";
    const today = new Date().toISOString().slice(0, 10);

    // Get user stats
    const { data: todayLogs } = await admin
      .from("energy_logs")
      .select("*")
      .eq("user_id", u.id)
      .gte("at", `${today}T00:00:00Z`)
      .order("at", { ascending: false });

    const { data: lastSleep } = await admin
      .from("sleep_logs")
      .select("*")
      .eq("user_id", u.id)
      .order("date", { ascending: false })
      .limit(1)
      .single();

    // Generate AI brief
    const prompt = `
You are an AI wellness coach. Generate a ${kind} brief for ${u.name || "the user"}.
Current energy: ${u.energy_level}/100
Recent sleep: ${lastSleep?.hours || "N/A"} hours, quality ${lastSleep?.quality_score || "N/A"}/100
Energy logs today: ${todayLogs?.length || 0} updates

Create a short, motivational ${kind} message (2-3 sentences) focused on energy optimization.
`;

    const aiRes = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${OPENAI_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "gpt-4o-mini",
        messages: [{ role: "system", content: prompt }],
        max_tokens: 150,
      }),
    });

    const aiData = await aiRes.json();
    const transcript = aiData.choices?.[0]?.message?.content || "Stay energized today!";

    // Generate TTS audio
    const tts = await fetch(
      "https://texttospeech.googleapis.com/v1/text:synthesize",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${TTS_KEY}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          input: { text: transcript },
          voice: { languageCode: "en-US", name: "en-US-Wavenet-C" },
          audioConfig: { audioEncoding: "MP3" },
        }),
      }
    );

    const audio = await tts.json();
    const audioBase64 = audio.audioContent;

    // TODO: Upload audio to Supabase Storage and get URL
    const audioUrl = `data:audio/mp3;base64,${audioBase64}`;

    // Save brief to database
    const { data: brief, error } = await admin
      .from("briefs")
      .upsert(
        {
          user_id: u.id,
          kind,
          for_date: today,
          transcript,
          audio_url: audioUrl,
        },
        { onConflict: "user_id,kind,for_date" }
      )
      .select()
      .single();

    if (error) return json(500, { error: error.message });

    return json(200, brief);
  } catch (e) {
    return json(500, { error: (e as Error).message });
  }
});

