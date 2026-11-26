-- ============================================================
--  보호구 · 의약품 지급대장 (공통) - 표 추가
--  Supabase 대시보드 → SQL Editor → 새 쿼리 → 전체 붙여넣고 Run
--  이미 실행했더라도 그대로 다시 실행하면 됩니다. (기존 데이터 유지)
--
--  kind    = '보호구' | '의약품'
--  items   = [{ n: 품명, q: 수량 }]   (보호구 : 안전모 · 안전화 · 보안경 · 안전장갑 · 기타 품목)
--  sign    = 수령인 손 서명 그림(PNG data URL)
--  consult = 의약품 '의료인 상담 내용' (제출 후 따로 작성)
--            { date, symptom, disease: 'O'|'X', diseaseNote, guide, staff, sign(담당자 서명) }
-- ============================================================

create table if not exists public.supply_ledger (
  id          uuid primary key default gen_random_uuid(),
  kind        text not null check (kind in ('보호구', '의약품')),
  issue_date  date not null,
  dept        text,
  name        text not null,
  items       jsonb not null default '[]'::jsonb,
  note        text,
  agree       boolean not null default false,
  sign        text,
  consult     jsonb,
  consult_at  timestamptz,
  created_by  text,
  created_at  timestamptz not null default now()
);

create index if not exists idx_supply_ledger_date on public.supply_ledger(issue_date desc);

alter table public.supply_ledger enable row level security;
drop policy if exists supply_ledger_all on public.supply_ledger;
create policy supply_ledger_all on public.supply_ledger
  for all to anon, authenticated using (true) with check (true);
