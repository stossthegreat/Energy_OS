#!/bin/bash
# Deploy all Energy OS Edge Functions

echo "🚀 Deploying Energy OS Edge Functions..."
echo ""

echo "📊 Phase 1: Core Logging Functions"
supabase functions deploy log_meal
supabase functions deploy workouts_post
supabase functions deploy sleep_post
echo ""

echo "🤖 Phase 2: AI Coach Functions"
supabase functions deploy mind_routine
supabase functions deploy training_plan
supabase functions deploy meal_plan
echo ""

echo "📸 Phase 3: Photo/Barcode Analysis"
supabase functions deploy photo_meal_analyze
supabase functions deploy barcode_lookup
echo ""

echo "⚡ Phase 4: Energy Management"
supabase functions deploy energy_update
supabase functions deploy generate_brief
echo ""

echo "🌍 Phase 5: Community & Challenges"
supabase functions deploy feed_post
supabase functions deploy challenges_join
supabase functions deploy challenges_admin
supabase functions deploy notify_low_energy
echo ""

echo "✅ All 14 functions deployed!"
echo ""
echo "Next steps:"
echo "1. Set environment variables in Supabase Dashboard"
echo "2. Run SQL migrations in SQL Editor"
echo "3. Create storage buckets (meals, briefs, avatars)"
echo "4. Test endpoints!"

