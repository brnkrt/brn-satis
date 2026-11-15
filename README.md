# BRN Satış Programı

Kırtasiye için barkodlu satış, stok ve kasa programı. Bilgisayarda ve telefonda uygulama olarak kurulur, internet olmadan da satış yapar. Kendi veritabanı, kendi kullanıcıları ve kendi girişi vardır; başka hiçbir programa bağlı değildir.

## Nasıl çalışır?

- **Kayıtlar buluttadır** (Supabase). Bilgisayar bozulsa veya tarayıcı temizlense de kayıtlar kaybolmaz.
- **İnternet olmadan da satış yapılır.** Satışlar önce cihaza kaydedilir, internet gelince kendiliğinden buluta gönderilir. Üst köşedeki işaret durumu gösterir: *Eşitlendi*, *Çevrimdışı · 3 bekliyor* gibi.
- Bir kasada yapılan satış, telefonda ve diğer kasalarda birkaç saniye içinde görünür.
- Telefonda kamerayla barkod okutularak satış yapılabilir, fiyat ve stok sorgulanabilir.

## Kurulum

### 1. Veritabanı (Supabase)

1. <https://supabase.com> adresinde ücretsiz hesapla giriş yapın ve **New project** ile yeni bir proje açın. Ad olarak `brn-satis` yazabilirsiniz. Bölge olarak *Frankfurt (eu-central-1)* seçin.
2. Proje hazır olunca soldaki menüden **SQL Editor > New query** bölümüne girin. `brn-schema.sql` dosyasının tamamını yapıştırıp **Run** deyin.
3. **Project Settings > API** (veya *Data API*) bölümünden iki bilgiyi kopyalayın:
   - **Project URL** (`https://xxxx.supabase.co`)
   - **Publishable key** (`sb_publishable_...`) ya da *anon public* anahtar
4. Bu iki bilgiyi `config.js` dosyasında `BURAYA_...` yazan yerlere yapıştırın.

> **service_role / secret** anahtarını hiçbir dosyaya yazmayın, kimseyle paylaşmayın.

### 2. Yayınlama (GitHub Pages)

1. GitHub'da yeni bir depo açın, örneğin `brn-satis`.
2. Bu klasördeki dosyaların hepsini depoya yükleyin.
3. **Settings > Pages** bölümünden *Branch: main / root* seçip kaydedin.
4. Birkaç dakika sonra program `https://KULLANICIADI.github.io/brn-satis/` adresinde açılır.

### 3. Giriş adresleri

Supabase panelinde **Authentication > URL Configuration** bölümüne girin. *Site URL* alanına programın adresini yazın ve aynı adresi *Redirect URLs* listesine ekleyin. Böylece kayıt onayı ve şifre sıfırlama e-postalarındaki bağlantılar programa döner.

### 4. İlk giriş

Programı açın, **Hesap oluştur** ile kaydolun ve e-postanızdaki onay bağlantısına tıklayın. Sonra giriş yapıp firmanızı oluşturun. Firmayı oluşturan kişi firma sahibi olur.

### 5. Uygulama olarak kurma

- **Bilgisayar:** Chrome veya Edge'de adres çubuğundaki *Yükle* simgesine ya da *Ayarlar > Uygulama olarak yükle* düğmesine tıklayın. Program masaüstünde kendi penceresinde açılır.
- **Android:** Chrome menüsünden *Ana ekrana ekle / Uygulamayı yükle*.
- **iPhone:** Safari'de *Paylaş > Ana Ekrana Ekle*.

### 6. Her cihaza kasa adı verin

*Ayarlar > Bu Cihaz > Kasa adı* alanına `KASA1`, `KASA2`, `TEL` gibi ayrı adlar yazın. Fiş numaraları bu adla başlar ve raporlar kasaya göre süzülebilir.

## Çalışan ekleme

1. Çalışan programı açar ve **Hesap oluştur** ile kaydolur.
2. Firma sahibi **Ayarlar > Kullanıcılar** bölümüne çalışanın e-postasını yazıp ekler.
3. Çalışan giriş yaptığında firma otomatik açılır. Firma sahibi çalışanı aynı bölümden çıkarabilir.

## İlk kullanım

