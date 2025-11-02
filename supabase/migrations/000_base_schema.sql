-- ======================================================
-- ENERGY OS — BASE SCHEMA
-- ======================================================

-- users: add quick-read energy_level cache
alter table public.users
  add column if not exists energy_level int check (energy_level between 0 and 100);

-- meals
create table if not exists public.meals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  at timestamptz not null default now(),
  photo_url text,
  title text,
  calories numeric,
  protein_g numeric,
  carbs_g numeric,
  fat_g numeric,
  macros jsonb default '{}',       -- optional extra micronutrients
  source text default 'manual'     -- 'manual' | 'photo' | 'barcode' | 'ai'
);

create index if not exists meals_user_at on public.meals(user_id, at desc);

-- workouts
create table if not exists public.workouts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  at timestamptz not null default now(),
  type text not null,              -- 'strength' | 'hiit' | ...
  intensity_rpe numeric,           -- 1..10
  duration_min int,
  notes text
);

create index if not exists workouts_user_at on public.workouts(user_id, at desc);

-- sleep logs
create table if not exists public.sleep_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  date date not null,              -- night-of
  hours numeric,
  quality_score int,               -- 0..100
  hrv_ms numeric
);

create unique index if not exists sleep_user_date on public.sleep_logs(user_id, date);

-- feelings / mood
create table if not exists public.feelings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  at timestamptz not null default now(),
  energy int,                      -- 1..10
  mood int,                        -- 1..10
  stress int,                      -- 1..10
  notes text
);

create index if not exists feelings_user_at on public.feelings(user_id, at desc);

-- energy logs
create table if not exists public.energy_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  at timestamptz not null default now(),
  source text not null,                 -- 'sleep' | 'meal' | 'training' | 'mood' | 'recalc'
  energy_delta numeric not null,        -- -5..+5 typical (capped in code)
  energy_level int not null,            -- 0..100 after applying delta
  factors jsonb not null default '{}'   -- breakdown used
);

create index if not exists energy_logs_user_at on public.energy_logs(user_id, at desc);

-- recommendations (coach outputs)
create table if not exists public.recommendations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  context jsonb not null,               -- {tab, scenario, query, ...}
  output jsonb not null,                -- coach JSON
  created_at timestamptz not null default now()
);

create index if not exists recos_user_time on public.recommendations(user_id, created_at desc);

-- briefs (TTS audio)
create table if not exists public.briefs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  kind text not null,                   -- 'morning' | 'evening'
  for_date date not null,
  transcript text not null,
  audio_url text not null,
  created_at timestamptz not null default now(),
  unique(user_id, kind, for_date)
);

-- =========================
-- RLS POLICIES
-- =========================
alter table public.meals           enable row level security;
alter table public.workouts        enable row level security;
alter table public.sleep_logs      enable row level security;
alter table public.feelings        enable row level security;
alter table public.recommendations enable row level security;
alter table public.energy_logs     enable row level security;
alter table public.briefs          enable row level security;

-- helper: ensure JWT belongs to row's user_id
create or replace function public.is_me(jwt_uid uuid, row_user_id uuid)
returns boolean language sql stable as $$
  select exists(select 1 from public.users u where u.id = row_user_id and u.auth_id = jwt_uid);
$$;

-- SELECT policies
create policy meals_sel           on public.meals           for select using (is_me(auth.uid(), user_id));
create policy workouts_sel        on public.workouts        for select using (is_me(auth.uid(), user_id));
create policy sleep_sel           on public.sleep_logs      for select using (is_me(auth.uid(), user_id));
create policy feelings_sel        on public.feelings        for select using (is_me(auth.uid(), user_id));
create policy recos_sel           on public.recommendations for select using (is_me(auth.uid(), user_id));
create policy energy_logs_sel     on public.energy_logs     for select using (is_me(auth.uid(), user_id));
create policy briefs_sel          on public.briefs          for select using (is_me(auth.uid(), user_id));

-- INSERT policies
create policy meals_ins           on public.meals           for insert with check (is_me(auth.uid(), user_id));
create policy workouts_ins        on public.workouts        for insert with check (is_me(auth.uid(), user_id));
create policy sleep_ins           on public.sleep_logs      for insert with check (is_me(auth.uid(), user_id));
create policy feelings_ins        on public.feelings        for insert with check (is_me(auth.uid(), user_id));
create policy recos_ins           on public.recommendations for insert with check (is_me(auth.uid(), user_id));
create policy energy_logs_ins     on public.energy_logs     for insert with check (is_me(auth.uid(), user_id));
create policy briefs_ins          on public.briefs          for insert with check (is_me(auth.uid(), user_id));

