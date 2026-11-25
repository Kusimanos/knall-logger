-- Knall-Logger: Datenbank in Supabase einrichten
-- Einmal im Supabase-Dashboard unter «SQL Editor» einfügen und auf «Run» klicken.
-- Jede Zeile gehört genau einem angemeldeten Konto. Niemand sonst kann sie lesen oder ändern
-- (Row Level Security). Tonausschnitte liegen in einem privaten Speicher-Bucket.

create table if not exists public.items (
  user_id    uuid        not null default auth.uid() references auth.users(id) on delete cascade,
  id         text        not null,
  kind       text        not null check (kind in ('event','note','session')),
  t          bigint      not null,
  data       jsonb       not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);
create index if not exists items_user_t on public.items (user_id, t);

alter table public.items enable row level security;

drop policy if exists "eigene lesen"    on public.items;
drop policy if exists "eigene anlegen"  on public.items;
drop policy if exists "eigene aendern"  on public.items;
drop policy if exists "eigene loeschen" on public.items;
create policy "eigene lesen"    on public.items for select to authenticated using (user_id = auth.uid());
create policy "eigene anlegen"  on public.items for insert to authenticated with check (user_id = auth.uid());
create policy "eigene aendern"  on public.items for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "eigene loeschen" on public.items for delete to authenticated using (user_id = auth.uid());

-- Privater Speicher für Tonausschnitte: Pfad = <user_id>/<ereignis-id>.wav
insert into storage.buckets (id, name, public)
values ('clips', 'clips', false)
on conflict (id) do update set public = false;

drop policy if exists "clips eigene lesen"    on storage.objects;
drop policy if exists "clips eigene anlegen"  on storage.objects;
drop policy if exists "clips eigene aendern"  on storage.objects;
drop policy if exists "clips eigene loeschen" on storage.objects;
create policy "clips eigene lesen"    on storage.objects for select to authenticated
  using (bucket_id = 'clips' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "clips eigene anlegen"  on storage.objects for insert to authenticated
  with check (bucket_id = 'clips' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "clips eigene aendern"  on storage.objects for update to authenticated
  using (bucket_id = 'clips' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "clips eigene loeschen" on storage.objects for delete to authenticated
  using (bucket_id = 'clips' and (storage.foldername(name))[1] = auth.uid()::text);