- **Ürünleri yükleme:** *Ayarlar > Ürünleri içe aktar* ile Excel'den kaydedilmiş CSV dosyası yüklenebilir. Sütun sırası: Barkod; Ürün Adı; Kategori; Alış Fiyatı; Satış Fiyatı; Stok; Kritik Stok.
- **Önceki tek dosyalık programdan aktarma:** Eski programda *Ayarlar > Yedek Al* ile indirilen `.json` dosyasını burada *Ayarlar > Yedekten yükle* ile seçin. Ürünler ve stok adetleri aktarılır.
- **Barkod okuyucu:** USB barkod okuyucu klavye gibi çalışır. Takıp okutmanız yeterli.
- **Fiş yazıcı:** Termal yazıcıyı Windows'a kurun. İlk fişte açılan yazdırma penceresinde yazıcıyı ve *Kenar boşluğu: Yok* seçeneğini seçin.

## Hızlı ürünler

- Satış ekranının altındaki **⚡ Hızlı Ürünler** düğmeleri tek tıkla sepete ekler. Hangi ürünlerin görüneceği **⚙ Düzenle** ile seçilir.
- Bir düğmeye **sağ tıklayınca** (telefonda **basılı tutunca**) menü açılır: **Düzenle** (ad, fiyat, barkod, stok, KDV), varyantlı ürünlerde **Tüm varyantlar**, **Sepete ekle**, **Etiket yazdır**, **Sola / Sağa taşı** ve **Hızlı ürünlerden çıkar**. Düzenleme satış ekranından çıkmadan yapılır.

## Ürün listesini sıralama

Ürünler ekranındaki **↕ Sırala** seçicisiyle liste ada, stoğa (azdan çoğa / çoktan aza), fiyata, en çok / en az satanlara, son eklenenlere, kategoriye ya da barkoda göre sıralanır. Bilgisayarda sütun başlıklarına tıklayarak da sıralanabilir; aynı başlığa ikinci tıklama yönü değiştirir (▲ / ▼). Seçim her cihazda hatırlanır.

## Varyantlı ürünler

Renk, ebat, çizgi tipi gibi seçenekleri olan ürünler için (örn. *Faber Tükenmez Kalem* → Mavi, Kırmızı, Siyah).

- **Ürünler › 🎨 Varyantlı Ürün**: ürün adını, kategoriyi ve fiyatı bir kez yazın.
- **📷 Varyantları hızlıca ekle** kutusuna barkodları sırayla okutun. Her okutmada alta yeni bir satır eklenir. Aynı barkod iki kez okutulursa ya da başka bir üründe kayıtlıysa uyarı verir. Telefonda 📷 düğmesiyle kamerayla art arda okutulabilir.
- Varyant adı **isteğe bağlıdır**. Boş bırakılırsa tüm varyantlar aynı ürün adını taşır. İsterseniz renk/ebat yazabilirsiniz; o zaman ad *Ürün Adı - Mavi* olur. Kutuya barkod yerine `Mavi, Kırmızı, Siyah` gibi virgülle ad da yazılabilir.
- **Fiyat tüm varyantlarda aynıdır.** Üstteki satış fiyatı otomatik olarak bütün varyantlara işlenir. Bir varyantın fiyatı ürün formundan ya da sepetteki *Kalıcı yap* ile değiştirilirse diğer varyantların fiyatı da birlikte değişir.
- Stoklarını yazıp **Kaydet**'e basın. Barkodu olmayan satır için **🎲** barkod üretir.
- Her varyant ayrı bir ürün gibi satılır, stoktan ayrı düşer ve ayrı etiketlenir.
- Listede bir varyantın **Düzenle** düğmesi tüm varyantları birlikte açar. Buradan yeni varyant eklenir, varyant silinir ya da ürün adı değiştirilir. Bir varyantın kritik stok, hızlı ürün ve sayım ayarları için satırdaki **⚙** düğmesi kullanılır.
- Daha önce tek ürün olarak girilmiş bir ürün, formundaki **🎨 Varyant ekle** düğmesiyle varyantlı hâle getirilebilir.

## Veresiye

- Satış ekranında **📒 Veresiye** (F6) seçilir, müşteri adı veya telefonuyla aranır ya da **+ Yeni müşteri** ile eklenir. Fişte müşteri adı, güncel borç ve imza yeri çıkar.
- **Veresiye** sekmesinde borçlu müşteriler ve toplam alacak görünür. **Aç** ile müşterinin hesap hareketleri açılır. Buradan **tahsilat** alınır, makbuz ve **hesap dökümü** yazdırılır.
- Gün sonu raporunda veresiye satışlar ve tahsilatlar ayrı gösterilir. *Kasaya giren nakit* satırı, nakit satış ile nakit tahsilatın toplamıdır.

