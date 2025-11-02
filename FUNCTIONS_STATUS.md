# ⚡ Energy OS Edge Functions - Complete List

## 📊 Overview

**Total Functions**: 16  
**Core Functions**: 9 (already created)  
**AI Coach Functions**: 3 (need to be created)  
**Optional Functions**: 4 (can be created later)

---

## ✅ CREATED FUNCTIONS (9)

These are already written and ready to deploy:

### 1. `log_meal` ✅
- **Location**: `supabase/functions/log_meal/index.ts`
- **Purpose**: Log meals manually or from AI/photo/barcode
- **Triggers**: Auto-calls `energy_update` after insert
- **Test**:
  ```bash
  curl -X POST https://<PROJECT>.supabase.co/functions/v1/log_meal \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"title":"Salmon","calories":400,"protein_g":35}'
  ```

### 2. `workouts_post` ✅
- **Location**: `supabase/functions/workouts_post/index.ts`
- **Purpose**: Log workout sessions
- **Triggers**: Auto-calls `energy_update`
- **Test**:
  ```bash
  curl -X POST https://<PROJECT>.supabase.co/functions/v1/workouts_post \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"type":"strength","duration_min":45,"intensity_rpe":8}'
  ```

### 3. `sleep_post` ✅
- **Location**: `supabase/functions/sleep_post/index.ts`
- **Purpose**: Log sleep data
- **Triggers**: Auto-calls `energy_update`
- **Test**:
  ```bash
  curl -X POST https://<PROJECT>.supabase.co/functions/v1/sleep_post \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"hours":7.5,"quality_score":85}'
  ```

### 4. `photo_meal_analyze` ✅
- **Location**: `supabase/functions/photo_meal_analyze/index.ts`
- **Purpose**: Analyze meal photos using Google Vision + Nutritionix
- **Requires**: `GOOGLE_VISION_API_KEY`, `NUTRITIONIX_APP_ID/KEY`
- **Test**:
  ```bash
  curl -X POST https://<PROJECT>.supabase.co/functions/v1/photo_meal_analyze \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"image_url":"https://..."}'
  ```

### 5. `barcode_lookup` ✅
- **Location**: `supabase/functions/barcode_lookup/index.ts`
- **Purpose**: Look up nutrition by barcode (UPC)
- **Requires**: `NUTRITIONIX_APP_ID/KEY`
- **Test**:
  ```bash
  curl -X POST https://<PROJECT>.supabase.co/functions/v1/barcode_lookup \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"upc":"04963406","log":false}'
  ```

### 6. `feed_post` ✅
- **Location**: `supabase/functions/feed_post/index.ts`
- **Purpose**: Post achievements to community feed
- **Test**:
  ```bash
  curl -X POST https://<PROJECT>.supabase.co/functions/v1/feed_post \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"type":"streak","message":"5-day streak!","emoji":"🔥"}'
  ```

### 7. `challenges_join` ✅
- **Location**: `supabase/functions/challenges_join/index.ts`
- **Purpose**: Join challenges, check-in, view leaderboards
- **Test**:
  ```bash
  curl -X POST https://<PROJECT>.supabase.co/functions/v1/challenges_join \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"action":"join","challenge_id":"<uuid>"}'
  ```

### 8. `challenges_admin` ✅
- **Location**: `supabase/functions/challenges_admin/index.ts`
- **Purpose**: Create new challenges (admin only)
- **Test**:
  ```bash
  curl -X POST https://<PROJECT>.supabase.co/functions/v1/challenges_admin \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"name":"7-Day Flow","mode":"longevity","duration_days":7}'
  ```

### 9. `notify_low_energy` ✅
- **Location**: `supabase/functions/notify_low_energy/index.ts`
- **Purpose**: Send push notifications to users with low energy
- **Requires**: `ONESIGNAL_APP_ID`, `ONESIGNAL_REST_API_KEY`
- **Cron**: Runs every hour at :15
- **Test**: Automatically triggered by cron schedule

---

## 🤖 AI COACH FUNCTIONS (3) - TO BE CREATED

These need to be written using OpenAI API:

### 10. `mind_routine` ⚠️ NEEDED
- **Purpose**: Generate meditation/breathing/journaling routines
- **Input**: `{"query": "5-min breathing for anxiety"}`
- **Output**: `{"title": "...", "steps": [...], "duration_min": 5}`
- **Requires**: `OPENAI_API_KEY`

**Template**:
```typescript
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const OPENAI_KEY = Deno.env.get("OPENAI_API_KEY")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const json = (s: number, d: unknown) => 
  new Response(JSON.stringify(d), {status: s, headers: {"Content-Type": "application/json"}});

Deno.serve(async req => {
  try {
    if (req.method !== "POST") return json(405, {error: "POST only"});
    
    const token = req.headers.get("Authorization")?.replace("Bearer ", "");
    if (!token) return json(401, {error: "no auth"});
    
    const authed = createClient(SUPABASE_URL, token);
    const { data: au } = await authed.auth.getUser();
    if (!au?.user) return json(401, {error: "invalid auth"});
    
    const body = await req.json();
    const query = body.query || "5-minute breathing exercise";
    
    // Call OpenAI
    const completion = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${OPENAI_KEY}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        model: "gpt-4",
        messages: [{
          role: "system",
          content: "You are a mindfulness coach. Generate meditation/breathing routines as JSON with: title, steps (array of strings), duration_min."
        }, {
          role: "user",
          content: query
        }],
        temperature: 0.7
      })
    }).then(r => r.json());
    
    const response = JSON.parse(completion.choices[0].message.content);
    return json(200, response);
    
  } catch (e) {
    return json(500, {error: (e as Error).message});
  }
});
```

