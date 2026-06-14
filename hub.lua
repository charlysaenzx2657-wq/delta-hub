-- [[ DELTA SUPREME HUB V8 ]] --

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")

local NombreDelJuego = "UNIVERSAL SCRIPT"
pcall(function() NombreDelJuego = MarketplaceService:GetProductInfo(game.PlaceId).Name end)

-- Limpiar hub anterior
pcall(function()
    if CoreGui:FindFirstChild("DeltaSupremeHub") then
        CoreGui:FindFirstChild("DeltaSupremeHub"):Destroy()
    end
end)
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("DeltaSupremeHub") then
        LocalPlayer.PlayerGui:FindFirstChild("DeltaSupremeHub"):Destroy()
    end
end)

-- Inyeccion robusta para Delta
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaSupremeHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local inyectado = false
if not inyectado then
    pcall(function()
        if type(gethui) == "function" then
            ScreenGui.Parent = gethui()
            inyectado = true
        end
    end)
end
if not inyectado then
    pcall(function()
        ScreenGui.Parent = CoreGui
        inyectado = true
    end)
end
if not inyectado then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Estados globales
getgenv().AutoCollect = false
getgenv().Noclip = false
getgenv().ClickTPAlways = false
getgenv().AntiKickBypass = true
getgenv().AutoSellEconomy = false
getgenv().InfiniteJump = false

-- ==========================================
-- LOGICA
-- ==========================================
local function safeTeleport(targetCFrame, speed)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return nil end
    speed = speed or 185
    local distance = (root.Position - targetCFrame.Position).Magnitude
    if distance < 5 then root.CFrame = targetCFrame return nil end
    if getgenv().AntiKickBypass then
        hum:ChangeState(Enum.HumanoidStateType.Physics)
        if hum.Sit then hum.Sit = false end
    end
    local t = distance / speed
    local tween = TweenService:Create(root, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    return tween
end

local function interactuarConObjeto(obj)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local tw = safeTeleport(obj.CFrame, 235)
    if tw then tw.Completed:Wait() end
    if firetouchinterest then firetouchinterest(root, obj, 0) task.wait(0.01) firetouchinterest(root, obj, 1) end
    local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj.Parent:FindFirstChildOfClass("ProximityPrompt")
    if prompt and fireproximityprompt then fireproximityprompt(prompt) end
    local clickDet = obj:FindFirstChildOfClass("ClickDetector") or obj.Parent:FindFirstChildOfClass("ClickDetector")
    if clickDet and fireclickdetector then fireclickdetector(clickDet) end
end

local function superScanner()
    if not getgenv().AutoCollect then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local objetos = Workspace:GetDescendants()
    for i = 1, #objetos do
        if not getgenv().AutoCollect then break end
        local obj = objetos[i]
        if obj and obj:IsA("BasePart") then
            local esValido = false
            local objName = string.lower(obj.Name)
            if string.find(objName,"coin") or string.find(objName,"gem") or string.find(objName,"chest") or
               string.find(objName,"reward") or string.find(objName,"drop") or string.find(objName,"token") or
               string.find(objName,"fruit") or string.find(objName,"money") or string.find(objName,"cash") or
               string.find(objName,"gold") or string.find(objName,"diamond") or string.find(objName,"box") then
                esValido = true
            end
            if not esValido and (obj:FindFirstChildOfClass("TouchTransmitter") or obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChildOfClass("ClickDetector")) then
                if not obj:IsDescendantOf(char) and not obj.Parent:FindFirstChildOfClass("Humanoid") then
                    esValido = true
                end
            end
            if esValido and obj.Parent then pcall(function() interactuarConObjeto(obj) end) task.wait(0.03) end
        end
        if i % 95 == 0 then task.wait() end
    end
end

task.spawn(function()
    while true do
        if getgenv().AutoSellEconomy then
            pcall(function()
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (string.find(string.lower(v.Name),"sell") or string.find(string.lower(v.Name),"entrega") or string.find(string.lower(v.Name),"vender")) then
                        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root then local past = root.CFrame root.CFrame = v.CFrame task.wait(0.2) root.CFrame = past break end
                    end
                end
            end)
        end
        task.wait(4)
    end
end)

task.spawn(function()
    while true do
        if getgenv().AutoCollect then pcall(superScanner) end
        task.wait(0.6)
    end
end)

RunService.Stepped:Connect(function()
    if getgenv().Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if getgenv().InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ==========================================
-- GUI
-- ==========================================
local minimizado = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 520)
MainFrame.Position = UDim2.new(0, 20, 0, 80)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Borde = Instance.new("UIStroke")
Borde.Color = Color3.fromRGB(80, 0, 180)
Borde.Thickness = 1.5
Borde.Parent = MainFrame

-- TITLE BAR
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 48)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 11
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleLine = Instance.new("Frame")
TitleLine.Size = UDim2.new(1, 0, 0, 2)
TitleLine.Position = UDim2.new(0, 0, 1, -2)
TitleLine.BackgroundColor3 = Color3.fromRGB(100, 0, 220)
TitleLine.BorderSizePixel = 0
TitleLine.ZIndex = 12
TitleLine.Parent = TitleBar

