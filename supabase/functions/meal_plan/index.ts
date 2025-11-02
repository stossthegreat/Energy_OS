import { serve } from "https://deno.land/std@0.177.0/http/server.ts";

serve(async (req) => {
  const { query } = await req.json();
  const prompt = `
You are a nutritionist AI. Suggest a healthy meal or recipe based on:
"${query}"

Return JSON: {
  title,
  prep_time,
  difficulty,
  servings,
  steps[],
  nutrition: { calories, protein, carbs, fat, fiber }
}.
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

