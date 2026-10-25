-- Emagrecimento Saudável 360° — execute no SQL Editor do Supabase
create table if not exists public.perfis(user_id uuid primary key references auth.users(id) on delete cascade, nome text, criado_em timestamptz default now(), atualizado_em timestamptz default now());
create table if not exists public.preferencias(user_id uuid primary key references auth.users(id) on delete cascade, dados jsonb not null default '{}', criado_em timestamptz default now(), atualizado_em timestamptz default now());
create table if not exists public.favoritos(user_id uuid references auth.users(id) on delete cascade, receita_id int not null, criado_em timestamptz default now(), primary key(user_id,receita_id));
create table if not exists public.planejamentos(id bigint generated always as identity primary key, user_id uuid not null references auth.users(id) on delete cascade, dados jsonb not null, criado_em timestamptz default now(), atualizado_em timestamptz default now());
create table if not exists public.atividades(id bigint generated always as identity primary key, user_id uuid not null references auth.users(id) on delete cascade, receita_id int, tipo text not null check (tipo in ('experimentada','concluida')), data date not null default current_date, criado_em timestamptz default now());
-- Autorização de acesso (separada da autenticação): só o servidor escreve
create table if not exists public.acessos(user_id uuid primary key references auth.users(id) on delete cascade, ativo boolean not null default false, origem text, atualizado_em timestamptz default now());
create index if not exists idx_plan_user on public.planejamentos(user_id);
create index if not exists idx_ativ_user on public.atividades(user_id);

alter table public.perfis enable row level security;
alter table public.preferencias enable row level security;
alter table public.favoritos enable row level security;
alter table public.planejamentos enable row level security;
alter table public.atividades enable row level security;
alter table public.acessos enable row level security;

create policy "perfis_proprio" on public.perfis for all to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "pref_proprio" on public.preferencias for all to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "fav_proprio" on public.favoritos for all to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "plan_proprio" on public.planejamentos for all to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "ativ_proprio" on public.atividades for all to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);
-- acessos: usuário apenas LÊ o próprio registro; não há policy de escrita (apenas service_role, no servidor)
create policy "acessos_leitura" on public.acessos for select to authenticated using (auth.uid()=user_id);

-- Para liberar um comprador manualmente (SQL Editor, como administrador):
-- insert into public.acessos(user_id,ativo,origem) values ('<UUID do usuário>', true, 'manual') on conflict (user_id) do update set ativo=true;
