# Energy OS - API Reference

## Base URL
```
https://<PROJECT>.supabase.co/functions/v1/
```

## Authentication
All requests require Bearer token:
```
Authorization: Bearer <user_token>
```

## Endpoints

### 1. Photo Meal Analyze
**Endpoint**: `POST /photo_meal_analyze`

**Request**:
```json
{
  "image_url": "https://.../my-photo.jpg"
}
```

**cURL Example**:
```bash
curl -s https://<PROJECT>.supabase.co/functions/v1/photo_meal_analyze \
 -H "Authorization: Bearer $TOKEN" \
 -H "Content-Type: application/json" \
 -d '{"image_url":"https://.../my-photo.jpg"}'
```

---

### 2. Barcode Lookup
**Endpoint**: `POST /barcode_lookup`

**Request**:
```json
{
  "upc": "04963406"
}
```

**cURL Example**:
```bash
curl -s https://<PROJECT>.supabase.co/functions/v1/barcode_lookup \
 -H "Authorization: Bearer $TOKEN" \
 -H "Content-Type: application/json" \
 -d '{"upc":"04963406"}'
```

---

### 3. Feed Post
**Endpoint**: `POST /feed_post`

**Request**:
```json
{
  "type": "streak",
  "message": "3-day PR streak",
  "emoji": "🔥"
}
```

**cURL Example**:
```bash
curl -s https://<PROJECT>.supabase.co/functions/v1/feed_post \
 -H "Authorization: Bearer $TOKEN" \
 -H "Content-Type: application/json" \
 -d '{"type":"streak","message":"3-day PR streak","emoji":"🔥"}'
```

---

### 4. Challenges Admin (Create Challenge)
**Endpoint**: `POST /challenges_admin`

**Request**:
```json
{
  "name": "7-Day Flow",
  "mode": "longevity",
  "duration_days": 7,
  "starts_at": "2025-11-02T09:00:00Z"
}
```

**cURL Example**:
```bash
curl -s https://<PROJECT>.supabase.co/functions/v1/challenges_admin \
 -H "Authorization: Bearer $ADMIN_TOKEN" \
 -H "Content-Type: application/json" \
 -d '{"name":"7-Day Flow","mode":"longevity","duration_days":7,"starts_at":"2025-11-02T09:00:00Z"}'
```

---

### 5. Challenges Join
**Endpoint**: `POST /challenges_join`

**Actions**: 
- `join` - Join a challenge
- `checkin` - Log daily progress
- `leaderboard` - Get challenge rankings

**Request (Join)**:
```json
{
  "action": "join",
  "challenge_id": "<uuid>"
}
```

**Request (Leaderboard)**:
```json
{
  "action": "leaderboard",
  "challenge_id": "<uuid>"
}
```

**cURL Example (Join)**:
```bash
curl -s https://<PROJECT>.supabase.co/functions/v1/challenges_join \
 -H "Authorization: Bearer $TOKEN" \
 -H "Content-Type: application/json" \
 -d '{"action":"join","challenge_id":"<uuid>"}'
```

**cURL Example (Leaderboard)**:
```bash
curl -s https://<PROJECT>.supabase.co/functions/v1/challenges_join \
 -H "Authorization: Bearer $TOKEN" \
 -H "Content-Type: application/json" \
 -d '{"action":"leaderboard","challenge_id":"<uuid>"}'
```

---

## Deployment Commands

```bash
# Deploy individual functions
supabase functions deploy photo_meal_analyze
supabase functions deploy barcode_lookup
supabase functions deploy feed_post
supabase functions deploy challenges_admin
supabase functions deploy challenges_join
supabase functions deploy notify_low_energy

# Deploy all at once
supabase functions deploy log_meal workouts_post sleep_post \
  mind_routine training_plan meal_plan energy_update generate_brief
```

## Cron Schedules

- **Energy Update**: Every hour (0 * * * *)
- **Morning Brief**: 7 AM daily (0 7 * * *)
- **Evening Brief**: 9 PM daily (0 21 * * *)
- **Low Energy Alert**: Every hour at :15 (15 * * * *)

