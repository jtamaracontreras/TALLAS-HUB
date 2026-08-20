-- ============================================================
--  Configuración de la base en Supabase
--  Pégalo en:  Supabase → tu proyecto → SQL Editor → New query → Run
-- ============================================================

-- 1) Tabla donde se guardan las tallas (una fila por persona)
create table if not exists public.tallas (
  person_id  text primary key,
  size       text,
  updated_at timestamptz default now()
);

-- 2) Permisos: permitir leer/escribir con la llave pública (anon)
--    Nota: esto deja la base abierta a quien tenga la URL + llave anon.
--    La contraseña de la app (ACCESS_CODE) es la capa que limita el acceso.
alter table public.tallas enable row level security;

drop policy if exists "acceso_publico_lectura" on public.tallas;
create policy "acceso_publico_lectura"
  on public.tallas for select
  to anon using (true);

drop policy if exists "acceso_publico_escritura" on public.tallas;
create policy "acceso_publico_escritura"
  on public.tallas for insert
  to anon with check (true);

drop policy if exists "acceso_publico_update" on public.tallas;
create policy "acceso_publico_update"
  on public.tallas for update
  to anon using (true) with check (true);

drop policy if exists "acceso_publico_borrado" on public.tallas;
create policy "acceso_publico_borrado"
  on public.tallas for delete
  to anon using (true);

-- 3) Activar tiempo real (para que los cambios aparezcan al instante)
alter publication supabase_realtime add table public.tallas;
