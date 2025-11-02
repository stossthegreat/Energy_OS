-- helper RPC to list low energy users in the last hour (simple example)
create or replace function public.get_low_energy_users(since_ts timestamptz)
returns table(user_id uuid, energy_level int)
language sql stable as $$
  select el.user_id, el.energy_level
  from public.energy_logs el
  where el.at >= since_ts and el.energy_level < 35
  group by el.user_id, el.energy_level
$$;

