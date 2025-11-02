-- ======================================================
-- ENERGY ENGINE AUTO-MAINTENANCE
-- ======================================================

-- 1️⃣  master recalculation function
create or replace function public.recalc_energy(user_uuid uuid)
returns void language plpgsql as $$
declare
  v_sleep numeric := 0;
  v_meal numeric := 0;
  v_train numeric := 0;
  v_avg  numeric := 50;
begin
  select coalesce(avg(quality_score),0) into v_sleep
    from sleep_logs where user_id=user_uuid
      and date > current_date - interval '7 day';

  select coalesce(avg(calories),0) into v_meal
    from meals where user_id=user_uuid
      and timestamp > now() - interval '3 day';

  select coalesce(avg(intensity_rpe),0) into v_train
    from workouts where user_id=user_uuid
      and timestamp > now() - interval '3 day';

  v_avg := 50
           + (v_sleep/100)*25
           + (least(v_meal,2200)/2200)*15
           + (v_train/10)*10;

  update users set energy_level = greatest(0,least(100,v_avg))
  where id = user_uuid;
end;
$$;

-- 2️⃣  trigger function (calls recalculation)
create or replace function public.trg_energy_update()
returns trigger language plpgsql as $$
begin
  perform recalc_energy(new.user_id);
  return new;
end;
$$;

-- 3️⃣  attach triggers to all log tables
create trigger trg_meal_energy
after insert on meals
for each row execute function trg_energy_update();

create trigger trg_workout_energy
after insert on workouts
for each row execute function trg_energy_update();

create trigger trg_sleep_energy
after insert on sleep_logs
for each row execute function trg_energy_update();

create trigger trg_feeling_energy
after insert on feelings
for each row execute function trg_energy_update();

-- 4️⃣  optional: keep energy_logs table in sync
create or replace function public.trg_energy_log()
returns trigger language plpgsql as $$
declare
  v_level numeric;
begin
  select energy_level into v_level from users where id = new.user_id;
  insert into energy_logs (user_id,timestamp,source,energy_level,energy_delta)
  values (new.user_id,now(),tg_table_name,v_level,0);
  return new;
end;
$$;

create trigger trg_log_meal
after insert on meals
for each row execute function trg_energy_log();

create trigger trg_log_workout
after insert on workouts
for each row execute function trg_energy_log();

create trigger trg_log_sleep
after insert on sleep_logs
for each row execute function trg_energy_log();

create trigger trg_log_feelings
after insert on feelings
for each row execute function trg_energy_log();

