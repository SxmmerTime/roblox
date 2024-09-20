if _G.GUI then _G.GUI:Destroy() end 
local Username = ({...})[1] or ""
local CoreGui = (gethui and gethui()) or (cloneref and cloneref(game:GetService("CoreGui"))) or game:GetService("CoreGui")
local Players = game:GetService("Players")

local clipboard = setclipboard or toclipboard or syn.write_clipboard
local floor = math.floor
local LocalPlayer = Players.LocalPlayer
local TargetPlayer = Players:FindFirstChild(Username) -- Leave Blank or Invalid to be your player
if not TargetPlayer then TargetPlayer = LocalPlayer end
local Character = TargetPlayer.Character
local Humanoid = Character:WaitForChild("Humanoid")
local AnimationExclusions = {}
local RawCodeValue = ""
local CurrentSelectedAnimation = nil
local OldCharAddedEvent = nil
local OldPlayAnimationEvent = nil
local CurrentRunningAnimation = nil
local ObjectCache = {}
local VarCache = {}
local AnimationCache = {}

assert(clipboard, "Executor must have clipboard function to work")

-- GuiElements
local MainScreenGui = Instance.new("ScreenGui")
_G.GUI = MainScreenGui
local Main = Instance.new("Frame")
local AnimationScroller = Instance.new("ScrollingFrame")
local CodeLabel = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")
local ButtonFrame = Instance.new("Frame")
local UIListLayout_2 = Instance.new("UIListLayout")
local CopyCode = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local ClearLogs = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local Exclude = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local Unexclude = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local PlayAnimation = Instance.new("TextButton")
local StopAnimation = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")
local ClearExclusions = Instance.new("TextButton")
local UICorner_6 = Instance.new("UICorner")
local CloseButton = Instance.new("TextButton")
Main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0, 311, 0, 145)
Main.Size = UDim2.new(0, 490, 0, 282)

AnimationScroller.Parent = Main
AnimationScroller.Active = true
AnimationScroller.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
AnimationScroller.BorderColor3 = Color3.fromRGB(0, 0, 0)
AnimationScroller.BorderSizePixel = 0
AnimationScroller.Position = UDim2.new(0, 8, 0, 5)
AnimationScroller.Size = UDim2.new(0, 128, 0, 268)
AnimationScroller.CanvasSize = UDim2.new(0, 0, 0, 0)

UIListLayout.Parent = AnimationScroller
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 3)

CodeLabel.Parent = Main
CodeLabel.BackgroundColor3 = Color3.fromRGB(75, 79, 88)
CodeLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
CodeLabel.BorderSizePixel = 0
CodeLabel.Position = UDim2.new(0, 146, 0, 5)
CodeLabel.Size = UDim2.new(0, 334, 0, 149)
CodeLabel.Font = Enum.Font.Roboto
CodeLabel.TextScaled = true
CodeLabel.Text = "lol hello"
CodeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CodeLabel.TextSize = 18.000
CodeLabel.TextWrapped = true
CodeLabel.TextXAlignment = Enum.TextXAlignment.Left
CodeLabel.RichText = true
CodeLabel.TextYAlignment = Enum.TextYAlignment.Top

ButtonFrame.Parent = Main
ButtonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ButtonFrame.BackgroundTransparency = 1.000
ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ButtonFrame.BorderSizePixel = 0
ButtonFrame.Position = UDim2.new(0, 146, 0, 164)
ButtonFrame.Size = UDim2.new(0, 334, 0, 109)

UIListLayout_2.Parent = ButtonFrame
UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_2.Padding = UDim.new(0, 11)
UIListLayout_2.Wraps = true

CopyCode.Parent = ButtonFrame
CopyCode.BackgroundColor3 = Color3.fromRGB(131, 131, 131)
CopyCode.BorderColor3 = Color3.fromRGB(0, 0, 0)
CopyCode.BorderSizePixel = 0
CopyCode.Position = UDim2.new(0, 135, 0, 65)
CopyCode.Size = UDim2.new(0, 65, 0, 18)
CopyCode.Font = Enum.Font.SourceSansBold
CopyCode.Text = "Copy Code"
CopyCode.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyCode.TextScaled = true
CopyCode.TextSize = 14.000
CopyCode.TextWrapped = true

