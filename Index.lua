local HitboxSize = 10 -- Tamanho da hitbox da cabeça
local TeamCheck = false -- Se true, só afeta inimigos
local Transparency = 0.8 -- Deixa a cabeça semi-transparente

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function applyBigHeadHitbox(player)
    if player == LocalPlayer then return end
    if TeamCheck and player.Team == LocalPlayer.Team then return end

    local character = player.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not head or not humanoid then return end

    -- Salva o tamanho original da cabeça (para evitar bugs)
    if not head:FindFirstChild("OriginalSize") then
        local originalSize = Instance.new("Vector3Value")
        originalSize.Name = "OriginalSize"
        originalSize.Value = head.Size
        originalSize.Parent = head
    end

    -- Modifica a hitbox (client-side)
    head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
    head.Transparency = Transparency
    head.CanCollide = false -- Evita travar personagens
    head.Material = Enum.Material.Neon -- Opcional (destaque visual)

    -- Corrige possíveis bugs de colisão
    if humanoid then
        humanoid.AutoRotate = true -- Evita personagens "travados"
    end
end

-- Aplica em todos os jogadores
for _, player in ipairs(Players:GetPlayers()) do
    applyBigHeadHitbox(player)
end

-- Atualiza quando um jogador spawna
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        applyBigHeadHitbox(player)
    end)
end)

-- Mantém a hitbox ativa (mesmo se o jogo tentar resetar)
RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and (not TeamCheck or player.Team ~= LocalPlayer.Team) then
            pcall(applyBigHeadHitbox, player) -- pcall evita erros
        end
    end
end)
