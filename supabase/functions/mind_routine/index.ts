import { serve } from "https://deno.land/std@0.177.0/http/server.ts";

serve(async (req) => {
  const { query } = await req.json();
  const prompt = `
You are a calm AI mind coach. Generate a 5-step breathing or mindfulness routine based on this user need:
"${query}"

Return JSON with: { title, subtitle, duration, steps[] }.
`;

  const response = await fetch("https://api.openai.com/v1/chat/completions", {
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

  const data = await response.json();
  return new Response(JSON.stringify(data.choices?.[0]?.message?.content), {
    headers: { "Content-Type": "application/json" },
  });
});