local TitleIcon = Instance.new("TextLabel")
TitleIcon.Size = UDim2.new(0, 36, 1, 0)
TitleIcon.Position = UDim2.new(0, 8, 0, 0)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Text = "👑"
TitleIcon.TextSize = 20
TitleIcon.Font = Enum.Font.SourceSansBold
TitleIcon.TextColor3 = Color3.fromRGB(255, 200, 50)
TitleIcon.ZIndex = 12
TitleIcon.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -110, 0, 28)
TitleText.Position = UDim2.new(0, 44, 0, 4)
TitleText.BackgroundTransparency = 1
TitleText.Text = string.upper(NombreDelJuego)
TitleText.TextColor3 = Color3.fromRGB(220, 180, 255)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextSize = 13
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.TextTruncate = Enum.TextTruncate.AtEnd
TitleText.ZIndex = 12
TitleText.Parent = TitleBar

local VersionBadge = Instance.new("TextLabel")
VersionBadge.Size = UDim2.new(0, 28, 0, 16)
VersionBadge.Position = UDim2.new(0, 44, 1, -18)
VersionBadge.BackgroundColor3 = Color3.fromRGB(80, 0, 180)
VersionBadge.Text = "V8"
VersionBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
VersionBadge.Font = Enum.Font.SourceSansBold
VersionBadge.TextSize = 10
VersionBadge.ZIndex = 12
VersionBadge.Parent = TitleBar
Instance.new("UICorner", VersionBadge).CornerRadius = UDim.new(0, 4)

local BtnMin = Instance.new("TextButton")
BtnMin.Size = UDim2.new(0, 30, 0, 30)
BtnMin.Position = UDim2.new(1, -68, 0.5, -15)
BtnMin.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
BtnMin.Text = "—"
BtnMin.TextColor3 = Color3.fromRGB(200, 200, 255)
BtnMin.Font = Enum.Font.SourceSansBold
BtnMin.TextSize = 14
BtnMin.ZIndex = 12
BtnMin.Parent = TitleBar
Instance.new("UICorner", BtnMin).CornerRadius = UDim.new(0, 6)

local BtnClose = Instance.new("TextButton")
BtnClose.Size = UDim2.new(0, 30, 0, 30)
BtnClose.Position = UDim2.new(1, -34, 0.5, -15)
BtnClose.BackgroundColor3 = Color3.fromRGB(160, 20, 40)
BtnClose.Text = "X"
BtnClose.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnClose.Font = Enum.Font.SourceSansBold
BtnClose.TextSize = 14
BtnClose.ZIndex = 12
BtnClose.Parent = TitleBar
Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0, 6)

-- Boton flotante para reabrir
local BtnReabrir = Instance.new("TextButton")
BtnReabrir.Size = UDim2.new(0, 52, 0, 52)
BtnReabrir.Position = UDim2.new(0, 10, 0, 80)
BtnReabrir.BackgroundColor3 = Color3.fromRGB(80, 0, 180)
BtnReabrir.Text = "👑"
BtnReabrir.TextSize = 24
BtnReabrir.Font = Enum.Font.SourceSansBold
BtnReabrir.TextColor3 = Color3.fromRGB(255, 200, 50)
BtnReabrir.Visible = false
BtnReabrir.ZIndex = 20
BtnReabrir.Parent = ScreenGui
Instance.new("UICorner", BtnReabrir).CornerRadius = UDim.new(1, 0)

-- CONTENT
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -48)
ContentFrame.Position = UDim2.new(0, 0, 0, 48)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 10
ContentFrame.Parent = MainFrame

