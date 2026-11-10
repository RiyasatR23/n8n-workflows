-- Tables used by the workflows. Run this in Supabase → SQL Editor.

-- Leads captured by 01-ai-lead-qualifier, read by 02-daily-lead-digest
create table if not exists public.leads (
  id           bigint generated always as identity primary key,
  created_at   timestamptz not null default now(),
  name         text not null,
  email        text not null,
  phone        text,
  company      text,
  message      text,
  source       text default 'website',
  score        text check (score in ('hot', 'warm', 'cold')),
  service      text,
  summary      text,
  reply_draft  text
);
create index if not exists leads_created_at_idx on public.leads (created_at);

-- Daily numbers read by 04-weekly-stats-report (one row per metric per day)
create table if not exists public.daily_metrics (
  id      bigint generated always as identity primary key,
  day     date not null,
  metric  text not null,
  value   numeric not null default 0,
  unique (day, metric)
);
create index if not exists daily_metrics_day_idx on public.daily_metrics (day);

-- Row Level Security on: only the service-role key used by n8n can read/write.
alter table public.leads enable row level security;
alter table public.daily_metrics enable row level security;

-- Optional: 14 days of sample data so the weekly report has something to show
insert into public.daily_metrics (day, metric, value)
select d::date, m.metric, round((m.base + random() * m.base * 0.4)::numeric, 0)
from generate_series(current_date - 14, current_date - 1, interval '1 day') as d
cross join (values ('Website visits', 120), ('Enquiries', 6), ('Quotes sent', 3), ('Revenue (R)', 4500)) as m(metric, base)
on conflict (day, metric) do nothing;
