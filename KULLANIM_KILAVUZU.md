# 🐝 OMEGA-JB Bee Swarm Simulator - Kullanım Kılavuzu

## 📥 Nasıl Çalıştırılır?

### 1. Roblox Executor İndir
Önce bir Roblox executor indirmen gerekiyor:
- **Windows:** KRNL, Fluxus, Synapse X, Script-Ware, Electron
- **Android:** Arceus X, Delta, Codex

### 2. Script'i Yükle

#### Yöntem 1: Loader ile (Önerilen)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dreadfull09/otofarm/main/loader.lua"))()
```

#### Yöntem 2: Direkt Script
```lua
-- Sadece Auto Farm için:
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dreadfull09/otofarm/main/src/autofarm.lua"))()

-- Sadece Pro Exploits için:
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dreadfull09/otofarm/main/src/proexploits.lua"))()
```

### 3. Adım Adım Kullanım

#### Auto Farm Kullanımı:

1. **Bee Swarm Simulator'a gir**
2. **Executor'u aç** (Roblox penceresinin yanında durmalı)
3. **Yukarıdaki kodu kopyala ve executor'a yapıştır**
4. **Execute/Inject butonuna tıkla**
5. **Ekranda GUI menü belirecek**

#### GUI Menü'de Yapılacaklar:

**Ana Sekme (Auto Farm):**
- ✅ "Enable Auto Farm" toggle'ını AÇ
- 🌻 "Select Field" dropdown'dan tarla seç (Sunflower, Mushroom, vb.)
- ⚡ "Farm Speed" slider'dan hız ayarla (50-500)
- 🎯 "Convert At (%)" slider'dan çanta dolum oranı (95% önerilir)
- ✅ "Auto Collect Tokens" - Tokenları otomatik toplar
- ✅ "Auto Dig" - Otomatik kazma yapar

**Teleport Sekmesi:**
- İstediğin konuma anında ışınlan
- Spawn, Hub, tüm tarlalar mevcut

**Mob Farm Sekmesi:**
- "Enable Mob Farm" ile böcek/örümcek avla
- "Instant Kill" ile anında öldür

**Player Mods Sekmesi:**
- WalkSpeed: Yürüme hızı (16-200)
- JumpPower: Zıplama gücü (50-200)
- Fly: Uçma modu
- NoClip: Duvarlardan geçme
- Infinite Jump: Sonsuz zıplama

**Hotkey'ler:**
- `F1` - Auto Farm aç/kapat
- `F2` - Pro Exploits aç
- `DELETE` - Acil durdurma
- `SPACE` (çift) - Infinite jump

---

## 🎯 Özelliklerin Açıklaması

### Auto Farm Ne Yapar?
1. Seçtiğin tarlaya gider
2. Belirlediğin hızda çiçekleri toplar
3. Tokenları otomatik toplar
4. Çanta %95 dolunca kovana gider
5. Balı dönüştürür
6. Tekrar tarlaya döner

### Pro Exploits Ne Yapar?
- **Item Duplication:** Eşya çoğaltma
- **Instant Level:** Anında level atlama
- **God Mode:** Ölümsüzlük
- **Server Exploits:** Server kontrolü

---

## ⚙️ Ayarlar (Config)

Script içinde şu ayarları değiştirebilirsin:

```lua
-- Hız ayarları
Speed = 100          -- Farm hızı
WalkSpeed = 80       -- Yürüme hızı
JumpPower = 120      -- Zıplama gücü

-- Farm ayarları
ConvertAt = 95       -- %95 dolunca dönüştür
Field = "Sunflower"  -- Varsayılan tarla

-- Güvenlik
AntiDetection = true -- Anti-cheat koruması
```

---

## 🔧 Sorun Giderme

### "Script çalışmıyor" hatası:
1. Executor'u yönetici olarak çalıştır
2. Farklı bir executor dene
3. Roblox'u yeniden başlat

### "GUI açılmıyor":
1. Orion Lib yükleniyor olabilir, bekle
2. İnternet bağlantını kontrol et
3. Executor'u yeniden inject et

### "Çok yavaş çalışıyor":
- Farm Speed'i artır (200-500)
- WalkSpeed'i artır (100-200)
- Bilgisayar performansını kontrol et

### "Banlandım" uyarısı:
- AntiDetection açık olsun
- Çok hızlı farm yapma (100-150 ideal)
- Aralıklarla kullan (2-3 saat sonra mola ver)

---

## 💡 İpuçları

1. **En İyi Farm Tarlaları:**
   - Başlangıç: Sunflower Field
   - Orta seviye: Strawberry Field
   - İleri seviye: Coconut Field

2. **Hızlı Level Atlama:**
   - Mob Farm + Auto Farm birlikte kullan
   - Quest'leri tamamla

3. **Güvenli Kullanım:**
   - Günde max 4-5 saat kullan
   - Arada elinle oyna
   - Çok hızlı ayarlardan kaçın

---

## ⚠️ Önemli Uyarılar

- Bu script Roblox kurallarını ihlal eder
- Hesabın banlanabilir (özellikle Pro Exploits)
- Alt hesap kullanman önerilir
- Kullanım riski sana aittir

---

## 📞 Yardım

Sorun yaşarsan:
1. Script'i yeniden yükle
2. Farklı executor dene
3. Roblox'u yeniden başlat

**Not:** Script eğitim amaçlıdır!