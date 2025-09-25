-- Tabela para armazenar valores por preferência que o motorista disponibiliza
-- e o valor cobrado por cada uma delas.

create table if not exists public.driver_preference_fees (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references public.drivers(id) on delete cascade,
  preference_key text not null,
  enabled boolean not null default false,
  fee numeric(10,2) not null default 0,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now(),
  unique(driver_id, preference_key)
);

-- Índices úteis
create index if not exists idx_driver_preference_fees_driver
  on public.driver_preference_fees(driver_id);

-- Sugestão de chaves de preferência (deve ser consistente no app):
-- 'needs_ac', 'needs_child_seat', 'needs_wheelchair_access'

-- RLS (se usando Supabase com RLS Ativado)
-- enable row level security
alter table public.driver_preference_fees enable row level security;

-- policy: o motorista pode gerenciar somente suas próprias preferências
do $$ begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'driver_preference_fees'
      and policyname = 'driver_can_manage_own_preference_fees'
  ) then
    create policy driver_can_manage_own_preference_fees
      on public.driver_preference_fees
      for all
      using (
        exists (
          select 1 from public.drivers d
          where d.id = driver_id
            and d.user_id = auth.uid()
        )
      )
      with check (
        exists (
          select 1 from public.drivers d
          where d.id = driver_id
            and d.user_id = auth.uid()
        )
      );
  end if;
end $$;

-- trigger para updated_at
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

do $$ begin
  if not exists (
    select 1 from pg_trigger where tgname = 'trg_driver_preference_fees_updated_at'
  ) then
    create trigger trg_driver_preference_fees_updated_at
      before update on public.driver_preference_fees
      for each row execute function public.set_updated_at();
  end if;
end $$;


