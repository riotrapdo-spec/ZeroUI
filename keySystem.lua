local KeySystem = {}

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Mobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local VP = workspace.CurrentCamera.ViewportSize

local hubImage = "https://i.ibb.co/k2WG4ctf/image.png"

local T = {
    BG = Color3.fromRGB(6,8,18),
    Card = Color3.fromRGB(12,14,28),
    Acc = Color3.fromRGB(75,125,255),
    AccH = Color3.fromRGB(100,148,255),
    AccD = Color3.fromRGB(55,100,220),
    Txt = Color3.fromRGB(230,234,255),
    Txt2 = Color3.fromRGB(125,135,170),
    Txt3 = Color3.fromRGB(60,68,100),
    TxtW = Color3.fromRGB(255,255,255),
    Bor = Color3.fromRGB(35,40,65),
    InBG = Color3.fromRGB(15,17,32),
    InBor = Color3.fromRGB(40,48,80),
    Suc = Color3.fromRGB(45,200,110),
    Err = Color3.fromRGB(255,60,72),
    Wrn = Color3.fromRGB(255,175,45),
    Par = Color3.fromRGB(45,70,160),
}

local function tw(o,p,d,s,r)
    local t = TweenService:Create(o,TweenInfo.new(d or 0.22,s or Enum.EasingStyle.Quart,r or Enum.EasingDirection.Out),p)
    t:Play() return t
end

local function cor(p,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r or 8)
    c.Parent = p
    return c
end

local function stk(p,c,th,tr)
    local s = Instance.new("UIStroke")
    s.Color = c or T.Bor
    s.Thickness = th or 1
    s.Transparency = tr or 0.35
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function drag(tb,fr)
    local d,ds,sp = false,nil,nil
    tb.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            d = true
            ds = i.Position
            sp = fr.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then d = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local dt = i.Position - ds
            tw(fr,{Position = UDim2.new(sp.X.Scale,sp.X.Offset+dt.X,sp.Y.Scale,sp.Y.Offset+dt.Y)},0.05,Enum.EasingStyle.Linear)
        end
    end)
end

local function rf(n)
    local o,d = pcall(function() return readfile(n) end)
    return o and d or nil
end

local function wf(n,d)
    pcall(function() writefile(n,d) end)
end

