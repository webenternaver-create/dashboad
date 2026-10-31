-- 설계 문서용 SQL. 실제 DB에는 실행하지 않는다.
-- month, team, target, actual은 원본 앱에서 확인한 항목이다.
-- id, user_id, created_at, 제약조건, RLS는 DB 연결을 위한 추가 설계다.
-- 가정: Supabase의 auth.users와 authenticated 역할을 사용할 때의 예시.

create table if not exists public.kpi_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  month date not null,
  team text not null check (char_length(trim(team)) between 1 and 80),
  target bigint not null check (target >= 0),
  actual bigint not null check (actual >= 0),
  created_at timestamptz not null default now(),
  constraint kpi_records_month_first_day check (extract(day from month) = 1),
  constraint kpi_records_user_month_team_unique unique (user_id, month, team)
);

alter table public.kpi_records enable row level security;

create policy "kpi_records_select_own"
  on public.kpi_records for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "kpi_records_insert_own"
  on public.kpi_records for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "kpi_records_update_own"
  on public.kpi_records for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "kpi_records_delete_own"
  on public.kpi_records for delete to authenticated
  using ((select auth.uid()) = user_id);

-- 달성률은 조회 시 actual 합계 / target 합계 * 100으로 계산한다.
-- target 합계가 0인 경우 앱에서 '목표 미설정'으로 표시한다.