-- BARRA DE ESTADO
local StateBar = Instance.new("Frame")
StateBar.Size = UDim2.new(1, -16, 0, 34)
StateBar.Position = UDim2.new(0, 8, 1, -42)
StateBar.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
StateBar.ZIndex = 11
StateBar.Parent = ContentFrame
Instance.new("UICorner", StateBar).CornerRadius = UDim.new(0, 8)
local statestroke = Instance.new("UIStroke")
statestroke.Color = Color3.fromRGB(60, 60, 90)
statestroke.Parent = StateBar

local StateIcon = Instance.new("TextLabel")
StateIcon.Size = UDim2.new(0, 28, 1, 0)
StateIcon.BackgroundTransparency = 1
StateIcon.Text = "💬"
StateIcon.TextSize = 14
StateIcon.Font = Enum.Font.SourceSansBold
StateIcon.ZIndex = 12
StateIcon.Parent = StateBar

local StateLabel = Instance.new("TextLabel")
StateLabel.Size = UDim2.new(1, -32, 1, 0)
StateLabel.Position = UDim2.new(0, 28, 0, 0)
StateLabel.BackgroundTransparency = 1
StateLabel.Text = "Hub cargado correctamente."
StateLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
StateLabel.Font = Enum.Font.SourceSansBold
StateLabel.TextSize = 11
StateLabel.TextXAlignment = Enum.TextXAlignment.Left
StateLabel.TextTruncate = Enum.TextTruncate.AtEnd
StateLabel.ZIndex = 12
StateLabel.Parent = StateBar

local function setMsg(texto, tipo)
    if tipo == "ok" then
        StateIcon.Text = "OK"
        StateLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
        StateBar.BackgroundColor3 = Color3.fromRGB(0, 40, 20)
    elseif tipo == "error" then
        StateIcon.Text = "!!"
        StateLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StateBar.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    else
        StateIcon.Text = ">>"
        StateLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
        StateBar.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    end
    StateLabel.Text = texto
    task.delay(3, function()
        StateIcon.Text = ">>"
        StateLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
        StateBar.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
        StateLabel.Text = "Listo."
    end)
end

-- SCROLL
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -16, 1, -50)
ScrollFrame.Position = UDim2.new(0, 8, 0, 6)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 0, 220)
ScrollFrame.ZIndex = 11
ScrollFrame.Parent = ContentFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.Padding = UDim.new(0, 7)
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- DRAG
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then updateDrag(input) end
end)

-- MINIMIZAR / CERRAR / REABRIR
BtnMin.MouseButton1Click:Connect(function()
    minimizado = not minimizado
    ContentFrame.Visible = not minimizado
    if minimizado then
        MainFrame.Size = UDim2.new(0, 310, 0, 48)
        BtnMin.Text = "+"
        TweenService:Create(Borde, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 180, 0)}):Play()
    else
        MainFrame.Size = UDim2.new(0, 310, 0, 520)
        BtnMin.Text = "—"
        TweenService:Create(Borde, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 0, 180)}):Play()
    end
end)

BtnClose.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 310, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.25)
    MainFrame.Visible = false
    BtnReabrir.Visible = true
end)

BtnReabrir.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MainFrame.BackgroundTransparency = 0
    MainFrame.Size = UDim2.new(0, 310, 0, 520)
    minimizado = false
    ContentFrame.Visible = true
    BtnMin.Text = "—"
    BtnReabrir.Visible = false
    TweenService:Create(Borde, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 0, 180)}):Play()
end)

-- CREADORES DE BOTONES
local function crearSep(texto)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 24)
    f.BackgroundColor3 = Color3.fromRGB(25, 10, 45)
    f.ZIndex = 12
    f.Parent = ScrollFrame
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = texto
    lbl.TextColor3 = Color3.fromRGB(160, 100, 255)
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 13
    lbl.Parent = f
end

local function crearBotonAtaque(texto, color, fn)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 42)
    b.BackgroundColor3 = color
    b.Text = texto
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 12
    b.ZIndex = 12
    b.Parent = ScrollFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function()
        local old = b.Text
        b.Text = "Ejecutando..."
        local ok, err = pcall(fn)
        task.wait(0.4)
        b.Text = old
        if not ok then setMsg("Error: " .. tostring(err):sub(1,40), "error") end
    end)
    return b
end

