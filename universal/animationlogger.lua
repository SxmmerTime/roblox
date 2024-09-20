if _G.GUI then _G.GUI:Destroy() end 
local CoreGui = (gethui and gethui()) or (cloneref and cloneref(game:GetService("CoreGui"))) or game:GetService("CoreGui")
local Players = game:GetService("Players")

local clipboard = setclipboard or toclipboard or syn.write_clipboard
local floor = math.floor
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
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
local UIListLayout = Instance.new("UIListLayout")
local CodeLabel = Instance.new("TextLabel")
local ButtonFrame = Instance.new("Frame")
local UIListLayout_2 = Instance.new("UIListLayout")
local CopyCode = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local ClearLogs = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local Exclude = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local PlayAnimation = Instance.new("TextButton")
local StopAnimation = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local Unexclude = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")

--Properties:

Main.Parent = game.StarterGui.ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Main.Position = UDim2.new(0.23, 0, 0.25, 0)
Main.Size = UDim2.new(0, 364, 0, 242)

AnimationScroller.Parent = Main
AnimationScroller.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
AnimationScroller.Position = UDim2.new(0.02, 0, 0.025, 0)
AnimationScroller.Size = UDim2.new(0, 120, 0, 230)

CloseButton.Name = "CloseButton"
CloseButton.Parent = Main
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.RichText = true
CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.953296721, 0, -0.0702479333, 0)
CloseButton.Size = UDim2.new(0, 17, 0, 17)
CloseButton.Text = "<b>X</b>"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)

UIListLayout.Parent = AnimationScroller
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 3)

CodeLabel.Parent = Main
CodeLabel.BackgroundColor3 = Color3.fromRGB(75, 79, 88)
CodeLabel.Position = UDim2.new(0.4, 0, 0.025, 0)
CodeLabel.Size = UDim2.new(0, 218, 0, 128)
CodeLabel.Font = Enum.Font.Roboto
CodeLabel.RichText = true
CodeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CodeLabel.TextSize = 18.000
CodeLabel.TextWrapped = true
CodeLabel.TextXAlignment = Enum.TextXAlignment.Left
CodeLabel.TextYAlignment = Enum.TextYAlignment.Top

ButtonFrame.Parent = Main
ButtonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ButtonFrame.BackgroundTransparency = 1.000
ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ButtonFrame.Position = UDim2.new(0.4, 0, 0.6, 0)
ButtonFrame.Size = UDim2.new(0, 218, 0, 94)

UIListLayout_2.Parent = ButtonFrame
UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_2.Padding = UDim.new(0, 11)
UIListLayout_2.Wraps = true

CopyCode.Parent = ButtonFrame
CopyCode.BackgroundColor3 = Color3.fromRGB(131, 131, 131)
CopyCode.BorderColor3 = Color3.fromRGB(0, 0, 0)
CopyCode.Position = UDim2.new(0.4, 0, 0.6, 0)
CopyCode.Size = UDim2.new(0, 65, 0, 18)
CopyCode.Font = Enum.Font.SourceSansBold
CopyCode.Text = "Copy Code"
CopyCode.TextScaled = true
CopyCode.TextColor3 = Color3.fromRGB(255, 255, 255)

UICorner.CornerRadius = UDim.new(0, 2)
UICorner.Parent = CopyCode

ClearLogs.Parent = ButtonFrame
ClearLogs.BackgroundColor3 = Color3.fromRGB(131, 131, 131)
ClearLogs.BorderColor3 = Color3.fromRGB(0, 0, 0)
ClearLogs.Position = UDim2.new(0.4, 0, 0.6, 0)
ClearLogs.Size = UDim2.new(0, 65, 0, 18)
ClearLogs.Font = Enum.Font.SourceSansBold
ClearLogs.TextScaled = true
ClearLogs.Text = "Clear Logs"
ClearLogs.TextColor3 = Color3.fromRGB(255, 255, 255)

UICorner_2.CornerRadius = UDim.new(0, 2)
UICorner_2.Parent = ClearLogs

Exclude.Parent = ButtonFrame
Exclude.BackgroundColor3 = Color3.fromRGB(131, 131, 131)
Exclude.Position = UDim2.new(0.4, 0, 0.6, 0)
Exclude.Size = UDim2.new(0, 65, 0, 18)
Exclude.Font = Enum.Font.SourceSansBold
Exclude.TextScaled = true
Exclude.Text = "Exclude"
Exclude.TextColor3 = Color3.fromRGB(255, 255, 255)