## Fatura (Trendyol e-Faturam)

- Üst menüdeki **🧾 Fatura** sekmesinden **+ Yeni Fatura** açılır. Satış sonrasında ya da *Raporlar › satış detayı*ndaki **🧾 Fatura kes** düğmesiyle satış doğrudan faturaya çevrilir.
- **Alıcı:** Kayıtlı müşteriden seçilebilir ya da yazılır. VKN (10 hane) / TCKN (11 hane) otomatik kontrol edilir. TCKN bilinmiyorsa *nihai tüketici* (11111111111) işaretlenir. Bilgiler istenirse müşteri kartına kaydedilir.
- **Kalemler:** Barkod okutulur ya da ürün aranır. Fiyatlar KDV dahildir; program KDV hariç tutarı ve KDV'yi oran oran ayırır. Ürünlerin KDV oranı ürün formundan, varsayılan oran *Ayarlar › Fatura*dan ayarlanır.
- **Trendyol e-Faturam'da kes:** Fatura kaydedilir ve aktarım paneli açılır. Portal yeni sekmede açılır, bilgiler 📋 düğmeleriyle kopyalanıp yapıştırılır. Portalın verdiği fatura numarası panele yazılınca fatura **Kesildi** olur.
- Taslak faturalar sonra tamamlanabilir. Kesilmiş bir fatura portalda iptal edilirse BRN'de *İptal edildi olarak işaretle* ile kaydı güncellenir.
- BRN'deki **🖨 Önizleme** çıktısı fatura değildir. Yasal fatura Trendyol e-Faturam'da kesilir.
- Yetki: çalışanların fatura kesebilmesi için *Ayarlar › Kullanıcılar › Yetkiler*den **Fatura hazırlama ve kesme** açılmalıdır.

### Tek tuşla otomatik kesim (ileride)

Trendyol e-Faturam'ın API'si yalnızca **önceden tanımlanmış sabit IPv4 adreslerinden** gelen isteklere açıktır. Program tarayıcıda çalıştığı için doğrudan bağlanamaz; araya sabit IP'li küçük bir sunucu gerekir. Kurulum için:

1. Trendyol e-Faturam portalında **Entegrasyon** ekranından *bireysel entegrasyon* başvurusu yapılır (sunucunun sabit IP adresi girilir, en fazla 3 adres).
2. Onay e-postasıyla test ortamına şifre belirlenir; denemeler test ortamında yapılır.
3. Sabit IP'li küçük bir sunucu (VPS) kiralanır. Bu sunucuda BRN ile Trendyol arasında aracılık eden küçük bir program çalışır.
4. Bunlar hazır olunca fatura ekranına **Trendyol'a gönder** düğmesi eklenir: fatura tek tuşla kesilir, numarası ve PDF'i otomatik gelir.

## Personel

Arvenato Ön Muhasebe'deki personel ekranının aynısıdır; kayıtlar BRN'nin kendi veritabanında tutulur.

- **Liste:** aktif personel, aylık net maaş, bu ay ödenen ve kalan maaş özetleri. Maaş günü geçen ya da yaklaşan personel için üstte uyarı çıkar. Her satırda maaş durumu (*Maaş ödendi / Kısmi / Ödenmedi*), izinde olanlar ve kalan yıllık izin görünür.
- **Personel kartı:** görev, telefon, işe giriş tarihi, aylık net maaş, maaş günü, yıllık izin hakkı, personel indirimi (%), TC no, durum (Çalışıyor / Ayrıldı). Kaydı olan personel silinmez, *Ayrıldı* yapılır.
- **Ödeme yap:** Maaş, avans, prim, SGK primi, diğer. Tutar o ayın kalan hak edişiyle otomatik gelir. Kasadan yapılan ödemeler gün sonu raporunda kasadan çıkan nakit olarak görünür.
- **Avans:** aylık avans takibi; net maaşı aşınca uyarır.
- **Mesai / Prim / Yemek:** fazla mesai (×1,5 / ×2 / ×1, saat ücreti maaş ÷ 225 önerilir), prim ve günlük yemek ücreti o ayın hak edişine eklenir.
- **İzinler:** kıdeme göre yıllık izin hakkı (1–5 yıl 14, 5–15 yıl 20, 15+ yıl 26 gün), kullanılan ve kalan izin; yıllık, ekstra, mazeret, raporlu, ücretsiz izin türleri. Gün sayısı pazar hariç otomatik hesaplanır.
- **Ürün alımı:** personelin aldığı ürünler maaştan düşülür. Barkod okutularak stoktan seçilebilir; personel indirimi otomatik uygulanır. İstenirse satış olarak kaydedilir (ciroya girer, stoktan düşer, ödeme türü *Maaştan*). Kayıt silinirse ürün stoğa geri döner.
- **Geçmiş:** tüm ödemeler aylara göre gruplu listelenir.
- Yetki: çalışanların bu bölümü görmesi için *Ayarlar › Kullanıcılar › Yetkiler*den **Personel, maaş, avans ve izinler** açılmalıdır (varsayılan kapalı).