UICorner.CornerRadius = UDim.new(0, 2)
UICorner.Parent = CopyCode

ClearLogs.Parent = ButtonFrame
ClearLogs.BackgroundColor3 = Color3.fromRGB(131, 131, 131)
ClearLogs.BorderColor3 = Color3.fromRGB(0, 0, 0)
ClearLogs.BorderSizePixel = 0
ClearLogs.Position = UDim2.new(0, 135, 0, 65)
ClearLogs.Size = UDim2.new(0, 65, 0, 18)
ClearLogs.Font = Enum.Font.SourceSansBold
ClearLogs.Text = "Clear Logs"
ClearLogs.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearLogs.TextScaled = true
ClearLogs.TextSize = 14.000
ClearLogs.TextWrapped = true

UICorner_2.CornerRadius = UDim.new(0, 2)
UICorner_2.Parent = ClearLogs

Exclude.Parent = ButtonFrame
Exclude.BackgroundColor3 = Color3.fromRGB(131, 131, 131)
Exclude.BorderColor3 = Color3.fromRGB(0, 0, 0)
Exclude.BorderSizePixel = 0
Exclude.Position = UDim2.new(0, 135, 0, 65)
Exclude.Size = UDim2.new(0, 65, 0, 18)
Exclude.Font = Enum.Font.SourceSansBold
Exclude.Text = "Exclude"
Exclude.TextColor3 = Color3.fromRGB(255, 255, 255)
Exclude.TextScaled = true
Exclude.TextSize = 14.000
Exclude.TextWrapped = true

UICorner_3.CornerRadius = UDim.new(0, 2)
UICorner_3.Parent = Exclude

Unexclude.Parent = ButtonFrame
Unexclude.BackgroundColor3 = Color3.fromRGB(131, 131, 131)
Unexclude.BorderColor3 = Color3.fromRGB(0, 0, 0)
Unexclude.BorderSizePixel = 0
Unexclude.Position = UDim2.new(0, 135, 0, 65)
Unexclude.Size = UDim2.new(0, 65, 0, 18)
Unexclude.Font = Enum.Font.SourceSansBold
Unexclude.Text = "Unexclude"
Unexclude.TextColor3 = Color3.fromRGB(255, 255, 255)
Unexclude.TextScaled = true
Unexclude.TextSize = 14.000
Unexclude.TextWrapped = true

UICorner_4.CornerRadius = UDim.new(0, 2)
UICorner_4.Parent = Unexclude

PlayAnimation.Parent = ButtonFrame
PlayAnimation.BackgroundColor3 = Color3.fromRGB(131, 131, 131)
PlayAnimation.BorderColor3 = Color3.fromRGB(0, 0, 0)
PlayAnimation.BorderSizePixel = 0
PlayAnimation.Position = UDim2.new(0, 135, 0, 65)
PlayAnimation.Size = UDim2.new(0, 65, 0, 18)
PlayAnimation.Font = Enum.Font.SourceSansBold
PlayAnimation.Text = "Play"
PlayAnimation.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayAnimation.TextScaled = true
PlayAnimation.TextSize = 14.000
PlayAnimation.TextWrapped = true

StopAnimation.Parent = ButtonFrame
StopAnimation.BackgroundColor3 = Color3.fromRGB(131, 131, 131)
StopAnimation.BorderColor3 = Color3.fromRGB(0, 0, 0)
StopAnimation.BorderSizePixel = 0
StopAnimation.Position = UDim2.new(0, 135, 0, 65)
StopAnimation.Size = UDim2.new(0, 65, 0, 18)
StopAnimation.Font = Enum.Font.SourceSansBold
StopAnimation.Text = "Stop"
StopAnimation.TextColor3 = Color3.fromRGB(255, 255, 255)
StopAnimation.TextScaled = true
StopAnimation.TextSize = 14.000
StopAnimation.TextWrapped = true