PlayAnimation.Parent = ButtonFrame
PlayAnimation.BackgroundColor3 = Color3.fromRGB(131, 131, 131)
PlayAnimation.Position = UDim2.new(0.4, 0, 0.6, 0)
PlayAnimation.Size = UDim2.new(0, 65, 0, 18)
PlayAnimation.Font = Enum.Font.SourceSansBold
PlayAnimation.TextScaled = true
PlayAnimation.Text = "Play"
PlayAnimation.TextColor3 = Color3.fromRGB(255, 255, 255)

StopAnimation.Parent = ButtonFrame
StopAnimation.BackgroundColor3 = Color3.fromRGB(131, 131, 131)
StopAnimation.Position = UDim2.new(0.4, 0, 0.6, 0)
StopAnimation.Size = UDim2.new(0, 65, 0, 18)
StopAnimation.Font = Enum.Font.SourceSansBold
StopAnimation.TextScaled = true
StopAnimation.Text = "Stop"
StopAnimation.TextColor3 = Color3.fromRGB(255, 255, 255)

UICorner_3.CornerRadius = UDim.new(0, 2)
UICorner_3.Parent = Exclude

Unexclude.Parent = ButtonFrame
Unexclude.TextScaled = true
Unexclude.BackgroundColor3 = Color3.fromRGB(131, 131, 131)
Unexclude.Position = UDim2.new(0.4, 0, 0.6, 0)
Unexclude.Size = UDim2.new(0, 65, 0, 18)
Unexclude.Font = Enum.Font.SourceSansBold
Unexclude.Text = "Unexclude"
Unexclude.TextColor3 = Color3.fromRGB(255, 255, 255)
Unexclude.TextSize = 14.000

UICorner_4.CornerRadius = UDim.new(0, 2)
UICorner_4.Parent = Unexclude

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
    id = tostring(id)
    id ='rbxassetid://' .. id:match("%d+")

    if ObjectCache[id] then
        return ObjectCache[id]
    end

    local _objects = game:GetObjects(id)
    ObjectCache[id] = _objects
    return _objects
end

local eslintVariable = function(varName: string, varValue: string)
    if VarCache[varName .. varValue] then
        return VarCache[varName .. varValue]
    end
    local var = `<font color="rgb({floor(0.6 * 255)}, {floor(0.2 * 255)}, {floor(0.2 * 255)})">local</font> {varName} = <font color="rgb({floor(0.3 * 255)}, {floor(0.5 * 255)}, {floor(0.3 * 255)})">{varValue}</font>`

    VarCache[varName .. varValue] = var
    return var
end

local LogAnimation = function(AnimationTrack: AnimationTrack)
    local Animation = AnimationTrack.Animation
    local animation_id = Animation.AnimationId

    if animation_id:sub(1, 4) == "http" then return end
    if rawget(AnimationExclusions, animation_id) == true then return end
    if AnimationCache[animation_id] then return end

    local track_name, animation_name = AnimationTrack.Name, objects(Animation.AnimationId)[1].Name
    local ButtonPlaceholder = createAnimationLog(animation_name)
    AnimationCache[animation_id] = true
    ButtonPlaceholder.Activated:Connect(function()
        print"fr"
        CurrentSelectedAnimation = {
            name = track_name;
            aname = animation_name;
            id = animation_id;
        }
        local trackName, animName, animId = eslintVariable("track_name", `"{track_name}"`), eslintVariable("anim_name", `"{animation_name}"`), eslintVariable("anim_id", `"{animation_id}"`)
        CodeLabel.Text = trackName .. '\n' .. animName .. '\n' .. animId
        RawCodeValue = `local track_name = "{track_name}"\nlocal anim_name = "{animation_name}"\nlocal anim_id = "{animation_id}"`
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

ClearLogs.Activated:Connect(function()
    CurrentSelectedAnimation = nil
    CodeLabel.Text = ""
    AnimationExclusions = {}
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
        
        CurrentRunningAnimation = Humanoid:LoadAnimation(anim)
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

OldCharAddedEvent = LocalPlayer.CharacterAdded:Connect(function(Char)
    Character = Char
    Humanoid = Char:WaitForChild("Humanoid")
    if OldPlayAnimationEvent then
        pcall(OldPlayAnimationEvent.Disconnect, OldPlayAnimationEvent)
    end

    OldPlayAnimationEvent = Humanoid.AnimationPlayed:Connect(LogAnimation)
end)

OldPlayAnimationEvent = Humanoid.AnimationPlayed:Connect(LogAnimation)
