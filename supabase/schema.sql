-- ACCT224 Reviewer — Supabase schema
-- Run this once in the Supabase SQL editor (Project > SQL Editor > New query).
-- One row per signed-in user, holding exactly what used to live in localStorage:
-- answers, flags, notes and last-viewed-week, as a single JSON blob.

create table if not exists public.progress (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Keep updated_at current on every write, without relying on client clocks.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists progress_set_updated_at on public.progress;
create trigger progress_set_updated_at
  before update on public.progress
  for each row
  execute function public.set_updated_at();

-- Row Level Security: a signed-in user may only ever see or change their own row.
-- Nobody — not other students, not the project owner — can read another row
-- through the public anon key; only the Supabase dashboard (service role) can.
alter table public.progress enable row level security;

create policy "select own progress"
  on public.progress for select
  using (auth.uid() = user_id);

create policy "insert own progress"
  on public.progress for insert
  with check (auth.uid() = user_id);

create policy "update own progress"
  on public.progress for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "delete own progress"
  on public.progress for delete
  using (auth.uid() = user_id);
