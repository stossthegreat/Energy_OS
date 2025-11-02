# 🚀 Energy OS - Deployment Guide

## 📋 Overview

This guide covers deploying the complete Energy OS backend (Supabase) and frontend (Flutter).

---

## 🗄️ Database Setup

### 1. Run Migrations in Order

Execute these SQL files in the Supabase SQL Editor:

```bash
# 1. Base schema (tables, RLS policies)
supabase/migrations/000_base_schema.sql

# 2. Energy triggers (auto-recalculation)
supabase/migrations/001_energy_triggers.sql

# 3. Low energy RPC (for notifications)
supabase/migrations/002_low_energy_rpc.sql

# 4. Community & challenges
supabase/migrations/003_community_challenges.sql
```

### 2. Create Storage Buckets

In Supabase Dashboard → Storage:

- **meals** (private) - for meal photos
- **briefs** (private) - for TTS audio files  
- **avatars** (private) - for user profile pictures

---

## ⚡ Edge Functions Deployment

### 1. Set Environment Variables

In Supabase Dashboard → Project Settings → Edge Functions, add:

```bash
SUPABASE_URL=<auto>                           # auto-filled
SUPABASE_SERVICE_ROLE_KEY=<auto>              # auto-filled
OPENAI_API_KEY=sk-...                         # OpenAI for AI Coach
GOOGLE_TTS_API_KEY=AIza...                    # Cloud Text-to-Speech
GOOGLE_VISION_API_KEY=AIza...                 # Cloud Vision (meal photos)
NUTRITIONIX_APP_ID=xxxxxxxx                   # Nutritionix for nutrition data
NUTRITIONIX_API_KEY=xxxxxxxx                  # Nutritionix API key
ONESIGNAL_APP_ID=xxxxxxxx                     # Optional: push notifications
ONESIGNAL_REST_API_KEY=xxxxxxxx               # Optional: push notifications
```

### 2. Deploy All Functions

```bash
cd supabase

# Core logging functions
supabase functions deploy log_meal
supabase functions deploy workouts_post
supabase functions deploy sleep_post

# AI Coach functions (create these from your existing code)
supabase functions deploy mind_routine
supabase functions deploy training_plan
supabase functions deploy meal_plan

# Energy & forecasting
supabase functions deploy energy_update
supabase functions deploy generate_brief

# Photo/barcode scanning
supabase functions deploy photo_meal_analyze
supabase functions deploy barcode_lookup

# Community & challenges
supabase functions deploy feed_post
supabase functions deploy challenges_join
supabase functions deploy challenges_admin

# Notifications
supabase functions deploy notify_low_energy

# Optional: Tribe feed, voice input, energy forecast
# supabase functions deploy tribe_feed
# supabase functions deploy voice_input
# supabase functions deploy energy_forecast
```

### 3. Verify Cron Schedules

In `supabase/config.toml`:

```toml
[functions.energy_update.schedules.recalc_hourly]
cron = "0 * * * *"                      # Recalc energy every hour
payload = "{\"source\":\"recalc\"}"

[functions.generate_brief.schedules.morning_brief]
cron = "0 7 * * *"                      # Morning brief at 07:00 UTC
payload = "{\"kind\":\"morning\"}"

[functions.generate_brief.schedules.evening_brief]
cron = "0 21 * * *"                     # Evening brief at 21:00 UTC
payload = "{\"kind\":\"evening\"}"

[functions.notify_low_energy.schedules.hourly_alert]
cron = "15 * * * *"                     # Check low energy users at :15 every hour
```

---

## 🧪 Testing Endpoints

### Authentication

```bash
# Sign up
curl -X POST https://<PROJECT>.supabase.co/auth/v1/signup \
  -H "apikey: $ANON_KEY" -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"password123"}'

# Login (get access token)
curl -X POST https://<PROJECT>.supabase.co/auth/v1/token?grant_type=password \
  -H "apikey: $ANON_KEY" -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"password123"}'

# Save the access_token as $TOKEN for subsequent calls
```

### Logging Functions

```bash
# Log a meal
curl -X POST https://<PROJECT>.supabase.co/functions/v1/log_meal \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Chicken Rice Bowl",
    "calories": 650,
    "protein_g": 45,
    "carbs_g": 60,
    "fat_g": 18,
    "source": "manual"
  }'

# Log a workout
curl -X POST https://<PROJECT>.supabase.co/functions/v1/workouts_post \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "strength",
    "duration_min": 45,
    "intensity_rpe": 8
  }'

# Log sleep
curl -X POST https://<PROJECT>.supabase.co/functions/v1/sleep_post \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "hours": 7.5,
    "quality_score": 85
  }'
```

