--[[
    ╔══════════════════════════════════════════════════════════╗
    ║           OMEGA-JB BSS LOADER                            ║
    ║     Loadstring ile çalışan ana giriş noktası            ║
    ╚══════════════════════════════════════════════════════════╝
--]]

local OMEGA_JB = {}

OMEGA_JB.Version = "2.0.0"
OMEGA_JB.Author = "OMEGA-JB"
OMEGA_JB.LastUpdated = "2026-03-08"

-- GitHub Raw URL'leri
OMEGA_JB.URLs = {
    AutoFarm = "https://raw.githubusercontent.com/Dreadfull09/otofarm/main/src/autofarm.lua",
    ProExploits = "https://raw.githubusercontent.com/Dreadfull09/otofarm/main/src/proexploits.lua",
    Utils = "https://raw.githubusercontent.com/Dreadfull09/otofarm/main/src/utils.lua",
    Config = "https://raw.githubusercontent.com/Dreadfull09/otofarm/main/src/config.lua"
}

-- Script seçenekleri
OMEGA_JB.Scripts = {
    [1] = {
        name = "Auto Farm (Temel)",
        url = OMEGA_JB.URLs.AutoFarm,
        description = "Otomatik farm, teleport, speed hack",
        color = Color3.fromRGB(0, 255, 100)
    },
    [2] = {
        name = "Pro Exploits (Gelişmiş)",
        url = OMEGA_JB.URLs.ProExploits,
        description = "Dupe, server exploits, instant actions",
        color = Color3.fromRGB(255, 100, 0)
    },
    [3] = {
        name = "Auto Farm + Pro (Full)",
        url = nil, -- Özel loader
        description = "Her iki script birlikte",
        color = Color3.fromRGB(255, 0, 255)
    }
}

-- Güvenli yükleme fonksiyonu
function OMEGA_JB:SafeLoad(url)
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if success and result and #result > 0 then
        return result
    else
        warn("[OMEGA-JB] Yükleme başarısız: " .. tostring(url))
        return nil
    end
end

-- Script çalıştırma
function OMEGA_JB:Execute(scriptCode)
    if scriptCode then
        local func, err = loadstring(scriptCode)
        if func then
            local success, result = pcall(func)
            if not success then
                warn("[OMEGA-JB] Çalıştırma hatası: " .. tostring(result))
            end
            return success
        else
            warn("[OMEGA-JB] Loadstring hatası: " .. tostring(err))
        end
    end
    return false
end

-- Script yükle ve çalıştır
function OMEGA_JB:LoadScript(scriptType)
    print("[OMEGA-JB] Script yükleniyor...")
    
    local scriptData = self.Scripts[scriptType]
    if not scriptData then
        warn("[OMEGA-JB] Geçersiz script tipi!")
        return
    end
    
    if scriptType == 3 then
        -- Full paket - önce utils, sonra her iki script
        self:Execute(self:SafeLoad(self.URLs.Utils))
        wait(0.5)
        self:Execute(self:SafeLoad(self.URLs.AutoFarm))
        wait(0.5)
        self:Execute(self:SafeLoad(self.URLs.ProExploits))
    else
        -- Tekli script
        local code = self:SafeLoad(scriptData.url)
        if code then
            self:Execute(code)
            print("[OMEGA-JB] " .. scriptData.name .. " yüklendi!")
        end
    end
end

-- GUI ile seçim
function OMEGA_JB:ShowMenu()
    local success, OrionLib = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
    end)
    
    if not success then
        -- OrionLib yüklenemezse otomatik Auto Farm başlat
        warn("[OMEGA-JB] GUI yüklenemedi, Auto Farm başlatılıyor...")
        self:LoadScript(1)
        return
    end
    
    local Window = OrionLib:MakeWindow({
        Name = "OMEGA-JB Loader v" .. self.Version,
        HidePremium = false,
        SaveConfig = false
    })
    
    local MainTab = Window:MakeTab({
        Name = "Script Seçimi",
        Icon = "rbxassetid://4483345998"
    })
    
    MainTab:AddLabel("Yüklemek istediğiniz scripti seçin:")
    MainTab:AddParagraph("Bilgi", "Auto Farm = Güvenli, Pro = Riskli")
    
    for id, scriptInfo in pairs(self.Scripts) do
        MainTab:AddButton({
            Name = scriptInfo.name,
            Callback = function()
                OrionLib:MakeNotification({
                    Name = "Yükleniyor...",
                    Content = scriptInfo.description,
                    Time = 3
                })
                wait(0.5)
                self:LoadScript(id)
            end
        })
    end
    
    -- Hızlı yükleme butonları
    MainTab:AddSection({Name = "Hızlı Yükleme"})
    
    MainTab:AddBind({
        Name = "Auto Farm Hotkey",
        Default = Enum.KeyCode.F1,
        Hold = false,
        Callback = function()
            self:LoadScript(1)
        end
    })
    
    MainTab:AddBind({
        Name = "Pro Exploits Hotkey",
        Default = Enum.KeyCode.F2,
        Hold = false,
        Callback = function()
            self:LoadScript(2)
        end
    })
    
    -- Bilgi sekmesi
    local InfoTab = Window:MakeTab({
        Name = "Bilgi",
        Icon = "rbxassetid://4483345998"
    })
    
    InfoTab:AddParagraph("Versiyon", self.Version)
    InfoTab:AddParagraph("Son Güncelleme", self.LastUpdated)
    InfoTab:AddParagraph("Loadstring Kullanımı", 
        'loadstring(game:HttpGet("SENIN_URL_N/loader.lua"))()')
    
    OrionLib:Init()
end

-- Otomatik başlatma (eğer doğrudan çalıştırılırsa)
if not getgenv().OMEGA_JB_MANUAL_LOAD then
    OMEGA_JB:ShowMenu()
end

-- Global erişim
getgenv().OMEGA_JB = OMEGA_JB

return OMEGA_JB