local function crearBotonInterruptor(texto, fn)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 42)
    b.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    b.Text = texto
    b.TextColor3 = Color3.fromRGB(220, 220, 240)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 12
    b.ZIndex = 12
    b.Parent = ScrollFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 90)
    stroke.Parent = b
    local activo = false
    b.MouseButton1Click:Connect(function()
        activo = not activo
        if activo then
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 130, 70)}):Play()
            b.TextColor3 = Color3.fromRGB(0, 255, 150)
            stroke.Color = Color3.fromRGB(0, 200, 100)
        else
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 42)}):Play()
            b.TextColor3 = Color3.fromRGB(220, 220, 240)
            stroke.Color = Color3.fromRGB(60, 60, 90)
        end
        pcall(fn)
    end)
    return b
end

local function crearBtnPeq(txt, color, parent, fn)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 92, 1, 0)
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 11
    b.ZIndex = 12
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    b.MouseButton1Click:Connect(fn)
    return b
end

local function crearFila()
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 40)
    f.BackgroundTransparency = 1
    f.ZIndex = 12
    f.Parent = ScrollFrame
    local row = Instance.new("UIListLayout")
    row.Parent = f
    row.FillDirection = Enum.FillDirection.Horizontal
    row.Padding = UDim.new(0, 5)
    return f
end

local function crearLabelPeq(texto)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 20)
    l.BackgroundTransparency = 1
    l.Text = texto
    l.TextColor3 = Color3.fromRGB(180, 180, 220)
    l.Font = Enum.Font.SourceSansBold
    l.TextSize = 11
    l.ZIndex = 12
    l.Parent = ScrollFrame
    return l
end

local ItemsEncontradosFrame = Instance.new("Frame")
ItemsEncontradosFrame.BackgroundTransparency = 1
ItemsEncontradosFrame.Size = UDim2.new(1, 0, 0, 0)
ItemsEncontradosFrame.ZIndex = 12
ItemsEncontradosFrame.Parent = ScrollFrame
local ILL = Instance.new("UIListLayout")
ILL.Parent = ItemsEncontradosFrame
ILL.Padding = UDim.new(0, 5)
ILL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ItemsEncontradosFrame.Size = UDim2.new(1, 0, 0, ILL.AbsoluteContentSize.Y)
end)