### AI Coach Functions

```bash
# Mind routine
curl -X POST https://<PROJECT>.supabase.co/functions/v1/mind_routine \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "5-min breathing for anxiety"}'

# Training plan
curl -X POST https://<PROJECT>.supabase.co/functions/v1/training_plan \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "upper body workout 30 minutes"}'

# Meal plan
curl -X POST https://<PROJECT>.supabase.co/functions/v1/meal_plan \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "high protein dinner with chicken"}'
```

### Photo Analysis

```bash
# Analyze meal photo
curl -X POST https://<PROJECT>.supabase.co/functions/v1/photo_meal_analyze \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "image_url": "https://your-bucket.supabase.co/storage/v1/object/public/meals/photo.jpg"
  }'

# Barcode lookup (preview only)
curl -X POST https://<PROJECT>.supabase.co/functions/v1/barcode_lookup \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "upc": "04963406",
    "log": false
  }'
```

### Community & Challenges

```bash
# Post to feed
curl -X POST https://<PROJECT>.supabase.co/functions/v1/feed_post \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "streak",
    "message": "3-day workout streak!",
    "emoji": "🔥"
  }'

# Join a challenge
curl -X POST https://<PROJECT>.supabase.co/functions/v1/challenges_join \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "action": "join",
    "challenge_id": "<uuid>"
  }'

# View leaderboard
curl -X POST https://<PROJECT>.supabase.co/functions/v1/challenges_join \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "action": "leaderboard",
    "challenge_id": "<uuid>"
  }'
```

---

## 📱 Flutter App Setup

### 1. Configure Supabase

Edit `lib/utils/constants.dart`:

```dart
static const String supabaseUrl = 'https://<YOUR-PROJECT>.supabase.co';
static const String supabaseAnonKey = '<YOUR-ANON-KEY>';
```

Or set via environment variables when building:

```bash
flutter build apk \
  --dart-define=SUPABASE_URL=https://<PROJECT>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<ANON-KEY>
```

### 2. Install Dependencies

```bash
cd /home/felix/energy_os
flutter pub get
```

### 3. Run the App

```bash
# Debug mode
flutter run

# Release build
flutter build apk --release
```

---

## ✅ Verification Checklist

### Database
- [ ] All 4 migrations run successfully
- [ ] RLS policies enabled on all tables
- [ ] Storage buckets created (meals, briefs, avatars)

### Edge Functions
- [ ] All 13+ functions deployed
- [ ] Environment variables set
- [ ] Cron schedules configured
- [ ] Test endpoints return 200 status

### Flutter App
- [ ] `flutter pub get` completes
- [ ] Supabase credentials configured
- [ ] App builds without errors
- [ ] Authentication flow works
- [ ] API calls succeed

---

## 🔍 Troubleshooting

### Function Deployment Fails

```bash
# Check function logs
supabase functions logs <function-name>

# Redeploy with verbose output
supabase functions deploy <function-name> --debug
```

### RLS Policy Errors

```sql
-- Check if user exists in users table
SELECT * FROM public.users WHERE auth_id = auth.uid();

-- Check policy definitions
SELECT * FROM pg_policies WHERE tablename = 'meals';
```

### Flutter Build Errors

```bash
# Clean build cache
flutter clean
flutter pub get

# Check for missing packages
flutter doctor -v
```

---

## 📊 Monitoring

### Supabase Dashboard

- **Database** → Monitor table sizes, query performance
- **Edge Functions** → View invocation logs, errors
- **Storage** → Check bucket usage
- **Auth** → Monitor user signups, sessions

### Function Metrics

```bash
# View recent invocations
supabase functions logs energy_update --limit 50

# Monitor cron jobs
supabase functions logs generate_brief --filter "cron"
```

---

## 🔐 Security Checklist

- [ ] Service role key never exposed in client code
- [ ] RLS policies tested for all tables
- [ ] Storage buckets set to private
- [ ] Auth emails confirmed before access
- [ ] API keys stored in Supabase secrets (not in code)

---

## 📚 Additional Resources

- [Supabase Edge Functions Docs](https://supabase.com/docs/guides/functions)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [Energy OS Backend Reference](./supabase/API_REFERENCE.md)
- [Environment Variables](./supabase/ENV_VARIABLES.md)

---

**Ready to deploy? Start with the database migrations, then Edge Functions, then the Flutter app! 🚀**