## Barkod etiketi

- **Ürünler › 🏷 Etiket Yazdır**: ürünleri arayın ya da barkod okutun, her ürün için adet girin, etiket boyutunu seçin ve yazdırın.
- Boyutlar: 40×30, 50×30, 58×40 mm termal etiket; A4 sayfa 24'lü (70×37) ve 40'lı (52,5×29,7).
- Barkodu olmayan ürünler için ürün formundaki **🎲 Üret** düğmesi, `29` ile başlayan mağaza içi bir barkod üretir. Etiket yazdırırken de toplu üretilebilir.
- Termal etiket yazıcıda, yazdırma penceresinde kağıt boyutu olarak etiket boyutunu ve *Kenar boşluğu: Yok* seçeneğini seçin.

## Kullanıcı yetkileri

Firma sahibi **Ayarlar › Kullanıcılar › Yetkiler** bölümünden her çalışan için şunları açıp kapatabilir:

| Yetki | Çalışan için varsayılan |
|---|---|
| Ürün ekleme, düzenleme ve fiyat değiştirme | Kapalı |
| Stok girişi ve sayım | Açık |
| Satışta indirim yapma | Kapalı |
| Veresiye satış, müşteriler ve tahsilat | Açık |
| Satış ve tahsilat iptali | Kapalı |
| Raporları, kârı ve alış fiyatlarını görme | Kapalı |
| Fiş bilgileri, yedek alma ve yedekten yükleme | Kapalı |

Satış yapma, ürün arama, fiyat sorgulama ve etiket yazdırma her kullanıcıya açıktır. Yetkileri yalnızca firma sahibi değiştirebilir; bunu veritabanı kuralı da korur (`brn-guncelleme-1.sql`). Diğer kısıtlamalar programın ekranlarında uygulanır.

## Kısayollar (bilgisayar)

| Tuş | İşlem |
|---|---|
| Enter | Okutulan / yazılan ürünü sepete ekle |
| `5*barkod` | Aynı üründen 5 adet ekle |
| F2 / F3 | Nakit / Kart |
| F4 | Alınan para alanına geç |
| F6 | Veresiye (müşteri seçimi) |
| F7 | Sepeti temizle |
| F9 | Satışı tamamla |

## Notlar

- İlk açılışta ve ilk girişte internet gerekir. Sonrasında program internet olmadan da açılır ve satış yapar.
- Stok, açılış adedi ile stok girişleri ve sayımlar toplanıp satışlar çıkarılarak hesaplanır. Bu sayede iki kasa aynı anda internetsiz satış yapsa bile stok doğru kalır.
- Silinen ürünler ve iptal edilen satışlar kaybolmaz, yalnızca işaretlenir. Raporlarda iptaller ayrıca gösterilir.
- *Ayarlar > Ek yedek indir* ile isteğe bağlı olarak `.json` yedek alınabilir. Asıl kayıtlar zaten bulutta durur.
- Supabase'in ücretsiz planında bir hafta hiç kullanılmayan projeler duraklatılır. Program her gün kullanıldığında bu sorun olmaz. Duraklatılırsa Supabase panelinden tek tıkla yeniden başlatılır, veriler silinmez.
- Yazdırılan fiş **bilgi fişidir, mali değeri yoktur**. Yasal belge için yazar kasa (ÖKC) / e-Arşiv kullanılmalıdır.
