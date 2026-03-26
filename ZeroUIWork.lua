--CopyRight ©️ 
local ZeroUI = {}
ZeroUI.Flags = {}
ZeroUI.Version = "1.2.0"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local Plr = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local Mobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local VP = Cam.ViewportSize
Cam:GetPropertyChangedSignal("ViewportSize"):Connect(function() VP = Cam.ViewportSize end)

local hubImageId = "https://i.ibb.co/k2WG4ctf/image.png"

local S = {}
local function upS()
    S.WinW = Mobile and math.clamp(VP.X*0.93,320,580) or 540
    S.WinH = Mobile and math.clamp(VP.Y*0.7,300,480) or 400
    S.Side = Mobile and 50 or 150
    S.Top = Mobile and 44 or 40
    S.Elem = Mobile and 44 or 38
    S.F1 = Mobile and 15 or 13
    S.F2 = Mobile and 13 or 12
    S.F3 = Mobile and 11 or 10
    S.Cor = Mobile and 10 or 8
    S.Pad = Mobile and 7 or 5
    S.TW = Mobile and 46 or 40
    S.TH = Mobile and 24 or 20
    S.KS = Mobile and 18 or 14
    S.BoxSize = Mobile and 52 or 46
end
upS()

local T = {
    WinBG = Color3.fromRGB(12,14,24), WinT = 0.04,
    SideBG = Color3.fromRGB(8,10,20), SideT = 0.02,
    TopBG = Color3.fromRGB(16,18,30), TopT = 0.02,
    ElemBG = Color3.fromRGB(20,23,40), ElemT = 0.08,
    ElemHov = Color3.fromRGB(28,32,55), ElemHovT = 0.04,
    Acc = Color3.fromRGB(75,125,255),
    AccH = Color3.fromRGB(100,148,255),
    AccD = Color3.fromRGB(55,100,220),
    AccS = Color3.fromRGB(35,55,120),
    Txt = Color3.fromRGB(230,234,255),
    Txt2 = Color3.fromRGB(125,135,170),
    Txt3 = Color3.fromRGB(60,68,100),
    TxtW = Color3.fromRGB(255,255,255),
    Bor = Color3.fromRGB(35,40,65), BorT = 0.35,
    TOff = Color3.fromRGB(40,45,68),
    TKnob = Color3.fromRGB(225,230,255),
    STrk = Color3.fromRGB(30,35,58),
    InBG = Color3.fromRGB(15,17,32),
    InBor = Color3.fromRGB(40,48,80),
    Div = Color3.fromRGB(30,35,58), DivT = 0.45,
    TabA = Color3.fromRGB(75,125,255),
    TabI = Color3.fromRGB(80,90,125),
    NBG = Color3.fromRGB(16,18,32), NT = 0.04,
    Suc = Color3.fromRGB(45,200,110),
    Err = Color3.fromRGB(255,60,72),
    Wrn = Color3.fromRGB(255,175,45),
    Inf = Color3.fromRGB(75,130,255),
    KeyBG = Color3.fromRGB(6,8,18),
    KeyC = Color3.fromRGB(14,16,30),
    FBG = Color3.fromRGB(10,12,24),
    FG = Color3.fromRGB(45,200,110),
    FM = Color3.fromRGB(255,200,50),
    FB = Color3.fromRGB(255,60,72),
    Par = Color3.fromRGB(45,70,160),
    BoxBG = Color3.fromRGB(10,12,22),
    BoxBor = Color3.fromRGB(50,70,150),
}

local function tw(o,p,d,s,r)
    local t=TweenService:Create(o,TweenInfo.new(d or 0.22,s or Enum.EasingStyle.Quart,r or Enum.EasingDirection.Out),p)
    t:Play() return t
end

local function cor(p,r)
    local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or S.Cor) c.Parent=p return c
end

local function stk(p,c,th,tr)
    local s=Instance.new("UIStroke") s.Color=c or T.Bor s.Thickness=th or 1 s.Transparency=tr or T.BorT
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border s.Parent=p return s
end

local function ll(p,pd)
    local l=Instance.new("UIListLayout") l.SortOrder=Enum.SortOrder.LayoutOrder l.Padding=UDim.new(0,pd or S.Pad)
    l.HorizontalAlignment=Enum.HorizontalAlignment.Center l.Parent=p return l
end

local function ac(sf,ly)
    local function u() sf.CanvasSize=UDim2.new(0,0,0,ly.AbsoluteContentSize.Y+16) end
    ly:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(u) u()
end

local function rip(p,x,y)
    local c=Instance.new("Frame") c.BackgroundColor3=T.Acc c.BackgroundTransparency=0.6
    c.Size=UDim2.fromOffset(0,0) c.Position=UDim2.fromOffset(x,y) c.AnchorPoint=Vector2.new(0.5,0.5)
    c.ZIndex=99 c.Parent=p cor(c,999)
    local m=math.max(p.AbsoluteSize.X,p.AbsoluteSize.Y)*2.5
    tw(c,{Size=UDim2.fromOffset(m,m),BackgroundTransparency=1},0.45,Enum.EasingStyle.Quad)
    task.delay(0.5,function() if c then c:Destroy() end end)
end

local function drag(tb,fr)
    local d,ds,sp=false,nil,nil
    tb.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            d=true ds=i.Position sp=fr.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if d and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then
            local dt=i.Position-ds
            tw(fr,{Position=UDim2.new(sp.X.Scale,sp.X.Offset+dt.X,sp.Y.Scale,sp.Y.Offset+dt.Y)},0.05,Enum.EasingStyle.Linear)
        end
    end)
end

local function rf(n) local o,d=pcall(function() return readfile(n) end) return o and d or nil end
local function wf(n,d) pcall(function() writefile(n,d) end) end

local FPS={}
function FPS:Create(gui)
    local vis,cur=false,60
    local f=Instance.new("Frame") f.Name="FPS" f.Size=UDim2.fromOffset(Mobile and 95 or 85,Mobile and 32 or 28)
    f.Position=UDim2.new(0,10,0,10) f.BackgroundColor3=T.FBG f.BackgroundTransparency=0.1
    f.BorderSizePixel=0 f.ZIndex=100 f.Visible=false f.Parent=gui cor(f,7) stk(f,T.Bor,1,0.4)

    local dot=Instance.new("Frame") dot.Size=UDim2.fromOffset(7,7) dot.Position=UDim2.new(0,8,0.5,0)
    dot.AnchorPoint=Vector2.new(0,0.5) dot.BackgroundColor3=T.FG dot.BorderSizePixel=0 dot.ZIndex=101
    dot.Parent=f cor(dot,99)

    task.spawn(function() while dot and dot.Parent do
        tw(dot,{BackgroundTransparency=0.4},0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut) task.wait(0.7)
        tw(dot,{BackgroundTransparency=0},0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut) task.wait(0.7)
    end end)

    local num=Instance.new("TextLabel") num.Size=UDim2.new(0,30,1,0) num.Position=UDim2.new(0,19,0,0)
    num.BackgroundTransparency=1 num.Text="60" num.TextColor3=T.Txt num.TextSize=Mobile and 14 or 12
    num.Font=Enum.Font.GothamBold num.TextXAlignment=Enum.TextXAlignment.Left num.ZIndex=101 num.Parent=f

    local lab=Instance.new("TextLabel") lab.Size=UDim2.new(0,22,1,0) lab.Position=UDim2.new(1,-28,0,0)
    lab.BackgroundTransparency=1 lab.Text="FPS" lab.TextColor3=T.Txt3 lab.TextSize=9
    lab.Font=Enum.Font.GothamBold lab.ZIndex=101 lab.Parent=f

    local bar=Instance.new("Frame") bar.Size=UDim2.new(0.82,0,0,2) bar.Position=UDim2.new(0.09,0,1,-4)
    bar.BackgroundColor3=T.STrk bar.BackgroundTransparency=0.5 bar.BorderSizePixel=0 bar.ZIndex=101
    bar.Parent=f cor(bar,1)

    local fil=Instance.new("Frame") fil.Size=UDim2.new(1,0,1,0) fil.BackgroundColor3=T.FG
    fil.BorderSizePixel=0 fil.ZIndex=102 fil.Parent=bar cor(fil,1)

    local fc,lt=0,tick()
    RunService.RenderStepped:Connect(function()
        fc=fc+1 local n=tick()
        if n-lt>=0.5 then
            cur=math.floor(fc/(n-lt)) fc=0 lt=n
            if f.Visible then
                num.Text=tostring(cur)
                local col=cur>=50 and T.FG or cur>=30 and T.FM or T.FB
                local pct=cur>=50 and 1 or cur>=30 and 0.6 or math.clamp(cur/60,0.05,0.4)
                tw(dot,{BackgroundColor3=col},0.25) tw(num,{TextColor3=col},0.25)
                tw(fil,{Size=UDim2.new(pct,0,1,0),BackgroundColor3=col},0.25)
            end
        end
    end)
    drag(f,f)

    local A={}
    function A:Toggle() vis=not vis
        if vis then f.Visible=true f.BackgroundTransparency=1 tw(f,{BackgroundTransparency=0.1},0.25)
        else tw(f,{BackgroundTransparency=1},0.2) task.delay(0.2,function() if not vis then f.Visible=false end end) end
        return vis
    end
    function A:Show() vis=true f.Visible=true tw(f,{BackgroundTransparency=0.1},0.25) end
    function A:Hide() vis=false tw(f,{BackgroundTransparency=1},0.2) task.delay(0.2,function() if not vis then f.Visible=false end end) end
    function A:GetFPS() return cur end
    return A
