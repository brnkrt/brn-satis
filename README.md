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

## Kısayollar (bilgisayar)

| Tuş | İşlem |
|---|---|
| Enter | Okutulan / yazılan ürünü sepete ekle |
| `5*barkod` | Aynı üründen 5 adet ekle |
| F2 / F3 | Nakit / Kart |
| F4 | Alınan para alanına geç |
| F7 | Sepeti temizle |
| F9 | Satışı tamamla |

## Notlar

- İlk açılışta ve ilk girişte internet gerekir. Sonrasında program internet olmadan da açılır ve satış yapar.
- Stok, açılış adedi ile stok girişleri ve sayımlar toplanıp satışlar çıkarılarak hesaplanır. Bu sayede iki kasa aynı anda internetsiz satış yapsa bile stok doğru kalır.
- Silinen ürünler ve iptal edilen satışlar kaybolmaz, yalnızca işaretlenir. Raporlarda iptaller ayrıca gösterilir.
- *Ayarlar > Ek yedek indir* ile isteğe bağlı olarak `.json` yedek alınabilir. Asıl kayıtlar zaten bulutta durur.
- Supabase'in ücretsiz planında bir hafta hiç kullanılmayan projeler duraklatılır. Program her gün kullanıldığında bu sorun olmaz. Duraklatılırsa Supabase panelinden tek tıkla yeniden başlatılır, veriler silinmez.
- Yazdırılan fiş **bilgi fişidir, mali değeri yoktur**. Yasal belge için yazar kasa (ÖKC) / e-Arşiv kullanılmalıdır.
