-- Bookora admin + order policies
-- Run this in Supabase Dashboard > SQL Editor.
-- Admin access is granted only to the authenticated user whose app_metadata.role = 'admin'.

alter table public.orders enable row level security;

drop policy if exists "bookora_public_create_orders" on public.orders;
create policy "bookora_public_create_orders"
on public.orders for insert
to anon, authenticated
with check (
  status = 'pending'
  and admin_note = ''
  and length(customer_name) between 2 and 120
  and length(phone) between 7 and 30
  and payment_method in ('instapay', 'vodafone_cash')
  and total >= 0
);

drop policy if exists "bookora_admin_read_orders" on public.orders;
create policy "bookora_admin_read_orders"
on public.orders for select
to authenticated
using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

drop policy if exists "bookora_admin_update_orders" on public.orders;
create policy "bookora_admin_update_orders"
on public.orders for update
to authenticated
using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- After creating the user with the admin email in Authentication > Users,
-- grant the admin role by running the UPDATE below with the user's actual UUID:
-- update auth.users
-- set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb) || '{"role":"admin"}'::jsonb
-- where email = 'gomaaomer639@gmail.com';
