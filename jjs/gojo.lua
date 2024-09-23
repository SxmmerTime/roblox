local DoUltAnimation = true
if ({...})[1] == true then DoUltAnimation = false end

local ChatService = game:GetService("Chat")
local TweenService = game:GetService("TweenService")
print(DoUltAnimation)
local GojoRaysObject = game:GetObjects("rbxassetid://76757246011623")[1]
local SniperObject = game:GetObjects("rbxassetid://112334622119806")[1]
local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character
local Humanoid = Character.Humanoid

function RandomString(Length)
	local Length = typeof(Length) == "number" and math.clamp(Length,1,100) or math.random(80,100)
	local Text = ""
	for i = 1,Length do
		Text = Text..string.char(math.random(14,128))
	end
	return Text
end

local HonoredMusic = "rbxassetid://14457960806"

local UltChats = {
	{"Cursed Energy is negative energy.", 1};
	{"While it can enhance the body, it can't regenerate it.", 1.8};
	{"So multiply that negative energy against itself to create positive energy.", 2.4};
	{"That's the reverse cursed technique.", 1.8};
	{"Easier said than done!", 1.5};
	{"I haven't been able to do that up until now myself!", 2};
	{"And I couldn't understand anything the one person who could do it said.", 2};
	{"But I finally grasped it on the verge of death!", 2.5};
	{"The true essence of cursed energy!", 1.3};
}
local ReversalMaxChats = {
	{
		{"Reversal Red, shoot up the classroom!", 0};
		{"Cya later Alligator", 1.3};
	};
	{
		{"Imaginary Technique!", 0};
		{"SCOPE HIM LIKE JFK!", 1.3};
	};
}

