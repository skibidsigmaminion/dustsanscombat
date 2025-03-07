return (function()
    -- Конфигурация
    local Config = {
        GodMode = true,
        DamageBoost = 15,
        BossName = "DustDust_Sans",
        KnifeName = "Real_Knife"
    }

    -- Перехват системы урона
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local CombatModule = require(LocalPlayer.PlayerScripts:WaitForChild("Combat"))
    
    local originalTakeDamage = CombatModule.TakeDamage
    CombatModule.TakeDamage = function(...)
        return Config.GodMode and nil or originalTakeDamage(...)
    end

    -- Усиление Real Knife
    local function ModifyWeapon()
        local function UpdateKnife(tool)
            if tool.Name == Config.KnifeName then
                local damage = tool:FindFirstChild("Damage") or Instance.new("IntValue")
                damage.Name = "Damage"
                damage.Value = 100 * Config.DamageBoost
                damage.Parent = tool
                
                tool:FindFirstChild("Cooldown").Value = 0.05
            end
        end

        LocalPlayer.Backpack.ChildAdded:Connect(UpdateKnife)
        LocalPlayer.Character.ChildAdded:Connect(UpdateKnife)
    end

    -- GUI интерфейс
    local function CreateBattleHUD()
        local gui = Instance.new("ScreenGui")
        gui.Name = "SansFightHUD"
        gui.Parent = game:GetService("CoreGui")

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 250, 0, 100)
        frame.Position = UDim2.new(0.8, 0, 0.05, 0)
        frame.BackgroundTransparency = 0.8

        local labels = {
            Status = Instance.new("TextLabel"),
            Damage = Instance.new("TextLabel")
        }

        for i, label in pairs(labels) do
            label.Size = UDim2.new(0.9, 0, 0.45, 0)
            label.Position = UDim2.new(0.05, 0, (i-1)*0.5, 0)
            label.TextColor3 = Color3.new(1,1,1)
            label.Font = Enum.Font.GothamBold
            label.Parent = frame
        end

        labels.Status.Text = "🛡️ Бессмертие: АКТИВНО"
        labels.Damage.Text = "🗡️ Урон: x"..Config.DamageBoost
        frame.Parent = gui
    end

    -- Активация при обнаружении босса
    local function BossDetector()
        while task.wait(1) do
            if workspace:FindFirstChild(Config.BossName) then
                ModifyWeapon()
                CreateBattleHUD()
                break
            end
        end
    end

    -- Инициализация
    if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("SingleplayerGUI") then
        BossDetector()
    end
end)()