UICorner_5.CornerRadius = UDim.new(0, 2)
UICorner_5.Parent = PlayAnimation

UICorner_5.CornerRadius = UDim.new(0, 2)
UICorner_5.Parent = StopAnimation

ClearExclusions.Parent = ButtonFrame
ClearExclusions.BackgroundColor3 = Color3.fromRGB(131, 131, 131)
ClearExclusions.BorderColor3 = Color3.fromRGB(0, 0, 0)
ClearExclusions.BorderSizePixel = 0
ClearExclusions.Position = UDim2.new(0, 135, 0, 65)
ClearExclusions.Size = UDim2.new(0, 65, 0, 18)
ClearExclusions.Font = Enum.Font.SourceSansBold
ClearExclusions.Text = "Clear Exclusions"
ClearExclusions.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearExclusions.TextScaled = true
ClearExclusions.TextSize = 14.000
ClearExclusions.TextWrapped = true

UICorner_6.CornerRadius = UDim.new(0, 2)
UICorner_6.Parent = ClearExclusions

CloseButton.Parent = Main
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.RichText = true
CloseButton.Position = UDim2.new(0, 468, 0, -18)
CloseButton.Size = UDim2.new(0, 22, 0, 19)
CloseButton.Font = Enum.Font.Unknown
CloseButton.Text = "<b>X</b>"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14.000

Main.Parent = MainScreenGui
MainScreenGui.Parent = CoreGui
local Placeholder = Instance.new("TextButton")
Placeholder.BackgroundColor3 = Color3.fromRGB(88, 88, 88)
Placeholder.Size = UDim2.new(0.9, 0, 0, 15)
Placeholder.Font = Enum.Font.Jura
Placeholder.TextScaled = true
Placeholder.TextColor3 = Color3.fromRGB(255, 255, 255)

local createAnimationLog = function(txt)
    local NewPlaceholder = Placeholder:Clone()
    NewPlaceholder.Text = txt
    NewPlaceholder.Parent = AnimationScroller
    return NewPlaceholder
end

local objects = function(id)
    id = id:sub(1, 4) ~= 'http' and 'rbxassetid://' .. tostring(id):match("%d+") or id

    if ObjectCache[id] then
        return ObjectCache[id]
    end

    local _objects = game:GetObjects(id)
    ObjectCache[id] = _objects
    return _objects
end

local eslintVariable = function(varName: string, varValue: string,t: boolean)
    if VarCache[varName .. varValue] then
        return VarCache[varName .. varValue]
    end
    local var = (not t and `<font color="rgb({floor(0.6 * 255)}, {floor(0.2 * 255)}, {floor(0.2 * 255)})">local</font> {varName} = <font color="rgb({floor(0.3 * 255)}, {floor(0.5 * 255)}, {floor(0.3 * 255)})">{varValue}</font>`) or `<font color="rgb({floor(0.6 * 255)}, {floor(0.2 * 255)}, {floor(0.2 * 255)})">local</font> {varName} = {varValue}`

    VarCache[varName .. varValue] = var
    return var
end

