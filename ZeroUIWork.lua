--[[
    ███████╗███████╗██████╗  ██████╗ ██╗   ██╗██╗
    ╚══███╔╝██╔════╝██╔══██╗██╔═══██╗██║   ██║██║
      ███╔╝ █████╗  ██████╔╝██║   ██║██║   ██║██║
     ███╔╝  ██╔══╝  ██╔══██╗██║   ██║██║   ██║██║
    ███████╗███████╗██║  ██║╚██████╔╝╚██████╔╝██║
    ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝
    
    ZeroUI v1.1.0
    Dark Transparent  •  Mobile Optimized  •  Bold Typography
    Built-in Key System  •  FPS Counter  •  Frosted Glass Dark
]]

local ZeroUI = {}
ZeroUI.Flags = {}
ZeroUI._windows = {}
ZeroUI.Version = "1.1.0"

-- ══════════════════════════════════════
--               SERVICES
-- ══════════════════════════════════════
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local CoreGui          = game:GetService("CoreGui")
local Stats            = game:GetService("Stats")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ══════════════════════════════════════
--           MOBILE DETECTION
-- ══════════════════════════════════════
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local ViewportSize = Camera.ViewportSize

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    ViewportSize = Camera.ViewportSize
end)

-- ══════════════════════════════════════
--          RESPONSIVE SIZES
-- ══════════════════════════════════════
local Sizes = {}
local function updateSizes()
    local vw = ViewportSize.X
    local vh = ViewportSize.Y
    Sizes.WindowW     = IsMobile and math.clamp(vw * 0.93, 320, 600) or 560
    Sizes.WindowH     = IsMobile and math.clamp(vh * 0.72, 300, 500) or 420
    Sizes.Sidebar     = IsMobile and 52 or 160
    Sizes.TopBar      = IsMobile and 46 or 42
    Sizes.Element     = IsMobile and 46 or 40
    Sizes.FontTitle   = IsMobile and 16 or 14
    Sizes.FontBody    = IsMobile and 14 or 13
    Sizes.FontSmall   = IsMobile and 12 or 11
    Sizes.Corner      = IsMobile and 12 or 10
    Sizes.Padding     = IsMobile and 8 or 6
    Sizes.ToggleW     = IsMobile and 48 or 42
    Sizes.ToggleH     = IsMobile and 26 or 22
    Sizes.KnobSize    = IsMobile and 20 or 16
end
updateSizes()

-- ══════════════════════════════════════
--       DARK TRANSPARENT THEME
-- ══════════════════════════════════════
local Theme = {
    -- Window
    WindowBG       = Color3.fromRGB(14, 16, 26),
    WindowTrans    = 0.12,

    -- Sidebar
    SidebarBG      = Color3.fromRGB(10, 12, 22),
    SidebarTrans   = 0.08,

    -- Top Bar
    TopBarBG       = Color3.fromRGB(18, 20, 32),
    TopBarTrans    = 0.06,

    -- Elements
    ElementBG      = Color3.fromRGB(22, 25, 42),
    ElementTrans   = 0.3,
    ElementHover   = Color3.fromRGB(30, 34, 58),
    ElementHoverT  = 0.15,

    -- Accent
    Accent         = Color3.fromRGB(75, 125, 255),
    AccentHover    = Color3.fromRGB(100, 148, 255),
    AccentDark     = Color3.fromRGB(55, 100, 220),
    AccentSoft     = Color3.fromRGB(40, 65, 140),

    -- Text
    TextPrimary    = Color3.fromRGB(228, 232, 255),
    TextSecondary  = Color3.fromRGB(130, 140, 175),
    TextDim        = Color3.fromRGB(70, 78, 110),
    TextOnAccent   = Color3.fromRGB(255, 255, 255),

    -- Borders
    Border         = Color3.fromRGB(40, 45, 72),
    BorderTrans    = 0.4,

    -- Toggle
    ToggleOff      = Color3.fromRGB(45, 50, 75),
    ToggleKnob     = Color3.fromRGB(230, 235, 255),

    -- Slider
    SliderTrack    = Color3.fromRGB(35, 40, 65),

    -- Input
    InputBG        = Color3.fromRGB(18, 20, 36),
    InputBorder    = Color3.fromRGB(45, 52, 85),

    -- Divider
    Divider        = Color3.fromRGB(35, 40, 65),
    DividerTrans   = 0.5,

    -- Tabs
    TabActive      = Color3.fromRGB(75, 125, 255),
    TabInactive    = Color3.fromRGB(85, 95, 130),

    -- Notifications
    NotifyBG       = Color3.fromRGB(18, 20, 34),
    NotifyTrans    = 0.08,
    Success        = Color3.fromRGB(45, 200, 110),
    Error          = Color3.fromRGB(255, 60, 72),
    Warning        = Color3.fromRGB(255, 175, 45),
    Info           = Color3.fromRGB(75, 130, 255),

    -- Key System
    KeyBG          = Color3.fromRGB(8, 10, 20),
    KeyCard        = Color3.fromRGB(16, 18, 32),

    -- FPS
    FpsBG          = Color3.fromRGB(12, 14, 26),
    FpsGood        = Color3.fromRGB(45, 200, 110),
    FpsMedium      = Color3.fromRGB(255, 200, 50),
    FpsBad         = Color3.fromRGB(255, 60, 72),

    -- Particles
    Particle       = Color3.fromRGB(50, 80, 180),
}

-- ══════════════════════════════════════
--          UTILITY FUNCTIONS
-- ══════════════════════════════════════
local function tw(obj, props, dur, style, dir)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props
    )
    t:Play()
    return t
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or Sizes.Corner)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border
    s.Thickness = thick or 1
    s.Transparency = trans or Theme.BorderTrans
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function padding(parent, px)
    local p = Instance.new("UIPadding")
    local n = UDim.new(0, px or Sizes.Padding)
    p.PaddingTop = n
    p.PaddingBottom = n
    p.PaddingLeft = n
    p.PaddingRight = n
    p.Parent = parent
    return p
end

local function listLayout(parent, pad, dir, hAlign)
    local l = Instance.new("UIListLayout")
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Padding = UDim.new(0, pad or Sizes.Padding)
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.HorizontalAlignment = hAlign or Enum.HorizontalAlignment.Center
    l.Parent = parent
    return l
end

local function ripple(parent, x, y)
    local circle = Instance.new("Frame")
    circle.Name = "Ripple"
    circle.BackgroundColor3 = Theme.Accent
    circle.BackgroundTransparency = 0.65
    circle.Size = UDim2.fromOffset(0, 0)
    circle.Position = UDim2.fromOffset(x, y)
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.ZIndex = 99
    circle.Parent = parent
    corner(circle, 999)
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.5
    tw(circle, {Size = UDim2.fromOffset(maxSize, maxSize), BackgroundTransparency = 1}, 0.5, Enum.EasingStyle.Quad)
    task.delay(0.55, function()
        if circle then circle:Destroy() end
    end)
end

local function makeDraggable(topbar, frame)
    local dragging, dragStart, startPos = false, nil, nil
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            tw(frame, {
                Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            }, 0.06, Enum.EasingStyle.Linear)
        end
    end)
end

local function readFile(name)
    local ok, d = pcall(function() return readfile(name) end)
    return ok and d or nil
end

local function saveFile(name, data)
    pcall(function() writefile(name, data) end)
end

local function autoCanvas(scrollFrame, layout)
    local function update()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
    update()
end

-- ══════════════════════════════════════
--          FPS COUNTER MODULE
-- ══════════════════════════════════════
local FPSModule = {}