function KeySystem:Show(cfg)
    cfg = cfg or {}
    cfg.Title = cfg.Title or "VERIFY"
    cfg.Note = cfg.Note or "Enter key"
    cfg.KeyURL = cfg.KeyURL or ""
    cfg.FileName = cfg.FileName or "KeySystem_Key"
    cfg.SaveKey = cfg.SaveKey ~= false
    cfg.OnSuccess = cfg.OnSuccess or function() end
    cfg.OnFail = cfg.OnFail or function() end

    local fn = cfg.FileName .. ".txt"
    local vk = ""
    local isURL = cfg.KeyURL:find("http") ~= nil

    if isURL then
        pcall(function()
            local r = game:HttpGet(cfg.KeyURL)
            vk = r:gsub("%s+",""):gsub("\n",""):gsub("\r","")
        end)
    else
        vk = cfg.KeyURL:gsub("%s+","")
    end

    if cfg.SaveKey then
        local sv = rf(fn)
        if sv and sv:gsub("%s+","") == vk and vk ~= "" then
            cfg.OnSuccess()
            return
        end
    end

    if CoreGui:FindFirstChild("KeySystemUI") then
        CoreGui:FindFirstChild("KeySystemUI"):Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "KeySystemUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.Parent = CoreGui

    local ov = Instance.new("Frame")
    ov.Size = UDim2.new(1,0,1,0)
    ov.BackgroundColor3 = Color3.fromRGB(2,2,8)
    ov.BackgroundTransparency = 1
    ov.BorderSizePixel = 0
    ov.Parent = gui
    tw(ov,{BackgroundTransparency = 0.2},0.5)

    task.spawn(function()
        for i = 1,30 do
            local d = Instance.new("Frame")
            local sz = math.random(2,6)
            d.Size = UDim2.fromOffset(sz,sz)
            d.Position = UDim2.new(math.random()*0.95,0,math.random()*0.95,0)
            d.BackgroundColor3 = T.Par
            d.BackgroundTransparency = math.random(60,88)/100
            d.BorderSizePixel = 0
            d.ZIndex = 2
            d.Parent = ov
            cor(d,99)
            task.spawn(function()
                while d and d.Parent do
                    tw(d,{
                        Position = UDim2.new(math.clamp(d.Position.X.Scale+(math.random()-0.5)*0.1,0,1),0,math.random()*0.95,0),
                        BackgroundTransparency = math.random(50,90)/100,
                        Size = UDim2.fromOffset(math.random(2,7),math.random(2,7))
                    },math.random(4,9),Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
                    task.wait(math.random(4,9))
                end
            end)
        end
    end)

    local cw = Mobile and math.clamp(VP.X*0.88,280,400) or 380
    local ch = Mobile and 360 or 340

    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.fromOffset(cw+100,ch+100)
    glow.Position = UDim2.new(0.5,0,0.5,0)
    glow.AnchorPoint = Vector2.new(0.5,0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = T.Acc
    glow.ImageTransparency = 0.85
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(24,24,276,276)
    glow.ZIndex = 9
    glow.Parent = ov

    task.spawn(function()
        while glow and glow.Parent do
            tw(glow,{ImageTransparency = 0.78},2.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
            task.wait(2.5)
            tw(glow,{ImageTransparency = 0.92},2.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
            task.wait(2.5)
        end
    end)

    local cd = Instance.new("Frame")
    cd.Size = UDim2.fromOffset(cw,ch)
    cd.Position = UDim2.new(0.5,0,0.5,0)
    cd.AnchorPoint = Vector2.new(0.5,0.5)
    cd.BackgroundColor3 = T.Card
    cd.BackgroundTransparency = 0.02
    cd.BorderSizePixel = 0
    cd.ZIndex = 10
    cd.Parent = ov
    cor(cd,14)
    stk(cd,T.Bor,1.2,0.2)

    local tl = Instance.new("Frame")
    tl.Size = UDim2.new(0.35,0,0,3)
    tl.Position = UDim2.new(0.325,0,0,0)
    tl.BackgroundColor3 = T.Acc
    tl.BorderSizePixel = 0
    tl.ZIndex = 12
    tl.Parent = cd
    cor(tl,2)

    task.spawn(function()
        while tl and tl.Parent do
            tw(tl,{Size = UDim2.new(0.55,0,0,3),Position = UDim2.new(0.225,0,0,0)},2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
            task.wait(2)
            tw(tl,{Size = UDim2.new(0.35,0,0,3),Position = UDim2.new(0.325,0,0,0)},2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
            task.wait(2)
        end
    end)

    local ico = Instance.new("ImageLabel")
    ico.Size = UDim2.fromOffset(48,48)
    ico.Position = UDim2.new(0.5,0,0,20)
    ico.AnchorPoint = Vector2.new(0.5,0)
    ico.BackgroundTransparency = 1
    ico.Image = hubImage
    ico.ZIndex = 12
    ico.Parent = cd
    cor(ico,10)

    local kt = Instance.new("TextLabel")
    kt.Size = UDim2.new(0.9,0,0,26)
    kt.Position = UDim2.new(0.5,0,0,76)
    kt.AnchorPoint = Vector2.new(0.5,0)
    kt.BackgroundTransparency = 1
    kt.Text = cfg.Title
    kt.TextColor3 = T.Txt
    kt.TextSize = Mobile and 20 or 18
    kt.Font = Enum.Font.GothamBold
    kt.ZIndex = 12
    kt.Parent = cd

    local ks = Instance.new("TextLabel")
    ks.Size = UDim2.new(0.85,0,0,18)
    ks.Position = UDim2.new(0.5,0,0,104)
    ks.AnchorPoint = Vector2.new(0.5,0)
    ks.BackgroundTransparency = 1
    ks.Text = cfg.Note
    ks.TextColor3 = T.Txt2
    ks.TextSize = Mobile and 13 or 12
    ks.Font = Enum.Font.GothamMedium
    ks.ZIndex = 12
    ks.Parent = cd

    local ic = Instance.new("Frame")
    ic.Size = UDim2.new(0.82,0,0,Mobile and 48 or 44)
    ic.Position = UDim2.new(0.5,0,0,138)
    ic.AnchorPoint = Vector2.new(0.5,0)
    ic.BackgroundColor3 = T.InBG
    ic.BorderSizePixel = 0
    ic.ZIndex = 12
    ic.Parent = cd
    cor(ic,10)
    local ist = stk(ic,T.InBor,1.2,0.3)

    local ib = Instance.new("TextBox")
    ib.Size = UDim2.new(1,-20,1,0)
    ib.Position = UDim2.new(0,10,0,0)
    ib.BackgroundTransparency = 1
    ib.Text = ""
    ib.PlaceholderText = "Enter key..."
    ib.PlaceholderColor3 = T.Txt3
    ib.TextColor3 = T.Txt
    ib.TextSize = Mobile and 14 or 13
    ib.Font = Enum.Font.GothamMedium
    ib.TextXAlignment = Enum.TextXAlignment.Left
    ib.ClearTextOnFocus = false
    ib.ZIndex = 13
    ib.Parent = ic

    ib.Focused:Connect(function()
        tw(ist,{Color = T.Acc,Transparency = 0},0.2)
    end)

    ib.FocusLost:Connect(function()
        tw(ist,{Color = T.InBor,Transparency = 0.3},0.2)
    end)

    local st = Instance.new("TextLabel")
    st.Size = UDim2.new(0.82,0,0,16)
    st.Position = UDim2.new(0.5,0,0,Mobile and 194 or 190)
    st.AnchorPoint = Vector2.new(0.5,0)
    st.BackgroundTransparency = 1
    st.Text = ""
    st.TextColor3 = T.Err
    st.TextSize = 11
    st.Font = Enum.Font.GothamMedium
    st.TextXAlignment = Enum.TextXAlignment.Left
    st.TextTransparency = 1
    st.ZIndex = 12
    st.Parent = cd

    local vb = Instance.new("TextButton")
    vb.Size = UDim2.new(0.82,0,0,Mobile and 48 or 44)
    vb.Position = UDim2.new(0.5,0,0,Mobile and 218 or 212)
    vb.AnchorPoint = Vector2.new(0.5,0)
    vb.BackgroundColor3 = T.Acc
    vb.BorderSizePixel = 0
    vb.Text = "VERIFY"
    vb.TextColor3 = T.TxtW
    vb.TextSize = Mobile and 15 or 14
    vb.Font = Enum.Font.GothamBold
    vb.AutoButtonColor = false
    vb.ZIndex = 12
    vb.Parent = cd
    cor(vb,10)

    vb.MouseEnter:Connect(function()
        tw(vb,{BackgroundColor3 = T.AccH},0.15)
    end)

    vb.MouseLeave:Connect(function()
        tw(vb,{BackgroundColor3 = T.Acc},0.15)
    end)

    local gb = Instance.new("TextButton")
    gb.Size = UDim2.new(0.82,0,0,Mobile and 40 or 36)
    gb.Position = UDim2.new(0.5,0,0,Mobile and 276 or 266)
    gb.AnchorPoint = Vector2.new(0.5,0)
    gb.BackgroundColor3 = T.InBG
    gb.BackgroundTransparency = 0.15
    gb.BorderSizePixel = 0
    gb.Text = "🔗 Copy Link"
    gb.TextColor3 = T.Txt2
    gb.TextSize = Mobile and 13 or 12
    gb.Font = Enum.Font.GothamMedium
    gb.AutoButtonColor = false
    gb.ZIndex = 12
    gb.Parent = cd
    cor(gb,8)
    stk(gb,T.Bor,1,0.45)

    gb.MouseEnter:Connect(function()
        tw(gb,{BackgroundTransparency = 0},0.15)
    end)

    gb.MouseLeave:Connect(function()
        tw(gb,{BackgroundTransparency = 0.15},0.15)
    end)

    gb.MouseButton1Click:Connect(function()
        pcall(function()
            if isURL then
                setclipboard(cfg.KeyURL)
            else
                setclipboard(vk)
            end
        end)
        gb.Text = "✅ Copied!"
        gb.TextColor3 = T.Suc
        task.wait(1.5)
        gb.Text = "🔗 Copy Link"
        gb.TextColor3 = T.Txt2
    end)

    local ft = Instance.new("TextLabel")
    ft.Size = UDim2.new(0.9,0,0,14)
    ft.Position = UDim2.new(0.5,0,1,-20)
    ft.AnchorPoint = Vector2.new(0.5,0)
    ft.BackgroundTransparency = 1
    ft.Text = "🛡️ Protected"
    ft.TextColor3 = T.Txt3
    ft.TextSize = 9
    ft.Font = Enum.Font.Gotham
    ft.ZIndex = 12
    ft.Parent = cd

    cd.Size = UDim2.fromOffset(cw-30,ch-30)
    cd.BackgroundTransparency = 1
    task.spawn(function()
        task.wait(0.1)
        tw(cd,{Size = UDim2.fromOffset(cw,ch),BackgroundTransparency = 0.02},0.5,Enum.EasingStyle.Back)
    end)

    local busy = false

    local function verify()
        if busy then return end
        busy = true
        local e = ib.Text:gsub("%s+","")
        vb.Text = "..."
        tw(vb,{BackgroundColor3 = T.AccD},0.1)
        task.wait(0.5)

        if e == "" then
            st.Text = "⚠ Enter key"
            st.TextColor3 = T.Wrn
            tw(st,{TextTransparency = 0},0.15)
            task.delay(2.5,function() tw(st,{TextTransparency = 1},0.2) end)
            vb.Text = "VERIFY"
            tw(vb,{BackgroundColor3 = T.Acc},0.15)
            busy = false
            return
        end

        if vk == "" then
            st.Text = "⚠ Server error"
            st.TextColor3 = T.Err
            tw(st,{TextTransparency = 0},0.15)
            task.delay(3,function() tw(st,{TextTransparency = 1},0.2) end)
            vb.Text = "VERIFY"
            tw(vb,{BackgroundColor3 = T.Acc},0.15)
            busy = false
            return
        end

        if e == vk then
            st.Text = "✅ Verified!"
            st.TextColor3 = T.Suc
            tw(st,{TextTransparency = 0},0.15)
            vb.Text = "✅"
            tw(vb,{BackgroundColor3 = T.Suc},0.2)

            if cfg.SaveKey then
                wf(fn,e)
            end

            task.wait(0.7)

            for _,c in ipairs(cd:GetDescendants()) do
                pcall(function()
                    if c:IsA("TextLabel") or c:IsA("TextButton") or c:IsA("TextBox") then
                        tw(c,{TextTransparency = 1},0.25)
                    elseif c:IsA("Frame") or c:IsA("ImageLabel") then
                        tw(c,{BackgroundTransparency = 1,ImageTransparency = 1},0.25)
                    end
                end)
            end

            tw(cd,{BackgroundTransparency = 1,Size = UDim2.fromOffset(cw+20,ch+20)},0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In)
            tw(glow,{ImageTransparency = 1},0.35)
            tw(ov,{BackgroundTransparency = 1},0.45)

            task.wait(0.5)
            gui:Destroy()
            cfg.OnSuccess()
        else
            st.Text = "❌ Invalid key"
            st.TextColor3 = T.Err
            tw(st,{TextTransparency = 0},0.15)
            tw(vb,{BackgroundColor3 = T.Err},0.1)
            tw(ist,{Color = T.Err,Transparency = 0},0.1)

            local op = cd.Position
            for i = 1,6 do
                tw(cd,{Position = op + UDim2.fromOffset(i%2 == 0 and 8 or -8,0)},0.035,Enum.EasingStyle.Linear)
                task.wait(0.035)
            end
            tw(cd,{Position = op},0.035,Enum.EasingStyle.Linear)

            task.wait(0.5)
            tw(vb,{BackgroundColor3 = T.Acc},0.2)
            tw(ist,{Color = T.InBor,Transparency = 0.3},0.2)
            vb.Text = "VERIFY"
            task.delay(2.5,function() tw(st,{TextTransparency = 1},0.2) end)
            cfg.OnFail()
            busy = false
        end
    end

    vb.MouseButton1Click:Connect(verify)

    ib.FocusLost:Connect(function(enter)
        if enter then verify() end
    end)

    drag(cd,cd)
end

return KeySystem