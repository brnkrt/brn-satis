-- BRN Satış Programı · Supabase veritabanı kurulumu
-- Supabase panelinde: SQL Editor > New query > bu dosyanın tamamını yapıştırın > Run
-- Tüm tablo ve fonksiyon adları "brn_" ile başlar; aynı projede başka bir program varsa ona dokunmaz.

create extension if not exists pgcrypto;

-- Firmalar ve kullanıcılar
create table if not exists public.brn_firmalar (
  id uuid primary key default gen_random_uuid(),
  ad text not null,
  olusturma timestamptz not null default now()
);

create table if not exists public.brn_uyeler (
  firma_id uuid not null references public.brn_firmalar(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  rol text not null default 'uye' check (rol in ('sahip','uye')),
  eklenme timestamptz not null default now(),
  primary key (firma_id, user_id)
);

-- Tüm program kayıtları (ürünler, stok girişleri, satışlar, ayarlar)
create table if not exists public.brn_kayitlar (
  firma_id uuid not null references public.brn_firmalar(id) on delete cascade,
  koleksiyon text not null,
  id text not null,
  veri jsonb not null default '{}'::jsonb,
  guncelleme timestamptz not null default now(),
  primary key (firma_id, koleksiyon, id)
);
create index if not exists brn_kayitlar_esitleme_idx on public.brn_kayitlar (firma_id, guncelleme);

-- Güncelleme zamanını sunucu saati belirler (cihaz saatleri farklı olsa da eşitleme kaçırmaz)
create or replace function public.brn_guncelleme_damgasi() returns trigger
language plpgsql as $$
begin
  new.guncelleme := clock_timestamp();
  return new;
end $$;
drop trigger if exists brn_kayitlar_damga on public.brn_kayitlar;
create trigger brn_kayitlar_damga before insert or update on public.brn_kayitlar
  for each row execute function public.brn_guncelleme_damgasi();

-- Yetki yardımcıları
create or replace function public.brn_uye_mi(f uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.brn_uyeler where firma_id = f and user_id = auth.uid());
$$;
create or replace function public.brn_sahip_mi(f uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.brn_uyeler where firma_id = f and user_id = auth.uid() and rol = 'sahip');
$$;

-- Satır düzeyinde güvenlik: herkes yalnızca üyesi olduğu firmanın kayıtlarını görür
alter table public.brn_firmalar enable row level security;
alter table public.brn_uyeler enable row level security;
alter table public.brn_kayitlar enable row level security;

drop policy if exists brn_firmalar_oku on public.brn_firmalar;
create policy brn_firmalar_oku on public.brn_firmalar for select to authenticated using (public.brn_uye_mi(id));
drop policy if exists brn_firmalar_guncelle on public.brn_firmalar;
create policy brn_firmalar_guncelle on public.brn_firmalar for update to authenticated using (public.brn_sahip_mi(id)) with check (public.brn_sahip_mi(id));

drop policy if exists brn_uyeler_oku on public.brn_uyeler;
create policy brn_uyeler_oku on public.brn_uyeler for select to authenticated using (user_id = auth.uid() or public.brn_uye_mi(firma_id));

drop policy if exists brn_kayit_oku on public.brn_kayitlar;
create policy brn_kayit_oku on public.brn_kayitlar for select to authenticated using (public.brn_uye_mi(firma_id));
-- Yetkiler ("yetki" kayıtları) yalnızca firma sahibi tarafından yazılabilir
drop policy if exists brn_kayit_ekle on public.brn_kayitlar;
create policy brn_kayit_ekle on public.brn_kayitlar for insert to authenticated with check (public.brn_uye_mi(firma_id) and (koleksiyon <> 'yetki' or public.brn_sahip_mi(firma_id)));
drop policy if exists brn_kayit_guncelle on public.brn_kayitlar;
create policy brn_kayit_guncelle on public.brn_kayitlar for update to authenticated using (public.brn_uye_mi(firma_id)) with check (public.brn_uye_mi(firma_id) and (koleksiyon <> 'yetki' or public.brn_sahip_mi(firma_id)));
-- Silme yok: kayıtlar "silindi" / "iptal" işaretiyle gizlenir, böylece tüm cihazlara yansır.

-- Firma oluşturma (oluşturan kişi firmanın sahibi olur)
create or replace function public.brn_firma_olustur(p_ad text) returns uuid
language plpgsql security definer set search_path = public as $$
declare v_id uuid;
begin
  if auth.uid() is null then raise exception 'Giriş yapmalısınız'; end if;
  insert into public.brn_firmalar (ad) values (coalesce(nullif(trim(p_ad), ''), 'Firmam')) returning id into v_id;
  insert into public.brn_uyeler (firma_id, user_id, rol) values (v_id, auth.uid(), 'sahip');
  return v_id;
end $$;

-- Kullanıcı yönetimi
create or replace function public.brn_uyeleri_listele(p_firma uuid)
returns table (user_id uuid, eposta text, rol text)
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.brn_uye_mi(p_firma) then raise exception 'Yetkiniz yok'; end if;
  return query select u.user_id, au.email::text, u.rol from public.brn_uyeler u join auth.users au on au.id = u.user_id where u.firma_id = p_firma order by u.eklenme;
end $$;

create or replace function public.brn_uye_ekle(p_firma uuid, p_eposta text) returns text
language plpgsql security definer set search_path = public as $$
declare v_uid uuid;
begin
  if not public.brn_sahip_mi(p_firma) then raise exception 'Kullanıcı eklemek için firma sahibi olmalısınız'; end if;
  select id into v_uid from auth.users where lower(email) = lower(trim(p_eposta)) limit 1;
  if v_uid is null then raise exception 'Bu e-postayla açılmış bir hesap yok. Kişi önce programda "Hesap oluştur" ile kaydolmalı.'; end if;
  insert into public.brn_uyeler (firma_id, user_id, rol) values (p_firma, v_uid, 'uye') on conflict do nothing;
  return 'ok';
end $$;

create or replace function public.brn_uye_cikar(p_firma uuid, p_user uuid) returns text
language plpgsql security definer set search_path = public as $$
begin
  if not public.brn_sahip_mi(p_firma) then raise exception 'Kullanıcı çıkarmak için firma sahibi olmalısınız'; end if;
  if p_user = auth.uid() then raise exception 'Kendinizi çıkaramazsınız'; end if;
  delete from public.brn_uyeler where firma_id = p_firma and user_id = p_user;
  return 'ok';
end $$;

revoke all on function public.brn_firma_olustur(text), public.brn_uyeleri_listele(uuid), public.brn_uye_ekle(uuid, text), public.brn_uye_cikar(uuid, uuid) from public, anon;
grant execute on function public.brn_firma_olustur(text), public.brn_uyeleri_listele(uuid), public.brn_uye_ekle(uuid, text), public.brn_uye_cikar(uuid, uuid), public.brn_uye_mi(uuid), public.brn_sahip_mi(uuid) to authenticated;
grant select, insert, update on public.brn_kayitlar to authenticated;
grant select, update on public.brn_firmalar to authenticated;
grant select on public.brn_uyeler to authenticated;

-- Canlı eşitleme (bir kasada yapılan satış diğer cihazlarda anında görünür)
do $$ begin
  alter publication supabase_realtime add table public.brn_kayitlar;
exception when duplicate_object then null; end $$;
