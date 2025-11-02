# Environment Variables for Supabase Edge Functions

Add these in Supabase Dashboard → Project Settings → Edge Functions

## Supabase (Auto-populated)
```
SUPABASE_URL=<auto>
SUPABASE_SERVICE_ROLE_KEY=<auto>
```

## OpenAI
```
OPENAI_KEY=sk-...                # Used by: mind_routine, training_plan, meal_plan
```

## Google Cloud APIs
```
GOOGLE_TTS_KEY=AIza...           # Used by: generate_brief
GOOGLE_VISION_API_KEY=AIza...    # Used by: photo_meal_analyze
```

## Nutritionix
```
NUTRITIONIX_APP_ID=xxxxxxxx
NUTRITIONIX_API_KEY=xxxxxxxx
```

## OneSignal (Optional - for push notifications)
```
ONESIGNAL_APP_ID=xxxxxxxx
ONESIGNAL_REST_API_KEY=xxxxxxxx
```

## Storage Buckets
Create these in Supabase Storage:
- `meals` (private)
- `briefs` (private)  
- `avatars` (public)