local AnimationUses = {}
local IsPlayingAnimation = false
local AnimationQueue = {}
local ReplaceAnimations = {
	{
		ID = "rbxassetid://14135387764";
		STOP_AFTER = nil;
        PAUSE_AFTER = nil;
        PAUSE_TIME = nil;
		SPEED = 0.8; -- Defaults to 1
		REPLACE = "rbxassetid://15292037778";
        USE_AFTER = nil;
        USE = nil;
		ADJUST = true;
	}; -- Reversal Red
	{
		ID = "rbxassetid://14737876270";
		STOP_AFTER = nil;
		PAUSE_AFTER = nil;
		PAUSE_TIME = nil;
		SPEED = 0.6;
		REPLACE = "rbxassetid://16610596137";
		USE_AFTER = nil;
		USE = function(CurrentTrack)
			local Rays = GojoRaysObject:Clone()
			local BeamData = {}
			Rays.PointLight.Brightness = 0
			for _, Child in pairs(Rays:GetDescendants()) do
				if Child:IsA("Beam") then
					BeamData[Child] = {
						W1 = Child.Width0;
						W2 = Child.Width1;
					}
					Child.Width0 = 0;
					Child.Width1 = 0;
				end
			end
			Rays.Anchored = true
			Rays.CFrame = Character.Head.CFrame

			TweenService:Create(Humanoid, TweenInfo.new(3, Enum.EasingStyle.Linear), {
				HipHeight = 11
			}):Play()

			local Sound = Instance.new("Sound")
			Sound.SoundId = HonoredMusic
			Sound.RollOffMinDistance = math.huge
			Sound.Volume = 0
			Sound.TimePosition = 7
			Sound.Parent = game.Workspace
			Sound:Play()

			TweenService:Create(Sound, TweenInfo.new(2, Enum.EasingStyle.Linear), {
				Volume = 0.8
			}):Play()

			task.delay(1, function()
				for _, UltChat in ipairs(UltChats) do
					task.wait(UltChat[2])
					ChatService:Chat(Character.Head, UltChat[1], Enum.ChatColor.White)
				end
			end)

			task.spawn(function()
				while Rays ~= nil do
					task.wait()
					Rays.CFrame = Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
				end
			end)

			local isFloating = true
			local floatingTween
			task.delay(2, function()
				Rays.Parent = game.Workspace
				TweenService:Create(Rays.PointLight, TweenInfo.new(1, Enum.EasingStyle.Linear), {
					Brightness = 10
				}):Play()
				for Beam, Data in pairs(BeamData) do
					TweenService:Create(Beam, TweenInfo.new(1, Enum.EasingStyle.Linear), {
						Width0 = Data.W1;
						Width1 = Data.W2;
					}):Play()
				end
			end)
			task.delay(3.5, function()
				CurrentTrack:AdjustSpeed(0)
				task.spawn(function()
					while isFloating and DoUltAnimation do
						task.wait()
						floatingTween = TweenService:Create(Humanoid, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
							HipHeight = 12
						})
						floatingTween:Play()
						floatingTween.Completed:Wait()
						floatingTween = TweenService:Create(Humanoid, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
							HipHeight = 10
						})
						floatingTween:Play()
						floatingTween.Completed:Wait()
					end
				end)
			end)
			
			task.wait(DoUltAnimation and 22 or 5)
			if floatingTween then
				floatingTween:Pause()
			end
			isFloating = false

			TweenService:Create(Humanoid, TweenInfo.new(3, Enum.EasingStyle.Linear), {
				HipHeight = 0
			}):Play()
			TweenService:Create(Sound, TweenInfo.new(6, Enum.EasingStyle.Linear), {
				Volume = 0
			}):Play()
			task.delay(6, function()
				Sound:Stop()
				Sound:Destroy()
			end)
			
			task.delay(1.5, function()
				TweenService:Create(Rays.PointLight, TweenInfo.new(1, Enum.EasingStyle.Linear), {
					Brightness = 0
				}):Play()
				for _, C in pairs(Rays:GetDescendants()) do
					if C:IsA("ParticleEmitter") then
						C.Enabled = false
					end
				end
				for Beam, _ in pairs(BeamData) do
					TweenService:Create(Beam, TweenInfo.new(1, Enum.EasingStyle.Linear), {
						Width0 = 0;
						Width1 = 0;
					}):Play()
				end
				task.wait(1)
				Rays:Destroy()
			end)
			CurrentTrack:AdjustSpeed(-0.6)
		end;
	}; -- Ult Animation
	{
		ID = "rbxassetid://17283946287";
		STOP_AFTER = nil;
		PAUSE_AFTER = nil;
		PAUSE_TIME = nil;
		SPEED = 1;
		REPLACE = "rbxassetid://17283946287";
		USE_AFTER = nil;
		USE = function(CurrentTrack)
			task.spawn(function()
				for _, Chat in ipairs(ReversalMaxChats[math.random(1, #ReversalMaxChats)]) do
					task.wait(Chat[2])
					ChatService:Chat(Character.Head, Chat[1], Enum.ChatColor.White)
				end
			end)
			local Sniper = SniperObject:Clone()
			Sniper.CanCollide = false
			Sniper.Parent = game.Workspace
			Sniper.Appear:Emit(150)
			local Motor = Instance.new("Motor6D")
			Motor.Parent = Character['Right Arm']
			Motor.Part0 = Motor.Parent
			Motor.Part1 = Sniper
			Motor.C0 = CFrame.new(.5, -3, 0)
			Motor.C1 = CFrame.Angles(math.rad(-35), math.rad(180), math.rad(90))
			task.delay(1.1, function()
				Sniper.Appear:Emit(150)
			end)
			task.wait(1.3)
			Motor:Destroy()
			Sniper.Transparency = 1
			Sniper.PointLight.Brightness = 0
			task.delay(2, Sniper.Destroy, Sniper)
		end
	}; -- Reversal Red Max
	{
		ID = "rbxassetid://85226615737055";
		STOP_AFTER = nil;
		PAUSE_AFTER = nil;
		PAUSE_TIME = nil;
		SPEED = 1;
		REPLACE = nil;
		USE_AFTER = nil;
		ADJUST = true;
		USE = function(CurrentTrack)
			CurrentTrack.TimePosition = .6;
			task.wait(.65)
			CurrentTrack:Stop()
			CurrentTrack:Play()
			CurrentTrack.TimePosition = 0;
			task.wait(.525)
			CurrentTrack:Stop()
			CurrentTrack:Destroy()
			task.wait(.1)
			IsPlayingAnimation = false
		end;
	}; -- Twofold Kick
	{
		ID = "rbxassetid://14351933730";
		STOP_AFTER = nil;
		PAUSE_AFTER = nil;
		PAUSE_TIME = nil;
		SPEED = 1;
		REPLACE = "rbxassetid://14351933730";
		USE_AFTER = nil;
		USE = function(CurrentTrack)
			for i = 1, math.random(2, 5) do
				task.wait(math.random(1, 10)/10)
				ChatService:Chat(Character.Head, RandomString(math.random(5, 10)), Enum.ChatColor.White)
			end
		end
	}; -- Hollow Purple
}

function PlayAnimation(ReplacementList)
	if IsPlayingAnimation then
		table.insert(AnimationQueue, ReplacementList)
		return
	end

	IsPlayingAnimation = true

	local Animation = Instance.new("Animation")
	Animation.Name = "GOJO_SCRIPT"
	Animation.AnimationId = ReplacementList.REPLACE or ReplacementList.ID
	print(ReplacementList.ID == ReplacementList.REPLACE)

	local LoadedAnimation = Humanoid:LoadAnimation(Animation)
	LoadedAnimation.Priority = Enum.AnimationPriority.Action4
	if ReplacementList.ID == ReplacementList.REPLACE then
		IsPlayingAnimation = false
	else
		LoadedAnimation:Play()
	end

	LoadedAnimation:AdjustSpeed(ReplacementList.SPEED or 1)

	if ReplacementList.STOP_AFTER then
		task.delay(ReplacementList.STOP_AFTER, function()
			pcall(LoadedAnimation.Stop, LoadedAnimation)
		end)
	end

    if ReplacementList.PAUSE_AFTER and ReplacementList.PAUSE_TIME then
        task.delay(ReplacementList.PAUSE_AFTER, function()
            LoadedAnimation:AdjustSpeed(0)
            task.wait(ReplacementList.PAUSE_TIME)
            LoadedAnimation:AdjustSpeed(ReplacementList.SPEED or 1)
        end)
    end

    local UseConnection
    if rawget(ReplacementList, "USE") then
		if rawget(ReplacementList, "USE_AFTER") then
			UseConnection = ReplacementList.USE_AFTER:Connect(function(Child)
				ReplacementList.USE(LoadedAnimation, Child, UseConnection)
			end)
		else
			ReplacementList.USE(LoadedAnimation)
		end
    end

	LoadedAnimation.Stopped:Connect(function()
        if UseConnection then UseConnection:Disconnect() end

        IsPlayingAnimation = false

		if #AnimationQueue > 0 then
			local NextAnimation = table.remove(AnimationQueue, 1)
			PlayAnimation(NextAnimation)
		end
	end)
end

local CheckAnimation = function(PlayingID)
	for _, Animations in pairs(ReplaceAnimations) do
		if Animations.ID:match("%d+") == PlayingID:match("%d+") then
			return Animations
		end
	end
	return nil
end

Humanoid.AnimationPlayed:Connect(function(AnimationTrack)
	local ID = AnimationTrack.Animation.AnimationId
	local FetchedAnimation = CheckAnimation(ID)

	if FetchedAnimation and AnimationTrack.Animation.Name ~= "GOJO_SCRIPT" then
		AnimationTrack.Priority = Enum.AnimationPriority.Action
		if FetchedAnimation.ID ~= FetchedAnimation.REPLACE then
			if FetchedAnimation['ADJUST'] == true then
				AnimationTrack:AdjustSpeed(0)
			else
				AnimationTrack:Stop()
			end
		end
		AnimationTrack:Destroy()
		PlayAnimation(FetchedAnimation)
	end
end)