local function LimpiarListaItems()
    for _, c in ipairs(ItemsEncontradosFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
end

-- ==========================================
-- BOTONES
-- ==========================================
crearSep("ATAQUES DE RED")

crearBotonAtaque("FORZAR ITEMS (SPAWNER)", Color3.fromRGB(160, 20, 50), function()
    local exitos = 0
    local fakes = {math.huge, 999999, "All", "Give", true, LocalPlayer.Name}
    for _, remoto in ipairs(ReplicatedStorage:GetDescendants()) do
        if remoto:IsA("RemoteEvent") or remoto:IsA("RemoteFunction") then
            local n = string.lower(remoto.Name)
            if string.find(n,"give") or string.find(n,"add") or string.find(n,"item") or string.find(n,"equip") or string.find(n,"buy") then
                pcall(function()
                    if remoto:IsA("RemoteEvent") then
                        remoto:FireServer(fakes[1]) remoto:FireServer(fakes[4],fakes[3]) remoto:FireServer(fakes[6],1)
                    else remoto:InvokeServer(fakes[4]) end
                end)
                exitos = exitos + 1
            end
        end
    end
    if exitos > 0 then setMsg("Enviado a "..exitos.." canales.", "ok")
    else setMsg("Sin remotos encontrados.", "error") end
end)

crearBotonAtaque("FORZAR RECOMPENSAS / MONEDAS", Color3.fromRGB(20, 100, 180), function()
    local exitos = 0
    for _, remoto in ipairs(ReplicatedStorage:GetDescendants()) do
        if remoto:IsA("RemoteEvent") or remoto:IsA("RemoteFunction") then
            local n = string.lower(remoto.Name)
            if string.find(n,"claim") or string.find(n,"reward") or string.find(n,"free") or string.find(n,"gift") or string.find(n,"daily") then
                pcall(function()
                    if remoto:IsA("RemoteEvent") then remoto:FireServer() else remoto:InvokeServer() end
                end)
                exitos = exitos + 1
            end
        end
    end
    if exitos > 0 then setMsg(exitos.." paquetes reclamados.", "ok")
    else setMsg("Sin remotos de recompensa.", "error") end
end)

crearSep("FARM & COLECTA")

crearBotonInterruptor("Iman Absoluto (Aspiradora)", function()
    getgenv().AutoCollect = not getgenv().AutoCollect
    setMsg(getgenv().AutoCollect and "Iman activado." or "Iman OFF.", getgenv().AutoCollect and "ok" or "info")
end)

crearBotonInterruptor("Auto-Vender Mochila (Loop)", function()
    getgenv().AutoSellEconomy = not getgenv().AutoSellEconomy
    setMsg(getgenv().AutoSellEconomy and "Auto-venta ON." or "Auto-venta OFF.", getgenv().AutoSellEconomy and "ok" or "info")
end)

crearSep("MOVIMIENTO")

crearBotonInterruptor("Escudo Anti-Kick", function()
    getgenv().AntiKickBypass = not getgenv().AntiKickBypass
    setMsg(getgenv().AntiKickBypass and "Escudo activo." or "Escudo OFF.", getgenv().AntiKickBypass and "ok" or "info")
end)

-- VELOCIDAD
local speedValues = {16,50,80,100,130,160,200,250}
local speedIndex = 1
local speedLabel = crearLabelPeq("WalkSpeed: 16")
local speedFrame = crearFila()

crearBtnPeq("Bajar", Color3.fromRGB(40,40,70), speedFrame, function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        speedIndex = math.max(1, speedIndex-1)
        hum.WalkSpeed = speedValues[speedIndex]
        speedLabel.Text = "WalkSpeed: "..speedValues[speedIndex]
        setMsg("Speed: "..speedValues[speedIndex], "ok")
    else setMsg("Sin personaje.", "error") end
end)
crearBtnPeq("Reset", Color3.fromRGB(80,20,20), speedFrame, function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then speedIndex=1 hum.WalkSpeed=16 speedLabel.Text="WalkSpeed: 16" setMsg("Speed reseteado.","info") end
end)
crearBtnPeq("Subir", Color3.fromRGB(0,80,40), speedFrame, function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        speedIndex = math.min(#speedValues, speedIndex+1)
        hum.WalkSpeed = speedValues[speedIndex]
        speedLabel.Text = "WalkSpeed: "..speedValues[speedIndex]
        setMsg("Speed: "..speedValues[speedIndex], "ok")
    else setMsg("Sin personaje.", "error") end
end)

-- JUMP
local jumpValues = {50,75,100,150,200,300}
local jumpIndex = 1
local jumpLabel = crearLabelPeq("JumpPower: 50")
local jumpFrame = crearFila()

crearBtnPeq("Bajar", Color3.fromRGB(40,40,70), jumpFrame, function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        jumpIndex = math.max(1, jumpIndex-1)
        hum.JumpPower = jumpValues[jumpIndex]
        jumpLabel.Text = "JumpPower: "..jumpValues[jumpIndex]
        setMsg("Jump: "..jumpValues[jumpIndex], "ok")
    else setMsg("Sin personaje.", "error") end
end)
crearBtnPeq("Reset", Color3.fromRGB(80,20,20), jumpFrame, function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then jumpIndex=1 hum.JumpPower=50 jumpLabel.Text="JumpPower: 50" setMsg("Salto reseteado.","info") end
end)
crearBtnPeq("Subir", Color3.fromRGB(0,80,40), jumpFrame, function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        jumpIndex = math.min(#jumpValues, jumpIndex+1)
        hum.JumpPower = jumpValues[jumpIndex]
        jumpLabel.Text = "JumpPower: "..jumpValues[jumpIndex]
        setMsg("Jump: "..jumpValues[jumpIndex], "ok")
    else setMsg("Sin personaje.", "error") end
end)

crearBotonInterruptor("Salto Infinito", function()
    getgenv().InfiniteJump = not getgenv().InfiniteJump
    setMsg(getgenv().InfiniteJump and "Salto infinito ON." or "Salto infinito OFF.", getgenv().InfiniteJump and "ok" or "info")
end)

crearBotonInterruptor("Noclip (Atravesar)", function()
    getgenv().Noclip = not getgenv().Noclip
    setMsg(getgenv().Noclip and "Noclip ON." or "Noclip OFF.", getgenv().Noclip and "ok" or "info")
end)

crearBotonInterruptor("Click To Teleport", function()
    getgenv().ClickTPAlways = not getgenv().ClickTPAlways
    setMsg(getgenv().ClickTPAlways and "Click TP ON." or "Click TP OFF.", getgenv().ClickTPAlways and "ok" or "info")
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if getgenv().ClickTPAlways and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.X, mouse.Hit.Y+3, mouse.Hit.Z)
        end
    end)
end)

crearSep("TELEPORT A JUGADOR")

local jugadoresLista = {}
local tpPlayerIndex = 1
local jugadorSeleccionado = nil
local tpLabel = crearLabelPeq("Ningun jugador seleccionado")
local tpFrame = crearFila()

local function actualizarJugadores()
    jugadoresLista = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(jugadoresLista, p) end
    end
    if #jugadoresLista > 0 then
        tpPlayerIndex = math.clamp(tpPlayerIndex, 1, #jugadoresLista)
        jugadorSeleccionado = jugadoresLista[tpPlayerIndex]
        tpLabel.Text = "-> "..jugadorSeleccionado.Name
    else
        jugadorSeleccionado = nil
        tpLabel.Text = "Sin jugadores en el servidor."
    end
end

crearBtnPeq("Prev", Color3.fromRGB(40,20,70), tpFrame, function()
    actualizarJugadores()
    if #jugadoresLista == 0 then setMsg("No hay jugadores.", "error") return end
    tpPlayerIndex = tpPlayerIndex - 1
    if tpPlayerIndex < 1 then tpPlayerIndex = #jugadoresLista end
    jugadorSeleccionado = jugadoresLista[tpPlayerIndex]
    tpLabel.Text = "-> "..jugadorSeleccionado.Name
    setMsg("Selec: "..jugadorSeleccionado.Name, "info")
end)
crearBtnPeq("IR", Color3.fromRGB(80,0,160), tpFrame, function()
    actualizarJugadores()
    if not jugadorSeleccionado then setMsg("Selecciona un jugador.", "error") return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local tRoot = jugadorSeleccionado.Character and jugadorSeleccionado.Character:FindFirstChild("HumanoidRootPart")
    if root and tRoot then
        root.CFrame = tRoot.CFrame + Vector3.new(3,0,0)
        setMsg("Teleport: "..jugadorSeleccionado.Name, "ok")
    else setMsg("Jugador sin personaje.", "error") end
end)
crearBtnPeq("Next", Color3.fromRGB(40,20,70), tpFrame, function()
    actualizarJugadores()
    if #jugadoresLista == 0 then setMsg("No hay jugadores.", "error") return end
    tpPlayerIndex = tpPlayerIndex + 1
    if tpPlayerIndex > #jugadoresLista then tpPlayerIndex = 1 end
    jugadorSeleccionado = jugadoresLista[tpPlayerIndex]
    tpLabel.Text = "-> "..jugadorSeleccionado.Name
    setMsg("Selec: "..jugadorSeleccionado.Name, "info")
end)

actualizarJugadores()
Players.PlayerAdded:Connect(actualizarJugadores)
Players.PlayerRemoving:Connect(actualizarJugadores)

crearSep("SCANNER DE MAPA")

crearBotonAtaque("SCANEAR MAPA", Color3.fromRGB(100,70,0), function()
    LimpiarListaItems()
    local itemsUnicos = {}
    local contador = 0
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if obj:FindFirstChildOfClass("TouchTransmitter") or obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChildOfClass("ClickDetector") then
                if not obj:IsDescendantOf(LocalPlayer.Character) and not obj.Parent:FindFirstChildOfClass("Humanoid") then
                    local nombre = obj.Name
                    if nombre ~= "Part" and nombre ~= "MeshPart" and not itemsUnicos[nombre] then
                        itemsUnicos[nombre] = true
                        contador = contador + 1
                        local btn = Instance.new("TextButton")
                        btn.Size = UDim2.new(1, 0, 0, 38)
                        btn.BackgroundColor3 = Color3.fromRGB(0,70,120)
                        btn.Text = "Farm: "..nombre
                        btn.TextColor3 = Color3.fromRGB(255,255,255)
                        btn.Font = Enum.Font.SourceSansBold
                        btn.TextSize = 11
                        btn.ZIndex = 12
                        btn.Parent = ItemsEncontradosFrame
                        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)
                        btn.MouseButton1Click:Connect(function()
                            setMsg("Farmeando: "..nombre, "info")
                            task.spawn(function()
                                local count = 0
                                for _, target in ipairs(Workspace:GetDescendants()) do
                                    if target.Name == nombre and target:IsA("BasePart") then
                                        pcall(function() interactuarConObjeto(target) end)
                                        count = count + 1
                                        task.wait(0.05)
                                    end
                                end
                                setMsg("Recogidos "..count.."x "..nombre, "ok")
                            end)
                        end)
                    end
                end
            end
        end
    end
    if contador == 0 then setMsg("Sin objetos interactivos.", "error")
    else setMsg("Scanner: "..contador.." tipos.", "ok") end
end)

setMsg("Hub V8 listo.", "ok")