### 11. `training_plan` ⚠️ NEEDED
- **Purpose**: Generate custom workout plans
- **Input**: `{"query": "30-min upper body workout"}`
- **Output**: `{"title": "...", "exercises": [...], "duration_min": 30}`
- **Requires**: `OPENAI_API_KEY`

### 12. `meal_plan` ⚠️ NEEDED
- **Purpose**: Generate meal plans / recipes
- **Input**: `{"query": "high protein dinner with chicken"}`
- **Output**: `{"title": "...", "ingredients": [...], "instructions": [...], "macros": {...}}`
- **Requires**: `OPENAI_API_KEY`

---

## 🔄 ENERGY MANAGEMENT (1) - TO BE CREATED

### 13. `energy_update` ⚠️ NEEDED
- **Purpose**: Recalculate user energy level (0-100)
- **Input**: `{"source": "meal" | "workout" | "sleep" | "recalc"}`
- **Logic**: 
  - Calls `recalc_energy()` SQL function (already created in migration 001)
  - Inserts row into `energy_logs` table
- **Cron**: Runs every hour
- **Note**: SQL triggers already handle most recalculation, this function is mainly for manual/cron triggers

**Template**:
```typescript
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const json = (s: number, d: unknown) => 
  new Response(JSON.stringify(d), {status: s, headers: {"Content-Type": "application/json"}});

Deno.serve(async req => {
  try {
    const body = await req.json();
    const source = body.source || "recalc";
    
    const admin = createClient(SUPABASE_URL, SERVICE_KEY);
    
    // Get all users (or specific user if provided)
    const { data: users } = await admin.from("users").select("id");
    
    for (const user of users || []) {
      // Call the SQL function
      await admin.rpc("recalc_energy", { user_uuid: user.id });
    }
    
    return json(200, {updated: users?.length || 0, source});
    
  } catch (e) {
    return json(500, {error: (e as Error).message});
  }
});
```

---

## 🎙️ OPTIONAL FUNCTIONS (4)

These can be created later for enhanced features:

### 14. `generate_brief` 📢 OPTIONAL
- **Purpose**: Generate voice briefs (TTS) with daily summaries
- **Requires**: `OPENAI_API_KEY`, `GOOGLE_TTS_API_KEY`
- **Cron**: Morning (7am), Evening (9pm)

### 15. `voice_input` 🎤 OPTIONAL
- **Purpose**: Transcribe voice to text
- **Requires**: `GOOGLE_SPEECH_API_KEY` or similar STT service

### 16. `tribe_feed` 🌍 OPTIONAL
- **Purpose**: Get realtime community feed
- **Note**: Can be replaced with Supabase Realtime subscriptions from Flutter

### 17. `energy_forecast` 🔮 OPTIONAL
- **Purpose**: Predict energy levels for next 7 days
- **Requires**: `OPENAI_API_KEY` or custom ML model

---

## 🚀 Deployment Priority

### Phase 1: Core Logging (NOW)
```bash
supabase functions deploy log_meal
supabase functions deploy workouts_post
supabase functions deploy sleep_post
supabase functions deploy photo_meal_analyze
supabase functions deploy barcode_lookup
```

### Phase 2: AI Coach (NEXT)
```bash
# Create these 3 functions first, then deploy
supabase functions deploy mind_routine
supabase functions deploy training_plan
supabase functions deploy meal_plan
supabase functions deploy energy_update
```

### Phase 3: Community (LATER)
```bash
supabase functions deploy feed_post
supabase functions deploy challenges_join
supabase functions deploy challenges_admin
supabase functions deploy notify_low_energy
```

### Phase 4: Optional (FUTURE)
```bash
supabase functions deploy generate_brief
supabase functions deploy voice_input
supabase functions deploy tribe_feed
supabase functions deploy energy_forecast
```

---

## ✅ Quick Deploy Script

```bash
#!/bin/bash
# deploy-all.sh

cd supabase

echo "Phase 1: Core logging..."
supabase functions deploy log_meal
supabase functions deploy workouts_post
supabase functions deploy sleep_post
supabase functions deploy photo_meal_analyze
supabase functions deploy barcode_lookup

echo "Phase 2: AI Coach..."
supabase functions deploy mind_routine
supabase functions deploy training_plan
supabase functions deploy meal_plan
supabase functions deploy energy_update

echo "Phase 3: Community..."
supabase functions deploy feed_post
supabase functions deploy challenges_join
supabase functions deploy challenges_admin
supabase functions deploy notify_low_energy

echo "✅ Core functions deployed!"
```

---

## 📝 Summary

- ✅ **9 functions ready** (logging, photos, community, challenges)
- ⚠️ **4 functions needed** (AI coach x3, energy_update)
- 📢 **4 functions optional** (briefs, voice, tribe, forecast)

**Next step**: Create the 4 needed functions, then run Phase 1 & 2 deployments! 🎉

