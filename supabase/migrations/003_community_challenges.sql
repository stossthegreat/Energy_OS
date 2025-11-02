-- COMMUNITY FEED
create table if not exists public.community_feed (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  type text not null,              -- 'streak'|'breakthrough'|'mode'|'meal'|'workout'
  message text not null,
  emoji text,
  is_public boolean not null default true
);
create index if not exists feed_user_time on public.community_feed(user_id, created_at desc);

-- CHALLENGES
create table if not exists public.challenges (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  mode text,                        -- 'longevity'|'performance'|'focus'...
  duration_days int not null,
  starts_at timestamptz not null,
  max_participants int,
  rules jsonb not null default '{}' -- {min_meals, sleep_target, ...}
);

create table if not exists public.challenge_entries (
  id uuid primary key default gen_random_uuid(),
  challenge_id uuid not null references public.challenges(id) on delete cascade,
  user_id uuid not null references public.users(id) on delete cascade,
  joined_at timestamptz not null default now(),
  progress jsonb not null default '{}',   -- daily check-ins
  score numeric not null default 0,
  unique (challenge_id, user_id)
);

-- RLS
alter table public.community_feed enable row level security;
alter table public.challenges enable row level security;
alter table public.challenge_entries enable row level security;

create policy feed_sel   on public.community_feed for select using (true);
create policy feed_ins   on public.community_feed for insert with check (exists (select 1 from public.users u where u.id=user_id and u.auth_id=auth.uid()));

create policy chall_sel  on public.challenges for select using (true);
create policy chall_ins  on public.challenges for insert with check (true); -- (gate with admin flag if needed)

create policy cen_sel    on public.challenge_entries for select using (exists (select 1 from public.users u where u.id=user_id and u.auth_id=auth.uid()));
create policy cen_ins    on public.challenge_entries for insert with check (exists (select 1 from public.users u where u.id=user_id and u.auth_id=auth.uid()));
create policy cen_upd    on public.challenge_entries for update using (exists (select 1 from public.users u where u.id=user_id and u.auth_id=auth.uid()));