function FPSModule:Create(parentGui)
    local fpsVisible = false
    local currentFPS = 60

    -- FPS Frame
    local fpsFrame = Instance.new("Frame")
    fpsFrame.Name = "FPSCounter"
    fpsFrame.Size = UDim2.fromOffset(IsMobile and 110 or 100, IsMobile and 38 or 32)
    fpsFrame.Position = UDim2.new(0, 12, 0, 12)
    fpsFrame.BackgroundColor3 = Theme.FpsBG
    fpsFrame.BackgroundTransparency = 0.2
    fpsFrame.BorderSizePixel = 0
    fpsFrame.ZIndex = 100
    fpsFrame.Visible = false
    fpsFrame.Parent = parentGui
    corner(fpsFrame, 8)
    stroke(fpsFrame, Theme.Border, 1, 0.4)

    -- FPS dot indicator
    local fpsDot = Instance.new("Frame")
    fpsDot.Size = UDim2.fromOffset(8, 8)
    fpsDot.Position = UDim2.new(0, 10, 0.5, 0)
    fpsDot.AnchorPoint = Vector2.new(0, 0.5)
    fpsDot.BackgroundColor3 = Theme.FpsGood
    fpsDot.BorderSizePixel = 0
    fpsDot.ZIndex = 101
    fpsDot.Parent = fpsFrame
    corner(fpsDot, 99)

    -- Dot pulse
    task.spawn(function()
        while fpsDot and fpsDot.Parent do
            tw(fpsDot, {BackgroundTransparency = 0.4}, 0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(0.8)
            tw(fpsDot, {BackgroundTransparency = 0}, 0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(0.8)
        end
    end)

    -- FPS number
    local fpsNumber = Instance.new("TextLabel")
    fpsNumber.Size = UDim2.new(0, 36, 1, 0)
    fpsNumber.Position = UDim2.new(0, 22, 0, 0)
    fpsNumber.BackgroundTransparency = 1
    fpsNumber.Text = "60"
    fpsNumber.TextColor3 = Theme.TextPrimary
    fpsNumber.TextSize = IsMobile and 16 or 14
    fpsNumber.Font = Enum.Font.GothamBold
    fpsNumber.TextXAlignment = Enum.TextXAlignment.Left
    fpsNumber.ZIndex = 101
    fpsNumber.Parent = fpsFrame

    -- FPS label
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Size = UDim2.new(0, 30, 1, 0)
    fpsLabel.Position = UDim2.new(1, -36, 0, 0)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS"
    fpsLabel.TextColor3 = Theme.TextDim
    fpsLabel.TextSize = IsMobile and 11 or 10
    fpsLabel.Font = Enum.Font.GothamBold
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.ZIndex = 101
    fpsLabel.Parent = fpsFrame

    -- FPS bar (mini performance bar)
    local fpsBar = Instance.new("Frame")
    fpsBar.Size = UDim2.new(0.85, 0, 0, 2)
    fpsBar.Position = UDim2.new(0.075, 0, 1, -5)
    fpsBar.BackgroundColor3 = Theme.SliderTrack
    fpsBar.BackgroundTransparency = 0.5
    fpsBar.BorderSizePixel = 0
    fpsBar.ZIndex = 101
    fpsBar.Parent = fpsFrame
    corner(fpsBar, 1)

    local fpsFill = Instance.new("Frame")
    fpsFill.Size = UDim2.new(1, 0, 1, 0)
    fpsFill.BackgroundColor3 = Theme.FpsGood
    fpsFill.BorderSizePixel = 0
    fpsFill.ZIndex = 102
    fpsFill.Parent = fpsBar
    corner(fpsFill, 1)

    -- FPS calculation
    local frameCount = 0
    local lastTime = tick()

    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = tick()
        if now - lastTime >= 0.5 then
            currentFPS = math.floor(frameCount / (now - lastTime))
            frameCount = 0
            lastTime = now

            if fpsFrame.Visible then
                fpsNumber.Text = tostring(currentFPS)

                -- Color based on FPS
                local fpsColor
                local barPct
                if currentFPS >= 50 then
                    fpsColor = Theme.FpsGood
                    barPct = 1
                elseif currentFPS >= 30 then
                    fpsColor = Theme.FpsMedium
                    barPct = 0.6
                else
                    fpsColor = Theme.FpsBad
                    barPct = math.clamp(currentFPS / 60, 0.05, 0.4)
                end

                tw(fpsDot, {BackgroundColor3 = fpsColor}, 0.3)
                tw(fpsNumber, {TextColor3 = fpsColor}, 0.3)
                tw(fpsFill, {Size = UDim2.new(barPct, 0, 1, 0), BackgroundColor3 = fpsColor}, 0.3)
            end
        end
    end)

    -- Draggable
    makeDraggable(fpsFrame, fpsFrame)

    local API = {}

    function API:Toggle()
        fpsVisible = not fpsVisible
        if fpsVisible then
            fpsFrame.Visible = true
            fpsFrame.BackgroundTransparency = 1
            tw(fpsFrame, {BackgroundTransparency = 0.2}, 0.3, Enum.EasingStyle.Back)
        else
            tw(fpsFrame, {BackgroundTransparency = 1}, 0.25)
            task.delay(0.25, function()
                if not fpsVisible then fpsFrame.Visible = false end
            end)
        end
        return fpsVisible
    end

    function API:Show()
        fpsVisible = true
        fpsFrame.Visible = true
        tw(fpsFrame, {BackgroundTransparency = 0.2}, 0.3)
    end

    function API:Hide()
        fpsVisible = false
        tw(fpsFrame, {BackgroundTransparency = 1}, 0.25)
        task.delay(0.25, function()
            if not fpsVisible then fpsFrame.Visible = false end
        end)
    end

    function API:GetFPS()
        return currentFPS
    end

    function API:IsVisible()
        return fpsVisible
    end

    return API
end

-- ══════════════════════════════════════
--      BUILT-IN KEY SYSTEM UI
-- ══════════════════════════════════════
local function showKeySystem(config, onSuccess)
    local fileName = (config.FileName or "ZeroUI_Key") .. ".txt"

    local validKey = ""
    local keyIsURL = config.Key:find("http") ~= nil

    if keyIsURL then
        pcall(function()
            local raw = game:HttpGet(config.Key)
            validKey = raw:gsub("%s+", ""):gsub("\n", ""):gsub("\r", "")
        end)
    else
        validKey = config.Key:gsub("%s+", "")
    end

    if config.SaveKey then
        local saved = readFile(fileName)
        if saved and saved:gsub("%s+", "") == validKey and validKey ~= "" then
            onSuccess()
            return
        end
    end

    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "ZeroUI_KeySystem"
    keyGui.ResetOnSpawn = false
    keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    keyGui.IgnoreGuiInset = true
    keyGui.DisplayOrder = 9999
    keyGui.Parent = CoreGui

    -- Dark overlay
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(2, 3, 8)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.Parent = keyGui
    tw(overlay, {BackgroundTransparency = 0.3}, 0.5)

    -- Particles
    task.spawn(function()
        for i = 1, 25 do
            local dot = Instance.new("Frame")
            local s = math.random(2, 6)
            dot.Size = UDim2.fromOffset(s, s)
            dot.Position = UDim2.new(math.random() * 0.95, 0, math.random() * 0.95, 0)
            dot.BackgroundColor3 = Theme.Particle
            dot.BackgroundTransparency = math.random(65, 92) / 100
            dot.BorderSizePixel = 0
            dot.ZIndex = 2
            dot.Parent = overlay
            corner(dot, 99)
            task.spawn(function()
                while dot and dot.Parent do
                    tw(dot, {
                        Position = UDim2.new(
                            math.clamp(dot.Position.X.Scale + (math.random()-0.5)*0.1, 0, 1), 0,
                            math.random()*0.95, 0
                        ),
                        BackgroundTransparency = math.random(55, 92) / 100,
                        Size = UDim2.fromOffset(math.random(2,7), math.random(2,7)),
                    }, math.random(4, 9), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                    task.wait(math.random(4, 9))
                end
            end)
        end
    end)

    local cardW = IsMobile and math.clamp(ViewportSize.X * 0.88, 280, 420) or 400
    local cardH = IsMobile and 350 or 330

    -- Glow behind card
    local cardGlow = Instance.new("ImageLabel")
    cardGlow.Size = UDim2.fromOffset(cardW + 100, cardH + 100)
    cardGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    cardGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    cardGlow.BackgroundTransparency = 1
    cardGlow.Image = "rbxassetid://5028857084"
    cardGlow.ImageColor3 = Theme.Accent
    cardGlow.ImageTransparency = 0.88
    cardGlow.ScaleType = Enum.ScaleType.Slice
    cardGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    cardGlow.ZIndex = 9
    cardGlow.Parent = overlay

    -- Glow pulse
    task.spawn(function()
        while cardGlow and cardGlow.Parent do
            tw(cardGlow, {ImageTransparency = 0.8}, 2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(2.5)
            tw(cardGlow, {ImageTransparency = 0.92}, 2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(2.5)
        end
    end)

    -- Card
    local card = Instance.new("Frame")
    card.Name = "KeyCard"
    card.Size = UDim2.fromOffset(cardW, cardH)
    card.Position = UDim2.new(0.5, 0, 0.5, 0)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.BackgroundColor3 = Theme.KeyCard
    card.BackgroundTransparency = 0.06
    card.BorderSizePixel = 0
    card.ZIndex = 10
    card.Parent = overlay
    corner(card, 16)
    stroke(card, Theme.Border, 1.2, 0.25)

    -- Top accent
    local topLine = Instance.new("Frame")
    topLine.Size = UDim2.new(0.35, 0, 0, 3)
    topLine.Position = UDim2.new(0.325, 0, 0, 0)
    topLine.BackgroundColor3 = Theme.Accent
    topLine.BorderSizePixel = 0
    topLine.ZIndex = 12
    topLine.Parent = card
    corner(topLine, 2)

    task.spawn(function()
        while topLine and topLine.Parent do
            tw(topLine, {Size = UDim2.new(0.55, 0, 0, 3), Position = UDim2.new(0.225, 0, 0, 0)}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(2)
            tw(topLine, {Size = UDim2.new(0.35, 0, 0, 3), Position = UDim2.new(0.325, 0, 0, 0)}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(2)
        end
    end)

    -- Lock
    local lock = Instance.new("TextLabel")
    lock.Size = UDim2.fromOffset(42, 42)
    lock.Position = UDim2.new(0.5, 0, 0, 22)
    lock.AnchorPoint = Vector2.new(0.5, 0)
    lock.BackgroundTransparency = 1
    lock.Text = "🔐"
    lock.TextSize = IsMobile and 32 or 28
    lock.ZIndex = 12
    lock.Parent = card

    local kTitle = Instance.new("TextLabel")
    kTitle.Size = UDim2.new(0.9, 0, 0, 28)
    kTitle.Position = UDim2.new(0.5, 0, 0, 70)
    kTitle.AnchorPoint = Vector2.new(0.5, 0)
    kTitle.BackgroundTransparency = 1
    kTitle.Text = "VERIFICATION"
    kTitle.TextColor3 = Theme.TextPrimary
    kTitle.TextSize = IsMobile and 20 or 18
    kTitle.Font = Enum.Font.GothamBold
    kTitle.ZIndex = 12
    kTitle.Parent = card

    local kSub = Instance.new("TextLabel")
    kSub.Size = UDim2.new(0.85, 0, 0, 18)
    kSub.Position = UDim2.new(0.5, 0, 0, 100)
    kSub.AnchorPoint = Vector2.new(0.5, 0)
    kSub.BackgroundTransparency = 1
    kSub.Text = config.Note or "Enter your access key"
    kSub.TextColor3 = Theme.TextSecondary
    kSub.TextSize = IsMobile and 13 or 12
    kSub.Font = Enum.Font.GothamMedium
    kSub.ZIndex = 12
    kSub.Parent = card

    -- Input
    local inputCont = Instance.new("Frame")
    inputCont.Size = UDim2.new(0.82, 0, 0, IsMobile and 46 or 42)
    inputCont.Position = UDim2.new(0.5, 0, 0, 135)
    inputCont.AnchorPoint = Vector2.new(0.5, 0)
    inputCont.BackgroundColor3 = Theme.InputBG
    inputCont.BorderSizePixel = 0
    inputCont.ZIndex = 12
    inputCont.Parent = card
    corner(inputCont, 10)
    local inputStroke = stroke(inputCont, Theme.InputBorder, 1.2, 0.3)

    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -20, 1, 0)
    inputBox.Position = UDim2.new(0, 10, 0, 0)
    inputBox.BackgroundTransparency = 1
    inputBox.Text = ""
    inputBox.PlaceholderText = "Paste key here..."
    inputBox.PlaceholderColor3 = Theme.TextDim
    inputBox.TextColor3 = Theme.TextPrimary
    inputBox.TextSize = IsMobile and 14 or 13
    inputBox.Font = Enum.Font.GothamMedium
    inputBox.TextXAlignment = Enum.TextXAlignment.Left
    inputBox.ClearTextOnFocus = false
    inputBox.ZIndex = 13
    inputBox.Parent = inputCont

    inputBox.Focused:Connect(function()
        tw(inputStroke, {Color = Theme.Accent, Transparency = 0}, 0.25)
    end)
    inputBox.FocusLost:Connect(function()
        tw(inputStroke, {Color = Theme.InputBorder, Transparency = 0.3}, 0.25)
    end)

    -- Status
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0.82, 0, 0, 16)
    status.Position = UDim2.new(0.5, 0, 0, IsMobile and 188 or 184)
    status.AnchorPoint = Vector2.new(0.5, 0)
    status.BackgroundTransparency = 1
    status.Text = ""
    status.TextColor3 = Theme.Error
    status.TextSize = IsMobile and 12 or 11
    status.Font = Enum.Font.GothamMedium
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextTransparency = 1
    status.ZIndex = 12
    status.Parent = card

    -- Verify
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0.82, 0, 0, IsMobile and 46 or 42)
    verifyBtn.Position = UDim2.new(0.5, 0, 0, IsMobile and 212 or 206)
    verifyBtn.AnchorPoint = Vector2.new(0.5, 0)
    verifyBtn.BackgroundColor3 = Theme.Accent
    verifyBtn.BorderSizePixel = 0
    verifyBtn.Text = "VERIFY KEY"
    verifyBtn.TextColor3 = Theme.TextOnAccent
    verifyBtn.TextSize = IsMobile and 15 or 14
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.AutoButtonColor = false
    verifyBtn.ZIndex = 12
    verifyBtn.Parent = card
    corner(verifyBtn, 10)

    verifyBtn.MouseEnter:Connect(function()
        tw(verifyBtn, {BackgroundColor3 = Theme.AccentHover}, 0.2)
    end)
    verifyBtn.MouseLeave:Connect(function()
        tw(verifyBtn, {BackgroundColor3 = Theme.Accent}, 0.2)
    end)

    -- Get Key
    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Size = UDim2.new(0.82, 0, 0, IsMobile and 40 or 36)
    getKeyBtn.Position = UDim2.new(0.5, 0, 0, IsMobile and 268 or 258)
    getKeyBtn.AnchorPoint = Vector2.new(0.5, 0)
    getKeyBtn.BackgroundColor3 = Theme.ElementBG
    getKeyBtn.BackgroundTransparency = 0.3
    getKeyBtn.BorderSizePixel = 0
    getKeyBtn.Text = "🔗  Copy Key Link"
    getKeyBtn.TextColor3 = Theme.TextSecondary
    getKeyBtn.TextSize = IsMobile and 13 or 12
    getKeyBtn.Font = Enum.Font.GothamMedium
    getKeyBtn.AutoButtonColor = false
    getKeyBtn.ZIndex = 12
    getKeyBtn.Parent = card
    corner(getKeyBtn, 8)
    stroke(getKeyBtn, Theme.Border, 1, 0.5)

    getKeyBtn.MouseEnter:Connect(function()
        tw(getKeyBtn, {BackgroundTransparency = 0.1}, 0.2)
    end)
    getKeyBtn.MouseLeave:Connect(function()
        tw(getKeyBtn, {BackgroundTransparency = 0.3}, 0.2)
    end)

    getKeyBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if keyIsURL then setclipboard(config.Key) else setclipboard(validKey) end
        end)
        getKeyBtn.Text = "✅  Copied!"
        getKeyBtn.TextColor3 = Theme.Success
        task.wait(2)
        getKeyBtn.Text = "🔗  Copy Key Link"
        getKeyBtn.TextColor3 = Theme.TextSecondary
    end)

    -- Footer
    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(0.9, 0, 0, 16)
    footer.Position = UDim2.new(0.5, 0, 1, -22)
    footer.AnchorPoint = Vector2.new(0.5, 0)
    footer.BackgroundTransparency = 1
    footer.Text = "🛡️ ZeroUI v" .. ZeroUI.Version
    footer.TextColor3 = Theme.TextDim
    footer.TextSize = 10
    footer.Font = Enum.Font.Gotham
    footer.ZIndex = 12
    footer.Parent = card

    -- Intro
    card.Size = UDim2.fromOffset(cardW - 30, cardH - 30)
    card.BackgroundTransparency = 1
    task.spawn(function()
        task.wait(0.15)
        tw(card, {Size = UDim2.fromOffset(cardW, cardH), BackgroundTransparency = 0.06}, 0.5, Enum.EasingStyle.Back)
    end)

    -- Verify logic
    local busy = false
    local function verify()
        if busy then return end
        busy = true
        local entered = inputBox.Text:gsub("%s+", "")

        verifyBtn.Text = "VERIFYING..."
        tw(verifyBtn, {BackgroundColor3 = Theme.AccentDark}, 0.15)
        task.wait(0.6)

        if entered == "" then
            status.Text = "⚠ Please enter a key"
            status.TextColor3 = Theme.Warning
            tw(status, {TextTransparency = 0}, 0.2)
            task.delay(3, function() tw(status, {TextTransparency = 1}, 0.3) end)
            verifyBtn.Text = "VERIFY KEY"
            tw(verifyBtn, {BackgroundColor3 = Theme.Accent}, 0.2)
            busy = false
            return
        end

        if validKey == "" then
            status.Text = "⚠ Failed to fetch key from server"
            status.TextColor3 = Theme.Error
            tw(status, {TextTransparency = 0}, 0.2)
            task.delay(4, function() tw(status, {TextTransparency = 1}, 0.3) end)
            verifyBtn.Text = "VERIFY KEY"
            tw(verifyBtn, {BackgroundColor3 = Theme.Accent}, 0.2)
            busy = false
            return
        end

        if entered == validKey then
            status.Text = "✅ Verified! Loading..."
            status.TextColor3 = Theme.Success
            tw(status, {TextTransparency = 0}, 0.2)
            verifyBtn.Text = "✅ VERIFIED"
            tw(verifyBtn, {BackgroundColor3 = Theme.Success}, 0.3)
            if config.SaveKey then saveFile(fileName, entered) end
            lock.Text = "🔓"

            task.wait(0.8)

            -- Exit animation
            for _, c in ipairs(card:GetDescendants()) do
                pcall(function()
                    if c:IsA("TextLabel") or c:IsA("TextButton") or c:IsA("TextBox") then
                        tw(c, {TextTransparency = 1}, 0.3)
                    elseif c:IsA("Frame") then
                        tw(c, {BackgroundTransparency = 1}, 0.3)
                    end
                end)
            end
            tw(card, {BackgroundTransparency = 1, Size = UDim2.fromOffset(cardW + 20, cardH + 20)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            tw(cardGlow, {ImageTransparency = 1}, 0.4)
            tw(overlay, {BackgroundTransparency = 1}, 0.5)

            task.wait(0.55)
            keyGui:Destroy()
            onSuccess()
        else
            status.Text = "❌ Invalid key"
            status.TextColor3 = Theme.Error
            tw(status, {TextTransparency = 0}, 0.2)
            tw(verifyBtn, {BackgroundColor3 = Theme.Error}, 0.15)
            tw(inputStroke, {Color = Theme.Error, Transparency = 0}, 0.15)

            local orig = card.Position
            for i = 1, 6 do
                local off = (i % 2 == 0) and 8 or -8
                tw(card, {Position = orig + UDim2.fromOffset(off, 0)}, 0.035, Enum.EasingStyle.Linear)
                task.wait(0.035)
            end
            tw(card, {Position = orig}, 0.035, Enum.EasingStyle.Linear)

            task.wait(0.5)
            tw(verifyBtn, {BackgroundColor3 = Theme.Accent}, 0.3)
            tw(inputStroke, {Color = Theme.InputBorder, Transparency = 0.3}, 0.3)
            verifyBtn.Text = "VERIFY KEY"
            task.delay(3, function() tw(status, {TextTransparency = 1}, 0.3) end)
            busy = false
        end
    end

    verifyBtn.MouseButton1Click:Connect(verify)
    inputBox.FocusLost:Connect(function(enter) if enter then verify() end end)
    makeDraggable(card, card)
end

-- ══════════════════════════════════════
--          CREATE WINDOW
-- ══════════════════════════════════════
function ZeroUI:Window(config)
    config = config or {}
    config.Name = config.Name or "ZeroUI"
    config.Icon = config.Icon or "⚡"
    config.ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift

    local WindowAPI = {}
    local tabs = {}
    local pages = {}
    local activeTab = nil
    local windowVisible = true
    local built = false
    local fpsCounter = nil

    local function buildWindow()
        if built then return end
        built = true

        if CoreGui:FindFirstChild("ZeroUI_Main") then
            CoreGui:FindFirstChild("ZeroUI_Main"):Destroy()
        end

        local gui = Instance.new("ScreenGui")
        gui.Name = "ZeroUI_Main"
        gui.ResetOnSpawn = false
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 100
        gui.Parent = CoreGui
        WindowAPI._gui = gui

        -- Background particles
        task.spawn(function()
            for i = 1, 15 do
                local p = Instance.new("Frame")
                local sz = math.random(2, 5)
                p.Size = UDim2.fromOffset(sz, sz)
                p.Position = UDim2.new(math.random()*0.95, 0, math.random()*0.95, 0)
                p.BackgroundColor3 = Theme.Particle
                p.BackgroundTransparency = 0.88
                p.BorderSizePixel = 0
                p.ZIndex = 0
                p.Parent = gui
                corner(p, 99)
                task.spawn(function()
                    while p and p.Parent do
                        tw(p, {
                            Position = UDim2.new(math.clamp(p.Position.X.Scale+(math.random()-0.5)*0.08,0,1),0,math.random()*0.95,0),
                            BackgroundTransparency = math.random(80,95)/100,
                        }, math.random(5,12), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                        task.wait(math.random(5,12))
                    end
                end)
            end
        end)

        -- Create FPS counter
        fpsCounter = FPSModule:Create(gui)

        local mainW = Sizes.WindowW
        local mainH = Sizes.WindowH

        -- Main frame
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "Main"
        mainFrame.Size = UDim2.fromOffset(mainW, mainH)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        mainFrame.BackgroundColor3 = Theme.WindowBG
        mainFrame.BackgroundTransparency = Theme.WindowTrans
        mainFrame.BorderSizePixel = 0
        mainFrame.ClipsDescendants = true
        mainFrame.ZIndex = 5
        mainFrame.Parent = gui
        corner(mainFrame, 14)
        stroke(mainFrame, Theme.Border, 1, 0.3)
        WindowAPI._main = mainFrame

        -- Dark glass gradient
        local glassGrad = Instance.new("UIGradient")
        glassGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 20, 35)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 14, 28)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 18, 32)),
        })
        glassGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.88),
            NumberSequenceKeypoint.new(0.5, 0.94),
            NumberSequenceKeypoint.new(1, 0.86),
        })
        glassGrad.Rotation = 135
        glassGrad.Parent = mainFrame

        -- ── Top Bar ──
        local topBar = Instance.new("Frame")
        topBar.Name = "TopBar"
        topBar.Size = UDim2.new(1, 0, 0, Sizes.TopBar)
        topBar.BackgroundColor3 = Theme.TopBarBG
        topBar.BackgroundTransparency = Theme.TopBarTrans
        topBar.BorderSizePixel = 0
        topBar.ZIndex = 8
        topBar.Parent = mainFrame

        local topBorder = Instance.new("Frame")
        topBorder.Size = UDim2.new(1, 0, 0, 1)
        topBorder.Position = UDim2.new(0, 0, 1, 0)
        topBorder.AnchorPoint = Vector2.new(0, 1)
        topBorder.BackgroundColor3 = Theme.Divider
        topBorder.BackgroundTransparency = Theme.DividerTrans
        topBorder.BorderSizePixel = 0
        topBorder.ZIndex = 9
        topBorder.Parent = topBar

        -- Icon + Title
        local titleContainer = Instance.new("Frame")
        titleContainer.Size = UDim2.new(0.65, 0, 1, 0)
        titleContainer.Position = UDim2.new(0, 10, 0, 0)
        titleContainer.BackgroundTransparency = 1
        titleContainer.ZIndex = 9
        titleContainer.Parent = topBar

        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.fromOffset(Sizes.TopBar - 8, Sizes.TopBar)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = config.Icon
        iconLabel.TextSize = IsMobile and 22 or 18
        iconLabel.ZIndex = 10
        iconLabel.Parent = titleContainer

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -(Sizes.TopBar), 1, 0)
        titleLabel.Position = UDim2.fromOffset(Sizes.TopBar - 4, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = config.Name
        titleLabel.TextColor3 = Theme.TextPrimary
        titleLabel.TextSize = Sizes.FontTitle
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
        titleLabel.ZIndex = 10
        titleLabel.Parent = titleContainer

        -- Version badge
        local verBadge = Instance.new("TextLabel")
        verBadge.Size = UDim2.fromOffset(IsMobile and 40 or 36, IsMobile and 18 or 16)
        verBadge.Position = UDim2.new(0, Sizes.TopBar - 4 + titleLabel.TextBounds.X + 8, 0.5, 0)
        verBadge.AnchorPoint = Vector2.new(0, 0.5)
        verBadge.BackgroundColor3 = Theme.AccentSoft
        verBadge.BackgroundTransparency = 0.5
        verBadge.Text = "v" .. ZeroUI.Version
        verBadge.TextColor3 = Theme.Accent
        verBadge.TextSize = 9
        verBadge.Font = Enum.Font.GothamBold
        verBadge.ZIndex = 10
        verBadge.Parent = titleContainer
        corner(verBadge, 4)

        -- Buttons
        local btnSize = IsMobile and 34 or 28

        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.fromOffset(btnSize, btnSize)
        closeBtn.Position = UDim2.new(1, -(btnSize + 8), 0.5, 0)
        closeBtn.AnchorPoint = Vector2.new(0, 0.5)
        closeBtn.BackgroundColor3 = Theme.Error
        closeBtn.BackgroundTransparency = 0.85
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Theme.TextSecondary
        closeBtn.TextSize = IsMobile and 16 or 14
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.AutoButtonColor = false
        closeBtn.BorderSizePixel = 0
        closeBtn.ZIndex = 10
        closeBtn.Parent = topBar
        corner(closeBtn, 8)

        closeBtn.MouseEnter:Connect(function()
            tw(closeBtn, {BackgroundTransparency = 0.3, TextColor3 = Theme.Error}, 0.2)
        end)
        closeBtn.MouseLeave:Connect(function()
            tw(closeBtn, {BackgroundTransparency = 0.85, TextColor3 = Theme.TextSecondary}, 0.2)
        end)
        closeBtn.MouseButton1Click:Connect(function() WindowAPI:Toggle() end)

        local minimizeBtn = Instance.new("TextButton")
        minimizeBtn.Size = UDim2.fromOffset(btnSize, btnSize)
        minimizeBtn.Position = UDim2.new(1, -(btnSize * 2 + 16), 0.5, 0)
        minimizeBtn.AnchorPoint = Vector2.new(0, 0.5)
        minimizeBtn.BackgroundColor3 = Theme.Warning
        minimizeBtn.BackgroundTransparency = 0.85
        minimizeBtn.Text = "—"
        minimizeBtn.TextColor3 = Theme.TextSecondary
        minimizeBtn.TextSize = IsMobile and 16 or 14
        minimizeBtn.Font = Enum.Font.GothamBold
        minimizeBtn.AutoButtonColor = false
        minimizeBtn.BorderSizePixel = 0
        minimizeBtn.ZIndex = 10
        minimizeBtn.Parent = topBar
        corner(minimizeBtn, 8)

        minimizeBtn.MouseEnter:Connect(function()
            tw(minimizeBtn, {BackgroundTransparency = 0.3, TextColor3 = Theme.Warning}, 0.2)
        end)
        minimizeBtn.MouseLeave:Connect(function()
            tw(minimizeBtn, {BackgroundTransparency = 0.85, TextColor3 = Theme.TextSecondary}, 0.2)
        end)

        local minimized = false
        minimizeBtn.MouseButton1Click:Connect(function()
            minimized = not minimized
            if minimized then
                tw(mainFrame, {Size = UDim2.fromOffset(mainW, Sizes.TopBar)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            else
                tw(mainFrame, {Size = UDim2.fromOffset(mainW, mainH)}, 0.35, Enum.EasingStyle.Back)
            end
        end)

        makeDraggable(topBar, mainFrame)

        -- ── Sidebar ──
        local sidebar = Instance.new("Frame")
        sidebar.Name = "Sidebar"
        sidebar.Size = UDim2.new(0, Sizes.Sidebar, 1, -Sizes.TopBar)
        sidebar.Position = UDim2.new(0, 0, 0, Sizes.TopBar)
        sidebar.BackgroundColor3 = Theme.SidebarBG
        sidebar.BackgroundTransparency = Theme.SidebarTrans
        sidebar.BorderSizePixel = 0
        sidebar.ZIndex = 7
        sidebar.Parent = mainFrame

        local sidebarBorder = Instance.new("Frame")
        sidebarBorder.Size = UDim2.new(0, 1, 1, 0)
        sidebarBorder.Position = UDim2.new(1, 0, 0, 0)
        sidebarBorder.BackgroundColor3 = Theme.Divider
        sidebarBorder.BackgroundTransparency = Theme.DividerTrans
        sidebarBorder.BorderSizePixel = 0
        sidebarBorder.ZIndex = 8
        sidebarBorder.Parent = sidebar

        local sidebarScroll = Instance.new("ScrollingFrame")
        sidebarScroll.Size = UDim2.new(1, -8, 1, -8)
        sidebarScroll.Position = UDim2.new(0, 4, 0, 4)
        sidebarScroll.BackgroundTransparency = 1
        sidebarScroll.ScrollBarThickness = 0
        sidebarScroll.BorderSizePixel = 0
        sidebarScroll.ZIndex = 8
        sidebarScroll.Parent = sidebar

        local sideLayout = listLayout(sidebarScroll, 4)
        autoCanvas(sidebarScroll, sideLayout)

        -- ── Content ──
        local contentArea = Instance.new("Frame")
        contentArea.Name = "Content"
        contentArea.Size = UDim2.new(1, -Sizes.Sidebar, 1, -Sizes.TopBar)
        contentArea.Position = UDim2.new(0, Sizes.Sidebar, 0, Sizes.TopBar)
        contentArea.BackgroundTransparency = 1
        contentArea.BorderSizePixel = 0
        contentArea.ZIndex = 6
        contentArea.ClipsDescendants = true
        contentArea.Parent = mainFrame

        -- Intro animation
        mainFrame.Size = UDim2.fromOffset(mainW * 0.9, mainH * 0.9)
        mainFrame.BackgroundTransparency = 1
        task.spawn(function()
            task.wait(0.1)
            tw(mainFrame, {
                Size = UDim2.fromOffset(mainW, mainH),
                BackgroundTransparency = Theme.WindowTrans,
            }, 0.5, Enum.EasingStyle.Back)
        end)

        -- Toggle keybind
        UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == config.ToggleKey then
                WindowAPI:Toggle()
            end
        end)

        -- ── Tab switching ──
        local function switchTab(tabData)
            if activeTab == tabData then return end
            activeTab = tabData
            for _, page in pairs(pages) do page.Visible = false end
            for _, t in ipairs(tabs) do
                tw(t.Button, {BackgroundTransparency = 1}, 0.2)
                tw(t.Label, {TextColor3 = Theme.TabInactive}, 0.2)
                if t.IconLabel then tw(t.IconLabel, {TextColor3 = Theme.TabInactive}, 0.2) end
                if t.Indicator then tw(t.Indicator, {BackgroundTransparency = 1}, 0.2) end
            end
            if pages[tabData.Id] then pages[tabData.Id].Visible = true end
            tw(tabData.Button, {BackgroundTransparency = 0.75, BackgroundColor3 = Theme.Accent}, 0.2)
            tw(tabData.Label, {TextColor3 = Theme.TabActive}, 0.2)
            if tabData.IconLabel then tw(tabData.IconLabel, {TextColor3 = Theme.TabActive}, 0.2) end
            if tabData.Indicator then tw(tabData.Indicator, {BackgroundTransparency = 0}, 0.2) end
        end

        -- ══════════════════════════
        --      TAB CREATION
        -- ══════════════════════════
        function WindowAPI:Tab(tabConfig)
            tabConfig = tabConfig or {}
            tabConfig.Name = tabConfig.Name or "Tab"
            tabConfig.Icon = tabConfig.Icon or "📁"

            local tabId = #tabs + 1
            local tabH = IsMobile and 44 or 38

            local tabBtn = Instance.new("TextButton")
            tabBtn.Name = "Tab_" .. tabConfig.Name
            tabBtn.Size = UDim2.new(1, 0, 0, tabH)
            tabBtn.BackgroundColor3 = Theme.Accent
            tabBtn.BackgroundTransparency = 1
            tabBtn.Text = ""
            tabBtn.AutoButtonColor = false
            tabBtn.BorderSizePixel = 0
            tabBtn.ZIndex = 9
            tabBtn.LayoutOrder = tabId
            tabBtn.Parent = sidebarScroll
            corner(tabBtn, 8)

            -- Active indicator (left bar)
            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 3, 0.6, 0)
            indicator.Position = UDim2.new(0, 0, 0.2, 0)
            indicator.BackgroundColor3 = Theme.Accent
            indicator.BackgroundTransparency = 1
            indicator.BorderSizePixel = 0
            indicator.ZIndex = 10
            indicator.Parent = tabBtn
            corner(indicator, 2)

            local tabIcon = Instance.new("TextLabel")
            tabIcon.Size = UDim2.fromOffset(tabH, tabH)
            tabIcon.Position = UDim2.new(0, 4, 0, 0)
            tabIcon.BackgroundTransparency = 1
            tabIcon.Text = tabConfig.Icon
            tabIcon.TextSize = IsMobile and 20 or 16
            tabIcon.TextColor3 = Theme.TabInactive
            tabIcon.ZIndex = 10
            tabIcon.Parent = tabBtn

            local tabLabel = Instance.new("TextLabel")
            tabLabel.Size = UDim2.new(1, -(tabH + 6), 1, 0)
            tabLabel.Position = UDim2.fromOffset(tabH + 4, 0)
            tabLabel.BackgroundTransparency = 1
            tabLabel.Text = tabConfig.Name
            tabLabel.TextColor3 = Theme.TabInactive
            tabLabel.TextSize = Sizes.FontBody
            tabLabel.Font = Enum.Font.GothamBold
            tabLabel.TextXAlignment = Enum.TextXAlignment.Left
            tabLabel.TextTruncate = Enum.TextTruncate.AtEnd
            tabLabel.Visible = not IsMobile
            tabLabel.ZIndex = 10
            tabLabel.Parent = tabBtn

            tabBtn.MouseEnter:Connect(function()
                if activeTab and activeTab.Id == tabId then return end
                tw(tabBtn, {BackgroundTransparency = 0.85}, 0.15)
            end)
            tabBtn.MouseLeave:Connect(function()
                if activeTab and activeTab.Id == tabId then return end
                tw(tabBtn, {BackgroundTransparency = 1}, 0.15)
            end)

            -- Page
            local page = Instance.new("ScrollingFrame")
            page.Name = "Page_" .. tabConfig.Name
            page.Size = UDim2.new(1, -16, 1, -16)
            page.Position = UDim2.new(0, 8, 0, 8)
            page.BackgroundTransparency = 1
            page.ScrollBarThickness = 3
            page.ScrollBarImageColor3 = Theme.Accent
            page.ScrollBarImageTransparency = 0.4
            page.BorderSizePixel = 0
            page.Visible = false
            page.ZIndex = 7
            page.Parent = contentArea

            local pageLayout = listLayout(page, Sizes.Padding + 2)
            autoCanvas(page, pageLayout)

            pages[tabId] = page

            local tabData = {
                Id = tabId,
                Button = tabBtn,
                Label = tabLabel,
                IconLabel = tabIcon,
                Indicator = indicator,
            }
            table.insert(tabs, tabData)

            tabBtn.MouseButton1Click:Connect(function() switchTab(tabData) end)

            if tabId == 1 then
                task.defer(function() switchTab(tabData) end)
            end

            -- ══════════════════════════
            --      ELEMENT BUILDERS
            -- ══════════════════════════
            local TabAPI = {}
            local elemOrder = 0
            local function nextOrder()
                elemOrder = elemOrder + 1
                return elemOrder
            end

            local function makeElement(height)
                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, 0, 0, height or Sizes.Element)
                container.BackgroundColor3 = Theme.ElementBG
                container.BackgroundTransparency = Theme.ElementTrans
                container.BorderSizePixel = 0
                container.ZIndex = 8
                container.LayoutOrder = nextOrder()
                container.Parent = page
                corner(container, 8)
                stroke(container, Theme.Border, 1, 0.55)

                container.MouseEnter:Connect(function()
                    tw(container, {BackgroundColor3 = Theme.ElementHover, BackgroundTransparency = Theme.ElementHoverT}, 0.2)
                end)
                container.MouseLeave:Connect(function()
                    tw(container, {BackgroundColor3 = Theme.ElementBG, BackgroundTransparency = Theme.ElementTrans}, 0.2)
                end)
                return container
            end

            -- ── SECTION ──
            function TabAPI:Section(name)
                local sec = Instance.new("Frame")
                sec.Size = UDim2.new(1, 0, 0, 28)
                sec.BackgroundTransparency = 1
                sec.ZIndex = 8
                sec.LayoutOrder = nextOrder()
                sec.Parent = page

                local secLabel = Instance.new("TextLabel")
                secLabel.Size = UDim2.new(1, -8, 1, 0)
                secLabel.Position = UDim2.fromOffset(4, 0)
                secLabel.BackgroundTransparency = 1
                secLabel.Text = (name or "Section"):upper()
                secLabel.TextColor3 = Theme.TextDim
                secLabel.TextSize = Sizes.FontSmall
                secLabel.Font = Enum.Font.GothamBold
                secLabel.TextXAlignment = Enum.TextXAlignment.Left
                secLabel.ZIndex = 9
                secLabel.Parent = sec

                local line = Instance.new("Frame")
                line.Size = UDim2.new(1, 0, 0, 1)
                line.Position = UDim2.new(0, 0, 1, -2)
                line.BackgroundColor3 = Theme.Divider
                line.BackgroundTransparency = Theme.DividerTrans
                line.BorderSizePixel = 0
                line.ZIndex = 9
                line.Parent = sec
            end

            -- ── BUTTON ──
            function TabAPI:Button(cfg)
                cfg = cfg or {}
                local container = makeElement()

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = ""
                btn.ZIndex = 9
                btn.AutoButtonColor = false
                btn.ClipsDescendants = true
                btn.Parent = container

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -16, 1, 0)
                label.Position = UDim2.fromOffset(12, 0)
                label.BackgroundTransparency = 1
                label.Text = cfg.Name or "Button"
                label.TextColor3 = Theme.TextPrimary
                label.TextSize = Sizes.FontBody
                label.Font = Enum.Font.GothamBold
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 10
                label.Parent = btn

                local arrow = Instance.new("TextLabel")
                arrow.Size = UDim2.fromOffset(20, 20)
                arrow.Position = UDim2.new(1, -28, 0.5, 0)
                arrow.AnchorPoint = Vector2.new(0, 0.5)
                arrow.BackgroundTransparency = 1
                arrow.Text = "›"
                arrow.TextColor3 = Theme.TextDim
                arrow.TextSize = 20
                arrow.Font = Enum.Font.GothamBold
                arrow.ZIndex = 10
                arrow.Parent = btn

                btn.MouseButton1Click:Connect(function()
                    local mouse = UserInputService:GetMouseLocation()
                    ripple(btn, mouse.X - container.AbsolutePosition.X, mouse.Y - container.AbsolutePosition.Y)
                    tw(container, {BackgroundTransparency = 0.05}, 0.08)
                    task.wait(0.1)
                    tw(container, {BackgroundTransparency = Theme.ElementTrans}, 0.15)
                    if cfg.Callback then cfg.Callback() end
                end)

                local API = {}
                function API:SetName(n) label.Text = n end
                function API:Destroy() container:Destroy() end
                return API
            end

            -- ── TOGGLE ──
            function TabAPI:Toggle(cfg)
                cfg = cfg or {}
                local toggled = cfg.Default or false
                local container = makeElement()

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -(Sizes.ToggleW + 24), 1, 0)
                label.Position = UDim2.fromOffset(12, 0)
                label.BackgroundTransparency = 1
                label.Text = cfg.Name or "Toggle"
                label.TextColor3 = Theme.TextPrimary
                label.TextSize = Sizes.FontBody
                label.Font = Enum.Font.GothamBold
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 10
                label.Parent = container

                local track = Instance.new("Frame")
                track.Size = UDim2.fromOffset(Sizes.ToggleW, Sizes.ToggleH)
                track.Position = UDim2.new(1, -(Sizes.ToggleW + 10), 0.5, 0)
                track.AnchorPoint = Vector2.new(0, 0.5)
                track.BackgroundColor3 = toggled and Theme.Accent or Theme.ToggleOff
                track.BorderSizePixel = 0
                track.ZIndex = 10
                track.Parent = container
                corner(track, Sizes.ToggleH / 2)

                local knob = Instance.new("Frame")
                knob.Size = UDim2.fromOffset(Sizes.KnobSize, Sizes.KnobSize)
                knob.Position = toggled
                    and UDim2.new(1, -(Sizes.KnobSize + 3), 0.5, 0)
                    or  UDim2.new(0, 3, 0.5, 0)
                knob.AnchorPoint = Vector2.new(0, 0.5)
                knob.BackgroundColor3 = Theme.ToggleKnob
                knob.BorderSizePixel = 0
                knob.ZIndex = 11
                knob.Parent = track
                corner(knob, Sizes.KnobSize / 2)

                local function updateToggle(val, fire)
                    toggled = val
                    tw(track, {BackgroundColor3 = val and Theme.Accent or Theme.ToggleOff}, 0.25)
                    tw(knob, {
                        Position = val
                            and UDim2.new(1, -(Sizes.KnobSize + 3), 0.5, 0)
                            or  UDim2.new(0, 3, 0.5, 0)
                    }, 0.25, Enum.EasingStyle.Back)
                    if cfg.Flag then ZeroUI.Flags[cfg.Flag] = val end
                    if fire ~= false and cfg.Callback then cfg.Callback(val) end
                end

                local clickBtn = Instance.new("TextButton")
                clickBtn.Size = UDim2.new(1, 0, 1, 0)
                clickBtn.BackgroundTransparency = 1
                clickBtn.Text = ""
                clickBtn.ZIndex = 12
                clickBtn.Parent = container
                clickBtn.MouseButton1Click:Connect(function() updateToggle(not toggled) end)

                if cfg.Flag then ZeroUI.Flags[cfg.Flag] = toggled end
                if toggled and cfg.Callback then cfg.Callback(true) end

                local API = {}
                function API:Set(val) updateToggle(val) end
                function API:Get() return toggled end
                function API:Destroy() container:Destroy() end
                return API
            end

            -- ── SLIDER ──
            function TabAPI:Slider(cfg)
                cfg = cfg or {}
                local min = cfg.Min or 0
                local max = cfg.Max or 100
                local value = math.clamp(cfg.Default or min, min, max)
                local inc = cfg.Increment or 1
                local sliderH = Sizes.Element + 22
                local container = makeElement(sliderH)

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.6, -12, 0, Sizes.Element - 4)
                label.Position = UDim2.fromOffset(12, 0)
                label.BackgroundTransparency = 1
                label.Text = cfg.Name or "Slider"
                label.TextColor3 = Theme.TextPrimary
                label.TextSize = Sizes.FontBody
                label.Font = Enum.Font.GothamBold
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 10
                label.Parent = container

                local valLabel = Instance.new("TextLabel")
                valLabel.Size = UDim2.new(0.4, -12, 0, Sizes.Element - 4)
                valLabel.Position = UDim2.new(0.6, 0, 0, 0)
                valLabel.BackgroundTransparency = 1
                valLabel.Text = tostring(value) .. (cfg.Suffix or "")
                valLabel.TextColor3 = Theme.Accent
                valLabel.TextSize = Sizes.FontBody
                valLabel.Font = Enum.Font.GothamBold
                valLabel.TextXAlignment = Enum.TextXAlignment.Right
                valLabel.ZIndex = 10
                valLabel.Parent = container

                local trackFrame = Instance.new("Frame")
                trackFrame.Size = UDim2.new(1, -24, 0, IsMobile and 10 or 8)
                trackFrame.Position = UDim2.new(0.5, 0, 1, -(IsMobile and 16 or 14))
                trackFrame.AnchorPoint = Vector2.new(0.5, 0)
                trackFrame.BackgroundColor3 = Theme.SliderTrack
                trackFrame.BorderSizePixel = 0
                trackFrame.ZIndex = 10
                trackFrame.Parent = container
                corner(trackFrame, 5)

                local pct = (value - min) / math.max(max - min, 1)
                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(math.clamp(pct, 0, 1), 0, 1, 0)
                fill.BackgroundColor3 = Theme.Accent
                fill.BorderSizePixel = 0
                fill.ZIndex = 11
                fill.Parent = trackFrame
                corner(fill, 5)

                local sKnobSize = IsMobile and 20 or 16
                local sKnob = Instance.new("Frame")
                sKnob.Size = UDim2.fromOffset(sKnobSize, sKnobSize)
                sKnob.Position = UDim2.new(math.clamp(pct, 0, 1), 0, 0.5, 0)
                sKnob.AnchorPoint = Vector2.new(0.5, 0.5)
                sKnob.BackgroundColor3 = Theme.ToggleKnob
                sKnob.BorderSizePixel = 0
                sKnob.ZIndex = 12
                sKnob.Parent = trackFrame
                corner(sKnob, sKnobSize / 2)
                stroke(sKnob, Theme.Accent, 2, 0.25)

                local function setValue(v, fire)
                    v = math.clamp(v, min, max)
                    v = math.floor(v / inc + 0.5) * inc
                    value = v
                    local p = (v - min) / math.max(max - min, 1)
                    tw(fill, {Size = UDim2.new(p, 0, 1, 0)}, 0.08, Enum.EasingStyle.Linear)
                    tw(sKnob, {Position = UDim2.new(p, 0, 0.5, 0)}, 0.08, Enum.EasingStyle.Linear)
                    valLabel.Text = tostring(v) .. (cfg.Suffix or "")
                    if cfg.Flag then ZeroUI.Flags[cfg.Flag] = v end
                    if fire ~= false and cfg.Callback then cfg.Callback(v) end
                end

                local sliding = false
                local inputBtn = Instance.new("TextButton")
                inputBtn.Size = UDim2.new(1, 0, 1, 12)
                inputBtn.Position = UDim2.new(0, 0, 0, -6)
                inputBtn.BackgroundTransparency = 1
                inputBtn.Text = ""
                inputBtn.ZIndex = 13
                inputBtn.Parent = trackFrame

                local function handleInput(input)
                    local trackPos = trackFrame.AbsolutePosition.X
                    local trackW = trackFrame.AbsoluteSize.X
                    local p = math.clamp((input.Position.X - trackPos) / trackW, 0, 1)
                    setValue(min + (max - min) * p)
                end

                inputBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        handleInput(input)
                    end
                end)
                inputBtn.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if sliding and (
                        input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch
                    ) then handleInput(input) end
                end)

                if cfg.Flag then ZeroUI.Flags[cfg.Flag] = value end

                local API = {}
                function API:Set(v) setValue(v) end
                function API:Get() return value end
                function API:Destroy() container:Destroy() end
                return API
            end

            -- ── DROPDOWN ──
            function TabAPI:Dropdown(cfg)
                cfg = cfg or {}
                local options = cfg.Options or {}
                local selected = cfg.Default or (options[1] or "")
                local opened = false
                local optionBtns = {}

                local headerH = Sizes.Element
                local optH = IsMobile and 38 or 32
                local maxVis = math.min(#options, 5)
                local dropH = optH * maxVis + 4

                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, 0, 0, headerH)
                container.BackgroundColor3 = Theme.ElementBG
                container.BackgroundTransparency = Theme.ElementTrans
                container.BorderSizePixel = 0
                container.ZIndex = 8
                container.ClipsDescendants = true
                container.LayoutOrder = nextOrder()
                container.Parent = page
                corner(container, 8)
                stroke(container, Theme.Border, 1, 0.55)

                local headerBtn = Instance.new("TextButton")
                headerBtn.Size = UDim2.new(1, 0, 0, headerH)
                headerBtn.BackgroundTransparency = 1
                headerBtn.Text = ""
                headerBtn.ZIndex = 9
                headerBtn.Parent = container

                local dLabel = Instance.new("TextLabel")
                dLabel.Size = UDim2.new(0.5, -12, 1, 0)
                dLabel.Position = UDim2.fromOffset(12, 0)
                dLabel.BackgroundTransparency = 1
                dLabel.Text = cfg.Name or "Dropdown"
                dLabel.TextColor3 = Theme.TextPrimary
                dLabel.TextSize = Sizes.FontBody
                dLabel.Font = Enum.Font.GothamBold
                dLabel.TextXAlignment = Enum.TextXAlignment.Left
                dLabel.ZIndex = 10
                dLabel.Parent = headerBtn

                local dValue = Instance.new("TextLabel")
                dValue.Size = UDim2.new(0.4, -12, 1, 0)
                dValue.Position = UDim2.new(0.5, 0, 0, 0)
                dValue.BackgroundTransparency = 1
                dValue.Text = tostring(selected)
                dValue.TextColor3 = Theme.Accent
                dValue.TextSize = Sizes.FontBody
                dValue.Font = Enum.Font.GothamMedium
                dValue.TextXAlignment = Enum.TextXAlignment.Right
                dValue.TextTruncate = Enum.TextTruncate.AtEnd
                dValue.ZIndex = 10
                dValue.Parent = headerBtn

                local dArrow = Instance.new("TextLabel")
                dArrow.Size = UDim2.fromOffset(18, 18)
                dArrow.Position = UDim2.new(1, -22, 0.5, 0)
                dArrow.AnchorPoint = Vector2.new(0, 0.5)
                dArrow.BackgroundTransparency = 1
                dArrow.Text = "▾"
                dArrow.TextColor3 = Theme.TextDim
                dArrow.TextSize = 16
                dArrow.Font = Enum.Font.GothamBold
                dArrow.ZIndex = 10
                dArrow.Parent = headerBtn

                local optScroll = Instance.new("ScrollingFrame")
                optScroll.Size = UDim2.new(1, -12, 1, -(headerH + 4))
                optScroll.Position = UDim2.new(0, 6, 0, headerH + 2)
                optScroll.BackgroundTransparency = 1
                optScroll.ScrollBarThickness = 2
                optScroll.BorderSizePixel = 0
                optScroll.ZIndex = 10
                optScroll.Visible = false
                optScroll.Parent = container

                local optLayout = listLayout(optScroll, 2)
                autoCanvas(optScroll, optLayout)

                local function buildOpts()
                    for _, b in ipairs(optionBtns) do b:Destroy() end
                    optionBtns = {}
                    for i, opt in ipairs(options) do
                        local oBtn = Instance.new("TextButton")
                        oBtn.Size = UDim2.new(1, 0, 0, optH)
                        oBtn.BackgroundColor3 = Theme.ElementBG
                        oBtn.BackgroundTransparency = 0.4
                        oBtn.Text = tostring(opt)
                        oBtn.TextColor3 = (opt == selected) and Theme.Accent or Theme.TextPrimary
                        oBtn.TextSize = Sizes.FontBody
                        oBtn.Font = (opt == selected) and Enum.Font.GothamBold or Enum.Font.GothamMedium
                        oBtn.AutoButtonColor = false
                        oBtn.BorderSizePixel = 0
                        oBtn.ZIndex = 11
                        oBtn.LayoutOrder = i
                        oBtn.Parent = optScroll
                        corner(oBtn, 6)

                        oBtn.MouseEnter:Connect(function() tw(oBtn, {BackgroundTransparency = 0.15}, 0.15) end)
                        oBtn.MouseLeave:Connect(function() tw(oBtn, {BackgroundTransparency = 0.4}, 0.15) end)

                        oBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            dValue.Text = tostring(opt)
                            if cfg.Flag then ZeroUI.Flags[cfg.Flag] = opt end
                            if cfg.Callback then cfg.Callback(opt) end
                            for _, ob in ipairs(optionBtns) do
                                ob.TextColor3 = Theme.TextPrimary
                                ob.Font = Enum.Font.GothamMedium
                            end
                            oBtn.TextColor3 = Theme.Accent
                            oBtn.Font = Enum.Font.GothamBold
                            opened = false
                            tw(container, {Size = UDim2.new(1, 0, 0, headerH)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                            tw(dArrow, {Rotation = 0}, 0.2)
                            task.delay(0.25, function() optScroll.Visible = false end)
                        end)
                        table.insert(optionBtns, oBtn)
                    end
                end
                buildOpts()

                headerBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        optScroll.Visible = true
                        tw(container, {Size = UDim2.new(1, 0, 0, headerH + dropH + 6)}, 0.3, Enum.EasingStyle.Back)
                        tw(dArrow, {Rotation = 180}, 0.2)
                    else
                        tw(container, {Size = UDim2.new(1, 0, 0, headerH)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                        tw(dArrow, {Rotation = 0}, 0.2)
                        task.delay(0.25, function() optScroll.Visible = false end)
                    end
                end)

                if cfg.Flag then ZeroUI.Flags[cfg.Flag] = selected end

                local API = {}
                function API:Set(val) selected = val; dValue.Text = tostring(val); if cfg.Flag then ZeroUI.Flags[cfg.Flag] = val end; if cfg.Callback then cfg.Callback(val) end; buildOpts() end
                function API:Get() return selected end
                function API:Refresh(newOpts) options = newOpts; buildOpts() end
                function API:Destroy() container:Destroy() end
                return API
            end

            -- ── INPUT ──
            function TabAPI:Input(cfg)
                cfg = cfg or {}
                local container = makeElement(Sizes.Element + 10)

                local iLabel = Instance.new("TextLabel")
                iLabel.Size = UDim2.new(0.38, -12, 1, 0)
                iLabel.Position = UDim2.fromOffset(12, 0)
                iLabel.BackgroundTransparency = 1
                iLabel.Text = cfg.Name or "Input"
                iLabel.TextColor3 = Theme.TextPrimary
                iLabel.TextSize = Sizes.FontBody
                iLabel.Font = Enum.Font.GothamBold
                iLabel.TextXAlignment = Enum.TextXAlignment.Left
                iLabel.ZIndex = 10
                iLabel.Parent = container

                local inputFrame = Instance.new("Frame")
                inputFrame.Size = UDim2.new(0.58, -12, 0, IsMobile and 34 or 28)
                inputFrame.Position = UDim2.new(1, -8, 0.5, 0)
                inputFrame.AnchorPoint = Vector2.new(1, 0.5)
                inputFrame.BackgroundColor3 = Theme.InputBG
                inputFrame.BorderSizePixel = 0
                inputFrame.ZIndex = 10
                inputFrame.Parent = container
                corner(inputFrame, 6)
                local iStroke = stroke(inputFrame, Theme.InputBorder, 1, 0.4)

                local iBox = Instance.new("TextBox")
                iBox.Size = UDim2.new(1, -12, 1, 0)
                iBox.Position = UDim2.fromOffset(6, 0)
                iBox.BackgroundTransparency = 1
                iBox.Text = cfg.Default or ""
                iBox.PlaceholderText = cfg.Placeholder or "Type..."
                iBox.PlaceholderColor3 = Theme.TextDim
                iBox.TextColor3 = Theme.TextPrimary
                iBox.TextSize = Sizes.FontBody
                iBox.Font = Enum.Font.GothamMedium
                iBox.TextXAlignment = Enum.TextXAlignment.Left
                iBox.ClearTextOnFocus = cfg.ClearOnFocus or false
                iBox.ZIndex = 11
                iBox.Parent = inputFrame

                iBox.Focused:Connect(function() tw(iStroke, {Color = Theme.Accent, Transparency = 0}, 0.2) end)
                iBox.FocusLost:Connect(function()
                    tw(iStroke, {Color = Theme.InputBorder, Transparency = 0.4}, 0.2)
                    if cfg.Flag then ZeroUI.Flags[cfg.Flag] = iBox.Text end
                    if cfg.Callback then cfg.Callback(iBox.Text) end
                end)

                local API = {}
                function API:Set(v) iBox.Text = v end
                function API:Get() return iBox.Text end
                function API:Destroy() container:Destroy() end
                return API
            end

            -- ── KEYBIND ──
            function TabAPI:Keybind(cfg)
                cfg = cfg or {}
                local currentKey = cfg.Default or Enum.KeyCode.E
                local listening = false
                local container = makeElement()

                local kLabel = Instance.new("TextLabel")
                kLabel.Size = UDim2.new(0.65, -12, 1, 0)
                kLabel.Position = UDim2.fromOffset(12, 0)
                kLabel.BackgroundTransparency = 1
                kLabel.Text = cfg.Name or "Keybind"
                kLabel.TextColor3 = Theme.TextPrimary
                kLabel.TextSize = Sizes.FontBody
                kLabel.Font = Enum.Font.GothamBold
                kLabel.TextXAlignment = Enum.TextXAlignment.Left
                kLabel.ZIndex = 10
                kLabel.Parent = container

                local kbW = IsMobile and 70 or 60
                local kBox = Instance.new("TextButton")
                kBox.Size = UDim2.fromOffset(kbW, IsMobile and 30 or 26)
                kBox.Position = UDim2.new(1, -(kbW + 10), 0.5, 0)
                kBox.AnchorPoint = Vector2.new(0, 0.5)
                kBox.BackgroundColor3 = Theme.InputBG
                kBox.Text = currentKey.Name
                kBox.TextColor3 = Theme.Accent
                kBox.TextSize = Sizes.FontSmall
                kBox.Font = Enum.Font.GothamBold
                kBox.AutoButtonColor = false
                kBox.BorderSizePixel = 0
                kBox.ZIndex = 10
                kBox.Parent = container
                corner(kBox, 6)
                stroke(kBox, Theme.InputBorder, 1, 0.4)

                kBox.MouseButton1Click:Connect(function()
                    listening = true
                    kBox.Text = "..."
                    tw(kBox, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.TextOnAccent}, 0.2)
                end)

                UserInputService.InputBegan:Connect(function(input, gpe)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        kBox.Text = currentKey.Name
                        listening = false
                        tw(kBox, {BackgroundColor3 = Theme.InputBG, TextColor3 = Theme.Accent}, 0.2)
                        if cfg.Flag then ZeroUI.Flags[cfg.Flag] = currentKey end
                        return
                    end
                    if not listening and not gpe and input.KeyCode == currentKey then
                        if cfg.Callback then cfg.Callback() end
                    end
                end)

                if cfg.Flag then ZeroUI.Flags[cfg.Flag] = currentKey end

                local API = {}
                function API:Set(key) currentKey = key; kBox.Text = key.Name end
                function API:Get() return currentKey end
                function API:Destroy() container:Destroy() end
                return API
            end

            -- ── PARAGRAPH ──
            function TabAPI:Paragraph(cfg)
                cfg = cfg or {}
                local content = cfg.Content or ""
                local lines = #content / 35 + 1
                local pH = math.max(Sizes.Element + 10, 30 + lines * 16)
                local container = makeElement(pH)

                local pTitle = Instance.new("TextLabel")
                pTitle.Size = UDim2.new(1, -20, 0, 22)
                pTitle.Position = UDim2.fromOffset(10, 4)
                pTitle.BackgroundTransparency = 1
                pTitle.Text = cfg.Title or "Info"
                pTitle.TextColor3 = Theme.TextPrimary
                pTitle.TextSize = Sizes.FontBody
                pTitle.Font = Enum.Font.GothamBold
                pTitle.TextXAlignment = Enum.TextXAlignment.Left
                pTitle.ZIndex = 10
                pTitle.Parent = container

                local pContent = Instance.new("TextLabel")
                pContent.Size = UDim2.new(1, -20, 1, -28)
                pContent.Position = UDim2.fromOffset(10, 26)
                pContent.BackgroundTransparency = 1
                pContent.Text = content
                pContent.TextColor3 = Theme.TextSecondary
                pContent.TextSize = Sizes.FontSmall
                pContent.Font = Enum.Font.GothamMedium
                pContent.TextXAlignment = Enum.TextXAlignment.Left
                pContent.TextYAlignment = Enum.TextYAlignment.Top
                pContent.TextWrapped = true
                pContent.ZIndex = 10
                pContent.Parent = container

                local API = {}
                function API:Set(title, body) if title then pTitle.Text = title end; if body then pContent.Text = body end end
                function API:Destroy() container:Destroy() end
                return API
            end

            -- ── LABEL ──
            function TabAPI:Label(cfg)
                cfg = cfg or {}
                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, 0, 0, 24)
                container.BackgroundTransparency = 1
                container.ZIndex = 8
                container.LayoutOrder = nextOrder()
                container.Parent = page

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, -16, 1, 0)
                lbl.Position = UDim2.fromOffset(8, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = cfg.Text or "Label"
                lbl.TextColor3 = Theme.TextSecondary
                lbl.TextSize = Sizes.FontBody
                lbl.Font = Enum.Font.GothamMedium
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.ZIndex = 9
                lbl.Parent = container

                local API = {}
                function API:Set(txt) lbl.Text = txt end
                function API:Destroy() container:Destroy() end
                return API
            end

            return TabAPI
        end

        -- ══════════════════════════
        --     NOTIFICATIONS
        -- ══════════════════════════
        function WindowAPI:Notify(nCfg)
            nCfg = nCfg or {}
            local title = nCfg.Title or "Notification"
            local content = nCfg.Content or ""
            local duration = nCfg.Duration or 5
            local nType = nCfg.Type or "info"

            local accentColor = ({
                success = Theme.Success,
                error   = Theme.Error,
                warning = Theme.Warning,
                info    = Theme.Info,
            })[nType:lower()] or Theme.Info

            local nW = IsMobile and math.clamp(ViewportSize.X * 0.85, 260, 360) or 320
            local nH = IsMobile and 80 or 72

            local notif = Instance.new("Frame")
            notif.Size = UDim2.fromOffset(nW, nH)
            notif.Position = UDim2.new(1, nW + 20, 1, -20)
            notif.AnchorPoint = Vector2.new(1, 1)
            notif.BackgroundColor3 = Theme.NotifyBG
            notif.BackgroundTransparency = Theme.NotifyTrans
            notif.BorderSizePixel = 0
            notif.ZIndex = 50
            notif.Parent = gui
            corner(notif, 12)
            stroke(notif, accentColor, 1.2, 0.3)

            local nBar = Instance.new("Frame")
            nBar.Size = UDim2.new(0, 4, 0.7, 0)
            nBar.Position = UDim2.new(0, 8, 0.15, 0)
            nBar.BackgroundColor3 = accentColor
            nBar.BorderSizePixel = 0
            nBar.ZIndex = 51
            nBar.Parent = notif
            corner(nBar, 2)

            local nTitle = Instance.new("TextLabel")
            nTitle.Size = UDim2.new(1, -28, 0, 22)
            nTitle.Position = UDim2.fromOffset(20, 8)
            nTitle.BackgroundTransparency = 1
            nTitle.Text = title
            nTitle.TextColor3 = Theme.TextPrimary
            nTitle.TextSize = Sizes.FontBody
            nTitle.Font = Enum.Font.GothamBold
            nTitle.TextXAlignment = Enum.TextXAlignment.Left
            nTitle.TextTruncate = Enum.TextTruncate.AtEnd
            nTitle.ZIndex = 51
            nTitle.Parent = notif

            local nContent = Instance.new("TextLabel")
            nContent.Size = UDim2.new(1, -28, 1, -32)
            nContent.Position = UDim2.fromOffset(20, 30)
            nContent.BackgroundTransparency = 1
            nContent.Text = content
            nContent.TextColor3 = Theme.TextSecondary
            nContent.TextSize = Sizes.FontSmall
            nContent.Font = Enum.Font.GothamMedium
            nContent.TextXAlignment = Enum.TextXAlignment.Left
            nContent.TextYAlignment = Enum.TextYAlignment.Top
            nContent.TextWrapped = true
            nContent.ZIndex = 51
            nContent.Parent = notif

            local nProgress = Instance.new("Frame")
            nProgress.Size = UDim2.new(1, 0, 0, 3)
            nProgress.Position = UDim2.new(0, 0, 1, -3)
            nProgress.BackgroundColor3 = accentColor
            nProgress.BackgroundTransparency = 0.3
            nProgress.BorderSizePixel = 0
            nProgress.ZIndex = 51
            nProgress.Parent = notif

            tw(notif, {Position = UDim2.new(1, -12, 1, -20)}, 0.4, Enum.EasingStyle.Back)
            tw(nProgress, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear)

            task.delay(duration, function()
                tw(notif, {Position = UDim2.new(1, nW + 20, 1, -20), BackgroundTransparency = 1}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.wait(0.4)
                if notif then notif:Destroy() end
            end)
        end

        -- ══════════════════════════
        --     FPS METHODS
        -- ══════════════════════════
        function WindowAPI:ToggleFPS()
            if fpsCounter then
                return fpsCounter:Toggle()
            end
        end

        function WindowAPI:ShowFPS()
            if fpsCounter then fpsCounter:Show() end
        end

        function WindowAPI:HideFPS()
            if fpsCounter then fpsCounter:Hide() end
        end

        function WindowAPI:GetFPS()
            if fpsCounter then return fpsCounter:GetFPS() end
            return 0
        end

        -- ══════════════════════════
        --     WINDOW METHODS
        -- ══════════════════════════
        function WindowAPI:Toggle()
            windowVisible = not windowVisible
            if windowVisible then
                gui.Enabled = true
                tw(mainFrame, {
                    Size = UDim2.fromOffset(mainW, mainH),
                    BackgroundTransparency = Theme.WindowTrans,
                }, 0.35, Enum.EasingStyle.Back)
            else
                tw(mainFrame, {
                    Size = UDim2.fromOffset(mainW * 0.9, mainH * 0.9),
                    BackgroundTransparency = 1,
                }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.delay(0.3, function()
                    if not windowVisible then gui.Enabled = false end
                end)
            end
        end

        function WindowAPI:Destroy()
            pcall(function() gui:Destroy() end)
        end

        -- Welcome notification
        WindowAPI:Notify({
            Title = config.Name,
            Content = "Loaded! " .. (IsMobile and "Tap" or "Press " .. config.ToggleKey.Name) .. " to toggle",
            Duration = 5,
            Type = "success",
        })
    end

    -- Handle key system
    if config.KeySystem and config.KeySystem.Key then
        showKeySystem(config.KeySystem, function() buildWindow() end)
    else
        buildWindow()
    end

    return WindowAPI
end

-- ══════════════════════════════════════
--          GLOBAL METHODS
-- ══════════════════════════════════════
function ZeroUI:GetFlag(flag)
    return self.Flags[flag]
end

function ZeroUI:SetFlag(flag, value)
    self.Flags[flag] = value
end

print("[ZeroUI] Library v" .. ZeroUI.Version .. " loaded")
print("[ZeroUI] Mobile: " .. tostring(IsMobile))

return ZeroUI