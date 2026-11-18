// BRN Satış Programı · çevrimdışı çalışma için uygulama dosyalarını önbelleğe alır.
// Sayfa internet varsa en güncel sürümü alır; internet yoksa kayıtlı sürüm açılır.
// Kayıtlar (Supabase) önbelleğe alınmaz; onları program kendi yerel veritabanında tutar.
// Önbellek adı "brn-" ile başlar ve yalnızca kendi eski önbelleklerini siler.
const SURUM = "brn-v28";
const KABUK = ["./", "./index.html", "./config.js", "./manifest.webmanifest", "./icon-192.png", "./icon-512.png", "./favicon-32.png", "./logo.png", "./logo-yatay.png"];
const KUTUPHANELER = [
  "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.45.4/dist/umd/supabase.js",
  "https://cdn.jsdelivr.net/npm/html5-qrcode@2.3.8/html5-qrcode.min.js",
  "https://cdn.jsdelivr.net/npm/jsbarcode@3.11.6/dist/JsBarcode.all.min.js",
  "https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"
];
self.addEventListener("install", e => {
  e.waitUntil(caches.open(SURUM).then(c => Promise.all([...KABUK, ...KUTUPHANELER].map(u => c.add(u).catch(() => {})))).then(() => self.skipWaiting()));
});
self.addEventListener("activate", e => {
  e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k.startsWith("brn-") && k !== SURUM).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener("fetch", e => {
  const u = new URL(e.request.url);
  if (e.request.method !== "GET" || u.hostname.endsWith("supabase.co")) return;
  const ayniKaynak = u.origin === self.location.origin;
  const kutuphane = /cdn\.jsdelivr\.net|fonts\.(googleapis|gstatic)\.com/.test(u.hostname);
  const onbellek = () => caches.open(SURUM);
  if (ayniKaynak) {
    // cache:'no-cache' → tarayıcının HTTP önbelleği atlanır, sunucuya "değişti mi?" sorulur (yeni sürüm hemen gelir)
    e.respondWith(fetch(e.request.url, {cache: "no-cache", credentials: "same-origin"}).then(r => { if (r.ok) { const k = r.clone(); onbellek().then(c => c.put(e.request, k)); } return r; })
      .catch(() => onbellek().then(c => c.match(e.request, {ignoreSearch: true}).then(r => r || c.match("./index.html")))));
  } else if (kutuphane) {
    e.respondWith(onbellek().then(c => c.match(e.request)).then(r => r || fetch(e.request).then(res => { const k = res.clone(); onbellek().then(c => c.put(e.request, k)); return res; })));
  }
});
