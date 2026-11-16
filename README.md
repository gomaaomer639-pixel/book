# Bookora — GitHub Pages + Supabase

The storefront stays on GitHub Pages. It loads active books from Supabase and keeps the existing `data/products.json` catalog visible as a compatibility fallback. Existing order creation through WhatsApp and order review in the admin panel remain available.

## Book management

Open `/admin.html` and sign in with the existing authorized Supabase admin account. The panel supports adding and editing Arabic and English titles and descriptions, category, integer EGP price, cover and PDF uploads, publish/hide, and deletion. Files use the existing `bookora-covers` and `bookora-books` storage buckets.

## Existing Supabase setup

The GitHub update leaves `assets/store-config.js`, `data/products.json`, and the repository's existing `supabase-bookora-setup.sql` unchanged. No SQL is run or published. The setup SQL included in this review folder is not part of the deployment; do not run it again. Book management expects the existing `products` table and storage policies to be configured in Supabase; current order policies stay untouched. Admin authorization is enforced by Supabase RLS for users whose JWT `app_metadata.role` is `admin`.

The browser config contains only public settings and the publishable Supabase key. Never add passwords or a `service_role` key.

## Deploy

Publish the repository root from `main` using GitHub Pages. Verify the storefront at `/book/` and the admin panel at `/book/admin.html`. The compatibility catalog is read-only until its books are imported into `products`; records already present in Supabase are deduplicated against it by title.

