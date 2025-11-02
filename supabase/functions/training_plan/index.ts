import { serve } from "https://deno.land/std@0.177.0/http/server.ts";

serve(async (req) => {
  const { query } = await req.json();
  const prompt = `
You are an elite fitness AI. Based on the user's request: "${query}",
return a 30-min to 60-min training plan JSON.

JSON keys: { title, duration, focus, exercises: [{ name, sets, reps, notes }] }.
`;

  const r = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${Deno.env.get("OPENAI_KEY")}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "gpt-4o-mini",
      messages: [{ role: "system", content: prompt }],
    }),
  });

  const data = await r.json();
  return new Response(JSON.stringify(data.choices?.[0]?.message?.content), {
    headers: { "Content-Type": "application/json" },
  });
});

