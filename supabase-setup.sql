-- SMT 客服看板：在 Supabase「SQL Editor」貼上整段，按 Run 一次即可
create table if not exists public.docs (
  owner uuid not null default auth.uid() references auth.users on delete cascade,
  col text not null,
  id text not null,
  data jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (owner, col, id)
);
alter table public.docs enable row level security;
drop policy if exists "only owner" on public.docs;
create policy "only owner" on public.docs for all to authenticated
  using (owner = auth.uid()) with check (owner = auth.uid());
alter table public.docs replica identity full;
alter publication supabase_realtime add table public.docs;