local LogAnimation = function(AnimationTrack: AnimationTrack)
    local Animation = AnimationTrack.Animation
    local animation_id = Animation.AnimationId

    if rawget(AnimationExclusions, animation_id) == true then return end
    if rawget(AnimationCache, animation_id) == true then return end

    local track_name, animation_name = AnimationTrack.Name, objects(Animation.AnimationId)[1].Name
    local ButtonPlaceholder = createAnimationLog(animation_name)
    AnimationCache[animation_id] = true
    ButtonPlaceholder.Activated:Connect(function()
        CurrentSelectedAnimation = {
            name = track_name;
            aname = animation_name;
            id = animation_id;
        }
        local trackName, animName, animId = eslintVariable("track_name", `"{track_name}"`), eslintVariable("anim_name", `"{animation_name}"`), eslintVariable("anim_id", `"{animation_id}"`)
        CodeLabel.Text = trackName .. '\n' .. animName .. '\n' .. 
			animId .. '\n' ..
			eslintVariable("animation", 'Instance.new("Animation")', true) .. '\n' .. 
			`animation.AnimationId = <font color="rgb({floor(0.3 * 255)}, {floor(0.5 * 255)}, {floor(0.3 * 255)})">"rbxassetid://{animation_id:match('%d+')}"</font>` .. '\n' .. 
			'<font color="rgb(107, 168, 209)">game</font>.<font color="rgb(50, 94, 150)">Players</font>.<font color="rgb(50, 94, 150)">LocalPlayer</font>.<font color="rgb(50, 94, 150)">Character</font>.<font color="rgb(50, 94, 150)">Humanoid</font>:<font color="rgb(189, 135, 43)">LoadAnimation</font>(animation)'
        RawCodeValue = `local track_name = "{track_name}"\nlocal anim_name = "{animation_name}"\nlocal anim_id = "{animation_id}"\nlocal animation = Instance.new("Animation")\nanimation.AnimationId = "{animation_id:sub(1, 4) ~= "http" and 'rbxassetid://'..animation_id:match('%d+') or animation_id}"\ngame.Players.LocalPlayer.Character.Humanoid:LoadAnimation(animation):Play()`
    end)
end

Exclude.Activated:Connect(function()
    if CurrentSelectedAnimation and not AnimationExclusions[CurrentSelectedAnimation.id] then
        AnimationExclusions[CurrentSelectedAnimation.id] = true
    end
end)

Unexclude.Activated:Connect(function()
    if CurrentSelectedAnimation and AnimationExclusions[CurrentSelectedAnimation.id] then
        AnimationExclusions[CurrentSelectedAnimation.id] = false
    end
end)

ClearExclusions.Activated:Connect(function()
    AnimationExclusions = {}
end)

ClearLogs.Activated:Connect(function()
    CurrentSelectedAnimation = nil
    CodeLabel.Text = ""
	AnimationCache = {}
    for _, child in pairs(AnimationScroller:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end)

PlayAnimation.Activated:Connect(function()
    if CurrentSelectedAnimation then
        if CurrentRunningAnimation then
            CurrentRunningAnimation:Stop()
            CurrentRunningAnimation = nil
        end

        local anim = Instance.new("Animation")
        anim.AnimationId = CurrentSelectedAnimation.id
        
        CurrentRunningAnimation = LocalPlayer.Character.Humanoid:LoadAnimation(anim)
        CurrentRunningAnimation:Play()
    end
end)

StopAnimation.Activated:Connect(function()
    if CurrentRunningAnimation then
        CurrentRunningAnimation:Stop()
        CurrentRunningAnimation = nil
    end
end)

CopyCode.Activated:Connect(function()
    if CurrentSelectedAnimation then
        if #RawCodeValue > 0 then
            clipboard(RawCodeValue)
        end
    end
end)

CloseButton.Activated:Connect(function()
    if OldCharAddedEvent then
        pcall(OldCharAddedEvent.Disconnect, OldCharAddedEvent)
    end

    if OldPlayAnimationEvent then
        pcall(OldPlayAnimationEvent.Disconnect, OldPlayAnimationEvent)
    end

    if CurrentRunningAnimation then
        CurrentRunningAnimation:Stop()
        CurrentRunningAnimation = nil
    end

    CurrentSelectedAnimation = nil
    MainScreenGui:Destroy()
    _G.GUI = nil
end)

OldCharAddedEvent = TargetPlayer.CharacterAdded:Connect(function(Char)
    Character = Char
    Humanoid = Char:WaitForChild("Humanoid")
    if OldPlayAnimationEvent then
        pcall(OldPlayAnimationEvent.Disconnect, OldPlayAnimationEvent)
    end

    OldPlayAnimationEvent = Humanoid.AnimationPlayed:Connect(LogAnimation)
end)

OldPlayAnimationEvent = Humanoid.AnimationPlayed:Connect(LogAnimation)
