# 🐝 OMEGA-JB Bee Swarm Simulator Scripts

[![Version](https://img.shields.io/badge/Version-2.0.0-blue.svg)](https://github.com/kullanici/bss-scripts)
[![Lua](https://img.shields.io/badge/Language-Lua-blue.svg)](https://www.lua.org/)
[![Roblox](https://img.shields.io/badge/Platform-Roblox-red.svg)](https://www.roblox.com/)

> **OMEGA-JB UNFILTERED** - Bee Swarm Simulator için profesyonel auto farm ve exploit scriptleri

---

## 📦 İçerik

| Script | Açıklama | Risk Seviyesi |
|--------|----------|---------------|
| `autofarm.lua` | Temel auto farm, teleport, speed hack | 🟢 Düşük |
| `proexploits.lua` | Gelişmiş exploitler, dupe, server-side | 🔴 Yüksek |
| `loader.lua` | Ana giriş noktası (loadstring) | 🟢 Düşük |

---

## 🚀 Hızlı Başlangıç

### Loadstring ile Yükleme (Önerilen)

```lua
-- Loader kullanarak (GUI ile seçim)
loadstring(game:HttpGet("https://raw.githubusercontent.com/KULLANICI_ADIN/REPO_ADIN/main/loader.lua"))()

-- Veya doğrudan script yükleme
loadstring(game:HttpGet("https://raw.githubusercontent.com/KULLANICI_ADIN/REPO_ADIN/main/src/autofarm.lua"))()
```

### Manuel Yükleme

1. Scripti kopyalayın
2. Roblox executor (Synapse X, KRNL, Fluxus vb.) açın
3. Yapıştırın ve çalıştırın

---

## ✨ Özellikler

### Auto Farm Script
- ✅ Otomatik pollen toplama
- ✅ Otomatik token koleksiyonu
- ✅ Otomatik bal dönüştürme
- ✅ Teleport sistemi (15+ field)
- ✅ Mob farming (örümcek, böcek)
- ✅ Speed/Jump modifikasyonu
- ✅ Fly / NoClip modları
- ✅ Anti-AFK koruması
- ✅ Modern GUI (Orion Lib)
- ✅ Anti-detection sistemi

### Pro Exploits Script
- 🔥 Item duplication (LagSwitch, Trade, ServerHop)
- 🔥 Server-side exploitler
- 🔥 Instant quest/badge/level
- 🔥 Bee mutation/god mode
- 🔥 World manipulation
- 🔥 Advanced bypass sistemleri

---

## 📁 Dosya Yapısı

```
bss-scripts/
├── README.md
├── loader.lua              # Ana giriş noktası
├── src/
│   ├── autofarm.lua        # Temel auto farm
│   ├── proexploits.lua     # Gelişmiş exploitler
│   ├── utils.lua           # Yardımcı fonksiyonlar
│   └── config.lua          # Yapılandırma
└── docs/
    └── USAGE.md            # Detaylı kullanım kılavuzu
```

---

## 🎮 Kullanım

### Auto Farm

```lua
-- Script çalıştıktan sonra GUI'den:
-- 1. "Enable Auto Farm" toggle'ını açın
-- 2. Field seçin (Sunflower, Mushroom, vb.)
-- 3. Hız ayarlarını yapın
-- 4. İsteğe bağlı: Mob farm, token collection
```

### Teleport

```lua
-- GUI'den "Teleport" sekmesine gidin
-- İstediğiniz konuma tıklayın
-- Anında ışınlanacaksınız
```

### Hotkeys

| Tuş | İşlem |
|-----|-------|
| F1 | Auto Farm başlat |
| F2 | Pro Exploits başlat |
| Space (x2) | Infinite Jump |

---

## ⚙️ Yapılandırma

Script içindeki `Config` tablosunu düzenleyerek özelleştirebilirsiniz:

```lua
local Config = {
    AutoFarm = {
        Enabled = true,
        Field = "Sunflower Field",
        Speed = 100,
        ConvertAt = 95, -- %95 dolunca dönüştür
        AutoCollectTokens = true,
        AutoDig = true
    }
}
```

---

## 🛡️ Güvenlik

- ✅ Anti-cheat detection bypass
- ✅ WalkSpeed/JumpPower spoofing
- ✅ Random delay injection
- ✅ Server event validation bypass
- ✅ Anti-kick protection

---

## ⚠️ Sorumluluk Reddi

> **BU SCRIPTLER EĞİTİM AMAÇLIDIR!**

- Roblox'un Terms of Service'ini ihlal eder
- Hesabınızın banlanma riski vardır
- Kullanım riski tamamen size aittir
- Yazar(lar) hiçbir sorumluluk kabul etmez

---

## 🔧 Gereksinimler

- Roblox Executor (Synapse X, KRNL, Fluxus, Script-Ware, Electron)
- Lua desteği
- Internet bağlantısı (loadstring için)

---

## 📝 Sürüm Geçmişi

### v2.0.0 (2026-03-08)
- ✨ İlk sürüm
- ✨ Auto Farm sistemi
- ✨ Pro Exploits paketi
- ✨ GitHub/loadstring desteği
- ✨ Orion Lib GUI

---

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing`)
3. Commit yapın (`git commit -m 'Add amazing feature'`)
4. Push yapın (`git push origin feature/amazing`)
5. Pull Request açın

---

## 📜 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

---

## 📞 İletişim

- Discord: @omega_jb
- GitHub: [github.com/kullanici](https://github.com/kullanici)

---

<p align="center">
  <b>OMEGA-JB UNFILTERED</b><br>
  <i>"Limitsiz potansiyel, sınırsız güç"</i>
</p>
