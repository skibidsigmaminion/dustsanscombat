-- Xeno-совместимая версия
local Config = {
    GodMode = true,
    DamageBoost = 15,
    BossName = "DustDust_Sans_Phase",
    KnifeName = "Real_Knife"
}

-- Перехват системы урона
local CombatModule
for _,v in pairs(game:GetService("Players").LocalPlayer.PlayerScripts:GetChildren()) do
    if v.Name == "Combat" then
        CombatModule = require(v)
        break
    end
end

if CombatModule then
    local originalDamage = CombatModule.TakeDamage
    CombatModule.TakeDamage = function(...)
        return Config.GodMode and nil or originalDamage(...)
    end
else
    warn("[ОШИБКА] Не найден Combat-модуль!")
end

-- Авто-буст ножа
local function BoostKnife()
    local function UpdateKnife(tool)
        if tool.Name == Config.KnifeName then
            local dmg = tool:FindFirstChild("Damage") or Instance.new("IntValue")
            dmg.Value = 100 * Config.DamageBoost
            dmg.Parent = tool
            
            if tool:FindFirstChild("Cooldown") then
                tool.Cooldown.Value = 0
            end
        end
    end

    game:GetService("Players").LocalPlayer.Backpack.ChildAdded:Connect(UpdateKnife)
    game:GetService("Players").LocalPlayer.Character.ChildAdded:Connect(UpdateKnife)
end

-- Xeno GUI
local XenoGUI = Instance.new("ScreenGui")
XenoGUI.Name = "XenoSansHUD"
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 80)
Frame.Position = UDim2.new(0.78, 0, 0.05, 0)
Frame.BackgroundTransparency = 0.7

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "GOD MODE: [ACTIVE]"
StatusLabel.TextColor3 = Color3.new(0, 1, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0.5, 0)
StatusLabel.Position = UDim2.new(0.05, 0, 0.1, 0)

local KnifeLabel = Instance.new("TextLabel")
KnifeLabel.Text = "KNIFE DMG: x"..Config.DamageBoost
KnifeLabel.TextColor3 = Color3.new(1, 0.5, 0)
KnifeLabel.Size = UDim2.new(0.9, 0, 0.5, 0)
KnifeLabel.Position = UDim2.new(0.05, 0, 0.5, 0)

StatusLabel.Parent = Frame
KnifeLabel.Parent = Frame
Frame.Parent = XenoGUI
XenoGUI.Parent = game:GetService("CoreGui")

-- Активация
BoostKnife()

-- Проверка фазы
spawn(function()
    while task.wait(2) do
        if workspace:FindFirstChild(Config.BossName.."2") then
            Config.DamageBoost = 25
            KnifeLabel.Text = "KNIFE DMG: x"..Config.DamageBoost
        end
    end
end)

print([[
[DustSans System]
Status: Successfully injected!
Damage Multiplier: x]]..Config.DamageBoost)
