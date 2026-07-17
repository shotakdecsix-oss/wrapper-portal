-- Wrapper Portal: Supabase スキーマ
-- Supabaseダッシュボード > SQL Editor に貼り付けて実行してください

create extension if not exists pgcrypto;

create table if not exists apps (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  link text not null,
  version text default '',
  status text default '開発中',
  description text default '',
  usage text default '',
  tags text[] default '{}',
  image text default '',
  changelog jsonb default '[]',
  favorite_count integer not null default 0,
  access_count integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table apps enable row level security;

-- 誰でも閲覧可能(公開ポータルなので)
create policy "public can read apps"
  on apps for select
  using (true);

-- ログイン済み(=管理者)のみ 追加/更新/削除 可能
create policy "authenticated can insert apps"
  on apps for insert
  to authenticated
  with check (true);

create policy "authenticated can update apps"
  on apps for update
  to authenticated
  using (true);

create policy "authenticated can delete apps"
  on apps for delete
  to authenticated
  using (true);

-- いいね数を+1する関数(誰でも呼べる。この操作だけRLSを迂回する)
create or replace function increment_favorite(target_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update apps set favorite_count = favorite_count + 1 where id = target_id;
end;
$$;

-- アクセス数を+1する関数(誰でも呼べる)
create or replace function increment_access(target_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update apps set access_count = access_count + 1 where id = target_id;
end;
$$;

grant execute on function increment_favorite(uuid) to anon, authenticated;
grant execute on function increment_access(uuid) to anon, authenticated;
