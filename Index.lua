local Players = game:GetService("Players") local RunService = game:GetService("RunService") local LocalPlayer = Players.LocalPlayer

_G.HeadSize = 15 _G.HeadTransparency = 1 _G.HeadRGB = Color3.fromRGB(255, 0, 0) _G.HitboxEnabled = true _G.ESPEnabled = false

local function getHead(character) return character:FindFirstChild("Head") or character:FindFirstChild("UpperHead") or character:FindFirstChildWhichIsA("MeshPart") end

local function resetHitbox(character) local head = getHead(character) if head then pcall(function() head.Size = Vector3.new(2, 1, 1) head.Transparency = 0 head.Material = Enum.Material.Plastic head.Color = Color3.fromRGB(255, 255, 255) head.CanCollide = true head.Massless = false end) end end

local function applyHitbox(character) local head = getHead(character) if head then pcall(function() head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize) head.Transparency = _G.HeadTransparency head.Color = _G.HeadRGB head.Material = Enum.Material.Neon head.CanCollide = false head.Massless = true end) end end

local function applyESP(character) local head = getHead(character) if head and not character:FindFirstChild("Highlight") then local highlight = Instance.new("Highlight", character) highlight.Adornee = head highlight.FillTransparency = 1 highlight.OutlineColor = _G.HeadRGB highlight.OutlineTransparency = 0 end end

local function removeESP(character) local highlight = character:FindFirstChild("Highlight") if highlight then highlight:Destroy() end end

local function setupCharacter(character) local head = getHead(character) if head then if _G.HitboxEnabled then applyHitbox(character) else resetHitbox(character) end if _G.ESPEnabled then applyESP(character) else removeESP(character) end end character.ChildAdded:Connect(function() local newHead = getHead(character) if newHead then if _G.HitboxEnabled then applyHitbox(character) else resetHitbox(character) end if _G.ESPEnabled then applyESP(character) else removeESP(character) end end end) end

local function setupPlayer(player) if player.Character then setupCharacter(player.Character) end player.CharacterAdded:Connect(setupCharacter) end

for _, player in pairs(Players:GetPlayers()) do if player ~= LocalPlayer then setupPlayer(player) end end

Players.PlayerAdded:Connect(function(player) if player ~= LocalPlayer then setupPlayer(player) end end)

RunService.RenderStepped:Connect(function() for _, player in pairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character then local head = getHead(player.Character) if head then if _G.HitboxEnabled then applyHitbox(player.Character) else resetHitbox(player.Character) end

if _G.ESPEnabled then
                if not player.Character:FindFirstChild("Highlight") then
                    applyESP(player.Character)
                end
            else
                removeESP(player.Character)
            end
        end
    end
end

end)

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))() local Window = Rayfield:CreateWindow({ Name = "Hitbox & ESP Config", LoadingTitle = "Carregando...", LoadingSubtitle = "By elegostahehe1", ConfigurationSaving = { Enabled = false }, Discord = { Enabled = false }, KeySystem = false })

local Main = Window:CreateTab("Configuração")

Main:CreateSlider({ Name = "Tamanho da Cabeça", Range = {2, 35}, Increment = 1, CurrentValue = _G.HeadSize, Callback = function(Value) _G.HeadSize = Value end })

Main:CreateSlider({ Name = "Transparência da Cabeça", Range = {0, 1}, Increment = 0.1, CurrentValue = _G.HeadTransparency, Callback = function(Value) _G.HeadTransparency = Value end })

Main:CreateColorPicker({ Name = "Cor RGB da Cabeça e ESP", Color = _G.HeadRGB, Callback = function(Value) _G.HeadRGB = Value for _, player in pairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character then local head = getHead(player.Character) if head then head.Color = _G.HeadRGB end local highlight = player.Character:FindFirstChild("Highlight") if highlight then highlight.OutlineColor = _G.HeadRGB end end end end })

Main:CreateToggle({ Name = "Ativar Hitbox", CurrentValue = _G.HitboxEnabled, Callback = function(Value) _G.HitboxEnabled = Value end })

Main:CreateToggle({ Name = "Ativar ESP", CurrentValue = _G.ESPEnabled, Callback = function(Value) _G.ESPEnabled = Value end })