end

local function showKey(cfg,onOk)
    local fn=(cfg.FileName or "ZeroUI_Key")..".txt"
    local vk="" local isURL=cfg.Key:find("http")~=nil
    if isURL then pcall(function() local r=game:HttpGet(cfg.Key) vk=r:gsub("%s+",""):gsub("\n",""):gsub("\r","") end)
    else vk=cfg.Key:gsub("%s+","") end
    if cfg.SaveKey then local sv=rf(fn) if sv and sv:gsub("%s+","")==vk and vk~="" then onOk() return end end

    local g=Instance.new("ScreenGui") g.Name="ZeroUI_Key" g.ResetOnSpawn=false g.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    g.IgnoreGuiInset=true g.DisplayOrder=9999 g.Parent=CoreGui

    local ov=Instance.new("Frame") ov.Size=UDim2.new(1,0,1,0) ov.BackgroundColor3=Color3.fromRGB(2,2,8)
    ov.BackgroundTransparency=1 ov.BorderSizePixel=0 ov.Parent=g tw(ov,{BackgroundTransparency=0.25},0.5)

    task.spawn(function() for i=1,25 do
        local d=Instance.new("Frame") local sz=math.random(2,5)
        d.Size=UDim2.fromOffset(sz,sz) d.Position=UDim2.new(math.random()*0.95,0,math.random()*0.95,0)
        d.BackgroundColor3=T.Par d.BackgroundTransparency=math.random(65,90)/100 d.BorderSizePixel=0 d.ZIndex=2
        d.Parent=ov cor(d,99)
        task.spawn(function() while d and d.Parent do
            tw(d,{Position=UDim2.new(math.clamp(d.Position.X.Scale+(math.random()-0.5)*0.08,0,1),0,math.random()*0.95,0),
            BackgroundTransparency=math.random(55,90)/100},math.random(4,8),Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
            task.wait(math.random(4,8))
        end end)
    end end)

    local cw=Mobile and math.clamp(VP.X*0.88,280,400) or 380
    local ch=Mobile and 340 or 320

    local glow=Instance.new("ImageLabel") glow.Size=UDim2.fromOffset(cw+80,ch+80)
    glow.Position=UDim2.new(0.5,0,0.5,0) glow.AnchorPoint=Vector2.new(0.5,0.5)
    glow.BackgroundTransparency=1 glow.Image="rbxassetid://5028857084" glow.ImageColor3=T.Acc
    glow.ImageTransparency=0.88 glow.ScaleType=Enum.ScaleType.Slice glow.SliceCenter=Rect.new(24,24,276,276)
    glow.ZIndex=9 glow.Parent=ov

    task.spawn(function() while glow and glow.Parent do
        tw(glow,{ImageTransparency=0.8},2.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut) task.wait(2.2)
        tw(glow,{ImageTransparency=0.92},2.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut) task.wait(2.2)
    end end)

    local cd=Instance.new("Frame") cd.Size=UDim2.fromOffset(cw,ch) cd.Position=UDim2.new(0.5,0,0.5,0)
    cd.AnchorPoint=Vector2.new(0.5,0.5) cd.BackgroundColor3=T.KeyC cd.BackgroundTransparency=0.03
    cd.BorderSizePixel=0 cd.ZIndex=10 cd.Parent=ov cor(cd,14) stk(cd,T.Bor,1.2,0.2)

    local tl=Instance.new("Frame") tl.Size=UDim2.new(0.35,0,0,3) tl.Position=UDim2.new(0.325,0,0,0)
    tl.BackgroundColor3=T.Acc tl.BorderSizePixel=0 tl.ZIndex=12 tl.Parent=cd cor(tl,2)
    task.spawn(function() while tl and tl.Parent do
        tw(tl,{Size=UDim2.new(0.5,0,0,3),Position=UDim2.new(0.25,0,0,0)},1.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
        task.wait(1.8)
        tw(tl,{Size=UDim2.new(0.35,0,0,3),Position=UDim2.new(0.325,0,0,0)},1.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
        task.wait(1.8)
    end end)

    local ico=Instance.new("ImageLabel") ico.Size=UDim2.fromOffset(42,42)
    ico.Position=UDim2.new(0.5,0,0,18) ico.AnchorPoint=Vector2.new(0.5,0)
    ico.BackgroundTransparency=1 ico.Image=hubImageId ico.ZIndex=12 ico.Parent=cd cor(ico,8)

    local kt=Instance.new("TextLabel") kt.Size=UDim2.new(0.9,0,0,24)
    kt.Position=UDim2.new(0.5,0,0,66) kt.AnchorPoint=Vector2.new(0.5,0)
    kt.BackgroundTransparency=1 kt.Text="VERIFY" kt.TextColor3=T.Txt
    kt.TextSize=Mobile and 18 or 16 kt.Font=Enum.Font.GothamBold kt.ZIndex=12 kt.Parent=cd

    local ks=Instance.new("TextLabel") ks.Size=UDim2.new(0.85,0,0,16)
    ks.Position=UDim2.new(0.5,0,0,92) ks.AnchorPoint=Vector2.new(0.5,0)
    ks.BackgroundTransparency=1 ks.Text=cfg.Note or "Enter key" ks.TextColor3=T.Txt2
    ks.TextSize=Mobile and 12 or 11 ks.Font=Enum.Font.GothamMedium ks.ZIndex=12 ks.Parent=cd

    local ic=Instance.new("Frame") ic.Size=UDim2.new(0.8,0,0,Mobile and 44 or 40)
    ic.Position=UDim2.new(0.5,0,0,122) ic.AnchorPoint=Vector2.new(0.5,0)
    ic.BackgroundColor3=T.InBG ic.BorderSizePixel=0 ic.ZIndex=12 ic.Parent=cd cor(ic,8)
    local ist=stk(ic,T.InBor,1.2,0.3)

    local ib=Instance.new("TextBox") ib.Size=UDim2.new(1,-16,1,0) ib.Position=UDim2.new(0,8,0,0)
    ib.BackgroundTransparency=1 ib.Text="" ib.PlaceholderText="Key..." ib.PlaceholderColor3=T.Txt3
    ib.TextColor3=T.Txt ib.TextSize=Mobile and 13 or 12 ib.Font=Enum.Font.GothamMedium
    ib.TextXAlignment=Enum.TextXAlignment.Left ib.ClearTextOnFocus=false ib.ZIndex=13 ib.Parent=ic

    ib.Focused:Connect(function() tw(ist,{Color=T.Acc,Transparency=0},0.2) end)
    ib.FocusLost:Connect(function() tw(ist,{Color=T.InBor,Transparency=0.3},0.2) end)

    local st=Instance.new("TextLabel") st.Size=UDim2.new(0.8,0,0,14)
    st.Position=UDim2.new(0.5,0,0,Mobile and 172 or 168) st.AnchorPoint=Vector2.new(0.5,0)
    st.BackgroundTransparency=1 st.Text="" st.TextColor3=T.Err st.TextSize=10
    st.Font=Enum.Font.GothamMedium st.TextXAlignment=Enum.TextXAlignment.Left
    st.TextTransparency=1 st.ZIndex=12 st.Parent=cd

    local vb=Instance.new("TextButton") vb.Size=UDim2.new(0.8,0,0,Mobile and 44 or 40)
    vb.Position=UDim2.new(0.5,0,0,Mobile and 192 or 188) vb.AnchorPoint=Vector2.new(0.5,0)
    vb.BackgroundColor3=T.Acc vb.BorderSizePixel=0 vb.Text="VERIFY" vb.TextColor3=T.TxtW
    vb.TextSize=Mobile and 14 or 13 vb.Font=Enum.Font.GothamBold vb.AutoButtonColor=false
    vb.ZIndex=12 vb.Parent=cd cor(vb,8)

    vb.MouseEnter:Connect(function() tw(vb,{BackgroundColor3=T.AccH},0.15) end)
    vb.MouseLeave:Connect(function() tw(vb,{BackgroundColor3=T.Acc},0.15) end)

    local gb=Instance.new("TextButton") gb.Size=UDim2.new(0.8,0,0,Mobile and 36 or 32)
    gb.Position=UDim2.new(0.5,0,0,Mobile and 244 or 236) gb.AnchorPoint=Vector2.new(0.5,0)
    gb.BackgroundColor3=T.ElemBG gb.BackgroundTransparency=0.2 gb.BorderSizePixel=0
    gb.Text="🔗 Copy Link" gb.TextColor3=T.Txt2 gb.TextSize=Mobile and 12 or 11
    gb.Font=Enum.Font.GothamMedium gb.AutoButtonColor=false gb.ZIndex=12 gb.Parent=cd
    cor(gb,7) stk(gb,T.Bor,1,0.5)

    gb.MouseButton1Click:Connect(function()
        pcall(function() if isURL then setclipboard(cfg.Key) else setclipboard(vk) end end)
        gb.Text="✅ Copied!" gb.TextColor3=T.Suc task.wait(1.5) gb.Text="🔗 Copy Link" gb.TextColor3=T.Txt2
    end)

    cd.Size=UDim2.fromOffset(cw-20,ch-20) cd.BackgroundTransparency=1
    task.spawn(function() task.wait(0.1)
        tw(cd,{Size=UDim2.fromOffset(cw,ch),BackgroundTransparency=0.03},0.45,Enum.EasingStyle.Back)
    end)

    local busy=false
    local function verify()
        if busy then return end busy=true
        local e=ib.Text:gsub("%s+","")
        vb.Text="..." tw(vb,{BackgroundColor3=T.AccD},0.1) task.wait(0.5)
        if e=="" then
            st.Text="⚠ Enter key" st.TextColor3=T.Wrn tw(st,{TextTransparency=0},0.15)
            task.delay(2.5,function() tw(st,{TextTransparency=1},0.2) end)
            vb.Text="VERIFY" tw(vb,{BackgroundColor3=T.Acc},0.15) busy=false return
        end
        if vk=="" then
            st.Text="⚠ Server error" st.TextColor3=T.Err tw(st,{TextTransparency=0},0.15)
            task.delay(3,function() tw(st,{TextTransparency=1},0.2) end)
            vb.Text="VERIFY" tw(vb,{BackgroundColor3=T.Acc},0.15) busy=false return
        end
        if e==vk then
            st.Text="✅ OK!" st.TextColor3=T.Suc tw(st,{TextTransparency=0},0.15)
            vb.Text="✅" tw(vb,{BackgroundColor3=T.Suc},0.2)
            if cfg.SaveKey then wf(fn,e) end
            task.wait(0.6)
            for _,c in ipairs(cd:GetDescendants()) do pcall(function()
                if c:IsA("TextLabel")or c:IsA("TextButton")or c:IsA("TextBox") then tw(c,{TextTransparency=1},0.2)
                elseif c:IsA("Frame")or c:IsA("ImageLabel") then tw(c,{BackgroundTransparency=1,ImageTransparency=1},0.2) end
            end) end
            tw(cd,{BackgroundTransparency=1},0.3) tw(glow,{ImageTransparency=1},0.3) tw(ov,{BackgroundTransparency=1},0.4)
            task.wait(0.45) g:Destroy() onOk()
        else
            st.Text="❌ Wrong key" st.TextColor3=T.Err tw(st,{TextTransparency=0},0.15)
            tw(vb,{BackgroundColor3=T.Err},0.1) tw(ist,{Color=T.Err,Transparency=0},0.1)
            local op=cd.Position
            for i=1,6 do tw(cd,{Position=op+UDim2.fromOffset(i%2==0 and 7 or-7,0)},0.03,Enum.EasingStyle.Linear) task.wait(0.03) end
            tw(cd,{Position=op},0.03,Enum.EasingStyle.Linear)
            task.wait(0.4) tw(vb,{BackgroundColor3=T.Acc},0.2) tw(ist,{Color=T.InBor,Transparency=0.3},0.2)
            vb.Text="VERIFY" task.delay(2.5,function() tw(st,{TextTransparency=1},0.2) end) busy=false
        end
    end
    vb.MouseButton1Click:Connect(verify)
    ib.FocusLost:Connect(function(en) if en then verify() end end)
    drag(cd,cd)
end

function ZeroUI:Window(cfg)
    cfg=cfg or {} cfg.Name=cfg.Name or "ZeroUI" cfg.Icon=cfg.Icon or "⚡"
    cfg.ToggleKey=cfg.ToggleKey or Enum.KeyCode.RightShift

    local W={} local tabs={} local pages={} local aTab=nil local vis=true local built=false local fpsC=nil

    local function build()
        if built then return end built=true
        if CoreGui:FindFirstChild("ZeroUI_Main") then CoreGui:FindFirstChild("ZeroUI_Main"):Destroy() end

        local gui=Instance.new("ScreenGui") gui.Name="ZeroUI_Main" gui.ResetOnSpawn=false
        gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling gui.IgnoreGuiInset=true gui.DisplayOrder=100
        gui.Parent=CoreGui W._gui=gui

        task.spawn(function() for i=1,12 do
            local p=Instance.new("Frame") local sz=math.random(2,4)
            p.Size=UDim2.fromOffset(sz,sz) p.Position=UDim2.new(math.random()*0.95,0,math.random()*0.95,0)
            p.BackgroundColor3=T.Par p.BackgroundTransparency=0.9 p.BorderSizePixel=0 p.ZIndex=0 p.Parent=gui cor(p,99)
            task.spawn(function() while p and p.Parent do
                tw(p,{Position=UDim2.new(math.clamp(p.Position.X.Scale+(math.random()-0.5)*0.06,0,1),0,math.random()*0.95,0),
                BackgroundTransparency=math.random(85,96)/100},math.random(5,10),Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
                task.wait(math.random(5,10))
            end end)
        end end)

        fpsC=FPS:Create(gui)
        local mW,mH=S.WinW,S.WinH

        local miniBox=Instance.new("ImageButton")
        miniBox.Name="MiniBox"
        miniBox.Size=UDim2.fromOffset(S.BoxSize,S.BoxSize)
        miniBox.Position=UDim2.new(0,14,0.5,0)
        miniBox.AnchorPoint=Vector2.new(0,0.5)
        miniBox.BackgroundColor3=T.BoxBG
        miniBox.BackgroundTransparency=0.05
        miniBox.BorderSizePixel=0
        miniBox.Image=hubImageId
        miniBox.ScaleType=Enum.ScaleType.Crop
        miniBox.ZIndex=50
        miniBox.Visible=false
        miniBox.AutoButtonColor=false
        miniBox.Parent=gui
        cor(miniBox,12)
        stk(miniBox,T.BoxBor,1.5,0.2)

        task.spawn(function() while miniBox and miniBox.Parent do
            tw(miniBox,{ImageTransparency=0.1},1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut) task.wait(1.5)
            tw(miniBox,{ImageTransparency=0},1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut) task.wait(1.5)
        end end)

        drag(miniBox,miniBox)

        local mf=Instance.new("Frame") mf.Name="Main"
        mf.Size=UDim2.fromOffset(mW,mH) mf.Position=UDim2.new(0.5,0,0.5,0)
        mf.AnchorPoint=Vector2.new(0.5,0.5) mf.BackgroundColor3=T.WinBG
        mf.BackgroundTransparency=T.WinT mf.BorderSizePixel=0 mf.ClipsDescendants=true
        mf.ZIndex=5 mf.Parent=gui cor(mf,12) stk(mf,T.Bor,1,0.25) W._main=mf

        local tb=Instance.new("Frame") tb.Name="Top" tb.Size=UDim2.new(1,0,0,S.Top)
        tb.BackgroundColor3=T.TopBG tb.BackgroundTransparency=T.TopT tb.BorderSizePixel=0
        tb.ZIndex=8 tb.Parent=mf

        local tbb=Instance.new("Frame") tbb.Size=UDim2.new(1,0,0,1) tbb.Position=UDim2.new(0,0,1,0)
        tbb.AnchorPoint=Vector2.new(0,1) tbb.BackgroundColor3=T.Div tbb.BackgroundTransparency=T.DivT
        tbb.BorderSizePixel=0 tbb.ZIndex=9 tbb.Parent=tb

        local tbImg=Instance.new("ImageLabel") tbImg.Size=UDim2.fromOffset(S.Top-10,S.Top-10)
        tbImg.Position=UDim2.new(0,8,0.5,0) tbImg.AnchorPoint=Vector2.new(0,0.5)
        tbImg.BackgroundTransparency=1 tbImg.Image=hubImageId tbImg.ZIndex=10 tbImg.Parent=tb cor(tbImg,6)

        local ttl=Instance.new("TextLabel") ttl.Size=UDim2.new(0.55,0,1,0)
        ttl.Position=UDim2.fromOffset(S.Top+4,0) ttl.BackgroundTransparency=1 ttl.Text=cfg.Name
        ttl.TextColor3=T.Txt ttl.TextSize=S.F1 ttl.Font=Enum.Font.GothamBold
        ttl.TextXAlignment=Enum.TextXAlignment.Left ttl.TextTruncate=Enum.TextTruncate.AtEnd
        ttl.ZIndex=10 ttl.Parent=tb

        local bs=Mobile and 32 or 26

        local xb=Instance.new("TextButton") xb.Size=UDim2.fromOffset(bs,bs)
        xb.Position=UDim2.new(1,-(bs+6),0.5,0) xb.AnchorPoint=Vector2.new(0,0.5)
        xb.BackgroundColor3=T.Err xb.BackgroundTransparency=0.85 xb.Text="✕"
        xb.TextColor3=T.Txt2 xb.TextSize=Mobile and 15 or 13 xb.Font=Enum.Font.GothamBold
        xb.AutoButtonColor=false xb.BorderSizePixel=0 xb.ZIndex=10 xb.Parent=tb cor(xb,7)

        xb.MouseEnter:Connect(function() tw(xb,{BackgroundTransparency=0.25,TextColor3=T.Err},0.15) end)
        xb.MouseLeave:Connect(function() tw(xb,{BackgroundTransparency=0.85,TextColor3=T.Txt2},0.15) end)

        local mb=Instance.new("TextButton") mb.Size=UDim2.fromOffset(bs,bs)
        mb.Position=UDim2.new(1,-(bs*2+12),0.5,0) mb.AnchorPoint=Vector2.new(0,0.5)
        mb.BackgroundColor3=T.Wrn mb.BackgroundTransparency=0.85 mb.Text="—"
        mb.TextColor3=T.Txt2 mb.TextSize=Mobile and 15 or 13 mb.Font=Enum.Font.GothamBold
        mb.AutoButtonColor=false mb.BorderSizePixel=0 mb.ZIndex=10 mb.Parent=tb cor(mb,7)

        mb.MouseEnter:Connect(function() tw(mb,{BackgroundTransparency=0.25,TextColor3=T.Wrn},0.15) end)
        mb.MouseLeave:Connect(function() tw(mb,{BackgroundTransparency=0.85,TextColor3=T.Txt2},0.15) end)

        local minimized=false
        mb.MouseButton1Click:Connect(function()
            minimized=not minimized
            if minimized then tw(mf,{Size=UDim2.fromOffset(mW,S.Top)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In)
            else tw(mf,{Size=UDim2.fromOffset(mW,mH)},0.3,Enum.EasingStyle.Back) end
        end)

        drag(tb,mf)

        xb.MouseButton1Click:Connect(function()
            vis=false
            tw(mf,{Size=UDim2.fromOffset(S.BoxSize,S.BoxSize),BackgroundTransparency=1},0.35,Enum.EasingStyle.Back,Enum.EasingDirection.In)
            task.delay(0.35,function()
                mf.Visible=false
                miniBox.Visible=true
                miniBox.Size=UDim2.fromOffset(S.BoxSize-10,S.BoxSize-10)
                miniBox.BackgroundTransparency=0.5
                tw(miniBox,{Size=UDim2.fromOffset(S.BoxSize,S.BoxSize),BackgroundTransparency=0.05},0.3,Enum.EasingStyle.Back)
            end)
        end)

        miniBox.MouseButton1Click:Connect(function()
            vis=true
            tw(miniBox,{Size=UDim2.fromOffset(S.BoxSize-10,S.BoxSize-10),BackgroundTransparency=0.8},0.2,Enum.EasingStyle.Back,Enum.EasingDirection.In)
            task.delay(0.2,function()
                miniBox.Visible=false
                mf.Visible=true
                mf.Size=UDim2.fromOffset(S.BoxSize,S.BoxSize)
                mf.BackgroundTransparency=0.8
                tw(mf,{Size=UDim2.fromOffset(mW,mH),BackgroundTransparency=T.WinT},0.4,Enum.EasingStyle.Back)
                minimized=false
            end)
        end)

        local sb=Instance.new("Frame") sb.Name="Side" sb.Size=UDim2.new(0,S.Side,1,-S.Top)
        sb.Position=UDim2.new(0,0,0,S.Top) sb.BackgroundColor3=T.SideBG sb.BackgroundTransparency=T.SideT
        sb.BorderSizePixel=0 sb.ZIndex=7 sb.Parent=mf

        local sbb=Instance.new("Frame") sbb.Size=UDim2.new(0,1,1,0) sbb.Position=UDim2.new(1,0,0,0)
        sbb.BackgroundColor3=T.Div sbb.BackgroundTransparency=T.DivT sbb.BorderSizePixel=0
        sbb.ZIndex=8 sbb.Parent=sb

        local ss=Instance.new("ScrollingFrame") ss.Size=UDim2.new(1,-6,1,-6) ss.Position=UDim2.new(0,3,0,3)
        ss.BackgroundTransparency=1 ss.ScrollBarThickness=0 ss.BorderSizePixel=0 ss.ZIndex=8 ss.Parent=sb
        local sl=ll(ss,3) ac(ss,sl)

        local ca=Instance.new("Frame") ca.Name="Content" ca.Size=UDim2.new(1,-S.Side,1,-S.Top)
        ca.Position=UDim2.new(0,S.Side,0,S.Top) ca.BackgroundTransparency=1 ca.BorderSizePixel=0
        ca.ZIndex=6 ca.ClipsDescendants=true ca.Parent=mf

        mf.Size=UDim2.fromOffset(mW*0.92,mH*0.92) mf.BackgroundTransparency=0.5
        task.spawn(function() task.wait(0.1)
            tw(mf,{Size=UDim2.fromOffset(mW,mH),BackgroundTransparency=T.WinT},0.45,Enum.EasingStyle.Back)
        end)

        UIS.InputBegan:Connect(function(i,g) if g then return end
            if i.KeyCode==cfg.ToggleKey then W:Toggle() end
        end)

        local function swTab(td)
            if aTab==td then return end aTab=td
            for _,pg in pairs(pages) do pg.Visible=false end
            for _,t in ipairs(tabs) do
                tw(t.Btn,{BackgroundTransparency=1},0.15)
                tw(t.Lbl,{TextColor3=T.TabI},0.15)
                if t.Ico then tw(t.Ico,{TextColor3=T.TabI},0.15) end
                if t.Ind then tw(t.Ind,{BackgroundTransparency=1},0.15) end
            end
            if pages[td.Id] then pages[td.Id].Visible=true end
            tw(td.Btn,{BackgroundTransparency=0.78,BackgroundColor3=T.Acc},0.15)
            tw(td.Lbl,{TextColor3=T.TabA},0.15)
            if td.Ico then tw(td.Ico,{TextColor3=T.TabA},0.15) end
            if td.Ind then tw(td.Ind,{BackgroundTransparency=0},0.15) end
        end

        function W:Tab(tc)
            tc=tc or {} tc.Name=tc.Name or "Tab" tc.Icon=tc.Icon or "📁"
            local tid=#tabs+1 local th=Mobile and 42 or 36

            local tbtn=Instance.new("TextButton") tbtn.Size=UDim2.new(1,0,0,th)
            tbtn.BackgroundColor3=T.Acc tbtn.BackgroundTransparency=1 tbtn.Text=""
            tbtn.AutoButtonColor=false tbtn.BorderSizePixel=0 tbtn.ZIndex=9
            tbtn.LayoutOrder=tid tbtn.Parent=ss cor(tbtn,7)

            local ind=Instance.new("Frame") ind.Size=UDim2.new(0,3,0.55,0) ind.Position=UDim2.new(0,0,0.225,0)
            ind.BackgroundColor3=T.Acc ind.BackgroundTransparency=1 ind.BorderSizePixel=0
            ind.ZIndex=10 ind.Parent=tbtn cor(ind,2)

            local tico=Instance.new("TextLabel") tico.Size=UDim2.fromOffset(th,th)
            tico.Position=UDim2.new(0,3,0,0) tico.BackgroundTransparency=1 tico.Text=tc.Icon
            tico.TextSize=Mobile and 18 or 15 tico.TextColor3=T.TabI tico.ZIndex=10 tico.Parent=tbtn

            local tlbl=Instance.new("TextLabel") tlbl.Size=UDim2.new(1,-(th+4),1,0)
            tlbl.Position=UDim2.fromOffset(th+3,0) tlbl.BackgroundTransparency=1 tlbl.Text=tc.Name
            tlbl.TextColor3=T.TabI tlbl.TextSize=S.F2 tlbl.Font=Enum.Font.GothamBold
            tlbl.TextXAlignment=Enum.TextXAlignment.Left tlbl.TextTruncate=Enum.TextTruncate.AtEnd
            tlbl.Visible=not Mobile tlbl.ZIndex=10 tlbl.Parent=tbtn

            tbtn.MouseEnter:Connect(function() if aTab and aTab.Id==tid then return end tw(tbtn,{BackgroundTransparency=0.88},0.12) end)
            tbtn.MouseLeave:Connect(function() if aTab and aTab.Id==tid then return end tw(tbtn,{BackgroundTransparency=1},0.12) end)

            local pg=Instance.new("ScrollingFrame") pg.Name="P_"..tc.Name
            pg.Size=UDim2.new(1,-14,1,-14) pg.Position=UDim2.new(0,7,0,7)
            pg.BackgroundTransparency=1 pg.ScrollBarThickness=2 pg.ScrollBarImageColor3=T.Acc
            pg.ScrollBarImageTransparency=0.4 pg.BorderSizePixel=0 pg.Visible=false pg.ZIndex=7 pg.Parent=ca
            local pgl=ll(pg,S.Pad+2) ac(pg,pgl)

            pages[tid]=pg
            local td={Id=tid,Btn=tbtn,Lbl=tlbl,Ico=tico,Ind=ind}
            table.insert(tabs,td)
            tbtn.MouseButton1Click:Connect(function() swTab(td) end)
            if tid==1 then task.defer(function() swTab(td) end) end

            local TA={} local eo=0
            local function no() eo=eo+1 return eo end

            local function me(h)
                local c=Instance.new("Frame") c.Size=UDim2.new(1,0,0,h or S.Elem)
                c.BackgroundColor3=T.ElemBG c.BackgroundTransparency=T.ElemT c.BorderSizePixel=0
                c.ZIndex=8 c.LayoutOrder=no() c.Parent=pg cor(c,7) stk(c,T.Bor,1,0.5)
                c.MouseEnter:Connect(function() tw(c,{BackgroundColor3=T.ElemHov,BackgroundTransparency=T.ElemHovT},0.15) end)
                c.MouseLeave:Connect(function() tw(c,{BackgroundColor3=T.ElemBG,BackgroundTransparency=T.ElemT},0.15) end)
                return c
            end

            function TA:Section(n)
                local s=Instance.new("Frame") s.Size=UDim2.new(1,0,0,24) s.BackgroundTransparency=1
                s.ZIndex=8 s.LayoutOrder=no() s.Parent=pg
                local l=Instance.new("TextLabel") l.Size=UDim2.new(1,-6,1,0) l.Position=UDim2.fromOffset(3,0)
                l.BackgroundTransparency=1 l.Text=(n or""):upper() l.TextColor3=T.Txt3 l.TextSize=S.F3
                l.Font=Enum.Font.GothamBold l.TextXAlignment=Enum.TextXAlignment.Left l.ZIndex=9 l.Parent=s
                local ln=Instance.new("Frame") ln.Size=UDim2.new(1,0,0,1) ln.Position=UDim2.new(0,0,1,-2)
                ln.BackgroundColor3=T.Div ln.BackgroundTransparency=T.DivT ln.BorderSizePixel=0 ln.ZIndex=9 ln.Parent=s
            end

            function TA:Button(c2)
                c2=c2 or {} local ct=me()
                local bt=Instance.new("TextButton") bt.Size=UDim2.new(1,0,1,0) bt.BackgroundTransparency=1
                bt.Text="" bt.ZIndex=9 bt.AutoButtonColor=false bt.ClipsDescendants=true bt.Parent=ct
                local lb=Instance.new("TextLabel") lb.Size=UDim2.new(1,-14,1,0) lb.Position=UDim2.fromOffset(10,0)
                lb.BackgroundTransparency=1 lb.Text=c2.Name or "Btn" lb.TextColor3=T.Txt lb.TextSize=S.F2
                lb.Font=Enum.Font.GothamBold lb.TextXAlignment=Enum.TextXAlignment.Left lb.ZIndex=10 lb.Parent=bt
                local ar=Instance.new("TextLabel") ar.Size=UDim2.fromOffset(16,16)
                ar.Position=UDim2.new(1,-22,0.5,0) ar.AnchorPoint=Vector2.new(0,0.5)
                ar.BackgroundTransparency=1 ar.Text="›" ar.TextColor3=T.Txt3 ar.TextSize=18
                ar.Font=Enum.Font.GothamBold ar.ZIndex=10 ar.Parent=bt
                bt.MouseButton1Click:Connect(function()
                    local m=UIS:GetMouseLocation()
                    rip(bt,m.X-ct.AbsolutePosition.X,m.Y-ct.AbsolutePosition.Y)
                    if c2.Callback then c2.Callback() end
                end)
                local A={} function A:SetName(n) lb.Text=n end function A:Destroy() ct:Destroy() end return A
            end

            function TA:Toggle(c2)
                c2=c2 or {} local tg=c2.Default or false local ct=me()
                local lb=Instance.new("TextLabel") lb.Size=UDim2.new(1,-(S.TW+20),1,0)
                lb.Position=UDim2.fromOffset(10,0) lb.BackgroundTransparency=1 lb.Text=c2.Name or "Toggle"
                lb.TextColor3=T.Txt lb.TextSize=S.F2 lb.Font=Enum.Font.GothamBold
                lb.TextXAlignment=Enum.TextXAlignment.Left lb.ZIndex=10 lb.Parent=ct
                local tr=Instance.new("Frame") tr.Size=UDim2.fromOffset(S.TW,S.TH)
                tr.Position=UDim2.new(1,-(S.TW+8),0.5,0) tr.AnchorPoint=Vector2.new(0,0.5)
                tr.BackgroundColor3=tg and T.Acc or T.TOff tr.BorderSizePixel=0 tr.ZIndex=10 tr.Parent=ct
                cor(tr,S.TH/2)
                local kn=Instance.new("Frame") kn.Size=UDim2.fromOffset(S.KS,S.KS)
                kn.Position=tg and UDim2.new(1,-(S.KS+3),0.5,0) or UDim2.new(0,3,0.5,0)
                kn.AnchorPoint=Vector2.new(0,0.5) kn.BackgroundColor3=T.TKnob kn.BorderSizePixel=0
                kn.ZIndex=11 kn.Parent=tr cor(kn,S.KS/2)
                local function up(v,f)
                    tg=v tw(tr,{BackgroundColor3=v and T.Acc or T.TOff},0.2)
                    tw(kn,{Position=v and UDim2.new(1,-(S.KS+3),0.5,0) or UDim2.new(0,3,0.5,0)},0.2,Enum.EasingStyle.Back)
                    if c2.Flag then ZeroUI.Flags[c2.Flag]=v end
                    if f~=false and c2.Callback then c2.Callback(v) end
                end
                local cb=Instance.new("TextButton") cb.Size=UDim2.new(1,0,1,0) cb.BackgroundTransparency=1
                cb.Text="" cb.ZIndex=12 cb.Parent=ct
                cb.MouseButton1Click:Connect(function() up(not tg) end)
                if c2.Flag then ZeroUI.Flags[c2.Flag]=tg end
                if tg and c2.Callback then c2.Callback(true) end
                local A={} function A:Set(v) up(v) end function A:Get() return tg end
                function A:Destroy() ct:Destroy() end return A
            end

            function TA:Slider(c2)
                c2=c2 or {} local mn=c2.Min or 0 local mx=c2.Max or 100
                local val=math.clamp(c2.Default or mn,mn,mx) local inc=c2.Increment or 1
                local sh=S.Elem+20 local ct=me(sh)
                local lb=Instance.new("TextLabel") lb.Size=UDim2.new(0.55,-10,0,S.Elem-4)
                lb.Position=UDim2.fromOffset(10,0) lb.BackgroundTransparency=1 lb.Text=c2.Name or "Slider"
                lb.TextColor3=T.Txt lb.TextSize=S.F2 lb.Font=Enum.Font.GothamBold
                lb.TextXAlignment=Enum.TextXAlignment.Left lb.ZIndex=10 lb.Parent=ct
                local vl=Instance.new("TextLabel") vl.Size=UDim2.new(0.4,-10,0,S.Elem-4)
                vl.Position=UDim2.new(0.55,0,0,0) vl.BackgroundTransparency=1
                vl.Text=tostring(val)..(c2.Suffix or "") vl.TextColor3=T.Acc vl.TextSize=S.F2
                vl.Font=Enum.Font.GothamBold vl.TextXAlignment=Enum.TextXAlignment.Right vl.ZIndex=10 vl.Parent=ct
                local tf=Instance.new("Frame") tf.Size=UDim2.new(1,-20,0,Mobile and 8 or 6)
                tf.Position=UDim2.new(0.5,0,1,-(Mobile and 14 or 12)) tf.AnchorPoint=Vector2.new(0.5,0)
                tf.BackgroundColor3=T.STrk tf.BorderSizePixel=0 tf.ZIndex=10 tf.Parent=ct cor(tf,4)
                local pc=(val-mn)/math.max(mx-mn,1)
                local fl=Instance.new("Frame") fl.Size=UDim2.new(pc,0,1,0) fl.BackgroundColor3=T.Acc
                fl.BorderSizePixel=0 fl.ZIndex=11 fl.Parent=tf cor(fl,4)
                local ks2=Mobile and 18 or 14
                local sk=Instance.new("Frame") sk.Size=UDim2.fromOffset(ks2,ks2) sk.Position=UDim2.new(pc,0,0.5,0)
                sk.AnchorPoint=Vector2.new(0.5,0.5) sk.BackgroundColor3=T.TKnob sk.BorderSizePixel=0
                sk.ZIndex=12 sk.Parent=tf cor(sk,ks2/2) stk(sk,T.Acc,2,0.2)
                local function sv(v,f)
                    v=math.clamp(v,mn,mx) v=math.floor(v/inc+0.5)*inc val=v
                    local p2=(v-mn)/math.max(mx-mn,1)
                    tw(fl,{Size=UDim2.new(p2,0,1,0)},0.06,Enum.EasingStyle.Linear)
                    tw(sk,{Position=UDim2.new(p2,0,0.5,0)},0.06,Enum.EasingStyle.Linear)
                    vl.Text=tostring(v)..(c2.Suffix or "")
                    if c2.Flag then ZeroUI.Flags[c2.Flag]=v end
                    if f~=false and c2.Callback then c2.Callback(v) end
                end
                local sld=false
                local ib2=Instance.new("TextButton") ib2.Size=UDim2.new(1,0,1,10) ib2.Position=UDim2.new(0,0,0,-5)
                ib2.BackgroundTransparency=1 ib2.Text="" ib2.ZIndex=13 ib2.Parent=tf
                local function hi(i) local p2=math.clamp((i.Position.X-tf.AbsolutePosition.X)/tf.AbsoluteSize.X,0,1)
                    sv(mn+(mx-mn)*p2) end
                ib2.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                        sld=true hi(i) end end)
                ib2.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                        sld=false end end)
                UIS.InputChanged:Connect(function(i)
                    if sld and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then
                        hi(i) end end)
                if c2.Flag then ZeroUI.Flags[c2.Flag]=val end
                local A={} function A:Set(v) sv(v) end function A:Get() return val end
                function A:Destroy() ct:Destroy() end return A
            end

            function TA:Dropdown(c2)
                c2=c2 or {} local opts=c2.Options or {} local sel=c2.Default or (opts[1] or "")
                local op=false local obs={}
                local hh=S.Elem local oh=Mobile and 36 or 30 local mv=math.min(#opts,5) local dh=oh*mv+4
                local ct=Instance.new("Frame") ct.Size=UDim2.new(1,0,0,hh) ct.BackgroundColor3=T.ElemBG
                ct.BackgroundTransparency=T.ElemT ct.BorderSizePixel=0 ct.ZIndex=8 ct.ClipsDescendants=true
                ct.LayoutOrder=no() ct.Parent=pg cor(ct,7) stk(ct,T.Bor,1,0.5)
                local hb=Instance.new("TextButton") hb.Size=UDim2.new(1,0,0,hh) hb.BackgroundTransparency=1
                hb.Text="" hb.ZIndex=9 hb.Parent=ct
                local dl=Instance.new("TextLabel") dl.Size=UDim2.new(0.48,-10,1,0) dl.Position=UDim2.fromOffset(10,0)
                dl.BackgroundTransparency=1 dl.Text=c2.Name or "Drop" dl.TextColor3=T.Txt dl.TextSize=S.F2
                dl.Font=Enum.Font.GothamBold dl.TextXAlignment=Enum.TextXAlignment.Left dl.ZIndex=10 dl.Parent=hb
                local dv=Instance.new("TextLabel") dv.Size=UDim2.new(0.42,-10,1,0) dv.Position=UDim2.new(0.48,0,0,0)
                dv.BackgroundTransparency=1 dv.Text=tostring(sel) dv.TextColor3=T.Acc dv.TextSize=S.F2
                dv.Font=Enum.Font.GothamMedium dv.TextXAlignment=Enum.TextXAlignment.Right
                dv.TextTruncate=Enum.TextTruncate.AtEnd dv.ZIndex=10 dv.Parent=hb
                local da=Instance.new("TextLabel") da.Size=UDim2.fromOffset(16,16)
                da.Position=UDim2.new(1,-18,0.5,0) da.AnchorPoint=Vector2.new(0,0.5)
                da.BackgroundTransparency=1 da.Text="▾" da.TextColor3=T.Txt3 da.TextSize=14
                da.Font=Enum.Font.GothamBold da.ZIndex=10 da.Parent=hb
                local os2=Instance.new("ScrollingFrame") os2.Size=UDim2.new(1,-10,1,-(hh+4))
                os2.Position=UDim2.new(0,5,0,hh+2) os2.BackgroundTransparency=1 os2.ScrollBarThickness=2
                os2.BorderSizePixel=0 os2.ZIndex=10 os2.Visible=false os2.Parent=ct
                local ol=ll(os2,2) ac(os2,ol)
                local function bo()
                    for _,b in ipairs(obs) do b:Destroy() end obs={}
                    for i,o in ipairs(opts) do
                        local ob=Instance.new("TextButton") ob.Size=UDim2.new(1,0,0,oh)
                        ob.BackgroundColor3=T.ElemBG ob.BackgroundTransparency=0.35 ob.Text=tostring(o)
                        ob.TextColor3=o==sel and T.Acc or T.Txt ob.TextSize=S.F2
                        ob.Font=o==sel and Enum.Font.GothamBold or Enum.Font.GothamMedium
                        ob.AutoButtonColor=false ob.BorderSizePixel=0 ob.ZIndex=11 ob.LayoutOrder=i
                        ob.Parent=os2 cor(ob,5)
                        ob.MouseEnter:Connect(function() tw(ob,{BackgroundTransparency=0.12},0.1) end)
                        ob.MouseLeave:Connect(function() tw(ob,{BackgroundTransparency=0.35},0.1) end)
                        ob.MouseButton1Click:Connect(function()
                            sel=o dv.Text=tostring(o)
                            if c2.Flag then ZeroUI.Flags[c2.Flag]=o end
                            if c2.Callback then c2.Callback(o) end
                            for _,x in ipairs(obs) do x.TextColor3=T.Txt x.Font=Enum.Font.GothamMedium end
                            ob.TextColor3=T.Acc ob.Font=Enum.Font.GothamBold
                            op=false tw(ct,{Size=UDim2.new(1,0,0,hh)},0.2,Enum.EasingStyle.Back,Enum.EasingDirection.In)
                            tw(da,{Rotation=0},0.15) task.delay(0.2,function() os2.Visible=false end)
                        end)
                        table.insert(obs,ob)
                    end
                end bo()
                hb.MouseButton1Click:Connect(function()
                    op=not op
                    if op then os2.Visible=true
                        tw(ct,{Size=UDim2.new(1,0,0,hh+dh+5)},0.25,Enum.EasingStyle.Back) tw(da,{Rotation=180},0.15)
                    else tw(ct,{Size=UDim2.new(1,0,0,hh)},0.2,Enum.EasingStyle.Back,Enum.EasingDirection.In)
                        tw(da,{Rotation=0},0.15) task.delay(0.2,function() os2.Visible=false end) end
                end)
                if c2.Flag then ZeroUI.Flags[c2.Flag]=sel end
                local A={} function A:Set(v) sel=v dv.Text=tostring(v) if c2.Flag then ZeroUI.Flags[c2.Flag]=v end
                    if c2.Callback then c2.Callback(v) end bo() end
                function A:Get() return sel end function A:Refresh(n) opts=n bo() end
                function A:Destroy() ct:Destroy() end return A
            end

            function TA:Input(c2)
                c2=c2 or {} local ct=me(S.Elem+8)
                local il=Instance.new("TextLabel") il.Size=UDim2.new(0.35,-10,1,0) il.Position=UDim2.fromOffset(10,0)
                il.BackgroundTransparency=1 il.Text=c2.Name or "Input" il.TextColor3=T.Txt il.TextSize=S.F2
                il.Font=Enum.Font.GothamBold il.TextXAlignment=Enum.TextXAlignment.Left il.ZIndex=10 il.Parent=ct
                local ifr=Instance.new("Frame") ifr.Size=UDim2.new(0.6,-10,0,Mobile and 32 or 26)
                ifr.Position=UDim2.new(1,-6,0.5,0) ifr.AnchorPoint=Vector2.new(1,0.5)
                ifr.BackgroundColor3=T.InBG ifr.BorderSizePixel=0 ifr.ZIndex=10 ifr.Parent=ct
                cor(ifr,5) local is2=stk(ifr,T.InBor,1,0.4)
                local ib3=Instance.new("TextBox") ib3.Size=UDim2.new(1,-10,1,0) ib3.Position=UDim2.fromOffset(5,0)
                ib3.BackgroundTransparency=1 ib3.Text=c2.Default or "" ib3.PlaceholderText=c2.Placeholder or "..."
                ib3.PlaceholderColor3=T.Txt3 ib3.TextColor3=T.Txt ib3.TextSize=S.F2
                ib3.Font=Enum.Font.GothamMedium ib3.TextXAlignment=Enum.TextXAlignment.Left
                ib3.ClearTextOnFocus=c2.ClearOnFocus or false ib3.ZIndex=11 ib3.Parent=ifr
                ib3.Focused:Connect(function() tw(is2,{Color=T.Acc,Transparency=0},0.15) end)
                ib3.FocusLost:Connect(function()
                    tw(is2,{Color=T.InBor,Transparency=0.4},0.15)
                    if c2.Flag then ZeroUI.Flags[c2.Flag]=ib3.Text end
                    if c2.Callback then c2.Callback(ib3.Text) end
                end)
                local A={} function A:Set(v) ib3.Text=v end function A:Get() return ib3.Text end
                function A:Destroy() ct:Destroy() end return A
            end

            function TA:Keybind(c2)
                c2=c2 or {} local ck=c2.Default or Enum.KeyCode.E local li=false local ct=me()
                local kl=Instance.new("TextLabel") kl.Size=UDim2.new(0.6,-10,1,0) kl.Position=UDim2.fromOffset(10,0)
                kl.BackgroundTransparency=1 kl.Text=c2.Name or "Key" kl.TextColor3=T.Txt kl.TextSize=S.F2
                kl.Font=Enum.Font.GothamBold kl.TextXAlignment=Enum.TextXAlignment.Left kl.ZIndex=10 kl.Parent=ct
                local kbw=Mobile and 62 or 52
                local kb=Instance.new("TextButton") kb.Size=UDim2.fromOffset(kbw,Mobile and 28 or 24)
                kb.Position=UDim2.new(1,-(kbw+8),0.5,0) kb.AnchorPoint=Vector2.new(0,0.5)
                kb.BackgroundColor3=T.InBG kb.Text=ck.Name kb.TextColor3=T.Acc kb.TextSize=S.F3
                kb.Font=Enum.Font.GothamBold kb.AutoButtonColor=false kb.BorderSizePixel=0
                kb.ZIndex=10 kb.Parent=ct cor(kb,5) stk(kb,T.InBor,1,0.4)
                kb.MouseButton1Click:Connect(function()
                    li=true kb.Text="..." tw(kb,{BackgroundColor3=T.Acc,TextColor3=T.TxtW},0.15) end)
                UIS.InputBegan:Connect(function(i,g)
                    if li and i.UserInputType==Enum.UserInputType.Keyboard then
                        ck=i.KeyCode kb.Text=ck.Name li=false
                        tw(kb,{BackgroundColor3=T.InBG,TextColor3=T.Acc},0.15)
                        if c2.Flag then ZeroUI.Flags[c2.Flag]=ck end return end
                    if not li and not g and i.KeyCode==ck then if c2.Callback then c2.Callback() end end
                end)
                if c2.Flag then ZeroUI.Flags[c2.Flag]=ck end
                local A={} function A:Set(k) ck=k kb.Text=k.Name end function A:Get() return ck end
                function A:Destroy() ct:Destroy() end return A
            end

            function TA:Paragraph(c2)
                c2=c2 or {} local cn=c2.Content or "" local ls=#cn/30+1
                local ph=math.max(S.Elem+8,26+ls*14) local ct=me(ph)
                local pt=Instance.new("TextLabel") pt.Size=UDim2.new(1,-16,0,20) pt.Position=UDim2.fromOffset(8,3)
                pt.BackgroundTransparency=1 pt.Text=c2.Title or "Info" pt.TextColor3=T.Txt pt.TextSize=S.F2
                pt.Font=Enum.Font.GothamBold pt.TextXAlignment=Enum.TextXAlignment.Left pt.ZIndex=10 pt.Parent=ct
                local pc2=Instance.new("TextLabel") pc2.Size=UDim2.new(1,-16,1,-24) pc2.Position=UDim2.fromOffset(8,23)
                pc2.BackgroundTransparency=1 pc2.Text=cn pc2.TextColor3=T.Txt2 pc2.TextSize=S.F3
                pc2.Font=Enum.Font.GothamMedium pc2.TextXAlignment=Enum.TextXAlignment.Left
                pc2.TextYAlignment=Enum.TextYAlignment.Top pc2.TextWrapped=true pc2.ZIndex=10 pc2.Parent=ct
                local A={} function A:Set(t,b) if t then pt.Text=t end if b then pc2.Text=b end end
                function A:Destroy() ct:Destroy() end return A
            end

            function TA:Label(c2)
                c2=c2 or {} local ct=Instance.new("Frame") ct.Size=UDim2.new(1,0,0,20)
                ct.BackgroundTransparency=1 ct.ZIndex=8 ct.LayoutOrder=no() ct.Parent=pg
                local l2=Instance.new("TextLabel") l2.Size=UDim2.new(1,-12,1,0) l2.Position=UDim2.fromOffset(6,0)
                l2.BackgroundTransparency=1 l2.Text=c2.Text or "" l2.TextColor3=T.Txt2 l2.TextSize=S.F2
                l2.Font=Enum.Font.GothamMedium l2.TextXAlignment=Enum.TextXAlignment.Left l2.ZIndex=9 l2.Parent=ct
                local A={} function A:Set(t) l2.Text=t end function A:Destroy() ct:Destroy() end return A
            end

            return TA
        end

        function W:Notify(nc)
            nc=nc or {} local ti=nc.Title or "Notice" local cn=nc.Content or ""
            local du=nc.Duration or 4 local ty=nc.Type or "info"
            local ac2=({success=T.Suc,error=T.Err,warning=T.Wrn,info=T.Inf})[ty:lower()] or T.Inf
            local nw=Mobile and math.clamp(VP.X*0.82,240,340) or 300
            local nh=Mobile and 72 or 64
            local nf=Instance.new("Frame") nf.Size=UDim2.fromOffset(nw,nh)
            nf.Position=UDim2.new(1,nw+16,1,-16) nf.AnchorPoint=Vector2.new(1,1)
            nf.BackgroundColor3=T.NBG nf.BackgroundTransparency=T.NT nf.BorderSizePixel=0
            nf.ZIndex=50 nf.Parent=gui cor(nf,10) stk(nf,ac2,1.2,0.25)
            local nb=Instance.new("Frame") nb.Size=UDim2.new(0,3,0.65,0) nb.Position=UDim2.new(0,7,0.175,0)
            nb.BackgroundColor3=ac2 nb.BorderSizePixel=0 nb.ZIndex=51 nb.Parent=nf cor(nb,2)
            local nt=Instance.new("TextLabel") nt.Size=UDim2.new(1,-24,0,20) nt.Position=UDim2.fromOffset(16,6)
            nt.BackgroundTransparency=1 nt.Text=ti nt.TextColor3=T.Txt nt.TextSize=S.F2
            nt.Font=Enum.Font.GothamBold nt.TextXAlignment=Enum.TextXAlignment.Left
            nt.TextTruncate=Enum.TextTruncate.AtEnd nt.ZIndex=51 nt.Parent=nf
            local nc2=Instance.new("TextLabel") nc2.Size=UDim2.new(1,-24,1,-28) nc2.Position=UDim2.fromOffset(16,26)
            nc2.BackgroundTransparency=1 nc2.Text=cn nc2.TextColor3=T.Txt2 nc2.TextSize=S.F3
            nc2.Font=Enum.Font.GothamMedium nc2.TextXAlignment=Enum.TextXAlignment.Left
            nc2.TextYAlignment=Enum.TextYAlignment.Top nc2.TextWrapped=true nc2.ZIndex=51 nc2.Parent=nf
            local np=Instance.new("Frame") np.Size=UDim2.new(1,0,0,2) np.Position=UDim2.new(0,0,1,-2)
            np.BackgroundColor3=ac2 np.BackgroundTransparency=0.3 np.BorderSizePixel=0 np.ZIndex=51 np.Parent=nf
            tw(nf,{Position=UDim2.new(1,-10,1,-16)},0.35,Enum.EasingStyle.Back)
            tw(np,{Size=UDim2.new(0,0,0,2)},du,Enum.EasingStyle.Linear)
            task.delay(du,function()
                tw(nf,{Position=UDim2.new(1,nw+16,1,-16),BackgroundTransparency=1},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In)
                task.wait(0.35) if nf then nf:Destroy() end
            end)
        end

        function W:ToggleFPS() if fpsC then return fpsC:Toggle() end end
        function W:ShowFPS() if fpsC then fpsC:Show() end end
        function W:HideFPS() if fpsC then fpsC:Hide() end end
        function W:GetFPS() return fpsC and fpsC:GetFPS() or 0 end

        function W:Toggle()
            vis=not vis
            if vis then
                miniBox.Visible=false mf.Visible=true mf.Size=UDim2.fromOffset(S.BoxSize,S.BoxSize)
                mf.BackgroundTransparency=0.5
                tw(mf,{Size=UDim2.fromOffset(mW,mH),BackgroundTransparency=T.WinT},0.4,Enum.EasingStyle.Back)
            else
                tw(mf,{Size=UDim2.fromOffset(S.BoxSize,S.BoxSize),BackgroundTransparency=1},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In)
                task.delay(0.3,function() if not vis then mf.Visible=false miniBox.Visible=true
                    miniBox.Size=UDim2.fromOffset(S.BoxSize-8,S.BoxSize-8)
                    tw(miniBox,{Size=UDim2.fromOffset(S.BoxSize,S.BoxSize)},0.25,Enum.EasingStyle.Back) end end)
            end
        end

        function W:Destroy() pcall(function() gui:Destroy() end) end

        W:Notify({Title=cfg.Name,Content="Loaded!",Duration=4,Type="success"})
    end

    if cfg.KeySystem and cfg.KeySystem.Key then showKey(cfg.KeySystem,function() build() end)
    else build() end
    return W
end

function ZeroUI:GetFlag(f) return self.Flags[f] end
function ZeroUI:SetFlag(f,v) self.Flags[f]=v end

return ZeroUI
