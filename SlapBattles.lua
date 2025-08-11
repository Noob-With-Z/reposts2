-- Slap Battles Script
-- View the owner profile here: github.com/Giangplay
-- view the official string here: raw.githubusercontent.com/Giangplay/Slap_Battles/main/Slap_Battles.lua
--[[
I made a small remake and recoded some parts of the code.

(I keep trying to do smth and change it all i can)

Changelog:

Legend:
[+] Added
[-] Removed
[/] Modified

[/] Improved QueueTeleport UI persistence:
 |_ Reworked Keep UI system using 'plr.OnTeleport' RBXConnection.
 |_ Introduced a file-based system for UI tracking:
 |   |_ File named 'SlapBattles.giangsett' created as an identifier.
 |   |_ This file can be manually edited via your file browser.

[/] Misc Tab Cleanup:
 |_ [-] Removed: Visual Slap Changer, Teleport To Game ID, Slap Battles Button (considered unnecessary).
 |_ [-] Removed Farms: Replica, Baller, Blink (Patched).
 |_ [-] Removed: Replica clone + Reverse effect (Patched).
 |_ [/] Improved Glove Equip System:
     |_ [-] Removed support for Tournaments (Patched).
     |_ [/] Enhanced glove name recognition:
         |_ Now supports lower/uppercase and spacing variations.
         |_ e.g.: "zahando", "ZaHando", "za hando", "Za Hando", "zAhAnDo", etc.
]]
--[[
-- // Temporary For Studio \\ --

cloneref = nil
sethiddenproperty, set_hidden_property, set_hidden_prop = nil
gethiddenproperty, get_hidden_property, get_hidden_prop = nil
queue_on_teleport, syn, fluxus = nil
request, http_request, http = nil
setclipboard, toclipboard, set_clipboard, Clipboard = nil
isfile, isfolder, makefolder = nil
writefile, readfile, appendfile = nil
firetouchinterest = nil
hookfunction, hookmetamethod = nil
getnamecallmethod, get_namecall_method = nil

function getgenv()
end

function cloneref()
end

function firetouchinterest()
end

function fireclickdetector()
end

function fireproximityprompt()
end

function hookmetamethod()
end

function identifyexecutor()
end

function getnamecallmethod()
end

function getconnections()
end

function gethui()
end

-- // lol \\ --
]]

if not game:IsLoaded() then
	game.Loaded:Wait()
end

function missing(t, f, fallback)
	if type(f) == t then return f end
	return fallback
end

local cloneref = missing("function", cloneref, function(...) return ... end)
local sethidden =  missing("function", sethiddenproperty or set_hidden_property or set_hidden_prop)
local gethidden =  missing("function", gethiddenproperty or get_hidden_property or get_hidden_prop)
local queueteleport =  missing("function", queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport))
local httprequest =  missing("function", request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request))
local everyClipboard = missing("function", setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set))
local firetouchinterest = missing("function", firetouchinterest)
local waxwritefile, waxreadfile = writefile, readfile
local writefile = missing("function", waxwritefile) and function(file, data, safe)
	if safe == true then return pcall(waxwritefile, file, data) end
	waxwritefile(file, data)
end
local readfile = missing("function", waxreadfile) and function(file, safe)
	if safe == true then return pcall(waxreadfile, file) end
	return waxreadfile(file)
end
local isfile = missing("function", isfile, readfile and function(file)
	local success, result = pcall(function()
		return readfile(file)
	end)
	return success and result ~= nil and result ~= ""
end)
local makefolder = missing("function", makefolder)
local isfolder = missing("function", isfolder)
local hookfunction = missing("function", hookfunction)
local hookmetamethod = missing("function", hookmetamethod)
local getnamecallmethod = missing("function", getnamecallmethod or get_namecall_method)

local OrionLib = loadstring(game:HttpGet(("https://raw.githubusercontent.com/Giangplay/Script/main/Orion_Library_PE_V2.lua")))()
local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local Players = cloneref(game:GetService("Players"))
local RS = cloneref(game:GetService("ReplicatedStorage"))

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

game:GetService("GuiService"):ClearError()

function CanWriteFile()
	if writefile then
		return true
	end
end

function CanReadFile()
	if readfile then
		return true
	end
end

if CanReadFile() and CanWriteFile() and isfile and isfolder and makefolder then
	local defaultconfig = {
		["AutoExecuteOnTeleport"] = false
	}
	
	local file
	local fileName
	
	if string.sub("SlapBattles", -3) == '.giangsett' then
		pcall(function() file = readfile("SlapBattles") end)
		fileName = "SlapBattles"
	else
		pcall(function() file = readfile("SlapBattles"..'.giangsett') end)
		fileName = "SlapBattles"..'.giangsett'
	end
	
	local config = defaultconfig
	local success, result = pcall(function()
		return game:GetService("HttpService"):JSONDecode(file)
	end)
	if success and result then
		config = result
	else
		if isfile("SlapBattles"..'.giangsett') == false then
			makefolder("slap battles")
		end
		writefile("SlapBattles"..'.giangsett', game:GetService("HttpService"):JSONEncode(defaultconfig))
	end
else
	warn("Don't have neccessary UNCs to do that.")
end

function GetSpecificSettings(SettName)
	
	if not SettName then
		if CanReadFile() then
			return true
		else
			return false
		end
	end
	
	if CanReadFile() then
		if SettName == "GetAll" then
			return game:GetService("HttpService"):JSONDecode(readfile("SlapBattles"..'.giangsett'))
		else
			local sett = game:GetService("HttpService"):JSONDecode(readfile("SlapBattles"..'.giangsett'))
			return sett[SettName]
		end
	end
end

local Teleporting = true

plr.OnTeleport:Connect(function(State)
	if Teleporting == true and State ~= Enum.TeleportState.Failed and (queueteleport or queue_on_teleport) then
		Teleporting = false
		queueteleport([[
		function missing(t, f, fallback)
			if type(f) == t then return f end
			return fallback
		end

		local waxwritefile, waxreadfile = writefile, readfile

		local readfile = missing("function", waxreadfile) and function(file, safe)
			if safe == true then return pcall(waxreadfile, file) end
			return waxreadfile(file)
		end

		function CanReadFile()
			if readfile then
				return true
			end
		end

		function GetSpecificSettings(SettName)
			if not SettName then
				if CanReadFile() then
					return true
				else
					return false
				end
			end

			if CanReadFile() then
				if SettName == "GetAll" then
					return game:GetService("HttpService"):JSONDecode(readfile("SlapBattles"..'.giangsett'))
				else
					local sett = game:GetService("HttpService"):JSONDecode(readfile("SlapBattles"..'.giangsett'))
					return sett[SettName]
				end
			end
		end		

		if GetSpecificSettings() and GetSpecificSettings("AutoExecuteOnTeleport") == true then
			local GameIsLoaded
			repeat task.wait() until game:IsLoaded()
			warn('[NoobZ Debug]: Player Teleported.')
			GameIsLoaded = true
			repeat task.wait() until GameIsLoaded
			task.wait(.25)
			
			loadstring(game:HttpGet('raw.githubusercontent.com/Noob-With-Z/reposts2/main/SlapBattles.lua'))()
			warn('[NoobZ Debug]: Loading...')
			warn('[NoobZ Debug]: Settings Loaded: {\n'..tostring(GetSpecificSettings("GetAll"))..'\n}')
		end
		]])
	end
end)

print("👏 Giang Hub Loaded 👏")

if game.PlaceId == 6403373529 or game.PlaceId == 9015014224 then
	local Hits = {
		-- // Slap-required Gloves (First > Last)
		["spin"] = RS.spinhit,
		["Stick"] = RS.GeneralHit,
		["Default"] = RS.b,
		["Diamond"] = RS.DiamondHit,
		["ZZZZZZZ"] = RS.ZZZZZZZHit,
		["Extended"] = RS.b,
		["Dual"] = RS.GeneralHit,
		["Brick"] = RS.BrickHit,
		["Snow"] = RS.SnowHit,
		["Pull"] = RS.PullHit,
		["Flash"] = RS.FlashHit,
		["Spring"] = RS.springhit,
		["Swapper"] = RS.HitSwapper,
		["Screwdriver"] = RS.GeneralHit,
		["Bull"] = RS.BullHit,
		["Dice"] = RS.DiceHit,
		["Ghost"] = RS.GhostHit,
		["Thanos"] = RS.GeneralHit,
		["Stun"] = RS.HtStun,
		["L.O.L.B.O.M.B"] = RS.GeneralHit,
		["Za Hando"] = RS.zhramt,
		["Fort"] = RS.Fort,
		["Magnet"] = RS.MagnetHIT,
		["Pusher"] = RS.PusherHit,
		["Anchor"] = RS.hitAnchor,
		["Space"] = RS.HtSpace,
		["Boomerang"] = RS.BoomerangH,
		["Speedrun"] = RS.Speedrunhit,
		["Mail"] = RS.MailHit,
		["T H I C K"] = RS.GeneralHit,
		["Golden"] = RS.GoldenHit,
		["Squid"] = RS.GeneralHit,
		["MR"] = RS.MisterHit,
		["Hive"] = RS.GeneralHit,
		["Reaper"] = RS.ReaperHit,
		["Baby"] = RS.GeneralHit,
		["Replica"] = RS.ReplicaHit,
		["Mace"] = RS.GeneralHit,
		["Defense"] = RS.DefenseHit,
		["Killstreak"] = RS.KSHit,
		["Reverse"] = RS.ReverseHit,
		["Shukuchi"] = RS.ShukuchiHit,
		["Duelist"] = RS.DuelistHit,
		["woah"] = RS.woahHit,
		["Ice"] = RS.IceHit,
		["Gummy"] = RS.GeneralHit,
		["Adios"] = RS.hitAdios,
		["Blocked"] = RS.BlockedHit,
		["Divert"] = RS.GeneralHit,
		["Engineer"] = RS.engiehit,
		["Rocky"] = RS.RockyHit,
		["Coil"] = RS.HtStun,
		["Conveyor"] = RS.ConvHit,
		["Balloony"] = RS.HtStun,
		["Phantom"] = RS.PhantomHit,
		["el gato"] = RS.GeneralHit,
		["Wormhole"] = RS.WormHit,
		["Shackle"] = RS.GeneralHit,
		["Flick"] = RS.GeneralHit,
		["STOP"] = RS.STOP,
		["Equalizer"] = RS.GeneralHit,
		["Track"] = RS.GeneralHit,
		["Stalker"] = RS.GeneralHit,
		["Prop"] = RS.GeneralHit,
		["Cherry"] = RS.GeneralHit,
		["Shield"] = RS.GeneralHit,
		["Clover"] = RS.GeneralHit,
		["Booster"] = RS.GeneralHit,
		["Chainsaw"] = RS.GeneralHit,
		["Ping Pong"] = RS.GeneralHit,
		["Trifecta"] = RS.GeneralHit,
		["Baller"] = RS.GeneralHit,
		["Home Run"] = RS.GeneralHit,
		["Friction"] = RS.GeneralHit,
		["Whirlwind"] = RS.GeneralHit,
		["Slicer"] = RS.GeneralHit,
		["Excavator"] = RS.GeneralHit,
		["Nightmare"] = RS.nightmarehit,
		["Thor"] = RS.ThorHit,
		["Pocket"] = RS.GeneralHit,
		["Grapple"] = RS.GeneralHit,
		["Cloud"] = RS.CloudHit,
		["Gravity"] = RS.GeneralHit,
		["Parry"] = RS.GeneralHit,
		["Jebaited"] = RS.GeneralHit,
		["Meteor"] = RS.GeneralHit,
		["Oven"] = RS.GeneralHit,
		["Guardian Angel"] = RS.GeneralHit,
		["Sun"] = RS.GeneralHit,
		["Ferryman"] = RS.GeneralHit,
		["Blackhole"] = RS.GeneralHit,
		["Blink"] = RS.GeneralHit,
		["Tableflip"] = RS.GeneralHit,
		["Slapstick"] = RS.GeneralHit,
		["Beatdown"] = RS.GeneralHit,
		["Chicken"] = RS.GeneralHit,
		["BONK"] = RS.GeneralHit,
		["Sbeve"] = RS.GeneralHit,
		["Golem"] = RS.GeneralHit,
		["Doomsday"] = RS.GeneralHit,
		["Grab"] = RS.GeneralHit,
		["UFO"] = RS.GeneralHit,
		["Demolition"] = RS.GeneralHit,
		["Beachball"] = RS.GeneralHit,
		["Shotgun"] = RS.GeneralHit,
		["64"] = RS.GeneralHit,
		["Roguelike"] = RS.GeneralHit,
		["Barrel"] = RS.GeneralHit,
		["Lawnmower"] = RS.GeneralHit,
		["Virus"] = RS.GeneralHit,
		["Infinity"] = RS.GeneralHit,
		["Aggro"] = RS.GeneralHit,
		["Medusa"] = RS.GeneralHit,
		["Seal"] = RS.GeneralHit,
		["Soul"] = RS.GeneralHit,
		["R/C"] = RS.GeneralHit,
		["Mushroom"] = RS.GeneralHit,
		["Scuba"] = RS.GeneralHit,
		["Pyromania"] = RS.GeneralHit,
		["God's Hand"] = RS.Godshand,
		["The Flex"] = RS.FlexHit,

		-- // Badge-required Gloves (First > Last)
		["MEGAROCK"] = RS.DiamondHit,
		["Plague"] = RS.PlagueHit,
		["Hallow Jack"] = RS.HallowHIT,
		["[REDACTED]"] = RS.ReHit,
		["bus"] = RS.hitbus,
		["Mitten"] = RS.MittenHit,
		["Phase"] = RS.PhaseH,
		["Warp"] = RS.WarpHt,
		["Bomb"] = RS.BombHit,
		["Bubble"] = RS.BubbleHit,
		["Jet"] = RS.JetHit,
		["Shard"] = RS.ShardHIT,
		["potato"] = RS.potatohit,
		["CULT"] = RS.CULTHit,
		["bob"] = RS.bobhit,
		["buddies"] = RS.buddiesHIT,
		["Moon"] = RS.CelestialHit,
		["Jupiter"] = RS.CelestialHit,
		["Spy"] = RS.SpyHit,
		["Detonator"] = RS.DetonatorHit,
		["Rage"] = RS.GRRRR,
		["Trap"] = RS.traphi,
		["Orbit"] = RS.Orbihit,
		["Hybrid"] = RS.HybridCLAP,
		["Slapple"] = RS.SlappleHit,
		["Disarm"] = RS.DisarmH,
		["Dominance"] = RS.DominanceHit,
		["Link"] = RS.LinkHit,
		["Chain"] = RS.GeneralHit,
		["Rattlebones"] = RS.GeneralHit,
		["Charge"] = RS.GeneralHit,
		["Tycoon"] = RS.GeneralHit,
		["Confusion"] = RS.GeneralHit,
		["Glitch"] = RS.GeneralHit,
		["Snowball"] = RS.GeneralHit,
		["Elude"] = RS.GeneralHit,
		["RNG"] = RS.GeneralHit,
		["fish"] = RS.GeneralHit,
		["🗿"] = RS.GeneralHit,
		["Obby"] = RS.GeneralHit,
		["Voodoo"] = RS.GeneralHit,
		["Goofy"] = RS.GeneralHit,
		["Leash"] = RS.GeneralHit,
		["Flamarang"] = RS.GeneralHit,
		["Kinetic"] = RS.HtStun,
		["Berserk"] = RS.GeneralHit,
		["Sparky"] = RS.HtStun,
		["Boogie"] = RS.HtStun,
		["Recall"] = RS.HtStun,
		["Quake"] = RS.GeneralHit,
		["Psycho"] = RS.GeneralHit,
		["Kraken"] = RS.GeneralHit,
		["Counter"] = RS.GeneralHit,
		["Hammer"] = RS.GeneralHit,
		["rob"] = RS.robhit,
		["Rhythm"] = RS.rhythmhit,
		["Rojo"] = RS.RojoHit,
		["Hitman"] = RS.HitmanHit,
		["Retro"] = RS.RetroHit,
		["Null"] = RS.NullHit,
		["Lure"] = RS.GeneralHit,
		["Tinkerer"] = RS.GeneralHit,
		["Necromancer"] = RS.GeneralHit,
		["Alchemist"] = RS.GeneralHit,
		["Druid"] = RS.GeneralHit,
		["Jester"] = RS.GeneralHit,
		["Scythe"] = RS.GeneralHit,
		["Santa"] = RS.GeneralHit,
		["Iceskate"] = RS.GeneralHit,
		["Blasphemy"] = RS.GeneralHit,
		["Pan"] = RS.GeneralHit,
		["Admin"] = RS.GeneralHit,
		["Joust"] = RS.GeneralHit,
		["Firework"] = RS.GeneralHit,
		["Run"] = RS.GeneralHit,
		["Glovel"] = RS.GeneralHit,
		["Divebomb"] = RS.GeneralHit,
		["Lamp"] = RS.GeneralHit,
		["Knockoff"] = RS.GeneralHit,
		["Frostbite"] = RS.GeneralHit,
		["Plank"] = RS.GeneralHit,
		["Spoonful"] = RS.GeneralHit,
		["the schlop"] = RS.GeneralHit,
		["Siphon"] = RS.GeneralHit,
		["Wrench"] = RS.GeneralHit,
		["Relude"] = RS.GeneralHit,
		["Hunter"] = RS.GeneralHit,
		["Avatar"] = RS.GeneralHit,
		["Water"] = RS.GeneralHit,
		["Fan"] = RS.GeneralHit,
		["Boxer"] = RS.GeneralHit,
		["MATERIALIZE"] = RS.GeneralHit,
		["Bind"] = RS.GeneralHit,
		["Poltergeist"] = RS.GeneralHit,
		["Clock"] = RS.GeneralHit,
		["Untitled Tag Glove"] = RS.GeneralHit,
		["Pillow"] = RS.GeneralHit,
		["Angler"] = RS.GeneralHit,
		["Jerry"] = RS.GeneralHit,
		["Snowroller"] = RS.GeneralHit,
		["Draw4"] = RS.GeneralHit,
		["Mouse"] = RS.GeneralHit,
		["Hexa"] = RS.GeneralHit,
		["Metaverse"] = RS.GeneralHit,
		["Swordfighter"] = RS.GeneralHit,
		["Tank"] = RS.GeneralHit,
		["Eggler"] = RS.GeneralHit,
		["Slender"] = RS.GeneralHit,
		["Swashbuckler"] = RS.GeneralHit,
		["Silly"] = RS.GeneralHit,
		["Slasher"] = RS.GeneralHit,
		["Car Keys"] = RS.GeneralHit,
		["Suction"] = RS.GeneralHit,
		["Reflect"] = RS.GeneralHit,
		["Dave"] = RS.GeneralHit,
		["Mortis"] = RS.GeneralHit,

		-- // Special or Gamepass
		["Acrobat"] = RS.GeneralHit,
		["OVERKILL"] = RS.Overkillhit,
		["CUSTOM"] = RS.CustomHit,
		["Ultra Instinct"] = RS.GeneralHit,
		["Titan"] = RS.GeneralHit,
		["Killerfish"] = RS.GeneralHit,
	}

	local Window = OrionLib:MakeWindow({IntroText = "Slap Battles 👏", IntroIcon = "rbxassetid://15315284749",Name = ("Giang Hub - Slap Battles 👏".." | ".. identifyexecutor()),IntroToggleIcon = "rbxassetid://7734091286", HidePremium = false, SaveConfig = false, IntroEnabled = true, ConfigFolder = "slap battles"})

	---Bypass----

	local bypass;
	bypass = hookmetamethod(game, "__namecall", function(method, ...) 
		if getnamecallmethod() == "FireServer" and method == game.ReplicatedStorage.Ban then
			return
		elseif getnamecallmethod() == "FireServer" and method == game.ReplicatedStorage.AdminGUI then
			return
		elseif getnamecallmethod() == "FireServer" and method == game.ReplicatedStorage.WalkSpeedChanged then
			return
		end
		return bypass(method, ...)
	end)

	---Potion---

	getgenv().GetPotion = {
		["Grug"] = {"Mushroom"},
		["idIot"] = {"Cake Mix"},
		["Nightmare"] = {"Dark Root","Dark Root","Dark Root"},
		["Confusion"] = {"Red Crystal","Blue Crystal","Glowing Mushroom"},
		["Power"] = {"Dire Flower","Red Crystal","Wild Vine"},
		["Paralyzing"] = {"Plane Flower","Plane Flower"},
		["Haste"] = {"Autumn Sprout","Jade Stone"},
		["Invisibility"] = {"Hazel Lily","Hazel Lily","Blue Crystal"},
		["Explosion"] = {"Red Crystal","Fire Flower","Fire Flower"},
		["Invincible"] = {"Elder Wood","Mushroom","Mushroom"},
		["Toxic"] = {"Dark Root","Dark Root","Blood Rose","Red Crystal"},
		["Freeze"] = {"Winter Rose","Winter Rose","Wild Vine","Blue Crystal","Glowing Mushroom"},
		["Feather"] = {"Mushroom","Hazel Lily"},
		["Speed"] = {"Mushroom","Mushroom","Plane Flower","Hazel Lily","Blue Crystal"},
		["Lethal"] = {"Blood Rose","Blood Rose","Blood Rose","Blood Rose","Blood Rose","Blood Rose","Blood Rose","Blood Rose","Blood Rose","Blood Rose","Dark Root","Dark Root","Dark Root","Dark Root","Dark Root","Dark Root","Dark Root","Dark Root","Dark Root","Dark Root"},
		["Slow"] = {"Mushroom","Mushroom","Blue Crystal","Blue Crystal","Jade Stone","Plane Flower"},
		["Antitoxin"] = {"Blue Crystal","Glowing Mushroom","Plane Flower","Plane Flower","Elder Wood"},
		["Corrupted Vine"] = {"Wild Vine","Wild Vine","Wild Vine","Blood Rose","Dark Root","Elder Wood","Jade Stone"},
		["Field"] = {"Hazel Lily","Plane Flower","Plane Flower"}
	}

	---GetSome---

	if not game.ReplicatedStorage:FindFirstChild("robAnimation") then
		local robAnim = Instance.new("Animation")
		robAnim.AnimationId = "rbxassetid://13675136513"
		robAnim.Parent = game.ReplicatedStorage
		robAnim.Name = "robAnimation"
	end

	if game.Workspace:FindFirstChild("NametagChanged") == nil then
		local NametagChanged = Instance.new("StringValue", workspace)
		NametagChanged.Name = "NametagChanged"
		NametagChanged.Value = ""

		local SlapChanged = Instance.new("StringValue", NametagChanged)
		SlapChanged.Name = "SlapChanged"
		SlapChanged.Value = ""
	end

	--Script - 15
	local Info = Window:MakeTab({
		Name = "Info",
		Icon = "rbxassetid://7734053426",
		PremiumOnly = false
	})

	local Script = Window:MakeTab({
		Name = "Script",
		Icon = "rbxassetid://8997387937",
		PremiumOnly = false
	})

	local Anti = Window:MakeTab({
		Name = "Anti",
		Icon = "rbxassetid://7734056608",
		PremiumOnly = false
	})

	local Badges = Window:MakeTab({
		Name = "Badges",
		Icon = "rbxassetid://7733673987",
		PremiumOnly = false
	})

	local LocalPlayer = Window:MakeTab({
		Name = "LocalPlayer",
		Icon = "rbxassetid://4335489011",
		PremiumOnly = false
	})

	local Misc = Window:MakeTab({
		Name = "Misc",
		Icon = "rbxassetid://4370318685",
		PremiumOnly = false
	})

	local GlovesFunctions = Window:MakeTab({
		Name = "Gloves Functions",
		Icon = "rbxassetid://7733955740",
		PremiumOnly = false
	})

	local Troll = Window:MakeTab({
		Name = "Troll",
		Icon = "rbxassetid://7733917120",
		PremiumOnly = false
	})

	local Credits = Window:MakeTab({
		Name = "Credits",
		Icon = "rbxassetid://7733955511",
		PremiumOnly = false
	})

	Info:AddParagraph("Zalo | Discord"," [ Zalo ]: Bạn muốn vào nhóm Zalo thì vào Credit nhé có link nhóm Zalo đó | [ Discord ]: If you want to join the Server hack slap battles group, go to the credits section ] | Good Luck")
	local InfoServer = Info:AddSection({Name = "Info Server"})
	CanYouFps = Info:AddLabel("Your Fps: [ "..math.floor(workspace:GetRealPhysicsFPS()).." ]")
	CanYouPing = Info:AddLabel("Your Ping: [ "..game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString().." ]")
	ServerPlayer = Info:AddLabel("Player In Server: [ "..#Players:GetPlayers().." / "..Players.MaxPlayers.." ]")
	TimeServer = Info:AddLabel("Server Time: [ "..math.floor(workspace.DistributedGameTime / 60 / 60).." Hour | "..math.floor(workspace.DistributedGameTime / 60) - (math.floor(workspace.DistributedGameTime / 60 / 60) * 60).." Minute | "..math.floor(workspace.DistributedGameTime) - (math.floor(workspace.DistributedGameTime / 60) * 60).." Second ]")
	TimeNow = Info:AddLabel("Now Time: [ "..os.date("%X").." ]")
	AgeAccYou = Info:AddLabel("Your Account Age: [ "..plr.AccountAge.." ]")
	ViewAgeServer = Info:AddLabel("Server Age: [ "..game.Workspace.Lobby.ServerAge.Text.SurfaceGui.TextLabel.Text.." ]")
	CodeKeypad = Info:AddLabel("Code Keypad [ "..tostring((#Players:GetPlayers()) * 25 + 1100 - 7).." ]")
	if game.Workspace:FindFirstChild("Keypad") then
		KeypadSpawn = Info:AddLabel("Keypad Spawned: [ Yes ]")
	else
		KeypadSpawn = Info:AddLabel("Keypad Spawned: [ No ]")
	end
	if game.Workspace:FindFirstChild("Toolbox") then
		ToolboxSpawn = Info:AddLabel("Are Toolbox Spawned: [ Yes ]")
	else
		ToolboxSpawn = Info:AddLabel("Are Toolbox Spawned: [ No ]")
	end
	if game.Workspace:FindFirstChild("SiphonOrb") then
		SiphonOrbSpawn = Info:AddLabel("Spawned Siphon Orb: [ Yes ]")
	else
		SiphonOrbSpawn = Info:AddLabel("Spawned Siphon Orb: [ No ]")
	end
	CheckSlap = Info:AddLabel("Slaps You Have: [ "..GetSlaps().." ]")
	Glove = Info:AddLabel("You're Using Glove: [ "..GetEquippedGlove().." ]")
	PlateTime = Info:AddLabel("Plate Time: [ "..plr.PlayerGui:WaitForChild("PlateIndicator"):FindFirstChild("TextLabel").Text.." ]")
	Info:AddParagraph("Game ID: [ "..game.PlaceId.." ]","Job ID: [ "..game.JobId.." ]")
	local InfoServer = Info:AddSection({Name = "Local Player"})
	if char:FindFirstChild("rock") then
		WalkspeedYou = Info:AddLabel("Walk Speed [ Not Walk then rock ]")
		JumppowerYou = Info:AddLabel("Jump Power [ Not Jump Power then rock ]")
		HealthYou = Info:AddLabel("Health You [ Not Health then rock ]")
		HipHeightYou = Info:AddLabel("Hip Height [ Not Hip then rock ]")
	else
		WalkspeedYou = Info:AddLabel("Walk Speed [ "..char.Humanoid.WalkSpeed.." ]")
		JumppowerYou = Info:AddLabel("Jump Power [ "..char.Humanoid.JumpPower.." ]")
		HealthYou = Info:AddLabel("Health You [ "..char.Humanoid.Health.." ]")
		HipHeightYou = Info:AddLabel("Hip Height [ "..char.Humanoid.HipHeight.." ]")
	end
	GravityYou = Info:AddLabel("Gravity [ "..game.Workspace.Gravity.." ]")
	PositionYou = Info:AddLabel("Position In Your [ "..tostring(math.round(char.HumanoidRootPart.Position.X)..", ".. math.round(char.HumanoidRootPart.Position.Y)..", "..math.round(char.HumanoidRootPart.Position.Z)).." ]")

	game:GetService("RunService").RenderStepped:Connect(function()
		
		local servertime = game.Workspace:WaitForChild("Lobby"):WaitForChild("ServerAge"):FindFirstChild("Text"):FindFirstChild("SurfaceGui"):FindFirstChild("TextLabel").Text
		local OnlyTheNumbersInTheText = servertime:gsub("%D+", "")
		local Time = tonumber(OnlyTheNumbersInTheText)
		
		CanYouFps:Set("Your Fps: [ "..math.floor(workspace:GetRealPhysicsFPS()).." ]")
		CanYouPing:Set("Your Ping: [ "..game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString().." ]")
		ServerPlayer:Set("Player In Server: [ "..#Players:GetPlayers().." / "..Players.MaxPlayers.." ]")
		TimeServer:Set("Time In Server (Time Playing): [ "..math.floor(workspace.DistributedGameTime / 60 / 60).." Hour | "..math.floor(workspace.DistributedGameTime / 60) - (math.floor(workspace.DistributedGameTime / 60 / 60) * 60).." Minute | "..math.floor(workspace.DistributedGameTime) - (math.floor(workspace.DistributedGameTime / 60) * 60).." Second ]")
		TimeNow:Set("Now Time: [ "..os.date("%X").." ]")
		AgeAccYou:Set("Your Account Age: [ "..plr.AccountAge.." ]")
		ViewAgeServer:Set("Server Age: [ " .. Time .. " ]")
		CodeKeypad:Set("Elude Code Keypad: [ "..tostring((#Players:GetPlayers()) * 25 + 1100 - 7).." ]")
		if game.Workspace:FindFirstChild("Keypad") then
			KeypadSpawn:Set("Keypad Spawned: [ Yes ]")
		else
			KeypadSpawn:Set("Keypad Spawned: [ No ]")
		end
		if game.Workspace:FindFirstChild("Toolbox") then
			ToolboxSpawn:Set("Are Toolbox Spawned: [ Yes ]")
		else
			ToolboxSpawn:Set("Are Toolbox Spawned: [ No ]")
		end
		if game.Workspace:FindFirstChild("SiphonOrb") then
			SiphonOrbSpawn:Set("Spawned Siphon Orb: [ Yes ]")
		else
			SiphonOrbSpawn:Set("Spawned Siphon Orb: [ No ]")
		end
		CheckSlap:Set("Total Slaps Quantity: [ "..GetSlaps().." ]")
		Glove:Set("You're Using Glove: [ "..GetEquippedGlove().." ]")
		PlateTime:Set("Plate Time: [ "..plr.PlayerGui.PlateIndicator.TextLabel.Text.." ]")
		if char:FindFirstChild("rock") then
			WalkspeedYou:Set("Walk Speed: [ Can't Get while being a Rock ]")
			JumppowerYou:Set("Jump Power: [ Can't Get while being a Rock ]")
			HealthYou:Set("Your Health: [ Can't Get while being a Rock ]")
			HipHeightYou:Set("Hip Height: [ Can't Get while being a Rock ]")
		else
			WalkspeedYou:Set("Walk Speed: [ "..char.Humanoid.WalkSpeed.." ]")
			JumppowerYou:Set("Jump Power: [ "..char.Humanoid.JumpPower.." ]")
			HealthYou:Set("Your Health: [ "..char.Humanoid.Health.." ]")
			HipHeightYou:Set("Hip Height: [ "..char.Humanoid.HipHeight.." ]")
		end
		GravityYou:Set("Gravity: [ "..game.Workspace.Gravity.." ]")
		PositionYou:Set("Your Current Position: [ "..tostring(math.round(char.HumanoidRootPart.Position.X)..", ".. math.round(char.HumanoidRootPart.Position.Y)..", "..math.round(char.HumanoidRootPart.Position.Z)).." ]")
	end)

	local InfoServer = Info:AddSection({Name = "Notification"})
	Info:AddLabel("------------------------------[ Warning ]------------------------------")
	Info:AddParagraph("[ Admin ]","[ Banned Hackers which node is not good ]")
	Info:AddParagraph("[ Record ]","[ When someone records it, you got a 90% ban ]")
	Info:AddParagraph("[ Lucky ]","[ If you are lucky enough to survive the banned then you are lucky ]")
	Info:AddParagraph("[ Tired ]","I'm Very Tired of Script and Script Update is slow. Please forgive me because I update slowly")
	Info:AddParagraph("[ Script Giang ]","This script was created by Giang, but there is a problem when creating a feature but no one testing no one can help me see if it works | I'm really sorry that I couldn't do the feature and it all failed and didn't work | I hope everyone understands me")
	Info:AddLabel("------------------------------[ End ]------------------------------")

	Script:AddButton({
		Name = "Synapse X [ PE Delta ]",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/delta-hydro/secret-host-haha/main/syn_ui_new.lua"))()
		end    
	})

	Script:AddButton({
		Name = "Codex [ PE ]",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/Codex.lua"))()
		end    
	})

	Script:AddButton({
		Name = "Kiwi [ PE ]",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/Kiwi-Ui.lua"))()
		end    
	})

	Script:AddButton({
		Name = "Krypton [ PE ]",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/Krypton.lua"))()
		end    
	})

	Script:AddButton({
		Name = "Krnl [ PE ]",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/Knrl.lua"))()
		end    
	})

	Script:AddButton({
		Name = "Animation [ PE ]",
		Callback = function()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/IlikeyocutgHAH12/EGEGESGGH/main/FE%20Animation%20GUI.txt'))()
		end    
	})

	Script:AddButton({
		Name = "Arceus x [ PE ]",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/Arceus_X_V3.lua"))()
		end    
	})

	Script:AddButton({
		Name = "Execute | Ui Library [ PE ]",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/Execute%20%7C%20UI%20Library.lua"))()
		end    
	})

	Script:AddButton({
		Name = "Kill Player [ PE ]",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/Kill%20player"))()
		end    
	})

	Script:AddButton({
		Name = "Keyboard",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt", true))()
		end    
	})

	Script:AddButton({
		Name = "Rejoin Gui",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/Rejoin.lua"))()
		end    
	})

	Script:AddButton({
		Name = "Inf yield Delta",
		Callback = function()
			loadstring(game:HttpGet("https://gist.githubusercontent.com/lxnnydev/c533c374ca4c1dcef4e1e10e33fa4a0c/raw/03e74f184f801dad77d3ebe1e2f18c6ac87ca612/delta___IY.gistfile1.txt.lua",true))()
		end    
	})

	Script:AddButton({
		Name = "Inf yield",
		Callback = function()
			loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
		end    
	})

	Script:AddButton({
		Name = "Hitbox",
		Callback = function()
			loadstring(game:HttpGet(("https://gist.githubusercontent.com/stellar-4242/430ef3087d8d87eb306ca03e728ffbb8/raw/798429dd908b1f4471a1fa569ff62c5e5a93ec61/SLAP.LUA")))()
		end    
	})

	Script:AddButton({
		Name = "Slap battles new R2O",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/cheesynob39/R2O/main/Games/6403373529.lua"))()
		end    
	})

	Script:AddButton({
		Name = "Auto Farm Bob",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Slap_Battles/main/File/Farm%20Bob.lua"))()
		end    
	})

	Script:AddButton({
		Name = "CherryUi's SB GUI",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/RandomScriptr3/gggggggg/main/lolez.txt", true))()
		end    
	})

	Script:AddButton({
		Name = "Position Gui",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/Position_Gui.lua", true))()
		end    
	})

	Script:AddButton({
		Name = "Fe Fly V3",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/Fly_V3.lua"))()
		end    
	})

	Script:AddButton({
		Name = "MoonUI v10",
		Callback = function()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/IlikeyocutgHAH12/MoonUI-v10-/main/MoonUI%20v10'))()
		end    
	})

	Script:AddButton({
		Name = "Btool Cute",
		Callback = function()
			loadstring(game:GetObjects("rbxassetid://6695644299")[1].Source)()
		end    
	})

	Script:AddButton({
		Name = "Dex V2",
		Callback = function()
			loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
		end    
	})

	Script:AddButton({
		Name = "Dex V3",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
		end    
	})

	Script:AddButton({
		Name = "TP gui player",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/TP_Player.lua"))()
		end    
	})

	Script:AddButton({
		Name = "Turies Spy",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/Reamsrpy.lua", true))()
		end    
	})

	Script:AddButton({
		Name = "Simple Spy",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/RemoteSpy-V2.lua", true))()
		end    
	})

	Script:AddButton({
		Name = "Hydroxide",
		Callback = function()
			local owner = "Upbolt"
			local branch = "revision"
			local function webImport(file)
				return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
			end
			webImport("init")
			webImport("ui/main")
		end    
	})

	Badges:AddDropdown({
		Name = "Teleport Safe",
		Default = "",
		Options = {"SafeSpotBox 1.0", "SafeSpotBox 2.0", "Bed"},
		Callback = function(Value)
			if Value == "SafeSpotBox 1.0" then
				char.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
			elseif Value == "SafeSpotBox 2.0" then
				char.HumanoidRootPart.CFrame = workspace["Safespot"].CFrame * CFrame.new(0,10,0)
			elseif Value == "Bed" then
				char.HumanoidRootPart.CFrame = workspace["Bed"].Bed3.CFrame * CFrame.new(0,0,-1)
			end
		end    
	})

	Badges:AddDropdown({
		Name = "Retro Obby",
		Default = "",
		Options = {"Get Badge", "Show All", "Off Show All", "Teleport Spawn 1", "Teleport Spawn 2", "Teleport Spawn 3", "Click Button"},
		Callback = function(Value)
			if Value == "Get Badge" then
				char.HumanoidRootPart.CFrame = workspace.FinishDoor_Retro.Part.CFrame
			elseif Value == "Show All" then
				game.ReplicatedStorage.Assets.Retro.Parent = game.Workspace
			elseif Value == "Off Show All" then
				game.Workspace.Retro.Parent = game.ReplicatedStorage.Assets
			elseif Value == "Teleport Spawn 1" then
				char.HumanoidRootPart.CFrame = game.Workspace.Retro.Map.RetroObbyMap.Spawn.CFrame
			elseif Value == "Teleport Spawn 2" then
				char.HumanoidRootPart.CFrame = game.Workspace.Retro.Map.RetroObbyMap.Spawn_stage2.CFrame
			elseif Value == "Teleport Spawn 3" then
				char.HumanoidRootPart.CFrame = game.Workspace.Retro.Map.RetroObbyMap.Spawn_stage3.CFrame
			elseif Value == "Click Button" then
				if game:GetService("ReplicatedStorage").Assets.Retro then
					game.ReplicatedStorage.Assets.Retro.Parent = workspace
					wait(1.5)
					fireclickdetector(workspace.Retro.Map.RetroObbyMap:GetChildren()[5].StaffApp.Button.ClickDetector)
				else
					fireclickdetector(workspace.Retro.Map.RetroObbyMap:GetChildren()[5].StaffApp.Button.ClickDetector)
				end
			end
		end    
	})

	Badges:AddDropdown({
		Name = "Repressed Memory",
		Default = "",
		Options = {"Show All","Off Show All","Teleport Enter","Teleport Portal","Teleport Bob Plushie","Click Bob Plushie [ Quests Hitman ]"},
		Callback = function(Value)
			if Value == "Show All" then
				game.ReplicatedStorage.RepressedMemoriesMap.Parent = game.Workspace
			elseif Value == "Off Show All" then
				game.Workspace.RepressedMemoriesMap.Parent = game.ReplicatedStorage
			elseif Value == "Teleport Enter" then
				char.HumanoidRootPart.CFrame = game.Workspace.RepressedMemories.Limbo.CFrame * CFrame.new(0,-5,0)
			elseif Value == "Teleport Portal" then
				char.HumanoidRootPart.CFrame = game.Workspace.RepressedMemories.SimonSaysGate.Portal.CFrame
			elseif Value == "Teleport Bob Plushie" then
				char.HumanoidRootPart.CFrame = game.Workspace.RepressedMemories._ugcQuestObjectBobPlushie.Handle.CFrame
			elseif Value == "Click Bob Plushie [ Quests Hitman ]" then
				if game:GetService("ReplicatedStorage").RepressedMemoriesMap then
					game.ReplicatedStorage.RepressedMemoriesMap.Parent = game.Workspace
					wait(1)
					char.HumanoidRootPart.CFrame = game.Workspace.RepressedMemories._ugcQuestObjectBobPlushie.Handle.CFrame
					wait(0.5)
					fireclickdetector(workspace.RepressedMemories._ugcQuestObjectBobPlushie.ClickDetector)
					wait(2)
					game.Workspace.RepressedMemoriesMap.Parent = game.ReplicatedStorage
				else
					char.HumanoidRootPart.CFrame = game.Workspace.RepressedMemories._ugcQuestObjectBobPlushie.Handle.CFrame
					wait(0.7)
					fireclickdetector(workspace.RepressedMemories._ugcQuestObjectBobPlushie.ClickDetector)
					wait(2)
					game.Workspace.RepressedMemoriesMap.Parent = game.ReplicatedStorage
				end
			end
		end    
	})

	Badges:AddDropdown({
		Name = "Map Kraken",
		Default = "",
		Options = {"Show All","Off Show All", "Teleport Enter"},
		Callback = function(Value)
			if Value == "Show All" then
				game.ReplicatedStorage.AbyssAssets.Abyss.Parent = game.Workspace
			elseif Value == "Off Show All" then
				game.Workspace.Abyss.Parent = game.ReplicatedStorage.AbyssAssets
			elseif Value == "Teleport Enter" then
				char.HumanoidRootPart.CFrame = CFrame.new(194, 35, -12671)
			end
		end    
	})

	Badges:AddButton({
		Name = "Reset Player",
		Callback = function()
			if char.Humanoid.Health ~= 0 then
				game:GetService("ReplicatedStorage"):WaitForChild("HumanoidDied"):FireServer(char,false)
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You are already dead",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})


				--OGL = char.HumanoidRootPart.CFrame
				--for i = 1,150 do
				--	game.ReplicatedStorage.SelfKnockback:FireServer({["Force"] = 0,["Direction"] = Vector3.new(0,0.01,0)})
				--	wait(0.05)
				--end
				--wait(1.5)
				--repeat
				--	local players = Players:GetChildren()
				--	local RandomPlayer = players[math.random(1, #players)]
				--	repeat RandomPlayer = players[math.random(1, #players)] until RandomPlayer ~= plr and RandomPlayer.Character:FindFirstChild("entered") and RandomPlayer.Character:FindFirstChild("rock") == nil and RandomPlayer.Character.Head:FindFirstChild("UnoReverseCard") == nil and RandomPlayer.Character.Humanoid.Health ~= 0
				--	Target = RandomPlayer
				--	char.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0,-20,0)
				--	wait(0.25)
				--	game.ReplicatedStorage.StunR:FireServer(char.Stun)
				--	char.HumanoidRootPart.CFrame = OGL
				--	wait(0.5)
				--	if char and char:FindFirstChild("EMPStunBadgeCounter") then
				--		OrionLib:MakeNotification({Name = "Error",Content = "Counter Stun [ "..char.EMPStunBadgeCounter.Value.." ]",Image = "rbxassetid://7733658504",Time = 5})
				--	end
				--	wait(12.3)
				--until char:FindFirstChild("EMPStunBadgeCounter") and char.EMPStunBadgeCounter.Value >= 50


function GetEquippedGlove()
	return plr:WaitForChild("leaderstats"):FindFirstChild("Glove").Value
end

function GetSlaps()
	return plr:WaitForChild("leaderstats"):FindFirstChild("Slaps").Value
end

	Badges:AddButton({
		Name = "Get Glove Kinetic",
		Callback = function()
			
		end 
	})

	Badges:AddButton({
		Name = "Win Obby Pyscho",
		Callback = function()
			if game.Workspace:FindFirstChild("RepressedMemoriesMap") ~= nil then
				local OGL = game.Workspace.RepressedMemoriesMap.Psychokinesis.Triggers.StartPsychoEvent.CFrame
				local OGL1 = game.Workspace.RepressedMemoriesMap.Psychokinesis.Triggers.StopPsychoEvent.CFrame
				wait(0.5)
				game.Workspace.RepressedMemoriesMap.Psychokinesis.Triggers.StartPsychoEvent.CFrame = char.HumanoidRootPart.CFrame
				wait(2.5)
				game.Workspace.RepressedMemoriesMap.Psychokinesis.Triggers.StartPsychoEvent.CFrame = OGL
				wait(2.5)
				game.Workspace.RepressedMemoriesMap.Psychokinesis.Triggers.StopPsychoEvent.CFrame = char.HumanoidRootPart.CFrame
				wait(2.5)
				game.Workspace.RepressedMemoriesMap.Psychokinesis.Triggers.StopPsychoEvent.CFrame = OGL1
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You have enter limbo [ don't show all, not work ]",Image = "rbxassetid://7733658504",Time = 5})
			end
		end 
	})

	Badges:AddButton({
		Name = "Get Glove Bomb",
		Callback = function()
			if GetEquippedGlove() == "Warp" and not game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2124919840) then
				local OldTouch = workspace.DEATHBARRIER.CanTouch
				local players = Players:GetChildren()
				local RandomPlayer = players[math.random(1, #players)]
				repeat RandomPlayer = players[math.random(1, #players)] until RandomPlayer ~= plr and RandomPlayer.Character:FindFirstChild("entered") and RandomPlayer.Character:FindFirstChild("Ragdolled").Value == false
				Target = RandomPlayer
				char.HumanoidRootPart.CFrame = Target.Character:FindFirstChild("HumanoidRootPart").CFrame
				task.wait(0.2)
				game.ReplicatedStorage.WarpHt:FireServer(Target.Character:WaitForChild("HumanoidRootPart"))
				task.wait(0.15)
				if workspace.DEATHBARRIER.CanTouch == true then
					char.HumanoidRootPart.CFrame = game:GetService("Workspace").DEATHBARRIER.CFrame
				else
					workspace.DEATHBARRIER.CanTouch = true
					char.HumanoidRootPart.CFrame = game:GetService("Workspace").DEATHBARRIER.CFrame
				end
				wait(0.1)
				game:GetService("ReplicatedStorage").WLOC:FireServer()
				wait(0.2)
				workspace.DEATHBARRIER.CanTouch = OldTouch
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Warp equipped, or you have owner badge",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	Badges:AddButton({
		Name = "Get Glove Warp",
		Callback = function()
			if GetEquippedGlove() == "Swapper" and not game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2124914780) then
				if getgenv().ClosestMagnitude == nil then
					getgenv().ClosestMagnitude = 999999
				end
				repeat
					for _, v in pairs(Players:GetPlayers()) do
						if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("entered") then
							local Magnitude = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
							if Magnitude <= getgenv().ClosestMagnitude then
								if v.Character:FindFirstChild("entered") == nil or v.Character.Humanoid.Health == 0 then
									getgenv().ClosestMagnitude = 999999
									RandomPlayer = nil
								else
									getgenv().ClosestMagnitude = Magnitude
									RandomPlayer = v
								end
							end
						end
					end
					if RandomPlayer and getgenv().ClosestMagnitude ~= 999999 then
						if RandomPlayer ~= plr and char:FindFirstChild("HumanoidRootPart") and RandomPlayer.Character then
							if char:FindFirstChild("entered") and RandomPlayer.Character:FindFirstChild("entered") and RandomPlayer.Character:FindFirstChild("HumanoidRootPart") and RandomPlayer.Character.Ragdolled.Value == false then
								char.HumanoidRootPart.CFrame = RandomPlayer.Character:FindFirstChild("Head").CFrame
								wait(0.17)
								game.ReplicatedStorage.HitSwapper:FireServer(RandomPlayer.Character:WaitForChild("Head"))
								char.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
							end
						end
					end
					task.wait(0.15)
				until RandomPlayer.Character.HumanoidRootPart.Position.Y < -10
				wait(0.2)
				char.HumanoidRootPart.CFrame = RandomPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,10,0)
				wait(0.15)
				game:GetService("ReplicatedStorage").SLOC:FireServer()
				wait(0.2)
				if getgenv().ClosestMagnitude and RandomPlayer then
					getgenv().ClosestMagnitude = nil
					RandomPlayer = nil
				end
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Swapper equipped, or you have owner badge",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	Badges:AddButton({
		Name = "Get Glove Plank",
		Callback = function()
			if GetEquippedGlove() == "Fort" and not game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 4031317971987872) then
				OGL = char.HumanoidRootPart.CFrame
				char.HumanoidRootPart.CFrame = CFrame.new(8, 97, 4)
				wait(0.2)
				char.HumanoidRootPart.Anchored = true
				wait(0.3)
				game:GetService("ReplicatedStorage").Fortlol:FireServer()
				wait(3.5)
				char.HumanoidRootPart.Anchored = false
				wait(0.1)
				char.HumanoidRootPart.CFrame = CFrame.new(8, 106, -6)
				wait(0.5)
				char.HumanoidRootPart.CFrame = OGL
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Fort equipped, or you have owner badge [ Don't turn on shiftlock ]",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	Badges:AddButton({
		Name = "Get Glove Blasphemy",
		Callback = function()
			if GetEquippedGlove() == "bus" and not game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 3335299217032061) then
				OGL = char.HumanoidRootPart.CFrame
				repeat
					if char.Humanoid.Health == 0 or char:FindFirstChild("entered") == nil then
						break
					end
					if char:FindFirstChild("entered") then
						local players = Players:GetChildren()
						local RandomPlayer = players[math.random(1, #players)]
						repeat RandomPlayer = players[math.random(1, #players)] until RandomPlayer ~= plr and RandomPlayer.Character:FindFirstChild("rock") == nil and RandomPlayer.Character.Head:FindFirstChild("UnoReverseCard") == nil and RandomPlayer.Character:FindFirstChild("entered")
						Target = RandomPlayer
						char.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
						task.wait(0.34)
						game:GetService("ReplicatedStorage").busmoment:FireServer()
						char.HumanoidRootPart.CFrame = OGL
						wait(1.5)
						game.ReplicatedStorage.SelfKnockback:FireServer({["Force"] = 0,["Direction"] = Vector3.new(0,0.01,0)})
						wait(0.8)
						for i = 1,50 do
							for i,v in pairs(game.Workspace:GetChildren()) do
								if v.Name == "BusModel" then
									v.CFrame = char.HumanoidRootPart.CFrame
								end
							end
							task.wait()
						end
					end
					task.wait(3.5)
				until game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 3335299217032061)
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have bus equipped, or you have owner badge",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	Badges:AddButton({
		Name = "Auto Quests Chest All Glove",
		Callback = function()
			if char:FindFirstChild("entered") then
				repeat task.wait()
					char.HumanoidRootPart.CFrame = CFrame.new(289, 13, 261)
					game:GetService("ReplicatedStorage").DigEvent:FireServer({["index"] = 2,["cf"] = CFrame.new(42.7222366, -6.17449856, 91.5175781, -0.414533257, 1.72594355e-05, -0.91003418, -5.57037238e-05, 1, 4.4339522e-05, 0.91003418, 6.90724992e-05, -0.414533257)})
				until game.Workspace:FindFirstChild("TreasureChestFolder") ~= nil and game.Workspace.TreasureChestFolder:FindFirstChild("TreasureChest") ~= nil
				wait(1)
				game.Workspace.TreasureChestFolder.TreasureChest.OpenRemote:FireServer()
				wait(0.9)
				game.ReplicatedStorage.HumanoidDied:FireServer(char,false)
				wait(3.75)
				char.HumanoidRootPart.CFrame = workspace.BountyHunterRoom.BountyHunterBooth._configPart.CFrame * CFrame.new(-5,0,0)
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You have enter arena",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	Badges:AddButton({
		Name = "Auto Get Glove FrostBite",
		Callback = function()
			plr.OnTeleport:Connect(function(state) 
				if state ~= Enum.TeleportState.Failed then
					if not game:IsLoaded() then
						game.Loaded:Wait()
					end
					repeat wait() until plr
					char.HumanoidRootPart.CFrame = CFrame.new(-554, 177, 56)
					wait(0.7)
					for i,v in ipairs(game:GetService("Workspace"):GetDescendants()) do
						if v.ClassName == "ProximityPrompt" then
							fireproximityprompt(v)
						end
					end
				end
			end)
			game:GetService("TeleportService"):Teleport(17290438723)
		end 
	})

	Badges:AddButton({
		Name = "Auto Get Glove Admin",
		Callback = function()
			plr.OnTeleport:Connect(function(state)
				if state ~= Enum.TeleportState.Failed then
					if queueteleport then
						queueteleport([[
					    if not game:IsLoaded() then
           			      game.Loaded:Wait()
       				    end
         			    repeat wait() until plr
						wait(13.5)
					    char.HumanoidRootPart.CFrame = CFrame.new(502, 76, 59)
						task.wait(6)
						if getconnections then
							for i,v in next, getconnections(plr.Idled) do
								v:Disable() 
							end
						end
						]])
					end
				end
			end)
			
			if game:GetService("ReplicatedStorage").Assets.Retro then
				game.ReplicatedStorage.Assets.Retro.Parent = workspace
				wait(1.5)
				fireclickdetector(workspace.Retro.Map.RetroObbyMap:GetChildren()[5].StaffApp.Button.ClickDetector)
			else
				fireclickdetector(workspace.Retro.Map.RetroObbyMap:GetChildren()[5].StaffApp.Button.ClickDetector)
			end
		end    
	})

	Badges:AddButton({
		Name = "Get Glove Chain",
		Callback = function()
			if GetSlaps() >= 1000 then
				if queueteleport then
					queueteleport([[
					if not game:IsLoaded() then
						game.Loaded:Wait()
					end
					repeat wait() until plr
					repeat wait() until game.Workspace:FindFirstChild("Map"):FindFirstChild("CodeBrick")
					if game.Workspace.Map.CodeBrick.SurfaceGui:FindFirstChild("IMGTemplate") then
						game.Workspace.Map.CodeBrick.SurfaceGui.IMGTemplate.Name = "1st"
						game.Workspace.Map.CodeBrick.SurfaceGui.IMGTemplate.Name = "2nd"
						game.Workspace.Map.CodeBrick.SurfaceGui.IMGTemplate.Name = "3rd"
						game.Workspace.Map.CodeBrick.SurfaceGui.IMGTemplate.Name = "4th"
					end
					local first
					local second
					local third
					local fourth
					
					for i,v in pairs(game.Workspace.Map.CodeBrick.SurfaceGui:GetChildren()) do
						if v.Name == "1st" then
							if v.Image == "http://www.roblox.com/asset/?id=9648769161" then
								first = "4"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648765536" then
								first = "2"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648762863" then
								first = "3"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648759883" then
								first = "9"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648755440" then
								first = "8"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648752438" then
								first = "2"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648749145" then
								first = "8"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648745618" then
								first = "3"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648742013" then
								first = "7"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648738553" then
								first = "8"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648734698" then
								first = "2"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648730082" then
								first = "6"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648723237" then
								first = "3"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648718450" then
								first = "6"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648715920" then
								first = "6"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648712563" then
								first = "2"
							end
						end
					end
					for i,v in pairs(game.Workspace.Map.CodeBrick.SurfaceGui:GetChildren()) do
						if v.Name == "2nd" then
							if v.Image == "http://www.roblox.com/asset/?id=9648769161" then
								second = "4"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648765536" then
								second = "2"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648762863" then
								second = "3"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648759883" then
								second = "9"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648755440" then
								second = "8"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648752438" then
								second = "2"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648749145" then
								second = "8"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648745618" then
								second = "3"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648742013" then
								second = "7"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648738553" then
								second = "8"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648734698" then
								second = "2"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648730082" then
								second = "6"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648723237" then
								second = "3"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648718450" then
								second = "6"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648715920" then
								second = "6"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648712563" then
								second = "2"
							end
						end
					end
					for i,v in pairs(game.Workspace.Map.CodeBrick.SurfaceGui:GetChildren()) do
						if v.Name == "3rd" then
							if v.Image == "http://www.roblox.com/asset/?id=9648769161" then
								third = "4"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648765536" then
								third = "2"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648762863" then
								third = "3"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648759883" then
								third = "9"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648755440" then
								third = "8"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648752438" then
								third = "2"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648749145" then
								third = "8"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648745618" then
								third = "3"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648742013" then
								third = "7"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648738553" then
								third = "8"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648734698" then
								third = "2"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648730082" then
								third = "6"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648723237" then
								third = "3"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648718450" then
								third = "6"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648715920" then
								third = "6"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648712563" then
								third = "2"
							end
						end
					end
					for i,v in pairs(game.Workspace.Map.CodeBrick.SurfaceGui:GetChildren()) do
						if v.Name == "4th" then
							if v.Image == "http://www.roblox.com/asset/?id=9648769161" then
								fourth = "4"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648765536" then
								fourth = "2"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648762863" then
								fourth = "3"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648759883" then
								fourth = "9"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648755440" then
								fourth = "8"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648752438" then
								fourth = "2"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648749145" then
								fourth = "8"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648745618" then
								fourth = "3"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648742013" then
								fourth = "7"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648738553" then
								fourth = "8"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648734698" then
								fourth = "2"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648730082" then
								fourth = "6"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648723237" then
								fourth = "3"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648718450" then
								fourth = "6"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648715920" then
								fourth = "6"
							elseif v.Image == "http://www.roblox.com/asset/?id=9648712563" then
								fourth = "2"
							end
						end
					end
					fireclickdetector(game.Workspace.Map.OriginOffice.Door.Keypad.Buttons.Reset.ClickDetector)
					task.wait(0.1)
					fireclickdetector(game.Workspace.Map.OriginOffice.Door.Keypad.Buttons[first].ClickDetector)
					task.wait(0.1)
					fireclickdetector(game.Workspace.Map.OriginOffice.Door.Keypad.Buttons[second].ClickDetector)
					task.wait(0.1)
					fireclickdetector(game.Workspace.Map.OriginOffice.Door.Keypad.Buttons[third].ClickDetector)
					task.wait(0.1)
					fireclickdetector(game.Workspace.Map.OriginOffice.Door.Keypad.Buttons[fourth].ClickDetector)
					task.wait(0.1)
					fireclickdetector(game.Workspace.Map.OriginOffice.Door.Keypad.Buttons.Enter.ClickDetector)
					task.wait(2)
					game:GetService("TeleportService"):Teleport(6403373529)
					]])
				end
				game:GetService("TeleportService"):Teleport(9431156611)
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have 1000 slap.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	Badges:AddDropdown({
		Name = "Join Maze Elude",
		Default = "Auto Keypad",
		Options = {"Teleport","Auto Keypad"},
		Callback = function(Value)
			getgenv().SelectMaze = Value
		end    
	})

	Badges:AddButton({
		Name = "Get Counter + Elude",
		Callback = function()
			if getgenv().SelectMaze == "Teleport" then
				
				if queueteleport then
					queueteleport([[
					if not game:IsLoaded() then
						game.Loaded:Wait()
					end
					repeat wait() until plr
					wait(3)
					local Time = 121
					fireclickdetector(game.Workspace.CounterLever.ClickDetector)
					char.HumanoidRootPart.CFrame = CFrame.new(0,100,0)
					wait(0.2)
					char.HumanoidRootPart.Anchored = true
					for i = 1,Time do
						Time = Time - 1
						game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = "Please wait for [ '..Time..' ] until you get it.",Icon = "rbxassetid://7733658504",Duration = 1})
						wait(1)
					end
					char.HumanoidRootPart.Anchored = false
					wait(0.5)
					firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), game.Workspace.Ruins.Elude.Glove, 0)
					firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), game.Workspace.Ruins.Elude.Glove, 1)
					for i,v in pairs(workspace.Maze:GetDescendants()) do
						if v:IsA("ClickDetector") then
							fireclickdetector(v)
						end
					end
					]])
				end
				
				game:GetService("TeleportService"):Teleport(11828384869)
			elseif getgenv().SelectMaze == "Auto Keypad" then
				if not workspace:FindFirstChild("Keypad") then
					OrionLib:MakeNotification({Name = "Error",Content = "Can't find any Keypad. Starting Serverhop...",Image = "rbxassetid://7733658504",Time = 5})
					for _, server in ipairs(game.HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
						if server.playing < server.maxPlayers and server.JobId ~= game.JobId then
							game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id)
						end
					end
				else
					
					if queueteleport then
						queueteleport([[
					if not game:IsLoaded() then
						game.Loaded:Wait()
					end
					repeat wait() until plr
					wait(3)
					local Time = 121
					fireclickdetector(game.Workspace.CounterLever.ClickDetector)
					char.HumanoidRootPart.CFrame = CFrame.new(0,100,0)
					wait(0.2)
					char.HumanoidRootPart.Anchored = true
					for i = 1,Time do
						Time = Time - 1
						game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = "You wait time [ "..Time.." ] receive.",Icon = "rbxassetid://7733658504",Duration = 1})
						wait(1)
					end
					firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), game.Workspace.Ruins.Elude.Glove, 0)
					firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), game.Workspace.Ruins.Elude.Glove, 1)
					for i,v in pairs(workspace.Maze:GetDescendants()) do
						if v:IsA("ClickDetector") then
							fireclickdetector(v)
						end
					end
						]])
					end
					
					OrionLib:MakeNotification({Name = "Success",Content = "Keypad found. Starting numbers sequence...",Image = "rbxassetid://7733658504",Time = 5})
					game.Workspace.CurrentCamera.CameraSubject = workspace.Keypad.Buttons.Enter
					fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Reset").ClickDetector)
					local digits = tostring((#Players:GetPlayers()) * 25 + 1100 - 7)
					for i = 1, #digits do
						task.wait(0.8)
						local digit = digits:sub(i, i)
						fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild(digit).ClickDetector)
					end
					task.wait(0.5)
					fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Enter").ClickDetector)
				end
			end
		end    
	})

	Badges:AddButton({
		Name = "Get Glove [Redacted]",
		Callback = function()
			if not game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2124847850) then
				local Door = 0
				for i = 1, 10 do
					Door = Door + 1
				
					firetouchinterest(char:WaitForChild("Head"), workspace.PocketDimension.Doors[Door].TouchInterest.Parent, 0)
					firetouchinterest(char:WaitForChild("Head"), workspace.PocketDimension.Doors[Door].TouchInterest.Parent, 1)
				
					wait(3.75)
				end
			else
			OrionLib:MakeNotification({Name = "Error",Content = "You already have this badge.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	Badges:AddButton({
		Name = "Get Duck, Orange & Knife Badge",
		Callback = function()
			if not game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2124760907) and not game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2128220957) and not game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2124760916) then
				fireclickdetector(game.Workspace.Lobby.Scene.knofe.ClickDetector)
				fireclickdetector(game.Workspace.Arena.island5.Orange.ClickDetector) 
				fireclickdetector(game.Workspace.Arena["default island"]["Rubber Ducky"].ClickDetector)
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You already have this badge.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end 
	})

	Badges:AddButton({
		Name = "Get Ice Skate [Can get it for free]",
		Callback = function()
			if not game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2906002612987222) then
				game:GetService("ReplicatedStorage").IceSkate:FireServer("Freeze")
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You already have this badge.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end 
	})

	Badges:AddButton({
		Name = "Get Lamp [Must have ZZZZZZZ Glove]",
		Callback = function()
			--[[
							repeat task.wait()
					game:GetService("ReplicatedStorage").nightmare:FireServer("LightBroken")
				until game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 490455814138437)
			]]
			
		end 
	})

	Badges:AddButton({
		Name = "Get The Schlop",
		Callback = function()
			if GetEquippedGlove() == "Cloud" and game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2130032297) and char:FindFirstChild("entered") == nil then
				char.HumanoidRootPart.CFrame = workspace.Arena.CannonIsland.Cannon.Base.CFrame * CFrame.new(0,2,35)
				wait(0.3)
				game:GetService("ReplicatedStorage").CloudAbility:FireServer()
				fireclickdetector(workspace.Lobby.fish.ClickDetector)
				wait(0.2)
				repeat task.wait() until char
				if not char:FindFirstChild("entered") and char:FindFirstChild("HumanoidRootPart") then
					repeat task.wait()
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
					until char:FindFirstChild("entered")
				end
				wait(0.3)
				if char and char:FindFirstChild("entered") and char:FindFirstChildOfClass("Humanoid") ~= nil and char.Humanoid.Sit == false then
					for i,v in pairs(game.Workspace:GetChildren()) do
						if v.Name:match(plr.Name) and v:FindFirstChild("VehicleSeat") then
							char.HumanoidRootPart.CFrame = v.VehicleSeat.CFrame
						end
					end
				end
				wait(0.7)
				for _ = 1, 10 do
					for i,v in pairs(game.Workspace:GetChildren()) do
						if v.Name:match(plr.Name) and v:FindFirstChild("VehicleSeat") then
							v.VehicleSeat.CFrame = CFrame.new(245, 129, -91)
						end
					end
					task.wait()
				end
				wait(0.4)
				game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer()
				wait(0.5)
				repeat task.wait()
					if char and char:FindFirstChild("entered") then
						for i,v in pairs(char:GetChildren()) do
							if v.ClassName == "Part" and v.Name ~= "Humanoid" then
								v.CFrame = game.workspace.Arena.Plate.CFrame
							end
						end
					end
				until char:WaitForChild("Ragdolled").Value == false
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have equiped Cloud | Badge Fish | You are in the lobby.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end 
	})

	Badges:AddDropdown({
		Name = "Farm Bob",
		Default = "Slow",
		Options = {"Auto Spawn E", "Auto Spawn", "Fast Spawn", "Normal","Super Fast Spawn"},
		Callback = function(Value)
			Autobob = Value
		end    
	})

	GetBob = Badges:AddToggle({
		Name = "AutoFarm Bob",
		Default = false,
		Callback = function(Value)
			getgenv().AutoFarmBob = Value
			if GetEquippedGlove() == "Replica" then
				while getgenv().AutoFarmBob and Autobob == "Auto Spawn E" do
					if char:FindFirstChild("entered") or game.Workspace:FindFirstChild("bobcap") == nil then
						game:GetService("VirtualInputManager"):SendKeyEvent(true,"E",false,x)
					else
						OrionLib:MakeNotification({Name = "Error",Content = "You got Bob spawn",Image = "rbxassetid://7733658504",Time = 5})
						GetBob:Set(false)
					end
					task.wait(0.5)
				end
				while getgenv().AutoFarmBob and Autobob == "Auto Spawn" do
					if char:FindFirstChild("entered") or game.Workspace:FindFirstChild("bobcap") == nil then
						game.ReplicatedStorage.Duplicate:FireServer(true)
					else
						OrionLib:MakeNotification({Name = "Error",Content = "You got Bob spawn",Image = "rbxassetid://7733658504",Time = 5})
						GetBob:Set(false)
					end
					task.wait(5.3)
				end
				while getgenv().AutoFarmBob and Autobob == "Fast Spawn" do
					repeat task.wait() until char
					if char:FindFirstChild("entered") == nil and char:FindFirstChild("HumanoidRootPart") then
						repeat task.wait()
							firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
							firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
						until char:FindFirstChild("entered") and char:FindFirstChildWhichIsA("Tool")
						task.wait(0.5)
						game:GetService("VirtualInputManager"):SendKeyEvent(true,"E",false,x)
						if game.Workspace:FindFirstChild("bobcap") == nil then
							game:GetService("ReplicatedStorage"):WaitForChild("HumanoidDied"):FireServer(char,false)
						else
							OrionLib:MakeNotification({Name = "Error",Content = "You got Bob spawn",Image = "rbxassetid://7733658504",Time = 5})
							GetBob:Set(false)
						end
					end
					task.wait()
				end
				while getgenv().AutoFarmBob and Autobob == "Normal" do
					if char and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.RootPart and char:FindFirstChild("entered") == nil then
						for i,v in pairs(game.Workspace.Lobby:GetChildren()) do
							if v.Name == "Teleport1" and char:FindFirstChildOfClass("Humanoid") then
								char.Humanoid.WalkToPoint = v.Position
							end
						end
					end
					if char:FindFirstChild("entered") then
						char.Humanoid.WalkToPoint = char.HumanoidRootPart.Position
						task.wait(0.2)
						game:GetService("VirtualInputManager"):SendKeyEvent(true,"E",false,x)
						if game.Workspace:FindFirstChild("bobcap") == nil then
							if char.Humanoid.Health == 100 then
								game:GetService("ReplicatedStorage"):WaitForChild("HumanoidDied"):FireServer(char,false)
							end
						else
							OrionLib:MakeNotification({Name = "Error",Content = "You got Bob spawn",Image = "rbxassetid://7733658504",Time = 5})
							GetBob:Set(false)
						end
					end
					task.wait()
				end
				while getgenv().AutoFarmBob and Autobob == "Super Fast Spawn" do
					firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
					firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
					wait(0.5)
					game:GetService("VirtualInputManager"):SendKeyEvent(true,"E",false,x)
					task.wait(0.2)
					if game.Workspace:FindFirstChild("bobcap") == nil then
						game:GetService("ReplicatedStorage"):WaitForChild("HumanoidDied"):FireServer(char,false)
					else
						OrionLib:MakeNotification({Name = "Error",Content = "You got Bob spawn",Image = "rbxassetid://7733658504",Time = 5})
						GetBob:Set(false)
					end
					task.wait(1.8)
				end
			elseif getgenv().AutoFarmBob == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Replica equipped, or You have Owned Items",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				GetBob:Set(false)
			end
		end    
	})

	Badges:AddToggle({
		Name = "Toolbox Farm",
		Default = false,
		Callback = function(Value)
			Toolboxfarm = Value
			while Toolboxfarm do
				if game.Workspace:FindFirstChild("Toolbox") then
					for i,v in pairs(game.Workspace:GetDescendants()) do
						if v.Name == "Toolbox" and v:FindFirstChild("ClickDetector") then
							fireclickdetector(v.ClickDetector, 0)
							fireclickdetector(v.ClickDetector, 1)
						end
					end
				end
				task.wait()
			end
		end    
	})

	Badges:AddToggle({
		Name = "Phase Or Jet Farm",
		Default = false,
		Callback = function(Value)
			getgenv().PhaseOrJetfarm = Value
			while getgenv().PhaseOrJetfarm do
				for i,v in pairs(game.Workspace:GetChildren()) do
					if v.Name == "JetOrb" or v.Name == "PhaseOrb" then
						firetouchinterest(char:WaitForChild("Head"), v, 0)
						firetouchinterest(char:WaitForChild("Head"), v, 1)
					end
				end
				task.wait()
			end
		end    
	})

	Badges:AddToggle({
		Name = "Siphon Farm",
		Default = false,
		Callback = function(Value)
			getgenv().Siphonfarm = Value
			while getgenv().Siphonfarm do
				if game.Workspace:FindFirstChild("SiphonOrb") then
					for i,v in pairs(game.Workspace:GetChildren()) do
						if v.Name == "SiphonOrb" then
							firetouchinterest(char:WaitForChild("Head"), v, 0)
							firetouchinterest(char:WaitForChild("Head"), v, 1)
						end
					end
				end
				task.wait()
			end
		end    
	})

	Badges:AddToggle({
		Name = "Phase Or Jet Glitch",
		Default = false,
		Callback = function(Value)
			getgenv().Glitchfarm = Value
			while getgenv().Glitchfarm do
				if GetEquippedGlove() == "Error" then
					if game.Workspace:FindFirstChild("JetOrb") or game.Workspace:FindFirstChild("PhaseOrb") then
						for i,v in pairs(game.Workspace:GetChildren()) do
							if v.Name == "JetOrb" or v.Name == "PhaseOrb" then
								game.ReplicatedStorage.Errorhit:FireServer(v)
							end
						end
					end
				end
				task.wait()
			end
		end    
	})

	Badges:AddToggle({
		Name = "Gift Farm",
		Default = false,
		Callback = function(Value)
			Giftfarm = Value
			while Giftfarm do
				for i,v in pairs(game.Workspace:GetChildren()) do
					if v.Name == "Gift" then
						firetouchinterest(char:WaitForChild("HumanoidRootPart"), v, 0)
						firetouchinterest(char:WaitForChild("HumanoidRootPart"), v, 1)
					end
				end
				task.wait()
			end
		end    
	})

	Badges:AddDropdown({
		Name = "Farm Time",
		Default = "",
		Options = {"Voodoo + Fish", "MegaRock"},
		Callback = function(Value)
			AutoTime = Value
		end    
	})

	FarmTimeServer = Badges:AddLabel("Farm Time [ 0 ]")

	GetFarmTime = Badges:AddToggle({
		Name = "AutoFarm Time",
		Default = false,
		Callback = function(Value)
			getgenv().AutoTimeGet = Value
			if AutoTime == "Voodoo + Fish" then
				if GetEquippedGlove() == "Ghost" and char:FindFirstChild("entered") == nil then
					game.ReplicatedStorage.Ghostinvisibilityactivated:FireServer()
					fireclickdetector(workspace.Lobby["ZZZZZZZ"].ClickDetector)
					wait(0.2)
					repeat task.wait() until char
					if not char:FindFirstChild("entered") and char:FindFirstChild("HumanoidRootPart") then
						repeat task.wait()
							firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
							firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
						until char:FindFirstChild("entered")
					end
					wait(0.2)
					char.HumanoidRootPart.CFrame = game.Workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
					wait(0.2)
					game:GetService("ReplicatedStorage").ZZZZZZZSleep:FireServer()
				elseif getgenv().AutoTimeGet == true then
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Ghost equipped, or You have go to lobby",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif AutoTime ~= "Voodoo + Fish" or Value == false then
				SleepTimeandTimeGhost = 0
				FarmTimeServer:Set("Farm Time [ 0 ]")
			end
			while getgenv().AutoTimeGet and AutoTime == "Voodoo + Fish" and task.wait() do
				if GetEquippedGlove() == "ZZZZZZZ" and char:FindFirstChild("entered") and char:FindFirstChild("Ragdolled").Value == true then
					task.wait(1)
					SleepTimeandTimeGhost += 1
					FarmTimeServer:Set("Farm Time [ "..SleepTimeandTimeGhost.." ]")
				elseif char:FindFirstChild("entered") == nil or char:FindFirstChild("Ragdolled").Value == false then
					SleepTimeandTimeGhost = 0
					FarmTimeServer:Set("Farm Time [ 0 ]")
				end
			end
			if AutoTime == "MegaRock" then
				if char:FindFirstChild("entered") and GetEquippedGlove() == "Diamond" then
					game:GetService("ReplicatedStorage"):WaitForChild("Rockmode"):FireServer()
				end
			elseif AutoTime ~= "MegaRock" or Value == false then
				if GetEquippedGlove() == "Diamond" and char:FindFirstChild("entered") == nil or char:FindFirstChild("rock") ~= nil then
					game:GetService("ReplicatedStorage"):WaitForChild("Rockmode"):FireServer()
					TimeMegarock = 0
					FarmTimeServer:Set("Farm Time [ 0 ]")
				end
			end
			while getgenv().AutoTimeGet and AutoTime == "MegaRock" and task.wait() do
				task.wait(1)
				if GetEquippedGlove() == "Diamond" and char:FindFirstChild("entered") and char:FindFirstChild("rock") then
					TimeMegarock += 1
					FarmTimeServer:Set("Farm Time [ "..TimeMegarock.." ]")
				elseif char:FindFirstChild("entered") == nil or char:FindFirstChild("rock") == nil then
					TimeMegarock = 0
					FarmTimeServer:Set("Farm Time [ 0 ]")
				end
			end
		end    
	})

	Badges:AddDropdown({
		Name = "Farm Brick",
		Default = "Slow",
		Options = {"Slow", "Fast"},
		Callback = function(Value)
			AutoBrick = Value
		end    
	})

	AutoFarmBrick = Badges:AddToggle({
		Name = "AutoFram Brick",
		Default = false,
		Callback = function(Value)
			Brickfarm = Value
			if GetEquippedGlove() == "Brick" then
				while Brickfarm and AutoBrick == "Slow" do
					game:GetService("VirtualInputManager"):SendKeyEvent(true,"E",false,x)
					task.wait(5.05)
				end
				while Brickfarm and AutoBrick == "Fast" do
					game:GetService("ReplicatedStorage").lbrick:FireServer()
					game:GetService("Players").LocalPlayer.PlayerGui.BRICKCOUNT.ImageLabel.TextLabel.Text = game:GetService("Players").LocalPlayer.PlayerGui.BRICKCOUNT.ImageLabel.TextLabel.Text + 1
					wait(1.5)
				end
			elseif Brickfarm == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Brick equipped",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				AutoFarmBrick:Set(false)
			end
		end    
	})

	AutoTycoon = Badges:AddToggle({
		Name = "Get Tycoon",
		Default = false,
		Callback = function(Value)
			getgenv().AutoTpPlate = Value
			if char:FindFirstChild("entered") and #Players:GetPlayers() >= 7 then
				while getgenv().AutoTpPlate do
					if char and char:FindFirstChild("entered") and #Players:GetPlayers() >= 7 then
						char.HumanoidRootPart.CFrame = game.workspace.Arena.Plate.CFrame
					end
					task.wait()
				end
			elseif getgenv().AutoTpPlate == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You need enter erane, or 7 people the server",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				AutoTycoon:Set(false)
			end
		end    
	})

	LocalPlayer:AddSlider({
		Name = "WalkSpeed",
		Min = 20,
		Max = 1000,
		Default = 20,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "WalkSpeed",
		Callback = function(Value)
			char.Humanoid.WalkSpeed = Value
			Walkspeed = Value
		end    
	})

	LocalPlayer:AddTextbox({
		Name = "WalkSpeed",
		Default = "UserSpeed",
		TextDisappear = false,
		Callback = function(Value)
			char.Humanoid.WalkSpeed = Value
			Walkspeed = Value
		end	  
	})

	LocalPlayer:AddToggle({
		Name = "Walkspeed Set Auto",
		Default = false,
		Callback = function(Value)
			KeepWalkspeed = Value
			while KeepWalkspeed do
				if char:FindFirstChild("Humanoid") ~= nil and char.Humanoid.WalkSpeed ~= Walkspeed then
					char.Humanoid.WalkSpeed = Walkspeed
				end
				task.wait()
			end
		end    
	})

	LocalPlayer:AddSlider({
		Name = "JumpPower",
		Min = 50,
		Max = 1000,
		Default = 50,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "JumpPower",
		Callback = function(Value)
			char.Humanoid.JumpPower = Value
			Jumppower = Value
		end    
	})

	LocalPlayer:AddTextbox({
		Name = "Jumppower",
		Default = "UserPower",
		TextDisappear = false,
		Callback = function(Value)
			char.Humanoid.JumpPower = Value
			Jumppower = Value
		end	  
	})

	LocalPlayer:AddToggle({
		Name = "Jumppower Set Auto",
		Default = false,
		Callback = function(Value)
			KeepJumppower = Value
			while KeepJumppower do
				if char:FindFirstChild("Humanoid") ~= nil and char.Humanoid.JumpPower ~= Jumppower then
					char.Humanoid.JumpPower = Jumppower
				end
				task.wait()
			end
		end    
	})

	LocalPlayer:AddSlider({
		Name = "Hip Height",
		Min = 0,
		Max = 100,
		Default = 0,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "Hip Height",
		Callback = function(Value)
			char.Humanoid.HipHeight = Value
			HipHeight = Value
		end    
	})

	LocalPlayer:AddTextbox({
		Name = "Hip Height",
		Default = "UserHeight",
		TextDisappear = false,
		Callback = function(Value)
			char.Humanoid.HipHeight = Value
			HipHeight = Value
		end	  
	})

	LocalPlayer:AddToggle({
		Name = "Hip Height Set Auto",
		Default = false,
		Callback = function(Value)
			KeepHipHeight = Value
			while KeepHipHeight do
				if char:FindFirstChild("Humanoid") ~= nil and char.Humanoid.HipHeight ~= HipHeight then
					char.Humanoid.HipHeight  = HipHeight
				end
				task.wait()
			end
		end    
	})

	LocalPlayer:AddSlider({
		Name = "Gravity",
		Min = 0,
		Max = 600,
		Default = 196,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "Gravity",
		Callback = function(Value)
			game.Workspace.Gravity = Value
			Gravity = Value
		end    
	})

	LocalPlayer:AddToggle({
		Name = "Gravity Set Auto",
		Default = false,
		Callback = function(Value)
			KeepGravity = Value
			while KeepGravity do
				if char:FindFirstChild("Humanoid") ~= nil and game.Workspace.Gravity ~= nil and game.Workspace.Gravity ~= Gravity then
					game.Workspace.Gravity = Gravity
				end
				task.wait()
			end
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Prop Ability",
		Default = "",
		Options = {"Barrel", "Bench", "Brick", "Bush 1", "Bush 2", "Cauldron", "Diamond", "Frenzy Bot", "Gift", "GoldenSlapple", "Imp", "Jet Orb", "Larry", "MEGAROCK", "Moai Head", "Obby 1", "Obby 2", "Obby 3", "Obby 4", "Obby 5", "Orange", "Oven", "Phase Heart", "Phase Orb", "Rock 1", "Rock 2", "Rock 3", "Sentry", "Slapple", "Snow Peep", "Snow Turret", "bob", "rob","Sbeve"},
		Callback = function(Value)
			PropAbility = Value
		end    
	})

	Prop = GlovesFunctions:AddToggle({
		Name = "Auto Spam Prop",
		Default = false,
		Callback = function(Value)
			PropSpam = Value
			if GetEquippedGlove() == "Prop" then
				while PropSpam and GetEquippedGlove() == "Prop" do
					if game.Workspace:FindFirstChild("PropModel_"..plr.Name) == nil then
						game:GetService("ReplicatedStorage").GeneralAbility:FireServer(PropAbility)
					end
					task.wait()
				end
			elseif PropSpam == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Prop equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				Prop:Set(false)
			end
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Santa Ability",
		Default = "milk",
		Options = {"bobplush", "snowpeep", "milk"},
		Callback = function(Value)
			SantaAbility = Value
		end    
	})

	Santa = GlovesFunctions:AddToggle({
		Name = "Auto Spam Santa",
		Default = false,
		Callback = function(Value)
			SantaSpam = Value
			if GetEquippedGlove() == "Santa" then
				while SantaSpam and GetEquippedGlove() == "Santa" do
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer(SantaAbility)
					task.wait()
				end
			elseif SantaSpam == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Santa equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				Santa:Set(false)
			end
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Admin Ability",
		Default = "Fling",
		Options = {"Fling", "Anvil", "Invisibility"},
		Callback = function(Value)
			AbilityAdmin = Value
		end    
	})

	Admin = GlovesFunctions:AddToggle({
		Name = "Auto Spam Admin [ All Glove ]",
		Default = false,
		Callback = function(Value)
			AdminSpam = Value
			while AdminSpam do
				game:GetService("ReplicatedStorage").AdminAbility:FireServer(AbilityAdmin)
				task.wait()
			end
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Retro Ability",
		Default = "Rocket Launcher",
		Options = {"Rocket Launcher", "Ban Hammer", "Bomb"},
		Callback = function(Value)
			RetroAbility = Value
		end    
	})

	GlovesFunctions:AddToggle({
		Name = "Auto Spam Retro [ All Glove ]",
		Default = false,
		Callback = function(Value)
			RetroSpam = Value
			while RetroSpam do
				game:GetService("ReplicatedStorage").RetroAbility:FireServer(RetroAbility)
				task.wait()
			end
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Slapstick Ability",
		Default = "runeffect",
		Options = {"runeffect", "fullcharged", "dash", "addarm","charge","cancelrun","discharge"},
		Callback = function(Value)
			SlapstickAbility = Value
		end    
	})

	GlovesFunctions:AddButton({
		Name = "Spam Ability Slapstick",
		Callback = function()
			if SlapstickAbility == "runeffect" then
				OldSpeed = char.Humanoid.WalkSpeed
				char.HumanoidRootPart.Anchored = true
				game:GetService("ReplicatedStorage").slapstick:FireServer("runeffect")
				wait(5)
				game:GetService("ReplicatedStorage").slapstick:FireServer("fullcharged")
				wait(1)
				OrionLib:MakeNotification({Name = "Error",Content = "Started RUN Now.",Image = "rbxassetid://7733658504",Time = 5})
				char.HumanoidRootPart.Anchored = false
				char.Humanoid.WalkSpeed = 70
				wait(25)
				char.Humanoid.WalkSpeed = OldSpeed
				game:GetService("ReplicatedStorage").slapstick:FireServer("cancelrun")
			elseif SlapstickAbility == "dash" then
				game:GetService("ReplicatedStorage").slapstick:FireServer("addarm")
				game:GetService("ReplicatedStorage").slapstick:FireServer("dash")
			end
		end    
	})

	GlovesFunctions:AddToggle({
		Name = "Auto Spam Slapstick [ All Glove ]",
		Default = false,
		Callback = function(Value)
			SlapstickSpam = Value
			if SlapstickSpam == true then
				game:GetService("ReplicatedStorage").slapstick:FireServer("addarm")
			end
			while SlapstickSpam do
				game:GetService("ReplicatedStorage").slapstick:FireServer(SlapstickAbility)
				task.wait()
			end
		end    
	})

	GlovesFunctions:AddTextbox({
		Name = "Godmode Player",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			if Value == "Me" or Value == "me" or Value == "Username" or Value == "" then
				SaveThePlayer = plr.Name
			else
				local targetAbbreviation = Value
				local targetPlayer
				for _, v in pairs(Players:GetPlayers()) do
					if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
						targetPlayer = v
						break
					end
				end
				if targetPlayer then
					SaveThePlayer = targetPlayer.Name
					OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..SaveThePlayer.." ]",Image = "rbxassetid://7733658504",Time = 5})
				else
					OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end	  
	})

	SavePlayer = GlovesFunctions:AddToggle({
		Name = "Auto Godmode Player",
		Default = false,
		Callback = function(Value)
			if SaveThePlayer == nil then
				SaveThePlayer = plr.Name
			end
			GuardianAngelSpam = Value
			if GetEquippedGlove() == "Guardian Angel" then
				while GuardianAngelSpam and GetEquippedGlove() == "Guardian Angel" do
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer(Players[SaveThePlayer])
					task.wait()
				end
			elseif GuardianAngelSpam == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Guardian Angel equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				SavePlayer:Set(false)
			end
		end    
	})

	GlovesFunctions:AddTextbox({
		Name = "Spam Rojo Player",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			if Value == "Me" or Value == "me" or Value == "Username" or Value == "" then
				Person = plr.Name
			else
				local targetAbbreviation = Value
				local targetPlayer
				for _, v in pairs(Players:GetPlayers()) do
					if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
						targetPlayer = v
						break
					end
				end
				if targetPlayer then
					Person = targetPlayer.Name
					OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..Person.." ]",Image = "rbxassetid://7733658504",Time = 5})
				else
					OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end	  
	})

	GlovesFunctions:AddDropdown({
		Name = "Rojo Ability",
		Default = "",
		Options = {"Normal", "Down"},
		Callback = function(Value)
			RojoAbility = Value
		end    
	})

	GlovesFunctions:AddToggle({
		Name = "Auto Spam Rojo [ All Glove ]",
		Default = false,
		Callback = function(Value)
			if Person == nil then
				Person = plr.Name
			end
			getgenv().RojoSpam = Value
			while getgenv().RojoSpam and RojoAbility == "Normal" do
				game:GetService("ReplicatedStorage"):WaitForChild("RojoAbility"):FireServer("Release", {Players[Person].Character.HumanoidRootPart.CFrame})
				task.wait()
			end
			while getgenv().RojoSpam and RojoAbility == "Down" do
				game:GetService("ReplicatedStorage"):WaitForChild("RojoAbility"):FireServer("Release", {Players[Person].Character.HumanoidRootPart.CFrame * CFrame.Angles(-1.5, -9.99999993922529e-09, -0.5663706660270691)})
				task.wait()
			end
		end    
	})

	GlovesFunctions:AddTextbox({
		Name = "Spam Divebomb Player",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			if Value == "Me" or Value == "me" or Value == "Username" or Value == "" then
				DivebombExplosion = plr.Name
			else
				local targetAbbreviation = Value
				local targetPlayer
				for _, v in pairs(Players:GetPlayers()) do
					if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
						targetPlayer = v
						break
					end
				end
				if targetPlayer then
					DivebombExplosion = targetPlayer.Name
					OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..DivebombExplosion.." ]",Image = "rbxassetid://7733658504",Time = 5})
				else
					OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end	  
	})

	GlovesFunctions:AddSlider({
		Name = "Charge Explosion",
		Min = 0,
		Max = 100,
		Default = 5,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "Charge",
		Callback = function(Value)
			getgenv().ChargeExplosion = Value
		end    
	})

	AutoSpawnDivebomb = GlovesFunctions:AddToggle({
		Name = "Auto Spam Divebomb",
		Default = false,
		Callback = function(Value)
			if DivebombExplosion == nil then
				DivebombExplosion = plr.Name
			end
			getgenv().DivebombSpam = Value
			if GetEquippedGlove() == "Divebomb" then
				while getgenv().DivebombSpam and GetEquippedGlove() == "Divebomb" do
					game:GetService("ReplicatedStorage").RocketJump:InvokeServer({["chargeAlpha"] = 99.7833333881571889,["rocketJump"] = true})
					game:GetService("ReplicatedStorage").RocketJump:InvokeServer({["position"] = Players[DivebombExplosion].Character.HumanoidRootPart.Position,["explosion"] = true,["explosionAlpha"] = getgenv().ChargeExplosion})
					task.wait()
				end
			elseif getgenv().DivebombSpam == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Divebomb equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				AutoSpawnDivebomb:Set(false)
			end
		end    
	})

	GlovesFunctions:AddTextbox({
		Name = "Punish Player",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().PunishPlayer = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().PunishPlayer.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	Cancel = false
	GlovesFunctions:AddButton({
		Name = "Punish Player",
		Callback = function()
			if char:FindFirstChild("Swapper") or plr.Backpack:FindFirstChild("Swapper") then
				OGL = char.HumanoidRootPart.CFrame
				game.Workspace.VoidPart.VoidPart1.CanCollide = true
				Timer = 0
				repeat
					if Cancel == true then
						break
					end
					if Players[getgenv().PunishPlayer].Character:FindFirstChild("HumanoidRootPart") then
						char.HumanoidRootPart.CFrame = CFrame.new(workspace[getgenv().PunishPlayer].HumanoidRootPart.Position.X,-49999,workspace[getgenv().PunishPlayer].HumanoidRootPart.Position.Z)
					end
					task.wait(0.01)
					if Timer < 1 then
						Timer = Timer + 0.01
					end
				until Players[getgenv().PunishPlayer].Character and workspace[getgenv().PunishPlayer]:FindFirstChild("HumanoidRootPart") and workspace[getgenv().PunishPlayer]:FindFirstChild("entered") and workspace[getgenv().PunishPlayer].Ragdolled.Value == false and Timer >= 1
				if Cancel == false then
					game:GetService("ReplicatedStorage").SLOC:FireServer()
				end
				wait(.25)
				char.HumanoidRootPart.CFrame = OGL
				game.Workspace.VoidPart.VoidPart1.CanCollide = false
				if char:FindFirstChildWhichIsA("Part",true) == nil then
					game:GetService("ReplicatedStorage"):WaitForChild("HumanoidDied"):FireServer(char,false)
				end
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Swapper equipped, or you aren't in the arena.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	GlovesFunctions:AddButton({
		Name = "Cancel Punish Player",
		Callback = function()
			Cancel = true
			wait(0.1)
			Cancel = false
		end    
	})

	getgenv().PlayerChoose = "Username"
	GlovesFunctions:AddDropdown({
		Name = "Player",
		Default = "Username",
		Options = {"Username","Random"},
		Callback = function(Value)
			getgenv().PlayerChoose = Value
		end    
	})

	GlovesFunctions:AddTextbox({
		Name = "Teleport Void Player",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().VoidPlayer = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().VoidPlayer.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	GlovesFunctions:AddButton({
		Name = "Teleport Void Player",
		Callback = function()
			if getgenv().PlayerChoose == "Username" then
				if char:FindFirstChild("Swapper") or plr.Backpack:FindFirstChild("Swapper") then
					OGL = char.HumanoidRootPart.CFrame
					task.wait(0.25)
					repeat task.wait()
						if workspace[getgenv().VoidPlayer]:FindFirstChild("HumanoidRootPart") then
							char.HumanoidRootPart.CFrame = CFrame.new(workspace[getgenv().VoidPlayer].HumanoidRootPart.Position.X,-70,workspace[getgenv().VoidPlayer].HumanoidRootPart.Position.Z)
							task.wait(0.37)
							char.HumanoidRootPart.Anchored = true
						end
					until Players[getgenv().VoidPlayer].Character and workspace[getgenv().VoidPlayer]:FindFirstChild("HumanoidRootPart") and workspace[getgenv().VoidPlayer]:FindFirstChild("entered") and workspace[getgenv().VoidPlayer].Ragdolled.Value == false
					task.wait(0.6)
					game:GetService("ReplicatedStorage").SLOC:FireServer()
					wait(.25)
					char.HumanoidRootPart.Anchored = false
					task.wait(0.05)
					char.HumanoidRootPart.CFrame = OGL
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Swapper equipped, or you aren't in the arena.",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif getgenv().PlayerChoose == "Random" then
				if char:FindFirstChild("Swapper") or plr.Backpack:FindFirstChild("Swapper") then
					OGL = char.HumanoidRootPart.CFrame
					local players = Players:GetChildren()
					local RandomPlayer = players[math.random(1, #players)]
					repeat RandomPlayer = players[math.random(1, #players)] until RandomPlayer ~= plr and RandomPlayer.Character:FindFirstChild("entered") and RandomPlayer.Character:FindFirstChild("Ragdolled").Value == false
					Target = RandomPlayer
					repeat task.wait()
						if Target.Character:FindFirstChild("HumanoidRootPart") then
							char.HumanoidRootPart.CFrame = CFrame.new(Target.Character.HumanoidRootPart.Position.X,-70,Target.Character.HumanoidRootPart.Position.Z)
							task.wait(0.37)
							char.HumanoidRootPart.Anchored = true
						end
					until Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") and Target.Character:FindFirstChild("entered") and Target.Character:FindFirstChild("Ragdolled").Value == false
					task.wait(0.6)
					game:GetService("ReplicatedStorage").SLOC:FireServer()
					wait(.25)
					char.HumanoidRootPart.Anchored = false
					task.wait(0.05)
					char.HumanoidRootPart.CFrame = OGL
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Swapper equipped, or you aren't in the arena.",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end    
	})

	GlovesFunctions:AddTextbox({
		Name = "Home Run Kill Player",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().KillerPlayer = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().KillerPlayer.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	GlovesFunctions:AddButton({
		Name = "Home Run Kill Player",
		Callback = function()
			if getgenv().PlayerChoose == "Username" then
				if GetEquippedGlove() == "Home Run" and Players[getgenv().KillerPlayer].Character:FindFirstChild("entered") then
					OGL = char.HumanoidRootPart.CFrame
					OGLZ = Players[getgenv().KillerPlayer].Character.HumanoidRootPart.Size
					Players[getgenv().KillerPlayer].Character.HumanoidRootPart.Size = Vector3.new(50,50,50)
					game:GetService("ReplicatedStorage").HomeRun:FireServer({["start"] = true})
					wait(4.2)
					game:GetService("ReplicatedStorage").HomeRun:FireServer({["finished"] = true})
					task.wait(0.12)
					char.HumanoidRootPart.CFrame = Players[getgenv().KillerPlayer].Character.HumanoidRootPart.CFrame
					task.wait(0.25)
					char.HumanoidRootPart.CFrame = OGL
					Players[getgenv().KillerPlayer].Character.HumanoidRootPart.Size = OGLZ
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Home Run equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif getgenv().PlayerChoose == "Random" then
				if GetEquippedGlove() == "Home Run" then
					OGL = char.HumanoidRootPart.CFrame
					game:GetService("ReplicatedStorage").HomeRun:FireServer({["start"] = true})
					wait(4.2)
					local players = Players:GetChildren()
					local RandomPlayer = players[math.random(1, #players)]
					repeat RandomPlayer = players[math.random(1, #players)] until RandomPlayer ~= plr and RandomPlayer.Character:FindFirstChild("rock") == nil and RandomPlayer.Character.Head:FindFirstChild("UnoReverseCard") == nil
					Target = RandomPlayer
					OGLZ = Target.Character.HumanoidRootPart.Size
					Target.Character.HumanoidRootPart.Size = Vector3.new(50,50,50)
					wait(0.25)
					game:GetService("ReplicatedStorage").HomeRun:FireServer({["finished"] = true})
					task.wait(0.12)
					char.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
					task.wait(0.25)
					char.HumanoidRootPart.CFrame = OGL
					Target.Character.HumanoidRootPart.Size = OGLZ
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Home Run equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end 
	})

	GlovesFunctions:AddTextbox({
		Name = "Hive Player",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().HivePlayer = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().HivePlayer.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	GlovesFunctions:AddButton({
		Name = "Hive Player",
		Callback = function()
			if getgenv().PlayerChoose == "Username" then
				if GetEquippedGlove() == "Hive" and Players[getgenv().HivePlayer].Character:FindFirstChild("entered") then
					OGL = char.HumanoidRootPart.CFrame
					OGLZ = Players[getgenv().HivePlayer].Character.HumanoidRootPart.Size
					Players[getgenv().HivePlayer].Character.HumanoidRootPart.Size = Vector3.new(20,20,20)
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
					task.wait(4.2)
					char.HumanoidRootPart.CFrame = Players[getgenv().HivePlayer].Character.HumanoidRootPart.CFrame
					wait(0.25)
					Magnitude = (char.HumanoidRootPart.Position - Players[getgenv().HivePlayer].Character.HumanoidRootPart.Position).Magnitude
					if 30 >= Magnitude then
						game:GetService("ReplicatedStorage"):WaitForChild("GeneralHit"):FireServer(Players[getgenv().HivePlayer].Character:WaitForChild("HumanoidRootPart"))
					end
					wait(0.25)
					char.HumanoidRootPart.CFrame = OGL
					Players[getgenv().HivePlayer].Character.HumanoidRootPart.Size = OGLZ
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Hive equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif getgenv().PlayerChoose == "Random" then
				if GetEquippedGlove() == "Hive" then
					OGL = char.HumanoidRootPart.CFrame
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
					task.wait(4.32)
					local players = Players:GetChildren()
					local RandomPlayer = players[math.random(1, #players)]
					repeat RandomPlayer = players[math.random(1, #players)] until RandomPlayer ~= plr and RandomPlayer.Character:FindFirstChild("entered") and RandomPlayer.Character:FindFirstChild("rock") == nil and RandomPlayer.Character.Head:FindFirstChild("UnoReverseCard") == nil
					Target = RandomPlayer
					OGLZ = Target.Character.HumanoidRootPart.Size
					Target.Character.HumanoidRootPart.Size = Vector3.new(20,20,20)
					char.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
					wait(0.25)
					Magnitude = (char.HumanoidRootPart.Position - Target.Character.HumanoidRootPart.Position).Magnitude
					if 30 >= Magnitude then
						game:GetService("ReplicatedStorage"):WaitForChild("GeneralHit"):FireServer(Target.Character:WaitForChild("HumanoidRootPart"))
					end
					wait(0.22)
					char.HumanoidRootPart.CFrame = OGL
					Target.Character.HumanoidRootPart.Size = OGLZ
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Hive equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end 
	})

	GlovesFunctions:AddTextbox({
		Name = "Quake Player",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().PressIntoTheGround = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().PressIntoTheGround.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	GlovesFunctions:AddButton({
		Name = "Quake Player",
		Callback = function()
			if getgenv().PlayerChoose == "Username" then
				if GetEquippedGlove() == "Quake" and char:FindFirstChild("entered") and Players[getgenv().PressIntoTheGround].Character:FindFirstChild("entered") then
					char.Humanoid:UnequipTools()
					char.Humanoid:EquipTool(plr.Backpack.Quake)
					OGL = char.HumanoidRootPart.CFrame
					game:GetService("ReplicatedStorage"):WaitForChild("QuakeQuake"):FireServer({["start"] = true})
					wait(3.45)
					char.HumanoidRootPart.CFrame = Players[getgenv().PressIntoTheGround].Character:FindFirstChild("Head").CFrame * CFrame.new(0,4,0)
					task.wait(0.18)
					game:GetService("ReplicatedStorage"):WaitForChild("QuakeQuake"):FireServer({["finished"] = true})
					task.wait(0.17)
					char.HumanoidRootPart.CFrame = OGL
					char.Humanoid:UnequipTools()
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Quake equipped.",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif getgenv().PlayerChoose == "Random" then
				if GetEquippedGlove() == "Quake" and char:FindFirstChild("entered") then
					char.Humanoid:UnequipTools()
					char.Humanoid:EquipTool(plr.Backpack.Quake)
					OGL = char.HumanoidRootPart.CFrame
					game:GetService("ReplicatedStorage"):WaitForChild("QuakeQuake"):FireServer({["start"] = true})
					wait(4)
					local players = Players:GetChildren()
					local RandomPlayer = players[math.random(1, #players)]
					repeat RandomPlayer = players[math.random(1, #players)] until RandomPlayer ~= plr and RandomPlayer.Character:FindFirstChild("rock") == nil and RandomPlayer.Character.Head:FindFirstChild("UnoReverseCard") == nil and RandomPlayer.Character:FindFirstChild("entered")
					Target = RandomPlayer
					char.HumanoidRootPart.CFrame = Target.Character:FindFirstChild("Head").CFrame * CFrame.new(0,4,0)
					task.wait(0.13)
					game:GetService("ReplicatedStorage"):WaitForChild("QuakeQuake"):FireServer({["finished"] = true})
					task.wait(0.17)
					char.HumanoidRootPart.CFrame = OGL
					char.Humanoid:UnequipTools()
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Quake equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end 
	})

	GlovesFunctions:AddTextbox({
		Name = "Cards Player",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			if Value == "Me" or Value == "me" or Value == "Username" or Value == "" then
				PersonCar = plr.Name
			else
				local targetAbbreviation = Value
				local targetPlayer
				for _, v in pairs(Players:GetPlayers()) do
					if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
						targetPlayer = v
						break
					end
				end
				if targetPlayer then
					PersonCar = targetPlayer.Name
					OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..PersonCar.." ]",Image = "rbxassetid://7733658504",Time = 5})
				else
					OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end	  
	})

	GlovesFunctions:AddButton({
		Name = "Cards Player",
		Callback = function()
			if getgenv().PlayerChoose == "Username" then
				if GetEquippedGlove() == "Jester" then
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer("Ability3",Players[PersonCar])
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Jester glove equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif getgenv().PlayerChoose == "Random" then
				if GetEquippedGlove() == "Jester" then
					local players = Players:GetChildren()
					local RandomPlayer = players[math.random(1, #players)]
					repeat RandomPlayer = players[math.random(1, #players)] until RandomPlayer ~= plr and RandomPlayer.Character:FindFirstChild("rock") == nil and RandomPlayer.Character.Head:FindFirstChild("UnoReverseCard") == nil and RandomPlayer.Character:FindFirstChild("entered")
					Target = RandomPlayer
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer("Ability3",Target)
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Jester glove equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end    
	})

	GlovesFunctions:AddTextbox({
		Name = "Oven Player",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().OvenPlayer = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().OvenPlayer.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	AutoOven = GlovesFunctions:AddToggle({
		Name = "Auto Oven Player",
		Default = false,
		Callback = function(Value)
			getgenv().OvenPlayerAuto = Value
			if GetEquippedGlove() == "Oven" then
				while getgenv().OvenPlayerAuto and GetEquippedGlove() == "Oven" do
					if getgenv().PlayerChoose == "Username" then
						if not game.Workspace:FindFirstChild(plr.Name.."'s Oven") then
							game:GetService("ReplicatedStorage").GeneralAbility:FireServer(Players[getgenv().OvenPlayer].Character.HumanoidRootPart.CFrame)
						end
					elseif getgenv().PlayerChoose == "Random" then
						local players = Players:GetChildren()
						local RandomPlayer = players[math.random(1, #players)]
						repeat RandomPlayer = players[math.random(1, #players)] until RandomPlayer ~= plr and RandomPlayer.Character:FindFirstChild("rock") == nil and RandomPlayer.Character.Head:FindFirstChild("UnoReverseCard") == nil and RandomPlayer.Character:FindFirstChild("entered")
						Target = RandomPlayer
						if not game.Workspace:FindFirstChild(plr.Name.."'s Oven") then
							game:GetService("ReplicatedStorage").GeneralAbility:FireServer(Target.Character.HumanoidRootPart.CFrame)
						end
					end
					task.wait()
				end
			elseif getgenv().OvenPlayerAuto == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Oven equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				AutoOven:Set(false)
			end
		end    
	})

	GlovesFunctions:AddTextbox({
		Name = "Siphon Player",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().SiphonPlayer = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().SiphonPlayer.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	AutoSiphon = GlovesFunctions:AddToggle({
		Name = "Auto Siphon Player",
		Default = false,
		Callback = function(Value)
			getgenv().AutoSiphonPlayer = Value
			if GetEquippedGlove() == "Siphon" then
				while getgenv().AutoSiphonPlayer and GetEquippedGlove() == "Siphon" do
					if getgenv().PlayerChoose == "Username" then
						if char:FindFirstChild("entered") and Players[getgenv().SiphonPlayer].Character:FindFirstChild("entered") then
							game:GetService("ReplicatedStorage").Events.Siphon:FireServer({["cf"] = Players[getgenv().SiphonPlayer].Character.HumanoidRootPart.CFrame})
						end
					elseif getgenv().PlayerChoose == "Random" then
						local players = Players:GetChildren()
						local RandomPlayer = players[math.random(1, #players)]
						if RandomPlayer ~= plr and char:FindFirstChild("HumanoidRootPart") and RandomPlayer.Character then
							if RandomPlayer.Character:FindFirstChild("entered") and RandomPlayer.Character:FindFirstChild("HumanoidRootPart") and RandomPlayer.Character:FindFirstChild("stevebody") == nil and RandomPlayer.Character:FindFirstChild("rock") == nil then
								game:GetService("ReplicatedStorage").Events.Siphon:FireServer({["cf"] = RandomPlayer.Character.HumanoidRootPart.CFrame})
							end
						end
					end 
					task.wait()
				end
			elseif getgenv().AutoSiphonPlayer == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Siphon equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				AutoSiphon:Set(false)
			end
		end    
	})

	GlovesFunctions:AddTextbox({
		Name = "Kick Player [Recall]",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				PlayerKickRecall = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..PlayerKickRecall.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	GlovesFunctions:AddButton({
		Name = "Kick Player [Recall]",
		Callback = function()
			if getgenv().PlayerChoose == "Username" then
				if GetEquippedGlove() == "Recall" and char:FindFirstChild("Recall") and char:FindFirstChild("entered") and char:FindFirstChild("HumanoidRootPart") and Players[PlayerKickRecall].Character:FindFirstChild("entered") and Players[PlayerKickRecall].Character:FindFirstChild("HumanoidRootPart") then
					OGL = char.HumanoidRootPart.CFrame
					for i,v in pairs(game.Workspace.Lobby.brazil:GetChildren()) do
						v.CanTouch = false
					end
					char.HumanoidRootPart.CFrame = CFrame.new(-725,310,-2)
					task.wait(0.25)
					game:GetService("ReplicatedStorage").Recall:InvokeServer(game:GetService("Players").LocalPlayer.Character.Recall)
					wait(2.7)
					char.HumanoidRootPart.CFrame = Players[PlayerKickRecall].Character.HumanoidRootPart.CFrame
					task.wait(1)
					char.HumanoidRootPart.CFrame = OGL
					for i,v in pairs(game.Workspace.Lobby.brazil:GetChildren()) do
						v.CanTouch = true
					end
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Recall equipped, or you have Backpack Recall equipped, or player not enter arena",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif getgenv().PlayerChoose == "Random" then
				if GetEquippedGlove() == "Recall" and char:FindFirstChild("Recall") and char:FindFirstChild("entered") and char:FindFirstChild("HumanoidRootPart") and Players[PlayerKick].Character:FindFirstChild("entered") and Players[PlayerKick].Character:FindFirstChild("HumanoidRootPart") then
					OGL = char.HumanoidRootPart.CFrame
					for i,v in pairs(game.Workspace.Lobby.brazil:GetChildren()) do
						v.CanTouch = false
					end
					char.HumanoidRootPart.CFrame = CFrame.new(-725,310,-2)
					task.wait(0.25)
					game:GetService("ReplicatedStorage").Recall:InvokeServer(game:GetService("Players").LocalPlayer.Character.Recall)
					wait(2.7)
					local players = Players:GetChildren()
					local randomPlayer = players[math.random(1, #players)]
					repeat randomPlayer = players[math.random(1, #players)] until randomPlayer ~= plr and randomPlayer.Character:FindFirstChild("entered") and randomPlayer.Character:FindFirstChild("ded") == nil and randomPlayer.Character:FindFirstChild("InLabyrinth") == nil and randomPlayer.Character:FindFirstChild("rock") == nil
					Target = randomPlayer
					char.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
					task.wait(1)
					char.HumanoidRootPart.CFrame = OGL
					for i,v in pairs(game.Workspace.Lobby.brazil:GetChildren()) do
						v.CanTouch = true
					end
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Recall equipped, or you have Backpack Recall equipped, or player not enter arena",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end    
	})

local KickPlayerFirework

	GlovesFunctions:AddTextbox({
		Name = "Kick Player [Firework]",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				KickPlayerFirework = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..KickPlayerFirework.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	GlovesFunctions:AddButton({
		Name = "Kick Player [Firework]",
		Callback = function()
			if getgenv().PlayerChoose == "Username" then
				if GetEquippedGlove() == "Firework" then
					if char:FindFirstChild("Entered") then
						if char:FindFirstChild("Humanoid").Health ~= 0 then
							if KickPlayerFirework ~= "" then
								local Victim = Players:FindFirstChild(KickPlayerFirework)
								if Victim and Victim.Character then
									if Victim.Character:FindFirstChild("Humanoid").Health ~= 0 then
										local VictimHRP = Victim.Character:FindFirstChild("HumanoidRootPart")
										if VictimHRP then
											local brazilportal = workspace:FindFirstChild("Lobby"):FindFirstChild("brazil")
											
											for i, v in pairs(brazilportal:GetDescendants()) do
												if v:IsA("BasePart") then
													v.CanTouch = false
												end
											end
											
											char:FindFirstChild("HumanoidRootPart").CFrame = brazilportal.portal.CFrame * CFrame.new(0, 1, 0)
											
											game:GetService("ReplicatedStorage"):FindFirstChild("Firework"):InvokeServer()
											
											for i,v in pairs(game.Workspace:GetChildren()) do
												if v.Name:match(plr.Name) and v:FindFirstChild("VehicleSeat") then
													v.VehicleSeat.CFrame = VictimHRP.CFrame
													task.wait(.01)
													v.VehicleSeat.CFrame = brazilportal.portal.CFrame
												end
											end
											
										else
											OrionLib:MakeNotification({Name = "Error",Content = "Victim's HumanoidRootPart didn't be found",Image = "rbxassetid://7733658504",Time = 5})
										end
									else
										OrionLib:MakeNotification({Name = "Error",Content = "Victim are dead.",Image = "rbxassetid://7733658504",Time = 5})
									end
								end
							else
								OrionLib:MakeNotification({Name = "Error",Content = "Non victim selected.",Image = "rbxassetid://7733658504",Time = 5})
							end
						else
							OrionLib:MakeNotification({Name = "Error",Content = "You are dead???",Image = "rbxassetid://7733658504",Time = 5})
						end
					else
						OrionLib:MakeNotification({Name = "Error",Content = "You need to be in the Arena.",Image = "rbxassetid://7733658504",Time = 5})
					end
				else
					OrionLib:MakeNotification({Name = "Error",Content = "Don't have Firework Glove equipped.",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end    
	})

	GlovesFunctions:AddToggle({
		Name = "Auto Sbeve All Player",
		Default = false,
		Callback = function(Value)
			getgenv().AutoSbeveAllPlayer = Value
			while getgenv().AutoSbeveAllPlayer do
				if GetEquippedGlove() == "Sbeve" or char:FindFirstChild("stevebody") then
					for i,v in pairs(Players:GetChildren()) do
						if v ~= plr and char:FindFirstChild("HumanoidRootPart") and v.Character then
							if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.Ragdolled.Value == false then
								v.Character.HumanoidRootPart.CanCollide = false
								v.Character.HumanoidRootPart.CFrame = char.stevebody.CFrame
							end
						end
					end
				end
				task.wait()
			end
		end    
	})

	GlovesFunctions:AddButton({
		Name = "Sbeve All Player",
		Callback = function()
			if GetEquippedGlove() == "Sbeve" or char:FindFirstChild("stevebody") then
				for i,v in pairs(Players:GetChildren()) do
					if v ~= plr and char:FindFirstChild("HumanoidRootPart") and v.Character then
						if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.Ragdolled.Value == false then
							v.Character.HumanoidRootPart.CanCollide = false
							v.Character.HumanoidRootPart.CFrame = char.stevebody.CFrame
						end
					end
				end
			end
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Black Hole",
		Default = "",
		Options = {"Normal", "Teleport Cannon Island","Teleport Cannon Island + Black Hole"},
		Callback = function(Value)
			getgenv().BlackHoleCre = Value
		end    
	})

	GlovesFunctions:AddButton({
		Name = "Auto Create Black Hole",
		Callback = function()
			if getgenv().BlackHoleCre == "Normal" then
				if char:FindFirstChild("entered") == nil and game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2125950512) and game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2147429609) then
					char.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(0,30,0)
					wait(0.1)
					char.HumanoidRootPart.Anchored = true
					wait(0.05)
					fireclickdetector(workspace.Lobby["rob"].ClickDetector)
					game:GetService("ReplicatedStorage").rob:FireServer()
					wait(4.8)
					char.HumanoidRootPart.Anchored = false
					task.wait(0.08)
					fireclickdetector(workspace.Lobby["bob"].ClickDetector)
					game:GetService("ReplicatedStorage").bob:FireServer()
					wait(0.5)
					for i = 1,26 do
						for _, v in pairs(workspace:GetChildren()) do
							if v.Name:match(plr.Name) and v:FindFirstChild("HumanoidRootPart") then
								char.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
							end
						end
					end
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You have in lobby, or You don't have badge bob, or badge rob.",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif getgenv().BlackHoleCre == "Teleport Cannon Island" then
				if char:FindFirstChild("entered") == nil and game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2125950512) and game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2147429609) then
					char.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(0,30,0)
					wait(0.1)
					char.HumanoidRootPart.Anchored = true
					wait(0.05)
					fireclickdetector(workspace.Lobby["rob"].ClickDetector)
					game:GetService("ReplicatedStorage").rob:FireServer()
					wait(4.8)
					char.HumanoidRootPart.Anchored = false
					task.wait(0.06)
					fireclickdetector(workspace.Lobby["bob"].ClickDetector)
					game:GetService("ReplicatedStorage").bob:FireServer()
					wait(0.5)
					for i = 1,26 do
						for _, v in pairs(workspace:GetChildren()) do
							if v.Name:match(plr.Name) and v:FindFirstChild("HumanoidRootPart") then
								char.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
							end
						end
					end
					wait(0.5)
					repeat task.wait() until char
					if not char:FindFirstChild("entered") and char:FindFirstChild("HumanoidRootPart") then
						repeat task.wait()
							firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
							firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
						until char:FindFirstChild("entered")
					end
					wait(0.27)
					char.HumanoidRootPart.CFrame = CFrame.new(227, 48, 169)
					wait(0.25)
					for i,v in ipairs(game.Workspace.Arena.CannonIsland:GetDescendants()) do
						if v.ClassName == "ProximityPrompt" then
							fireproximityprompt(v)
						end
					end
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You have in lobby, or You don't have badge bob, or badge rob.",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif getgenv().BlackHoleCre == "Teleport Cannon Island + Black Hole" then
				if char:FindFirstChild("entered") == nil and game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2125950512) and game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2147429609) then
					char.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(0,30,0)
					wait(0.1)
					char.HumanoidRootPart.Anchored = true
					wait(0.05)
					fireclickdetector(workspace.Lobby["rob"].ClickDetector)
					game:GetService("ReplicatedStorage").rob:FireServer()
					wait(4.8)
					char.HumanoidRootPart.Anchored = false
					task.wait(0.06)
					fireclickdetector(workspace.Lobby["bob"].ClickDetector)
					game:GetService("ReplicatedStorage").bob:FireServer()
					wait(0.5)
					for i = 1,26 do
						for _, v in pairs(workspace:GetChildren()) do
							if v.Name:match(plr.Name) and v:FindFirstChild("HumanoidRootPart") then
								char.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
							end
						end
					end
					wait(0.5)
					repeat task.wait() until char
					if not char:FindFirstChild("entered") and char:FindFirstChild("HumanoidRootPart") then
						repeat task.wait()
							firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
							firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
						until char:FindFirstChild("entered")
					end
					wait(0.27)
					char.HumanoidRootPart.CFrame = CFrame.new(227, 48, 169)
					wait(0.25)
					for i,v in ipairs(game.Workspace.Arena.CannonIsland:GetDescendants()) do
						if v.ClassName == "ProximityPrompt" then
							fireproximityprompt(v)
						end
					end
					wait(0.05)
					repeat task.wait()
						if game.Workspace:FindFirstChild("Blackhole_Particles") and game.Workspace.Blackhole_Particles:FindFirstChild("BlackHole") then
							char.HumanoidRootPart.CFrame = game.Workspace.Blackhole_Particles.BlackHole.CFrame
						end
					until char.Humanoid.Health == 0
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You have in lobby, or You don't have badge bob, or badge rob.",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end    
	})

	GlovesFunctions:AddButton({
		Name = "Auto Enter Map Null",
		Callback = function()
			if game.Workspace:FindFirstChild("Blackhole_Particles") == nil then
				OrionLib:MakeNotification({Name = "Error",Content = "When will someone create a black hole [ BOB + ROB ].",Image = "rbxassetid://7733658504",Time = 5})
			elseif char:FindFirstChild("entered") ~= nil and GetEquippedGlove() ~= "Default" then
				game:GetService("ReplicatedStorage"):WaitForChild("HumanoidDied"):FireServer(char,false)
				wait(3.75)
				fireclickdetector(game.Workspace.Lobby.Default.ClickDetector)
				wait(0.5)
				repeat task.wait() until char
				if not char:FindFirstChild("entered") and char:FindFirstChild("HumanoidRootPart") then
					repeat task.wait()
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
					until char:FindFirstChild("entered")
				end
				wait(0.5)
				if game.Workspace.Blackhole_Particles ~= nil and game.Workspace.Blackhole_Particles.BlackHole ~= nil then
					repeat task.wait()
						char.HumanoidRootPart.CFrame = game.Workspace.Blackhole_Particles.BlackHole.CFrame
					until char.Humanoid.Health == 0
				end
			elseif char:FindFirstChild("entered") ~= nil and GetEquippedGlove() == "Default" then
				if game.Workspace.Blackhole_Particles ~= nil and game.Workspace.Blackhole_Particles.BlackHole ~= nil then
					repeat task.wait()
						char.HumanoidRootPart.CFrame = game.Workspace.Blackhole_Particles.BlackHole.CFrame
					until char.Humanoid.Health == 0
				end
			elseif char:FindFirstChild("entered") == nil and GetEquippedGlove() == "Default" then
				repeat task.wait() until char
				if not char:FindFirstChild("entered") and char:FindFirstChild("HumanoidRootPart") then
					repeat task.wait()
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
					until char:FindFirstChild("entered")
				end
				wait(0.5)
				if game.Workspace.Blackhole_Particles ~= nil and game.Workspace.Blackhole_Particles.BlackHole ~= nil then
					repeat task.wait()
						char.HumanoidRootPart.CFrame = game.Workspace.Blackhole_Particles.BlackHole.CFrame
					until char.Humanoid.Health == 0
				end
			elseif char:FindFirstChild("entered") == nil and GetEquippedGlove() ~= "Default" then
				fireclickdetector(game.Workspace.Lobby.Default.ClickDetector)
				wait(0.07)
				repeat task.wait() until char
				if not char:FindFirstChild("entered") and char:FindFirstChild("HumanoidRootPart") then
					repeat task.wait()
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
					until char:FindFirstChild("entered")
				end
				wait(0.05)
				if game.Workspace.Blackhole_Particles ~= nil and game.Workspace.Blackhole_Particles.BlackHole ~= nil then
					repeat task.wait()
						char.HumanoidRootPart.CFrame = game.Workspace.Blackhole_Particles.BlackHole.CFrame
					until char.Humanoid.Health == 0
				end
			end
		end    
	})

	GlovesFunctions:AddButton({
		Name = "Auto Enter Cannon",
		Callback = function()
			if char:FindFirstChild("entered") == nil then
				repeat task.wait() until char
				if not char:FindFirstChild("entered") and char:FindFirstChild("HumanoidRootPart") then
					repeat task.wait()
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
					until char:FindFirstChild("entered")
				end
				wait(0.2)
				char.HumanoidRootPart.CFrame = CFrame.new(227, 48, 169)
				wait(0.25)
				for i,v in ipairs(game.Workspace.Arena.CannonIsland:GetDescendants()) do
					if v.ClassName == "ProximityPrompt" then
						fireproximityprompt(v)
					end
				end
			elseif char:FindFirstChild("entered") then
				char.HumanoidRootPart.CFrame = CFrame.new(227, 48, 169)
				wait(0.25)
				for i,v in ipairs(game.Workspace.Arena.CannonIsland:GetDescendants()) do
					if v.ClassName == "ProximityPrompt" then
						fireproximityprompt(v)
					end
				end
			end
		end    
	})

	GlovesFunctions:AddToggle({
		Name = "Auto Teleport Black Hole",
		Default = false,
		Callback = function(Value)
			getgenv().TeleportBlackHole = Value
			while getgenv().TeleportBlackHole do
				if char:FindFirstChild("entered") then
					if game.Workspace:FindFirstChild("Blackhole_Particles") and game.Workspace.Blackhole_Particles:FindFirstChild("BlackHole") then
						char.HumanoidRootPart.CFrame = game.Workspace.Blackhole_Particles.BlackHole.CFrame
					end
				end
				task.wait()
			end
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Teleport Old Place",
		Default = "Yes",
		Options = {"Yes", "No","Player"},
		Callback = function(Value)
			getgenv().TeleportOldPlace = Value
		end    
	})

	GlovesFunctions:AddTextbox({
		Name = "Teleport Player [Recall]",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				PlayerTeleport = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..PlayerTeleport.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	GlovesFunctions:AddButton({
		Name = "Player Teleport [Recall]",
		Callback = function()
			if char:FindFirstChild("entered") and GetEquippedGlove() == "Recall" and plr.Backpack:FindFirstChild("Recall") == nil then
				if getgenv().TeleportOldPlace == "Yes" then
					OLG = char.HumanoidRootPart.CFrame
				end
				game:GetService("ReplicatedStorage").Recall:InvokeServer(game:GetService("Players").LocalPlayer.Character.Recall)
				wait(2.75)
				char.HumanoidRootPart.CFrame = Players[PlayerTeleport].Character.Head.CFrame
				task.wait(0.5)
				if getgenv().TeleportOldPlace == "Yes" then
					char.HumanoidRootPart.CFrame = OLG
				elseif getgenv().TeleportOldPlace == "Player" then
					char.HumanoidRootPart.CFrame = Players[PlayerTeleport].Character.HumanoidRootPart.CFrame
				end
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Recall equipped or you haven't in arena or you have equip Backpack Recall.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	local PlayerToGrabBring

	GlovesFunctions:AddTextbox({
		Name = "Bring Player Target [Grab]",
		Default = "Username/Displayname",
		TextDisappear = false,
		Callback = function(Value)
			local additional
			for i, v in pairs(Players:GetPlayers()) do
				if string.find(Value, v.Name:lower()) or string.find(Value, v.DisplayName:lower()) then
					PlayerToGrabBring = v.Name
					additional = v.DisplayName
					break
				else
					PlayerToGrabBring = nil
				end
			end
			
			if PlayerToGrabBring ~= nil then
				OrionLib:MakeNotification({Name = "Player Found",Content = additional .. " (@" .. PlayerToGrabBring .. ")", Image = "rbxasdetid://7733658504",Time = 5})
			end
		end
	})

	GlovesFunctions:AddButton({
		Name = "Bring Player [Grab]",
		Callback = function()
			if GetEquippedGlove() == "Grab" and PlayerToGrabBring then
				if char:FindFirstChild("entered") then
					if Players:FindFirstChild(PlayerToGrabBring) and Players:FindFirstChild(PlayerToGrabBring).Character and Players:FindFirstChild(PlayerToGrabBring).Character:FindFirstChild("entered") then
						if Players:FindFirstChild(PlayerToGrabBring).Character:FindFirstChild("Humanoid").Health > 0 or not Players:FindFirstChild(PlayerToGrabBring).Character then
							local LastPlrPosition = char:FindFirstChild("HumanoidRootPart").CFrame

							char:FindFirstChild("HumanoidRootPart").CFrame = Players:FindFirstChild(PlayerToGrabBring).Character:FindFirstChild("HumanoidRootPart").CFrame

							wait(0.15)
							game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
							wait(0.15)

							char:FindFirstChild("HumanoidRootPart").CFrame = LastPlrPosition
						else
							OrionLib:MakeNotification({Name = "Target Missing",Content = "Target are dead.",Image = "rbxasdetid://7733658504",Time = 5})
						end
					else
						OrionLib:MakeNotification({Name = "Error",Content = "Target aren't in Arena or character missing.",Image = "rbxasdetid://7733658504",Time = 5})
					end
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You aren't in Arena.",Image = "rbxasdetid://7733658504",Time = 5})
				end
			else
				if GetSlaps() > (tonumber(workspace:WaitForChild("Lobby"):WaitForChild("GloveStands"):FindFirstChild("Grab"):FindFirstChild("SlapsInfoPart"):FindFirstChild("SurfaceGui"):FindFirstChild("TextLabel").Text) - 1) then
					OrionLib:MakeNotification({Name = "Missing Glove",Content = "You don't have Grab equipped.",Image = "rbxasdetid://7733658504",Time = 5})
				else
					OrionLib:MakeNotification({Name = "Not Enough Slaps",Content = "You don't have enough slaps to use Grab.",Image = "rbxasdetid://7733658504",Time = 5})
				end
				if not PlayerToGrabBring then
					OrionLib:MakeNotification({Name = "Target Missing",Content = "There are not targets selected to do this action.",Image = "rbxasdetid://7733658504",Time = 5})
				end
			end
		end 
	})

	GlovesFunctions:AddButton({
		Name = "Kick Player Za Hando",
		Callback = function()
			if GetEquippedGlove() == "Za Hando" then
				OGWS = char.Humanoid.WalkSpeed
				OGJP = char.Humanoid.JumpPower
				OGL = char.HumanoidRootPart.CFrame
				for i,v in pairs(game.Workspace.Lobby.brazil:GetChildren()) do
					v.CanTouch = false
				end
				game:GetService("ReplicatedStorage").Erase:FireServer()
				wait(0.47)
				char.Humanoid.WalkSpeed = 0
				char.Humanoid.JumpPower = 0
				char.HumanoidRootPart.CFrame = CFrame.new(-725,310,-2)
				wait(3.75)
				char.HumanoidRootPart.CFrame = OGL
				char.Humanoid.WalkSpeed = OGWS
				char.Humanoid.JumpPower = OGJP
				for i,v in pairs(game.Workspace.Lobby.brazil:GetChildren()) do
					v.CanTouch = true
				end
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Za Hando equipped.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	GlovesFunctions:AddButton({
		Name = "Spawn Orb Siphon",
		Callback = function()
			if char:FindFirstChild("entered") and GetEquippedGlove() == "Siphon" then
				game:GetService("ReplicatedStorage").Events.Siphon:FireServer({["cf"] = game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].Part.CFrame})
				wait(0.2)
				if game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"]:FindFirstChild("siphon_charge") then
					game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].CFrame = char.HumanoidRootPart.CFrame
				end
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Siphon equipped or you haven't in arena.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Potion",
		Default = "Speed",
		Options = {"Grug","idIot","Nightmare","Confusion","Power","Paralyzing","Haste","Invisibility","Explosion","Invincible","Toxic","Freeze","Feather","Speed","Lethal","Slow","Antitoxin","Corrupted Vine","Field"},
		Callback = function(Value)
			getgenv().MakePotion = Value
		end    
	})

	GlovesFunctions:AddSlider({
		Name = "Medicine Mix Potion",
		Min = 1,
		Max = 200,
		Default = 5,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "Mix",
		Callback = function(Value)
			getgenv().GivePotion = Value
		end    
	})

	if getgenv().PotionChooseNuke == nil then
		getgenv().PotionChooseNuke = "Normal"
	end
	GlovesFunctions:AddDropdown({
		Name = "Potions",
		Default = "",
		Options = {"Nuke", "Normal"},
		Callback = function(Value)
			getgenv().PotionChooseNuke = Value
		end    
	})

	GlovesFunctions:AddButton({
		Name = "Get Potions",
		Callback = function()
			if getgenv().PotionChooseNuke == "Normal" then
				if GetEquippedGlove() == "Alchemist" then
					if not game.Workspace:FindFirstChild(plr.Name.."'s Cauldron") then
						game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
					end
					for b = 1, getgenv().GivePotion do
						if not game.Workspace:FindFirstChild(plr.Name.."'s Cauldron") then
							game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
						end
						for i = 1, #getgenv().GetPotion[getgenv().MakePotion] do
							game.ReplicatedStorage:WaitForChild("AlchemistEvent"):FireServer(unpack({"AddItem", getgenv().GetPotion[getgenv().MakePotion][i]}))
							game.ReplicatedStorage:WaitForChild("AlchemistEvent"):FireServer(unpack({"MixItem", getgenv().GetPotion[getgenv().MakePotion][i]}))
						end
						game.ReplicatedStorage:WaitForChild("AlchemistEvent"):FireServer(unpack({"BrewPotion"}))
						task.wait()
					end
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Alchemist equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif getgenv().PotionChooseNuke == "Nuke" then
				if GetEquippedGlove() == "Alchemist" then
					if not game.Workspace:FindFirstChild(plr.Name.."'s Cauldron") then
						game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
					end
					for b = 1, getgenv().GivePotion do
						if not game.Workspace:FindFirstChild(plr.Name.."'s Cauldron") then
							game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
						end
						for i = 1, #getgenv().GetPotion[getgenv().MakePotion] do
							game.ReplicatedStorage:WaitForChild("AlchemistEvent"):FireServer(unpack({"AddItem", getgenv().GetPotion[getgenv().MakePotion][i]}))
							game.ReplicatedStorage:WaitForChild("AlchemistEvent"):FireServer(unpack({"MixItem", getgenv().GetPotion[getgenv().MakePotion][i]}))
						end
						game.ReplicatedStorage:WaitForChild("AlchemistEvent"):FireServer(unpack({"BrewPotion"}))
					end
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Alchemist equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end    
	})

	PotionAuto = GlovesFunctions:AddToggle({
		Name = "Auto Potion",
		Default = false,
		Callback = function(Value)
			getgenv().AutoGetPotion = Value
			if GetEquippedGlove() == "Alchemist" then
				while getgenv().AutoGetPotion do
					if not game.Workspace:FindFirstChild(plr.Name.."'s Cauldron") then
						game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
					end
					for i = 1, #getgenv().GetPotion[getgenv().MakePotion] do
						game.ReplicatedStorage:WaitForChild("AlchemistEvent"):FireServer(unpack({"AddItem", getgenv().GetPotion[getgenv().MakePotion][i]}))
						game.ReplicatedStorage:WaitForChild("AlchemistEvent"):FireServer(unpack({"MixItem", getgenv().GetPotion[getgenv().MakePotion][i]}))
					end
					game.ReplicatedStorage:WaitForChild("AlchemistEvent"):FireServer(unpack({"BrewPotion"}))
					task.wait()
				end
			elseif getgenv().AutoGetPotion == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Alchemist equipped",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				PotionAuto:Set(false)
			end
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Potion Throw",
		Default = "Speed Potion",
		Options = {"Grug Potion","IdIot Potion","Nightmare Potion","Confusion Potion","Power Potion","Paralyzing Potion","Haste Potion","Invisibility Potion","Expotion","Invincible Potion","Toxic Potion","Freeze Potion","Feather Potion","Speed Potion","Lethal Poison","Slow Potion","Antitoxin Potion"},
		Callback = function(Value)
			getgenv().PotionThrownNuke = Value
		end    
	})

	if getgenv().NukeExtend == nil then
		getgenv().NukeExtend = "90"
	end
	GlovesFunctions:AddTextbox({
		Name = "Nuke Extend",
		Default = "UseNumber",
		TextDisappear = false,
		Callback = function(Value)
			getgenv().NukeExtend = Value
		end	  
	})

	if getgenv().NukeHeightPotion == nil then
		getgenv().NukeHeightPotion = "-5"
	end
	GlovesFunctions:AddTextbox({
		Name = "Nuke Potion Height",
		Default = "UseNumber",
		TextDisappear = false,
		Callback = function(Value)
			getgenv().NukeHeightPotion = Value
		end	  
	})

	GlovesFunctions:AddDropdown({
		Name = "Place",
		Default = "",
		Options = {"Arena", "Island Slapple", "Tournament", "Moai Island", "Player"},
		Callback = function(Value)
			getgenv().PhaceNuke = Value
		end    
	})

	PotionThrowNukeAuto = GlovesFunctions:AddToggle({
		Name = "Auto Throw Nuke Potion",
		Default = false,
		Callback = function(Value)
			getgenv().AutoThrowPotion = Value
			if getgenv().AutoThrowPotion == false then
				if game.Workspace.CurrentCamera and game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
					game.Workspace.CurrentCamera.CameraSubject = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				end
			end
			if getgenv().AutoThrowPotion == true and char:FindFirstChild("entered") == nil and GetEquippedGlove() == "Alchemist" then
				if getgenv().AutoThrowPotion == true then
					char.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame
					if getgenv().PhaceNuke == "Arena" then
						game.Workspace.CurrentCamera.CameraSubject = game.workspace.Origo
					elseif getgenv().PhaceNuke == "Island Slapple" then
						game.Workspace.CurrentCamera.CameraSubject = game.workspace.Arena.island5.Union
					elseif getgenv().PhaceNuke == "Tournament" then
						game.Workspace.CurrentCamera.CameraSubject = workspace.Battlearena.Arena
					elseif getgenv().PhaceNuke == "Moai Island" then
						game.Workspace.CurrentCamera.CameraSubject = game.Workspace.Arena.island4.Grass
					elseif getgenv().PhaceNuke == "Player" then 
						game.Workspace.CurrentCamera.CameraSubject = game.workspace.Origo
					end
				elseif getgenv().AutoThrowPotion == false then
					char.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame
				end
				while getgenv().AutoThrowPotion do
					local RandomTeleX = math.random(-getgenv().NukeExtend,getgenv().NukeExtend)
					local RandomTeleZ = math.random(-getgenv().NukeExtend,getgenv().NukeExtend)
					if getgenv().PhaceNuke == "Arena" then
						char.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(RandomTeleX,getgenv().NukeHeightPotion,RandomTeleZ)
					elseif getgenv().PhaceNuke == "Island Slapple" then
						char.HumanoidRootPart.CFrame = game.workspace.Arena.island5.Union.CFrame * CFrame.new(RandomTeleX,getgenv().NukeHeightPotion,RandomTeleZ)
					elseif getgenv().PhaceNuke == "Tournament" then
						char.HumanoidRootPart.CFrame = workspace.Battlearena.Arena.CFrame * CFrame.new(RandomTeleX,getgenv().NukeHeightPotion,RandomTeleZ)
					elseif getgenv().PhaceNuke == "Moai Island" then
						char.HumanoidRootPart.CFrame = game.Workspace.Arena.island4.Grass.CFrame * CFrame.new(RandomTeleX,getgenv().NukeHeightPotion,RandomTeleZ)
					elseif getgenv().PhaceNuke == "Player" then
						local players = Players:GetChildren()
						local randomPlayer = players[math.random(1, #players)]
						repeat randomPlayer = players[math.random(1, #players)] until randomPlayer ~= plr and randomPlayer.Character:FindFirstChild("entered") and randomPlayer.Character:FindFirstChild("ded") == nil and randomPlayer.Character:FindFirstChild("InLabyrinth") == nil and randomPlayer.Character:FindFirstChild("rock") == nil
						Target = randomPlayer
						char.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0,getgenv().NukeHeightPotion,5)
					end
					task.wait()
					game:GetService("ReplicatedStorage").AlchemistEvent:FireServer("UsePotion",getgenv().PotionThrownNuke,true)
				end
			elseif getgenv().AutoThrowPotion == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You dont't have Alchemist equipped, or you have in the lobby",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				PotionThrowNukeAuto:Set(false)
			end
		end    
	})

	GlovesFunctions:AddTextbox({
		Name = "Speed Ping Pong",
		Default = "UserSpeed",
		TextDisappear = false,
		Callback = function(Value)
			if Value == "inf" or Value == "Inf" or Value == "infinity" or Value == "Infinity" then
				OrbitSpeed = 9e9
			else
				OrbitSpeed = Value
			end
		end	  
	})

	GlovesFunctions:AddSlider({
		Name = "Extend Ping Pong",
		Min = 0,
		Max = 200,
		Default = 15,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "Extend",
		Callback = function(Value)
			getgenv().ExtendPingPong = Value
		end    
	})

	PingPong = GlovesFunctions:AddToggle({
		Name = "Ping Pong Orbit",
		Default = false,
		Callback = function(Value)
			PingPongOrbit = Value
			if GetEquippedGlove() == "Ping Pong" then
				char.Torso.RadioPart.Rotation = char.HumanoidRootPart.Rotation
				Orbit = "0"
				if OrbitSpeed == nil then
					OrbitSpeed = 1
				end
				PingPongBall = plr.Name.."_PingPongBall"
				while PingPongOrbit and GetEquippedGlove() == "Ping Pong" do
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
					Orbit = Orbit + OrbitSpeed
					char.Torso.RadioPart.Rotation = Vector3.new(-180, Orbit, -180)
					if char.Torso.RadioPart:GetChildren()[2] then
						for i,v in pairs(game.Workspace:GetChildren()) do
							if v.ClassName == "Part" and v.Name == PingPongBall then
								v.CFrame = char.Torso.RadioPart.CFrame * CFrame.new(0,0,-getgenv().ExtendPingPong) * CFrame.Angles(math.rad(0), math.rad(-90), math.rad(0))
							end
						end
						for i,v in pairs(char.Torso.RadioPart:GetChildren()) do
							if v.ClassName == "Part" and v.Name == PingPongBall then
								v.CFrame = char.Torso.RadioPart.CFrame * CFrame.new(0,0,getgenv().ExtendPingPong) * CFrame.Angles(math.rad(0), math.rad(90), math.rad(0))
							end
						end
					elseif char.Torso.RadioPart:GetChildren()[1] or char.Torso.RadioPart:GetChildren()[2] then
						for i,v in pairs(game.Workspace:GetChildren()) do
							if v.ClassName == "Part" and v.Name == PingPongBall then
								v.Parent = char.Torso.RadioPart
								break
							end
						end
					end
					task.wait(0.01)
				end
			elseif Value == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Ping Pong equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				PingPong:Set(false)
			end
		end    
	})

	PingPongFling = GlovesFunctions:AddToggle({
		Name = "Ping Pong Fling",
		Default = false,
		Callback = function(Value)
			getgenv().PingPongFlingAll = Value
			if GetEquippedGlove() == "Ping Pong" then
				PingPongBall = plr.Name.."_PingPongBall"
				while getgenv().PingPongFlingAll and GetEquippedGlove() == "Ping Pong" do
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
					local players = Players:GetChildren()
					local RandomPlayer = players[math.random(1, #players)]
					repeat RandomPlayer = players[math.random(1, #players)] until RandomPlayer ~= plr and RandomPlayer.Character:FindFirstChild("rock") == nil and RandomPlayer.Character.Head:FindFirstChild("UnoReverseCard") == nil and RandomPlayer.Character:FindFirstChild("entered")
					Target = RandomPlayer
					if Target ~= plr.Name and Target.Character and Target.Character:WaitForChild("Ragdolled").Value == false then
						for i,v in pairs(game.Workspace:GetChildren()) do
							if v.ClassName == "Part" and v.Name == PingPongBall then
								v.CFrame = Target.Character.HumanoidRootPart.CFrame
							end
						end
					end
					task.wait(0.01)
				end
			elseif Value == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Ping Pong equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				PingPongFling:Set(false)
			end
		end    
	})

	GlovesFunctions:AddTextbox({
		Name = "Ping Pong Player",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().TargeterNameFling = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().TargeterNameFling.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	GlovesFunctions:AddSlider({
		Name = "Extend Ping Pong Player",
		Min = 0,
		Max = 50,
		Default = 15,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "Extend",
		Callback = function(Value)
			getgenv().ExtendPingPongPlayer = Value
		end    
	})

	PingPongPlayerFling = GlovesFunctions:AddToggle({
		Name = "Ping Pong Player",
		Default = false,
		Callback = function(Value)
			getgenv().PingPongFlingPlayer = Value
			if GetEquippedGlove() == "Ping Pong" then
				PingPongBall = plr.Name.."_PingPongBall"
				while getgenv().PingPongFlingPlayer and GetEquippedGlove() == "Ping Pong" do
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
					if Players[getgenv().TargeterNameFling].Character and Players[getgenv().TargeterNameFling].Character:WaitForChild("Ragdolled").Value == false then
						for i,v in pairs(game.Workspace:GetChildren()) do
							if v.ClassName == "Part" and v.Name == PingPongBall then
								v.CFrame = Players[getgenv().TargeterNameFling].Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-getgenv().ExtendPingPongPlayer)
							end
						end
					end
					task.wait()
				end
			elseif Value == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Ping Pong equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				PingPongPlayerFling:Set(false)
			end
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Equipped Glove Farm",
		Default = "",
		Options = {"Baller","Replica","Blink","Reverse"},
		Callback = function(Value)
			if char:FindFirstChild("entered") == nil then
				if Value == "Baller" then
					fireclickdetector(workspace.Lobby["Baller"].ClickDetector)
				elseif Value == "Replica" then
					fireclickdetector(workspace.Lobby["Replica"].ClickDetector)
				elseif Value == "Blink" then
					fireclickdetector(workspace.Lobby["Blink"].ClickDetector)
				elseif Value == "Reverse" then
					fireclickdetector(workspace.Lobby["Reverse"].ClickDetector)
				end
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You aren't in the lobby.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Will Teleport Farm",
		Default = "SafeSpotBox 1.0",
		Options = {"Up To You","SafeSpotBox 1.0","SafeSpotBox 2.0"},
		Callback = function(Value)
			getgenv().GetTeleport = Value
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Slap Farm",
		Default = "Normal",
		Options = {"Normal","Fast × Slap Farm [ Lag ]"},
		Callback = function(Value)
			getgenv().GetSlapGot = Value
		end    
	})

	GlovesFunctions:AddSlider({
		Name = "Slap Farm",
		Min = 1,
		Max = 2000,
		Default = 1,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "Slap",
		Callback = function(Value)
			getgenv().SlapFarmGet = Value
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Ingredient",
		Default = "",
		Options = {"Autumn Sprout", "Blood Rose", "Blue Crystal", "Dark Root", "Dire Flower","Elder Wood", "Fire Flower", "Glowing Mushroom", "Hazel Lily", "Jade Stone","Lamp Grass", "Mushroom", "Plane Flower", "Red Crystal", "Wild Vine", "Winter Rose","Cake Mix"},
		Callback = function(Value)
			AlchemistIngredientsGet = Value
		end    
	})

	GlovesFunctions:AddButton({
		Name = "Get Alchemist Ingredients",
		Callback = function()
			if GetEquippedGlove() == "Alchemist" then
				game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem", AlchemistIngredientsGet)
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Alchemist equipped.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end 
	})

	GetAlchemist = GlovesFunctions:AddToggle({
		Name = "Auto Get Alchemist Ingredients",
		Default = false,
		Callback = function(Value)
			AlchemistIngredients = Value
			if GetEquippedGlove() == "Alchemist" then
				while AlchemistIngredients and GetEquippedGlove() == "Alchemist" do
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem", AlchemistIngredientsGet)
					task.wait()
				end
			elseif AlchemistIngredients == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Alchemist equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				GetAlchemist:Set(false)
			end
		end    
	})

	GetAllAlchemist = GlovesFunctions:AddToggle({
		Name = "Get All Alchemist Ingredients",
		Default = false,
		Callback = function(Value)
			AlchemistIngredients = Value
			if GetEquippedGlove() == "Alchemist" then
				while AlchemistIngredients and GetEquippedGlove() == "Alchemist" do
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Mushroom")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Glowing Mushroom")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Fire Flower")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Winter Rose")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Dark Root")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Dire Flower")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Autumn Sprout")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Elder Wood")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Hazel Lily")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Wild Vine")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Jade Stone")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Lamp Grass")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Plane Flower")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Blood Rose")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Red Crystal")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Blue Crystal")
					game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem","Cake Mix")
					task.wait()
				end
			elseif AlchemistIngredients == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Alchemist equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				GetAllAlchemist:Set(false)
			end
		end    
	})

	GlovesFunctions:AddSlider({
		Name = "Extend HitBox Rob",
		Min = 5,
		Max = 400,
		Default = 20,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "Extend",
		Callback = function(Value)
			getgenv().ExtendHitboxRob = Value
		end    
	})

	GlovesFunctions:AddColorpicker({
		Name = "Color Hitbox Rob",
		Default = Color3.fromRGB(255, 255, 255),
		Callback = function(Value)
			getgenv().ColorHitboxRob = Value
		end	  
	})

	GlovesFunctions:AddToggle({
		Name = "Hitbox All Rob & Color",
		Default = false,
		Callback = function(Value)
			getgenv().HitboxRob = Value
			while getgenv().HitboxRob do
				for i,v in pairs(game.Workspace:GetChildren()) do
					if v.Name == "Field" then
						v.Size = Vector3.new(getgenv().ExtendHitboxRob,getgenv().ExtendHitboxRob,getgenv().ExtendHitboxRob)
						v.BrickColor = BrickColor.new(getgenv().ColorHitboxRob)
					end
				end
				task.wait()
			end
			if getgenv().HitboxRob == false then
				for i,v in pairs(game.Workspace:GetChildren()) do
					if v.Name == "Field" then
						v.Size = Vector3.new(16,16,16)
						v.BrickColor = BrickColor.new(255,255,255)
					end
				end
			end
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Godmode Glove",
		Default = "Golden",
		Options = {"Reverse","Golden"},
		Callback = function(Value)
			SetGodmode = Value
		end    
	})

	GlovesFunctions:AddToggle({
		Name = "Auto Godmode",
		Default = false,
		Callback = function(Value)
			AutoGodmode = Value
			if SetGodmode == "Reverse" and GetEquippedGlove() == "Reverse" then
				while AutoGodmode and SetGodmode == "Reverse" do
					if char:FindFirstChild("entered") and char:FindFirstChild("SelectionBox", 1) == nil and char.Head:FindFirstChild("UnoReverseCard") == nil then
						game:GetService("ReplicatedStorage"):WaitForChild("ReverseAbility"):FireServer()
					end
					task.wait(0.85)
				end
			end
			if SetGodmode == "Golden" and GetEquippedGlove() == "Golden" then
				while AutoGodmode and SetGodmode == "Golden" do
					if char:FindFirstChild("entered") and char.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") then
						game:GetService("ReplicatedStorage").Goldify:FireServer(true)
					end
					task.wait()
				end
			end
		end    
	})

	GlovesFunctions:AddSlider({
		Name = "Speed Cloud",
		Min = 0.1,
		Max = 1.2,
		Default = 0.5,
		Color = Color3.fromRGB(255,255,255),
		Increment = 0.1,
		ValueName = "Speed",
		Callback = function(Value)
			getgenv().SetSpeedCloud = Value
		end    
	})

	CloudSpeed = GlovesFunctions:AddToggle({
		Name = "Auto Set Cloud Speed",
		Default = false,
		Callback = function(Value)
			getgenv().CloudSpeed = Value
			if GetEquippedGlove() == "Cloud" then
				while getgenv().CloudSpeed and GetEquippedGlove() == "Cloud" do
					for i,v in pairs(game.Workspace:GetChildren()) do
						if v.Name:match(plr.Name) and v:FindFirstChild("BodyVelocity") then
							v.BodyVelocity.Velocity = v.BodyVelocity.Velocity * getgenv().SetSpeedCloud
						end
					end
					task.wait(0.10)
				end
			elseif getgenv().CloudSpeed == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Cloud equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				CloudSpeed:Set(false)
			end
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Cloud Bring",
		Default = "",
		Options = {"Player","Your"},
		Callback = function(Value)
			getgenv().CloudBring = Value
		end    
	})

	GlovesFunctions:AddTextbox({
		Name = "Bring Cloud Player",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().BringPlayerCloud = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().BringPlayerCloud.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	CloudBringSit = GlovesFunctions:AddToggle({
		Name = "Auto Bring Cloud",
		Default = false,
		Callback = function(Value)
			getgenv().BringCloud = Value
			if GetEquippedGlove() == "Cloud" then
				while getgenv().BringCloud and getgenv().CloudBring == "Player" and GetEquippedGlove() == "Cloud" do
					if Players[getgenv().BringPlayerCloud].Character and char:FindFirstChild("entered") and Players[getgenv().BringPlayerCloud].Character:FindFirstChild("entered") and Players[getgenv().BringPlayerCloud].Character.Humanoid.Sit == false then
						for i,v in pairs(game.Workspace:GetChildren()) do
							if v.Name:match(plr.Name) and v:FindFirstChild("VehicleSeat") then
								v.VehicleSeat.CFrame = Players[getgenv().BringPlayerCloud].Character.HumanoidRootPart.CFrame * CFrame.new(0,-2.32,0)
							end
						end
					end
					task.wait()
				end
				while getgenv().BringCloud and getgenv().CloudBring == "Your" and GetEquippedGlove() == "Cloud" do
					if char and char:FindFirstChild("entered") and char:FindFirstChildOfClass("Humanoid") ~= nil and char.Humanoid.Sit == false then
						for i,v in pairs(game.Workspace:GetChildren()) do
							if v.Name:match(plr.Name) and v:FindFirstChild("VehicleSeat") then
								v.VehicleSeat.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0,-2.32,0)
							end
						end
					end
					task.wait()
				end
			elseif getgenv().BringCloud == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Cloud equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				CloudBringSit:Set(false)
			end
		end    
	})

	GlovesFunctions:AddDropdown({
		Name = "Firework Bring",
		Default = "",
		Options = {"Player","Your"},
		Callback = function(Value)
			getgenv().FireworkBring = Value
		end    
	})

	GlovesFunctions:AddTextbox({
		Name = "Bring Firework Player",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().BringPlayerFirework = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().BringPlayerFirework.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	FireworkBringSit = GlovesFunctions:AddToggle({
		Name = "Auto Bring Firework",
		Default = false,
		Callback = function(Value)
			getgenv().BringFirework = Value
			if GetEquippedGlove() == "Firework" and char:FindFirstChild("entered") then
				while getgenv().BringFirework and getgenv().FireworkBring == "Player" and GetEquippedGlove() == "Firework" do
					if Players[getgenv().BringPlayerFirework].Character and char:FindFirstChild("entered") and Players[getgenv().BringPlayerFirework].Character:FindFirstChild("entered") and Players[getgenv().BringPlayerFirework].Character.Humanoid.Sit == false then
						for i,v in pairs(game.Workspace:GetChildren()) do
							if v.Name:match(plr.Name) and v:FindFirstChild("VehicleSeat") then
								v.VehicleSeat.CFrame = Players[getgenv().BringPlayerFirework].Character.HumanoidRootPart.CFrame
							end
						end
					end
					task.wait()
				end
				while getgenv().BringFirework and getgenv().FireworkBring == "Your" and GetEquippedGlove() == "Firework" do
					if char and char:FindFirstChild("entered") and char:FindFirstChildOfClass("Humanoid") ~= nil and char.Humanoid.Sit == false then
						for i,v in pairs(game.Workspace:GetChildren()) do
							if v.Name:match(plr.Name) and v:FindFirstChild("VehicleSeat") then
								v.VehicleSeat.CFrame = char.HumanoidRootPart.CFrame
							end
						end
					end
					task.wait()
				end
			elseif GetEquippedGlove() ~= "Firework" then
				if char:FindFirstChild("entered") == nil then
					if game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2628581469266954) then
						fireclickdetector(workspace:FindFirstChild("Lobby"):FindFirstChild("Firework").ClickDetector)
						OrionLib:MakeNotification({Name = "Error",Content = "You need to be in the Arena.",Image = "rbxassetid://7733658504",Time = 5})
					else
						OrionLib:MakeNotification({Name = "Error",Content = "You don't have the Firework badge [Easy As Pie].",Image = "rbxassetid://7733658504",Time = 5})
						FireworkBringSit:Set(false)	
					end
				else
					if not game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2628581469266954) then
						OrionLib:MakeNotification({Name = "Error",Content = "You don't have the Firework badge [Easy As Pie].",Image = "rbxassetid://7733658504",Time = 5})
						FireworkBringSit:Set(false)	
					else
						OrionLib:MakeNotification({Name = "Error",Content = "You need to have equipped the Firework Glove.",Image = "rbxassetid://7733658504",Time = 5})
						FireworkBringSit:Set(false)	
					end
				end
			elseif GetEquippedGlove() == "Firework" and char:FindFirstChild("entered") == nil then
				OrionLib:MakeNotification({Name = "Error",Content = "You need to be in the Arena.",Image = "rbxassetid://7733658504",Time = 5})
				FireworkBringSit:Set(false)
			elseif GetEquippedGlove() ~= "Firework" and char:FindFirstChild("entered") == nil then
				OrionLib:MakeNotification({Name = "Error",Content = "You need to be in the Arena and with Firework Glove equipped.",Image = "rbxassetid://7733658504",Time = 5})
				FireworkBringSit:Set(false)
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You need to equip Firework Glove and be in the Arena.",Image = "rbxassetid://7733658504",Time = 5})
				FireworkBringSit:Set(false)
			end
		end    
	})

	FullKinetic = GlovesFunctions:AddToggle({
		Name = "Auto Full Kinetic",
		Default = false,
		Callback = function(Value)
			local FullKineticSpam = Value
			if GetEquippedGlove() == "Kinetic" and char:FindFirstChild("entered") then
				while FullKineticSpam and GetEquippedGlove() == "Kinetic" do
					game.ReplicatedStorage.SelfKnockback:FireServer({["Force"] = 0,["Direction"] = Vector3.new(0,0.01,0)})
					task.wait()
				end
			elseif Value == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Kinetic equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				FullKinetic:Set(false)
			end
		end    
	})

	GlovesFunctions:AddButton({
		Name = "Infinite Invisibility",
		Callback = function()
			if char:FindFirstChild("entered") == nil and GetSlaps() >= 666 then
				OGlove = GetEquippedGlove()
				fireclickdetector(workspace.Lobby.Ghost.ClickDetector)
				game.ReplicatedStorage.Ghostinvisibilityactivated:FireServer()
				fireclickdetector(workspace.Lobby[OGlove].ClickDetector)
				task.wait(1)
				for i,v in pairs(char:GetChildren()) do
					if v.Name  ~= "Humanoid" then
						v.Transparency = 0
					end
				end
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You need to be in lobby and have 666+ slaps.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	GlovesFunctions:AddColorpicker({
		Name = "Color Skin",
		Default = Color3.fromRGB(255, 0, 0),
		Callback = function(Value)
			getgenv().skinColor = Value
		end	  
	})

	ColorSkin = GlovesFunctions:AddToggle({
		Name = "Auto Color Skin",
		Default = false,
		Callback = function(Value)
			getgenv().GoldColor = Value
			if GetEquippedGlove() == "Golden" then
				while getgenv().GoldColor and GetEquippedGlove() == "Golden" do
					game:GetService("ReplicatedStorage"):WaitForChild("Goldify"):FireServer(false, BrickColor.new(getgenv().skinColor))
					task.wait()
				end
			elseif getgenv().GoldColor == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Golden equipped.",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				ColorSkin:Set(false)
			end
		end    
	})

	RainBox = GlovesFunctions:AddToggle({
		Name = "Auto Rainbow",
		Default = false,
		Callback = function(Value)
			getgenv().Rainbow = Value
			if GetEquippedGlove() == "Golden" then
				while getgenv().Rainbow and GetEquippedGlove() == "Golden" do
					local randomnumber = math.random(1004, 1032)
					game:GetService("ReplicatedStorage").Goldify:FireServer(false, BrickColor.new(randomnumber))
					task.wait(0.075)
				end
			elseif getgenv().Rainbow == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Golden equipped",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				RainBox:Set(false)
			end
		end    
	})

	GlovesFunctions:AddToggle({
		Name = "Invisible Reverse [Visual]",
		Default = false,
		Callback = function(Value)
			local Invis_Reverse = Value
			while Invis_Reverse do
				repeat task.wait() until char:FindFirstChild("SelectionBox", 1) and char:FindFirstChild("Head"):FindFirstChild("UnoReverseCard")
				char.Head["UnoReverseCard"]:Destroy()
				for i,v in pairs(char:GetDescendants()) do
					if v.Name == "SelectionBox" then
						v:Destroy()
					end
				end
				task.wait()
			end
		end    
	})

	Misc:AddToggle({
		Name = "Infinite Jump",
		Default = false,
		Callback = function(Value)
			getgenv().InfiniteJump = Value
			game:GetService("UserInputService").JumpRequest:connect(function()
				if getgenv().InfiniteJump then
					char.Humanoid:ChangeState("Jumping")
				end
			end)
		end    
	})

	Misc:AddDropdown({
		Name = "Godmode",
		Default = "",
		Options = {"Godmode", "Godmode + Invisibility"},
		Callback = function(Value)
			if Value == "Godmode" then
				if char:FindFirstChild("entered") == nil then
					firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1, 0)
					firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1, 1)
				end
				repeat task.wait() until char:FindFirstChildWhichIsA("Tool") or plr.Backpack:FindFirstChildWhichIsA("Tool")
				for i,v in pairs(char:GetChildren()) do
					if v.ClassName == "Tool" then
						v.Parent = game.LogService
					end
				end
				for i,v in pairs(plr.Backpack:GetChildren()) do
					v.Parent = game.LogService
				end
				game:GetService("ReplicatedStorage"):WaitForChild("HumanoidDied"):FireServer(char,false)
				wait(3.75)
				for i,v in pairs(game.LogService:GetChildren()) do
					v.Parent = plr.Backpack
				end
				for i,v in pairs(plr.Backpack:GetChildren()) do
					char.Humanoid:EquipTool(v)
				end 
				char.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(0,-5,0)
			elseif Value == "Godmode + Invisibility" then
				if GetSlaps() >= 666 then
					if char:FindFirstChild("entered") == nil then
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1, 0)
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1, 1)
					end
					repeat task.wait() until char:FindFirstChildWhichIsA("Tool") or plr.Backpack:FindFirstChildWhichIsA("Tool")
					for i,v in pairs(char:GetChildren()) do
						if v.ClassName == "Tool" then
							v.Parent = game.LogService
						end
					end
					for i,v in pairs(plr.Backpack:GetChildren()) do
						v.Parent = game.LogService
					end
					game:GetService("ReplicatedStorage"):WaitForChild("HumanoidDied"):FireServer(char,false)
					wait(3.75)
					OGlove = GetEquippedGlove()
					fireclickdetector(workspace.Lobby.Ghost.ClickDetector)
					game.ReplicatedStorage.Ghostinvisibilityactivated:FireServer()
					fireclickdetector(workspace.Lobby[OGlove].ClickDetector)
					for i,v in pairs(game.LogService:GetChildren()) do
						v.Parent = plr.Backpack
					end
					for i,v in pairs(plr.Backpack:GetChildren()) do
						char.Humanoid:EquipTool(v)
					end 
					char.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(0,-5,0)
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You need 666+ slaps",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end    
	})

	Misc:AddDropdown({
		Name = "Teleport",
		Default = "",
		Options = {"Arena", "Lobby", "Hunter Room", "Brazil", "Island Slapple", "Plate", "Tournament", "Cannon Island", "Equip Glovel", "Keypad", "Cube Of Death", "Moai Island", "Default Arena", "Island 1", "Island 2", "Island 3"},
		Callback = function(Value)
			if Value == "Arena" then
				char.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(0,-5,0)
			elseif Value == "Lobby" then
				char.HumanoidRootPart.CFrame = CFrame.new(-800,328,-2.5)
			elseif Value == "Hunter Room" then
				char.HumanoidRootPart.CFrame = game.workspace.BountyHunterRoom.Union.CFrame * CFrame.new(0,5,0)
			elseif Value == "Brazil" then
				char.HumanoidRootPart.CFrame = game.workspace.Lobby.brazil.portal.CFrame
			elseif Value == "Island Slapple" then
				char.HumanoidRootPart.CFrame = game.workspace.Arena.island5.Union.CFrame * CFrame.new(0,3.25,0)
			elseif Value == "Plate" then
				char.HumanoidRootPart.CFrame = game:GetService("Workspace").Arena.Plate.CFrame
			elseif Value == "Tournament" then
				char.HumanoidRootPart.CFrame = workspace.Battlearena.Arena.CFrame * CFrame.new(0,10,0)
			elseif Value == "Cannon Island" then
				char.HumanoidRootPart.CFrame = workspace.Arena.CannonIsland.Cannon.Base.CFrame * CFrame.new(0,0,35)
			elseif Value == "Equip Glovel" then
				if GetEquippedGlove() == "Extended" and char:FindFirstChild("entered") then
					char.HumanoidRootPart.CFrame = workspace.Arena.CannonIsland.GlovelHoleInTheWall.GlovelHoleInTheWall.CFrame
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Extended equipped.",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif Value == "Keypad" then
				if not workspace:FindFirstChild("Keypad") then
					OrionLib:MakeNotification({Name = "Error",Content = "Current server don't have Keypad.",Image = "rbxassetid://7733658504",Time = 5})
				else
					char.HumanoidRootPart.CFrame = workspace.Keypad.Buttons.Enter.CFrame
				end
			elseif Value == "Cube Of Death" then
				if game.Workspace:FindFirstChild("the cube of death(i heard it kills)", 1) then
					char.HumanoidRootPart.CFrame = game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].Part.CFrame * CFrame.new(0,5,0)
				end
			elseif Value == "Moai Island" then
				char.HumanoidRootPart.CFrame = CFrame.new(215, -15.5, 0.5)
			elseif Value == "Default Arena" then
				char.HumanoidRootPart.CFrame = CFrame.new(120,360,-3)
			elseif Value == "Island 1" then
				char.HumanoidRootPart.CFrame = CFrame.new(-211.210846, -5.27827597, 4.13719559, -0.0225322824, 1.83683113e-08, -0.999746144, -1.83560154e-08, 1, 1.87866842e-08, 0.999746144, 1.87746618e-08, -0.0225322824)
			elseif Value == "Island 2" then
				char.HumanoidRootPart.CFrame = CFrame.new(-8.17191315, -5.14452887, -205.249741, -0.98216176, -3.48867246e-09, -0.188037917, -4.19987778e-09, 1, 3.38382322e-09, 0.188037917, 4.11319823e-09, -0.98216176)
			elseif Value == "Island 3" then
				char.HumanoidRootPart.CFrame = CFrame.new(-6.66747713, -5.06731462, 213.575378, 0.945777893, 2.52095178e-10, 0.324814111, -3.7823856e-08, 1, 1.09357536e-07, -0.324814111, -1.15713661e-07, 0.945777893)
			end
		end    
	})

	Misc:AddDropdown({
		Name = "Animation Combat",
		Default = "",
		Options = {"Skukuchi Attacker", "Skukuchi Target", "Bomb Throw", "Bubble Shoot", "Revolver", "Ban Hammer", "Slapstick", "Dual", "Slap", "Bomb", "Rocket Launcher", "Rojo", "Rojo Recoil", "Thor", "Rob"},
		Callback = function(Value)
			if Value == "Skukuchi Attacker" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.CutsceneAttacker, char.Humanoid):Play()
			elseif Value == "Skukuchi Target" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.CutsceneTarget, char.Humanoid):Play()
			elseif Value == "Bomb Throw" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.bombthrow, char.Humanoid):Play()
			elseif Value == "Bubble Shoot" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.bubbleshoot, char.Humanoid):Play()
			elseif Value == "Revolver" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Hitman.RevolverAnim, char.Humanoid):Play()
			elseif Value == "Ban Hammer" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Retro.Animations["Ban Hammer"], char.Humanoid):Play()
			elseif Value == "Slapstick" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.slapstick_slap, char.Humanoid):Play()
			elseif Value == "Dual" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.DualSlap, char.Humanoid):Play()
			elseif Value == "Slap" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.Slap, char.Humanoid):Play()
			elseif Value == "Bomb" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Retro.Animations.Bomb, char.Humanoid):Play()
			elseif Value == "Rocket Launcher" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Retro.Animations["Rocket Launcher"], char.Humanoid):Play()
			elseif Value == "Rojo" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Rojo.Animation, char.Humanoid):Play()
			elseif Value == "Rojo Recoil" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Rojo.AnimationRecoil, char.Humanoid):Play()
			elseif Value == "Thor" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Thor.Animation, char.Humanoid):Play()
			elseif Value == "Rob" then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.robAnimation, char.Humanoid):Play()
			end
		end    
	})

	Misc:AddTextbox({
		Name = "Animation",
		Default = "Id Animation",
		TextDisappear = false,
		Callback = function(Value)
			getgenv().Animation = Value
		end	  
	})

	Misc:AddButton({
		Name = "Start Animation [From Custom Animation By ID]",
		Callback = function()
			if game.ReplicatedStorage:FindFirstChild("Animation") == nil then
				local Anim = Instance.new("Animation")
				Anim.AnimationId = "rbxassetid://"..getgenv().Animation
				Anim.Name = "Animation"
				Anim.Parent = game.ReplicatedStorage
			elseif game.ReplicatedStorage:FindFirstChild("Animation") ~= nil then
				game.ReplicatedStorage:FindFirstChild("Animation").AnimationId = "rbxassetid://"..getgenv().Animation
			end
			wait(0.5)
			if game.ReplicatedStorage:FindFirstChild("Animation") ~= nil then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.Animation, char.Humanoid):Play()
			end
		end    
	})

	Misc:AddButton({
		Name = "Stop Animation | Destroy",
		Callback = function()
			if game.ReplicatedStorage:FindFirstChild("Animation") ~= nil then
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.Animation, char.Humanoid):Stop()
				game.ReplicatedStorage.Animation:Destroy()
			end
		end    
	})

	Misc:AddToggle({
		Name = "Autofarm Slapples",
		Default = false,
		Callback = function(Value)
			local SlappleFarm = Value
			while SlappleFarm do
				if char:FindFirstChild("entered") then
					for i, v in pairs(workspace.Arena.island5.Slapples:GetChildren()) do
						if char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("entered") and v.Name == "Slapple" or v.Name == "GoldenSlapple" and v:FindFirstChild("Glove") and v.Glove:FindFirstChildWhichIsA("TouchTransmitter") then
							firetouchinterest(char.HumanoidRootPart, v.Glove, 0)
							firetouchinterest(char.HumanoidRootPart, v.Glove, 1)
						end
					end
				end
				task.wait()
			end
		end    
	})

	Misc:AddToggle({
		Name = "Autofarm Candy",
		Default = false,
		Callback = function(Value)
			local CandyCornsFarm = Value
			while CandyCornsFarm do
				for i, v in pairs(game.Workspace.CandyCorns:GetChildren()) do
					if char:FindFirstChild("Head") and v:FindFirstChildWhichIsA("TouchTransmitter") then
						firetouchinterest(char.Head, v, 0)
						firetouchinterest(char.Head, v, 1)
					end
				end
				task.wait()
			end
		end    
	})

	Misc:AddTextbox({
		Name = "Player Teleport",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().PlayerTeleport = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().PlayerTeleport.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	Misc:AddButton({
		Name = "Teleport To Player",
		Callback = function()
			char.HumanoidRootPart.CFrame = Players[getgenv().PlayerTeleport].Character.HumanoidRootPart.CFrame
		end    
	})

	Misc:AddTextbox({
		Name = "Player View",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().ViewPlayer = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().ViewPlayer.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	Misc:AddToggle({
		Name = "Auto View Player",
		Default = false,
		Callback = function(Value)
			getgenv().PlayerView = Value
			if getgenv().PlayerView == false then
				if game.Workspace.CurrentCamera and game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
					game.Workspace.CurrentCamera.CameraSubject = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				end
			end
			while getgenv().PlayerView do
				if game.Workspace.CurrentCamera and Players[getgenv().ViewPlayer].Character and Players[getgenv().ViewPlayer].Character:FindFirstChildOfClass("Humanoid") then
					game.Workspace.CurrentCamera.CameraSubject = Players[getgenv().ViewPlayer].Character:FindFirstChildOfClass("Humanoid")
				end
				task.wait()
			end
		end    
	})

	Misc:AddTextbox({
		Name = "Speed Fly",
		Default = "Userspeed",
		TextDisappear = false,
		Callback = function(Value)
			getgenv().SetSpeedFly = Value
		end	  
	})

	getgenv().SetSpeedFly = 100
	Misc:AddToggle({
		Name = "Start Fly",
		Default = false,
		Callback = function(Value)
			getgenv().StartFly = Value
			if getgenv().StartFly == false then
				if char and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.RootPart and char.HumanoidRootPart:FindFirstChild("VelocityHandler") and char.HumanoidRootPart:FindFirstChild("GyroHandler") then
					char.HumanoidRootPart.VelocityHandler:Destroy()
					char.HumanoidRootPart.GyroHandler:Destroy()
					char.Humanoid.PlatformStand = false
				end
			end
			while getgenv().StartFly do
				if char and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.RootPart and char.HumanoidRootPart:FindFirstChild("VelocityHandler") and char.HumanoidRootPart:FindFirstChild("GyroHandler") then
					char.HumanoidRootPart.VelocityHandler.MaxForce = Vector3.new(9e9,9e9,9e9)
					char.HumanoidRootPart.GyroHandler.MaxTorque = Vector3.new(9e9,9e9,9e9)
					char.Humanoid.PlatformStand = true
					char.HumanoidRootPart.GyroHandler.CFrame = workspace.CurrentCamera.CoordinateFrame
					char.HumanoidRootPart.VelocityHandler.Velocity = Vector3.new()
					if require(plr.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X > 0 then
						char.HumanoidRootPart.VelocityHandler.Velocity = char.HumanoidRootPart.VelocityHandler.Velocity + game.Workspace.CurrentCamera.CFrame.RightVector * (require(plr.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X * getgenv().SetSpeedFly)
					end
					if require(plr.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X < 0 then
						char.HumanoidRootPart.VelocityHandler.Velocity = char.HumanoidRootPart.VelocityHandler.Velocity + game.Workspace.CurrentCamera.CFrame.RightVector * (require(plr.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X * getgenv().SetSpeedFly)
					end
					if require(plr.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z > 0 then
						char.HumanoidRootPart.VelocityHandler.Velocity = char.HumanoidRootPart.VelocityHandler.Velocity - game.Workspace.CurrentCamera.CFrame.LookVector * (require(plr.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z * getgenv().SetSpeedFly)
					end
					if require(plr.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z < 0 then
						char.HumanoidRootPart.VelocityHandler.Velocity = char.HumanoidRootPart.VelocityHandler.Velocity - game.Workspace.CurrentCamera.CFrame.LookVector * (require(plr.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z * getgenv().SetSpeedFly)
					end
				elseif char and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.RootPart and char.HumanoidRootPart:FindFirstChild("VelocityHandler") == nil and char.HumanoidRootPart:FindFirstChild("GyroHandler") == nil then
					local bv = Instance.new("BodyVelocity")
					local bg = Instance.new("BodyGyro")

					bv.Name = "VelocityHandler"
					bv.Parent = char.HumanoidRootPart
					bv.MaxForce = Vector3.new(0,0,0)
					bv.Velocity = Vector3.new(0,0,0)

					bg.Name = "GyroHandler"
					bg.Parent = char.HumanoidRootPart
					bg.MaxTorque = Vector3.new(0,0,0)
					bg.P = 1000
					bg.D = 50
				end
				task.wait()
			end
		end    
	})

	Misc:AddDropdown({
		Name = "Pocket",
		Default = "Add All Player",
		Options = {"Add All Player","Remove All Player"},
		Callback = function(Value)
			getgenv().StartMusicGot = Value
		end    
	})

	Misc:AddButton({
		Name = "Pocket Player",
		Callback = function()
			if getgenv().StartMusicGot == "Add All Player" then
				if GetEquippedGlove() == "Pocket" then
					for i,v in pairs(Players:GetPlayers()) do
						game:GetService("ReplicatedStorage").PocketWhitelist:FireServer("add", v)
					end
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Pocket Equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif getgenv().StartMusicGot == "Remove All Player" then
				if GetEquippedGlove() == "Pocket" then
					for i,v in pairs(Players:GetPlayers()) do
						game:GetService("ReplicatedStorage").PocketWhitelist:FireServer("remove", v)
					end
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Pocket Equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end    
	})

	Misc:AddTextbox({
		Name = "Play Pocket Radio",
		Default = "UserIDMusic",
		TextDisappear = false,
		Callback = function(Value)
			getgenv().IDPocketRadio = Value
		end	  
	})

	Misc:AddDropdown({
		Name = "Music",
		Default = "Play",
		Options = {"Play","Stop"},
		Callback = function(Value)
			getgenv().StartMusicGot = Value
		end    
	})

	Misc:AddButton({
		Name = "Play Music",
		Callback = function()
			if getgenv().StartMusicGot == "Play" then
				if GetEquippedGlove() == "Pocket" then
					game:GetService("ReplicatedStorage").PocketMusic:FireServer("play","rbxassetid://"..getgenv().IDPocketRadio)
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Pocket Equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif getgenv().StartMusicGot == "Stop" then
				if GetEquippedGlove() == "Pocket" then
					game:GetService("ReplicatedStorage").PocketMusic:FireServer("stop")
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Pocket Equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end    
	})

	Misc:AddButton({
		Name = "Auto Keypad",
		Callback = function()
			if not workspace:FindFirstChild("Keypad") then
				OrionLib:MakeNotification({Name = "Error",Content = "Current server don't have any Keypad. Starting Serverhop...",Image = "rbxassetid://7733658504",Time = 5})
				task.wait(1.5)
				for _, v in ipairs(game.HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
					if v.playing < v.maxPlayers and v.JobId ~= game.JobId then
						game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id)
					end
				end
			else
				game.Workspace.CurrentCamera.CameraSubject = workspace.Keypad.Buttons.Enter
				fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Reset").ClickDetector)
				local digits = tostring((#Players:GetPlayers()) * 25 + 1100 - 7)
				for i = 1, #digits do
					wait(.5)
					local digit = digits:sub(i,i)
					fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild(digit).ClickDetector)
				end
				wait(1)
				fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Enter").ClickDetector)
			end
		end    
	})

	Notifykeypad = Misc:AddToggle({
		Name = "Auto Notification Keypad",
		Default = false,
		Callback = function(Value)
			getgenv().NotifyKeypad = Value
			while getgenv().NotifyKeypad do
				if not game.Workspace:FindFirstChild("Keypad") then
					repeat task.wait() until game.Workspace:FindFirstChild("Keypad")
					OrionLib:MakeNotification({Name = "Keypad Spawned",Content = "Keypad Spawn.",Image = "rbxassetid://7733658504",Time = 8})
					Notifykeypad:Set(false)
				else
					OrionLib:MakeNotification({Name = "Keypad Spawned",Content = "Available Keypad.",Image = "rbxassetid://7733658504",Time = 5})
					NotifyToolbox:Set(false)
				end
				task.wait(0.05)
			end
		end    
	})

	NotifyToolbox = Misc:AddToggle({
		Name = "Auto Notification ToolBox",
		Default = false,
		Callback = function(Value)
			getgenv().NotifyToolBox = Value
			while getgenv().NotifyToolBox do
				if not game.Workspace:FindFirstChild("Toolbox") then
					repeat task.wait() until game.Workspace:FindFirstChild("Toolbox")
					OrionLib:MakeNotification({Name = "Item Spawned",Content = "Toolbox Spawn.",Image = "rbxassetid://7733658504",Time = 5})
					NotifyToolbox:Set(false)
				else
					OrionLib:MakeNotification({Name = "Item Spawned",Content = "Available Toolbox.",Image = "rbxassetid://7733658504",Time = 5})
					NotifyToolbox:Set(false)
				end
				task.wait(0.05)
			end
		end    
	})

	NotifyAdminJoin = Misc:AddToggle({
		Name = "Auto Notification Admin Join",
		Default = false,
		Callback = function(Value)
			getgenv().NotifyAdminJoin = Value
			while getgenv().NotifyAdminJoin do
				for i,v in pairs(Players:GetChildren()) do
					if v:GetRankInGroup(9950771) >= 2 or v:GetRankInGroup(9950771) >= 3 or v:GetRankInGroup(9950771) >= 4 or v:GetRankInGroup(9950771) >= 5 or v:GetRankInGroup(9950771) >= 7 or v:GetRankInGroup(9950771) >= 8 or v:GetRankInGroup(9950771) >= 9 or v:GetRankInGroup(9950771) >= 10 or v:GetRankInGroup(9950771) >= 11 or v:GetRankInGroup(9950771) >= 12 then
						OrionLib:MakeNotification({Name = "Staff Joined",Content = "Admin [ "..v.Name.." ] Has Joined",Image = "rbxassetid://7733658504",Time = 5})
						NotifyAdminJoin:Set(false)
					else
						OrionLib:MakeNotification({Name = "Staff Joined",Content = "Available Admin [ "..v.Name.." ]",Image = "rbxassetid://7733658504",Time = 5})
						NotifyAdminJoin:Set(false)
					end
				end
				task.wait()
			end
		end    
	})

	Misc:AddTextbox({
		Name = "Write Code Keypad",
		Default = "",
		TextDisappear = false,
		Callback = function(Value)
			getgenv().writeCode = Value
		end	  
	})

	Misc:AddDropdown({
		Name = "Enter Keypad",
		Default = "Enter",
		Options = {"Not Enter","Enter"},
		Callback = function(Value)
			getgenv().EnterKeypad = Value
		end    
	})

	Misc:AddButton({
		Name = "Write Code Keypad Start",
		Callback = function()
			if getgenv().EnterKeypad == "Not Enter" then
				if not workspace:FindFirstChild("Keypad") then
					OrionLib:MakeNotification({Name = "Error",Content = "Current server don't have Keypad.",Image = "rbxassetid://7733658504",Time = 5})
				else
					game.Workspace.CurrentCamera.CameraSubject = workspace.Keypad.Buttons.Enter
					fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Reset").ClickDetector)
					for i = 1,#getgenv().writeCode do
						wait(.5)
						local digit = getgenv().writeCode:sub(i,i)
						fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild(digit).ClickDetector)
					end
				end
			elseif getgenv().EnterKeypad == "Enter" then
				if not workspace:FindFirstChild("Keypad") then
					OrionLib:MakeNotification({Name = "Error",Content = "Current server don't have Keypad.",Image = "rbxassetid://7733658504",Time = 5})
				else
					game.Workspace.CurrentCamera.CameraSubject = workspace.Keypad.Buttons.Enter
					fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Reset").ClickDetector)
					for i = 1,#getgenv().writeCode do
						wait(.5)
						local digit = getgenv().writeCode:sub(i,i)
						fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild(digit).ClickDetector)
					end
					wait(1)
					fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Enter").ClickDetector)
				end
			end
		end    
	})

	Misc:AddDropdown({
		Name = "Easter Egg Code",
		Default = "",
		Options = {"911","8008","666","6969","1987"},
		Callback = function(Value)
			getgenv().EggCodes = Value
		end    
	})

	Misc:AddButton({
		Name = "Easter Egg Keypad",
		Callback = function()
			if not workspace:FindFirstChild("Keypad") then
				OrionLib:MakeNotification({Name = "Error",Content = "Current server don't have Keypad.",Image = "rbxassetid://7733658504",Time = 5})
			else
				game.Workspace.CurrentCamera.CameraSubject = workspace.Keypad.Buttons.Enter
				fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Reset").ClickDetector)
				for i = 1,#getgenv().EggCodes do
					wait(.5)
					local digit = getgenv().EggCodes:sub(i,i)
					fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild(digit).ClickDetector)
				end
				wait(1)
				fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Enter").ClickDetector)
			end
		end    
	})

	Misc:AddTextbox({
		Name = "ID Badge",
		Default = "UseId",
		TextDisappear = false,
		Callback = function(Value)
			getgenv().IdBadgeGetNotify = Value
		end	  
	})

	Misc:AddButton({
		Name = "Check Badge",
		Callback = function()
			if not game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, getgenv().IdBadgeGetNotify) then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Owner Item",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You have Owner Item",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	Misc:AddDropdown({
		Name = "Retro Help",
		Default = "",
		Options = {"Get Retro","Teleport Button","Enter Retro"},
		Callback = function(Value)
			getgenv().HelpPlayerGetHehe = Value
		end    
	})

	Misc:AddTextbox({
		Name = "Help Player Retro",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().PlayerRetroGo = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().PlayerRetroGo.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	Misc:AddButton({
		Name = "Player Help Retro",
		Callback = function()
			if getgenv().HelpPlayerGetHehe == "Get Retro" then
				if GetEquippedGlove() == "Recall" then
					if game.Workspace:FindFirstChild("Retro") == nil then
						game.ReplicatedStorage.Assets.Retro.Parent = game.Workspace
					end
					wait(0.5)
					char.HumanoidRootPart.CFrame = workspace.FinishDoor_Retro.Part.CFrame
					wait(1)
					game:GetService("ReplicatedStorage").Recall:InvokeServer(game:GetService("Players").LocalPlayer.Character.Recall)
					task.wait(2.4)
					char.HumanoidRootPart.CFrame = Players[getgenv().PlayerRetroGo].Character.HumanoidRootPart.CFrame
					wait(1)
					char.HumanoidRootPart.CFrame = workspace.FinishDoor_Retro.Part.CFrame
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Recall equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif getgenv().HelpPlayerGetHehe == "Teleport Button" then
				if GetEquippedGlove() == "Recall" then
					if game.Workspace:FindFirstChild("Retro") == nil then
						game.ReplicatedStorage.Assets.Retro.Parent = game.Workspace
					end
					wait(0.5)
					char.HumanoidRootPart.CFrame = CFrame.new(-16976, 801, 4907)
					wait(1)
					game:GetService("ReplicatedStorage").Recall:InvokeServer(game:GetService("Players").LocalPlayer.Character.Recall)
					task.wait(2.4)
					char.HumanoidRootPart.CFrame = Players[getgenv().PlayerRetroGo].Character.HumanoidRootPart.CFrame
					wait(1)
					char.HumanoidRootPart.CFrame = CFrame.new(-16976, 801, 4907)
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Recall equipped",Image = "rbxassetid://7733658504",Time = 5})
				end
			elseif getgenv().HelpPlayerGetHehe == "Enter Retro" then
				if GetEquippedGlove() == "Glitch" and GetSlaps() >= 50000 and char:FindFirstChild("entered") == nil and Players[getgenv().PlayerRetroGo].Character:FindFirstChild("entered") then
					char.HumanoidRootPart.CFrame = Players[getgenv().PlayerRetroGo].Character.HumanoidRootPart.CFrame
					wait(0.35)
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
					fireclickdetector(game.Workspace.Lobby["Error"].ClickDetector)
					task.wait(8.5)
					char.HumanoidRootPart.CFrame = Players[getgenv().PlayerRetroGo].Character.HumanoidRootPart.CFrame
					wait(0.07)
					Magnitude = (char.HumanoidRootPart.Position - Players[getgenv().PlayerRetroGo].Character.HumanoidRootPart.Position).Magnitude
					if 30 >= Magnitude then
						game.ReplicatedStorage.Errorhit:FireServer(Players[getgenv().PlayerRetroGo].Character:WaitForChild("Head"),true)
					end
				else
					OrionLib:MakeNotification({Name = "Error",Content = "You have in Lobby | Player [ "..getgenv().PlayerRetroGo.." ] in arena, or You don't have Glitch equipped, or you have don't have 50K Slap",Image = "rbxassetid://7733658504",Time = 5})
				end
			end
		end    
	})

	Misc:AddTextbox({
		Name = "Help Player Get Quake",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().HelpPlayerGetQuake = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().HelpPlayerGetQuake.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	Misc:AddButton({
		Name = "Start Help Player [Quake]",
		Callback = function()
			if GetEquippedGlove() == "Home Run" and char:FindFirstChild("entered") == nil and Players[getgenv().HelpPlayerGetQuake].leaderstats.Glove.Value == "Berserk" then
				local OGLSize = Players[getgenv().HelpPlayerGetQuake].Character.HumanoidRootPart.Size
				game:GetService("ReplicatedStorage").HomeRun:FireServer({["start"] = true})
				fireclickdetector(game.Workspace.Lobby.woah.ClickDetector)
				wait(4.2)
				char.HumanoidRootPart.CFrame = Players[getgenv().HelpPlayerGetQuake].Character.HumanoidRootPart.CFrame
				task.wait(.2)
				game:GetService("ReplicatedStorage").VineThud:FireServer()
				task.wait(1)
				fireclickdetector(game.Workspace.Lobby["Home Run"].ClickDetector)
				Players[getgenv().HelpPlayerGetQuake].Character.HumanoidRootPart.Size = Vector3.new(50,50,50)
				wait(0.2)
				char.HumanoidRootPart.CFrame = Players[getgenv().HelpPlayerGetQuake].Character.HumanoidRootPart.CFrame
				wait(0.1)
				game:GetService("ReplicatedStorage").HomeRun:FireServer({["finished"] = true})
				wait(3)
				Players[getgenv().HelpPlayerGetQuake].Character.HumanoidRootPart.Size = OGLSize
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Home Run equipped, or you have to go lobby, or player don't have Berserk equipped.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end 
	})

	Misc:AddTextbox({
		Name = "Help Player Get Goofy",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().HelpPlayerGetGoofy = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().HelpPlayerGetGoofy.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	Misc:AddButton({
		Name = "Start Help Player [Goofy]",
		Callback = function()
			if GetEquippedGlove() == "Confusion" and char:FindFirstChild("entered") == nil and game:GetService("BadgeService"):UserHasBadgeAsync(plr.UserId, 2133016756) then
				char.HumanoidRootPart.CFrame = Players[getgenv().HelpPlayerGetGoofy].Character.HumanoidRootPart.CFrame
				wait(0.2)
				Magnitude = (char.HumanoidRootPart.Position - Players[getgenv().HelpPlayerGetGoofy].Character.HumanoidRootPart.Position).Magnitude
				if 30 >= Magnitude then
					game:GetService("ReplicatedStorage"):WaitForChild("GeneralHit"):FireServer(Players[getgenv().HelpPlayerGetGoofy].Character:WaitForChild("HumanoidRootPart"))
				end
				fireclickdetector(workspace.Lobby.Goofy.ClickDetector)
				wait(2)
				char.HumanoidRootPart.CFrame = Players[getgenv().HelpPlayerGetGoofy].Character.HumanoidRootPart.CFrame
				wait(0.2)
				Magnitude = (char.HumanoidRootPart.Position - Players[getgenv().HelpPlayerGetGoofy].Character.HumanoidRootPart.Position).Magnitude
				if 30 >= Magnitude then
					game:GetService("ReplicatedStorage"):WaitForChild("GeneralHit"):FireServer(Players[getgenv().HelpPlayerGetGoofy].Character:WaitForChild("HumanoidRootPart"))
				end
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Confusion equipped, or you have to go lobby.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end 
	})

	Misc:AddDropdown({
		Name = "Will Teleport Help",
		Default = "Up To You",
		Options = {"Up To You","SafeSpotBox 1.0","SafeSpotBox 2.0"},
		Callback = function(Value)
			getgenv().GetTeleportHelp = Value
		end    
	})

	Misc:AddTextbox({
		Name = "Help Player Get Berserk",
		Default = "Username",
		TextDisappear = false,
		Callback = function(Value)
			local targetAbbreviation = Value
			local targetPlayer
			for _, v in pairs(Players:GetPlayers()) do
				if string.sub(v.Name, 1, #targetAbbreviation):lower() == targetAbbreviation:lower() then
					targetPlayer = v
					break
				end
			end
			if targetPlayer then
				getgenv().HelpPlayerGetBerserk = targetPlayer.Name
				OrionLib:MakeNotification({Name = "Error",Content = "Found Player [ "..getgenv().HelpPlayerGetBerserk.." ]",Image = "rbxassetid://7733658504",Time = 5})
			else
				OrionLib:MakeNotification({Name = "Error",Content = "Can't find player",Image = "rbxassetid://7733658504",Time = 5})
			end
		end	  
	})

	Misc:AddSlider({
		Name = "Time Help Berserk",
		Min = 1,
		Max = 3,
		Default = 3,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "Time",
		Callback = function(Value)
			getgenv().TimeHelpGotIm = Value
		end    
	})

	Misc:AddButton({
		Name = "Start Help Player [Berserk]",
		Callback = function()
			if GetEquippedGlove() == "Kinetic" and char:FindFirstChild("entered") and Players[getgenv().HelpPlayerGetBerserk].Character:FindFirstChild("entered") then
				for o = 1,getgenv().TimeHelpGotIm do
					if getgenv().GetTeleportHelp == "Up To You" then
						OGL = char.HumanoidRootPart.CFrame
					elseif getgenv().GetTeleportHelp == "SafeSpotBox 1.0" then
						char.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
					elseif getgenv().GetTeleportHelp == "SafeSpotBox 2.0" then
						char.HumanoidRootPart.CFrame = workspace["Safespot"].CFrame * CFrame.new(0,10,0)
					end
					char.Humanoid:UnequipTools()
					for i = 1,150 do
						game.ReplicatedStorage.SelfKnockback:FireServer({["Force"] = 0,["Direction"] = Vector3.new(0,0.01,0)})
						task.wait()
					end
					wait(2.8)
					if getgenv().GetTeleportHelp == "Up To You" then
						char.HumanoidRootPart.CFrame = OGL
					elseif getgenv().GetTeleportHelp == "SafeSpotBox 1.0" or getgenv().GetTeleportHelp == "SafeSpotBox 2.0" then
						char.HumanoidRootPart.CFrame = Players[getgenv().HelpPlayerGetBerserk].Character.Head.CFrame * CFrame.new(0,5.80,0)
					end
					wait(0.28)
					if plr.Backpack:FindFirstChild("Kinetic") then
						char.Humanoid:EquipTool(plr.Backpack.Kinetic)
					end
					wait(0.19)
					game:GetService("ReplicatedStorage").KineticExpl:FireServer(char.Kinetic, char.HumanoidRootPart.Position)
					char.Humanoid:UnequipTools()
					wait(0.7)
					if getgenv().GetTeleportHelp == "Up To You" then
						char.HumanoidRootPart.CFrame = OGL
					elseif getgenv().GetTeleportHelp == "SafeSpotBox 1.0" then
						char.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
					elseif getgenv().GetTeleportHelp == "SafeSpotBox 2.0" then
						char.HumanoidRootPart.CFrame = workspace["Safespot"].CFrame * CFrame.new(0,10,0)
					end
					wait(3.8)
				end
			else
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Kinetic equipped, or you have to go Arena, or player have go to arena.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end 
	})

	Misc:AddSlider({
		Name = "HipHeight AutoFarm Slap",
		Min = 0,
		Max = 20,
		Default = 0,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "Hip",
		Callback = function(Value)
			getgenv().HipAutoFarmSlap = Value
		end    
	})

	Misc:AddToggle({
		Name = "AutoFarm Slap",
		Default = false,
		Callback = function(Value)
			getgenv().AutoFarmSlap = Value
			while getgenv().AutoFarmSlap do
				for i,v in pairs(Players:GetChildren()) do
					if v ~= plr and char:FindFirstChild("HumanoidRootPart") and v.Character then
						if char:FindFirstChild("entered") and v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false then
							if v.Character.Head:FindFirstChild("UnoReverseCard") == nil or GetEquippedGlove() == "Error" then
								if getgenv().AutoFarmSlap == true then
									char.HumanoidRootPart.CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,getgenv().HipAutoFarmSlap,0)
									task.wait(0.5)
									gloveHits[GetEquippedGlove()]:FireServer(v.Character:WaitForChild("HumanoidRootPart"),true)
									task.wait(0.43)
								end
							end
						end
					end
				end
				task.wait()
			end
		end    
	})

	Misc:AddToggle({
		Name = "Auto Slap Ball",
		Default = false,
		Callback = function(Value)
			getgenv().AutoSlapBall = Value
			while getgenv().AutoSlapBall do
				if game.Workspace:FindFirstChild("Balls") then
					for i, v in pairs(workspace:GetChildren()) do
						if v.Name == "Balls" then
							for i, z in pairs(v:GetChildren()) do
								if string.find(z.Name, "'s Ball") then
									game:GetService("ReplicatedStorage").Events.BeachBall:FireServer(z, Vector3.new(game:GetService("Workspace").CurrentCamera.CFrame.LookVector.X, 0, game:GetService("Workspace").CurrentCamera.CFrame.LookVector.Z).Unit * 0.2)
								end
							end
						end
					end
				end
				task.wait()
			end
		end    
	})

	getgenv().OnAbility = false
	Misc:AddToggle({
		Name = "Auto Spam Ability",
		Default = false,
		Callback = function(Value)
			getgenv().OnAbility = Value
			while getgenv().OnAbility and GetEquippedGlove() == "Fort" do
				game:GetService("ReplicatedStorage").Fortlol:FireServer()
				wait(3.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Home Run" do
				game:GetService("ReplicatedStorage").HomeRun:FireServer({["start"] = true})
				game:GetService("ReplicatedStorage").HomeRun:FireServer({["finished"] = true})
				task.wait(4.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "🗿" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer(char.Head.CFrame * CFrame.new(0, -2, -10))
				wait(3.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Shukuchi" do
				local players = Players:GetChildren()
				local RandomPlayer = players[math.random(1, #players)]
				repeat RandomPlayer = players[math.random(1, #players)] until RandomPlayer ~= plr and RandomPlayer.Character:FindFirstChild("rock") == nil and RandomPlayer.Character.Head:FindFirstChild("UnoReverseCard") == nil
				Target = RandomPlayer
				if char and char:FindFirstChild("HumanoidRootPart") and char.Head:FindFirstChild("RedEye") == nil then
					char.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
				end
				wait(0.09)
				game:GetService("ReplicatedStorage").SM:FireServer(Target)
				wait(0.8)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Slicer" do
				game:GetService("ReplicatedStorage").Slicer:FireServer("sword")
				game:GetService("ReplicatedStorage").Slicer:FireServer("slash", char.HumanoidRootPart.CFrame, Vector3.new())
				wait(5.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Reverse" do
				game:GetService("ReplicatedStorage"):WaitForChild("ReverseAbility"):FireServer()
				task.wait(5.7)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "rob" do
				game:GetService("ReplicatedStorage").rob:FireServer()
				wait(3)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "bob" do
				game:GetService("ReplicatedStorage").bob:FireServer()
				wait(9)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Kraken" do
				game:GetService("ReplicatedStorage").KrakenArm:FireServer()
				wait(5)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Sbeve" do
				game:GetService("ReplicatedStorage").KrakenArm:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Psycho" do
				game:GetService("ReplicatedStorage").Psychokinesis:InvokeServer({["grabEnabled"] = true})
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Killstreak" do
				game:GetService("ReplicatedStorage").KSABILI:FireServer()
				wait(6.9)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "bus" do
				game:GetService("ReplicatedStorage").busmoment:FireServer()
				wait(5.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Mitten" do
				game:GetService("ReplicatedStorage").MittenA:FireServer()
				wait(5.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Defense" do
				game:GetService("ReplicatedStorage").Barrier:FireServer()
				wait(0.25)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Bomb" do
				game:GetService("ReplicatedStorage").BombThrow:FireServer()
				wait(2.5)
				game:GetService("ReplicatedStorage").BombThrow:FireServer()
				wait(4.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Replica" do
				game:GetService("ReplicatedStorage").Duplicate:FireServer(true)
				wait(5.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Pusher" do
				game:GetService("ReplicatedStorage").PusherWall:FireServer()
				wait(5.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Jet" do
				local players = Players:GetChildren()
				local RandomPlayer = players[math.random(1, #players)]
				repeat RandomPlayer = players[math.random(1, #players)] until RandomPlayer ~= plr and RandomPlayer.Character:FindFirstChild("entered") and RandomPlayer.Character:FindFirstChild("rock") == nil
				Target = RandomPlayer
				game:GetService("ReplicatedStorage").AirStrike:FireServer(Target.Character)
				wait(5.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Tableflip" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				wait(3.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Shield" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				wait(3.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Rocky" do
				game:GetService("ReplicatedStorage").RockyShoot:FireServer()
				task.wait(7.5)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "God's Hand" do
				game:GetService("ReplicatedStorage").TimestopJump:FireServer()
				game:GetService("ReplicatedStorage").Timestopchoir:FireServer()
				game:GetService("ReplicatedStorage").Timestop:FireServer()
				wait(50.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Za Hando" do
				game:GetService("ReplicatedStorage").Erase:FireServer()
				wait(5.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Baller" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				wait(4.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Glitch" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				wait(5.34)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Stun" do
				game:GetService("ReplicatedStorage").StunR:FireServer(game:GetService("Players").LocalPlayer.Character.Stun)
				wait(10.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "STOP" do
				game:GetService("ReplicatedStorage").STOP:FireServer(true)
				wait(4.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Quake" do
				game:GetService("ReplicatedStorage"):WaitForChild("QuakeQuake"):FireServer({["start"] = true})
				game:GetService("ReplicatedStorage"):WaitForChild("QuakeQuake"):FireServer({["finished"] = true})
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Track" do
				local players = Players:GetChildren()
				local RandomPlayer = players[math.random(1, #players)]
				repeat RandomPlayer = players[math.random(1, #players)] until RandomPlayer ~= plr and RandomPlayer.Character:FindFirstChild("entered") and RandomPlayer.Character:FindFirstChild("rock") == nil
				Target = RandomPlayer
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer(Target.Character)
				wait(10.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Mail" do
				game:GetService("ReplicatedStorage").MailSend:FireServer()
				wait(3.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Shard" do
				game:GetService("ReplicatedStorage").Shards:FireServer()
				wait(4.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "fish" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				wait(3.05)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Null" do
				game:GetService("ReplicatedStorage").NullAbility:FireServer()
				wait(0.01)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Counter" do
				game:GetService("ReplicatedStorage").Counter:FireServer()
				char.Humanoid.WalkSpeed = 20
				task.wait(6.2)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Voodoo" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				task.wait(6.27)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Swapper" do
				game:GetService("ReplicatedStorage").SLOC:FireServer()
				wait(5.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Gravity" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Bubble" do
				game:GetService("ReplicatedStorage").BubbleThrow:FireServer()
				wait(3.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Slapple" do
				game:GetService("ReplicatedStorage").funnyTree:FireServer(char.HumanoidRootPart.Position)
				wait(3.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Detonator" do
				game:GetService("ReplicatedStorage").Fart:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Berserk" do
				game:GetService("ReplicatedStorage").BerserkCharge:FireServer(game:GetService("Players").LocalPlayer.Character.Berserk)
				wait(2.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Rojo" do
				game:GetService("ReplicatedStorage"):WaitForChild("RojoAbility"):FireServer("Release", {char.HumanoidRootPart.CFrame})
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Kinetic" do
				OGL = char.HumanoidRootPart.CFrame
				char.Humanoid:UnequipTools()
				for i = 1,100 do
					game.ReplicatedStorage.SelfKnockback:FireServer({["Force"] = 0,["Direction"] = Vector3.new(0,0.01,0)})
					task.wait(0.05)
				end
				wait(2)
				char.HumanoidRootPart.CFrame = OGL
				if plr.Backpack:FindFirstChild("Kinetic") then
					char.Humanoid:EquipTool(plr.Backpack.Kinetic)
				end
				game:GetService("ReplicatedStorage").KineticExpl:FireServer(char.Kinetic, char.HumanoidRootPart.Position)
				char.Humanoid:UnequipTools()
				wait(2.2)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Dominance" do
				game:GetService("ReplicatedStorage").DominanceAc:FireServer(char.HumanoidRootPart.Position)
				wait(3.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "[REDACTED]" do
				game:GetService("ReplicatedStorage").Well:FireServer()
				wait(5.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Duelist" do
				game:GetService("ReplicatedStorage").DuelistAbility:FireServer()
				wait(5.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Engineer" do
				game:GetService("ReplicatedStorage").Sentry:FireServer()
				wait(5.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Brick" do
				game:GetService("ReplicatedStorage").lbrick:FireServer()
				game:GetService("Players").LocalPlayer.PlayerGui.BRICKCOUNT.ImageLabel.TextLabel.Text = game:GetService("Players").LocalPlayer.PlayerGui.BRICKCOUNT.ImageLabel.TextLabel.Text + 1
				wait(1.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Trap" do
				game:GetService("ReplicatedStorage").funnyhilariousbeartrap:FireServer()
				wait(3.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "woah" do
				game:GetService("ReplicatedStorage").VineThud:FireServer()
				wait(5.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Ping Pong" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Recall" do
				game:GetService("ReplicatedStorage").Recall:InvokeServer(game:GetService("Players").LocalPlayer.Character.Recall)
				wait(3.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "ZZZZZZZ" do
				game:GetService("ReplicatedStorage").ZZZZZZZSleep:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Adios" do
				game:GetService("ReplicatedStorage").AdiosActivated:FireServer()
				wait(8.3)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Boogie" do
				if plr.Backpack:FindFirstChild("Boogie") then
					char.Humanoid:EquipTool(plr.Backpack.Boogie)
				end
				game:GetService("ReplicatedStorage").BoogieBall:FireServer(char.Boogie, char.HumanoidRootPart.Position)
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Balloony" do
				if plr.Backpack:FindFirstChild("Balloony") then
					char.Humanoid:EquipTool(plr.Backpack.Balloony)
				end
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer(game:GetService("Players").LocalPlayer.Character.Balloony)
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Phase" do
				game:GetService("ReplicatedStorage").PhaseA:FireServer()
				wait(5.475)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Hallow Jack" do
				game:GetService("ReplicatedStorage"):WaitForChild("Hallow"):FireServer()
				wait(3.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Phantom" do
				game:GetService("ReplicatedStorage").PhantomDash:InvokeServer(workspace[plr.Name].Phantom) 
				wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Sparky" do
				game:GetService("ReplicatedStorage").Sparky:FireServer(game:GetService("Players").LocalPlayer.Character.Sparky)
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Charge" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer(game:GetService("Players").LocalPlayer.Character.Charge)
				wait(3.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Coil" do
				game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(game:GetService("Players").LocalPlayer.Character.Coil)
				char.Humanoid.WalkSpeed = Walkspeed
				wait(3.1)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Diamond" do
				game:GetService("ReplicatedStorage"):WaitForChild("Rockmode"):FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "MEGAROCK" do
				game:GetService("ReplicatedStorage"):WaitForChild("Rockmode"):FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Excavator" do
				game:GetService("ReplicatedStorage"):WaitForChild("Excavator"):InvokeServer()
				game:GetService("ReplicatedStorage"):WaitForChild("ExcavatorCancel"):FireServer()
				wait(7.3)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Thor" do
				game:GetService("ReplicatedStorage").ThorAbility:FireServer(char.HumanoidRootPart.CFrame)
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Meteor" do
				game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Sun" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer("Cast")
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Whirlwind" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Guardian Angel" do
				game.ReplicatedStorage.GeneralAbility:FireServer(plr)
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Parry" do
				game.ReplicatedStorage.GeneralAbility:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "MR" do
				game:GetService("ReplicatedStorage").Spherify:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Druid" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				task.wait(3.21)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Oven" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer(char.HumanoidRootPart.CFrame)
				wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Jester" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer("Ability1")
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Ferryman" do
				local players = Players:GetChildren()
				local randomPlayer = players[math.random(1, #players)]
				repeat randomPlayer = players[math.random(1, #players)] until randomPlayer ~= plr and randomPlayer.Character:FindFirstChild("entered") and randomPlayer.Character:FindFirstChild("ded") == nil and randomPlayer.Character:FindFirstChild("InLabyrinth") == nil and randomPlayer.Character:FindFirstChild("rock") == nil
				Target = randomPlayer
				char.FerrymanStaff.StaffConfig.AbilityEvent:FireServer("Leap")
				wait(1.85)
				char.FerrymanStaff.StaffConfig.AbilityEvent:FireServer("FinishLeap",Target.Character.HumanoidRootPart.Position)
				task.wait(3.9)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Scythe" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Blackhole" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Jebaited" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer(char.HumanoidRootPart.Position)
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Blink" do
				game:GetService("ReplicatedStorage").Blink:FireServer("OutOfBody", {["dir"] = Vector3.new(0, 0, 0),["ismoving"] = false,["mousebehavior"] = Enum.MouseBehavior.Default})
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Joust" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer("Start")
				char.Humanoid.WalkSpeed = 40
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Slapstick" do
				game:GetService("ReplicatedStorage").slapstick:FireServer("charge")
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Firework" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Chicken" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Lamp" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "BONK" do
				game:GetService("ReplicatedStorage").BONK:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Frostbite" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer(2)
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Golem" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer("recall")
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Grab" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Spoonful" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer({["state"] = "vfx",["origin"] = char.HumanoidRootPart.CFrame * CFrame.Angles(-3.141592502593994, 1.0475832223892212, 3.141592502593994),["vfx"] = "jumptween",["sendplr"] = game:GetService("Players").LocalPlayer})
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer({["state"] = "vfx",["cf"] = char.HumanoidRootPart.CFrame * CFrame.Angles(-2.1319260597229004, 0.651054859161377, 2.3744168281555176),["vfx"] = "crash"})
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "el gato" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "UFO" do
				if game.Workspace:FindFirstChild(plr.Name.."'s UFO VFX") == nil and game.Workspace:FindFirstChild(plr.Name.."'s UFO") == nil then
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				end
				task.wait(0.3)
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Hive" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Siphon" do
				game:GetService("ReplicatedStorage").Events.Siphon:FireServer({["cf"] = char.HumanoidRootPart.CFrame})
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Demolition" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer("c4")
				game:GetService("ReplicatedStorage").Events.c4:FireServer()
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Shotgun" do
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer("buckshot")
				task.wait()
			end
			while getgenv().OnAbility and GetEquippedGlove() == "Beachball" do
				if workspace.Balls:FindFirstChild(plr.Name.."'s Ball") == nil then
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				elseif workspace.Balls:FindFirstChild(plr.Name.."'s Ball").Position < -10 then
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				end
				wait(0.2)
				if workspace.Balls:FindFirstChild(plr.Name.."'s Ball") then
					game:GetService("ReplicatedStorage").Events.BeachBall:FireServer(workspace.Balls:FindFirstChild(plr.Name.."'s Ball"), Vector3.new(game:GetService("Workspace").CurrentCamera.CFrame.LookVector.X, 0, game:GetService("Workspace").CurrentCamera.CFrame.LookVector.Z).Unit * 0.2)
				end
				task.wait()
			end
		end    
	})

	Misc:AddDropdown({
		Name = "Ability Spam All Glove",
		Default = "Null",
		Options = {"Null", "Rhythm Explosion"},
		Callback = function(Value)
			AbilitySpamAllGlove = Value
		end    
	})

	Misc:AddToggle({
		Name = "Spam Ability All Glove",
		Default = false,
		Callback = function(Value)
			local SpamAbility = Value
			while SpamAbility and AbilitySpamAllGlove == "Null" do
				game:GetService("ReplicatedStorage").NullAbility:FireServer()
				wait(0.1)
			end
			while SpamAbility and AbilitySpamAllGlove == "Rhythm Explosion" do
				game:GetService("ReplicatedStorage").rhythmevent:FireServer("AoeExplosion",0)
				task.wait()
			end
		end    
	})

	Misc:AddToggle({
		Name = "Spam Ability 250 Kill",
		Default = false,
		Callback = function(Value)
			getgenv().SpamAbliKilll = Value
			while getgenv().SpamAbliKilll do
				if char:FindFirstChild("KS250Complete") then
					game:GetService("ReplicatedStorage").TheForce:FireServer()
				end
				task.wait()
			end
		end    
	})

	Misc:AddToggle({
		Name = "AutoFarm Kill",
		Default = false,
		Callback = function(Value)
			getgenv().AutoFarmKill = Value
			if getgenv().AutoFarmKill == true then
				if getgenv().ClosestMagnitude == nil then
					getgenv().ClosestMagnitude = 99999
				end
			else
				if getgenv().ClosestMagnitude then
					getgenv().ClosestMagnitude = nil
				end
			end
			while getgenv().AutoFarmKill do
				for _, v in pairs(Players:GetPlayers()) do
					if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("entered") then
						local Magnitude = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
						if Magnitude <= getgenv().ClosestMagnitude then
							getgenv().ClosestMagnitude = Magnitude
							RandomPlayer = v
						end
					end
				end
				if RandomPlayer.Character:FindFirstChild("entered") == nil or RandomPlayer.Character.Humanoid.Health == 0 or RandomPlayer.Character:FindFirstChild("Torso") and RandomPlayer.Character.Torso.Anchored == true then
					getgenv().ClosestMagnitude = 999999
					RandomPlayer = nil
				end
				if RandomPlayer and getgenv().ClosestMagnitude ~= 999999 then
					if RandomPlayer ~= plr and char:FindFirstChild("HumanoidRootPart") and RandomPlayer.Character then
						if char:FindFirstChild("entered") and RandomPlayer.Character:FindFirstChild("entered") and RandomPlayer.Character:FindFirstChild("HumanoidRootPart") and RandomPlayer.Character.Ragdolled.Value == false then
							char.HumanoidRootPart.CFrame = RandomPlayer.Character:FindFirstChild("Head").CFrame
							wait(0.19)
							game.ReplicatedStorage.KSHit:FireServer(RandomPlayer.Character:WaitForChild("Head"))
							char.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
						end
					end
				end
				task.wait(0.4)
			end
		end    
	})

	RhythmNote = Misc:AddToggle({
		Name = "Infinite Rhythm",
		Default = false,
		Callback = function(Value)
			local RhythmNoteSpam = Value
			if GetEquippedGlove() == "Rhythm" then
				while RhythmNoteSpam and GetEquippedGlove() == "Rhythm" do
					plr.PlayerGui.Rhythm.LocalScript.Disabled = false
					plr.PlayerGui.Rhythm.LocalScript.Disabled = true
					char.Rhythm:Activate()
					task.wait()
				end
			elseif RhythmNoteSpam == true then
				OrionLib:MakeNotification({Name = "Error",Content = "You don't have Rhythm equipped",Image = "rbxassetid://7733658504",Time = 5})
				wait(0.05)
				RhythmNote:Set(false)
			end
		end    
	})

	Misc:AddButton({
		Name = "Auto Play Rhythm",
		Callback = function()
			plr.PlayerGui.Rhythm.MainFrame.Bars.ChildAdded:Connect(function()
				task.delay(1.65, function()
					char:FindFirstChild("Rhythm"):Activate()
				end)
			end)
		end    
	})

	Misc:AddDropdown({
		Name = "Rojo Spawn",
		Default = "",
		Options = {"Attack","Attack Fake"},
		Callback = function(Value)
			if Value == "Attack" then
				char.HumanoidRootPart.Anchored = true
				game:GetService("ReplicatedStorage"):WaitForChild("RojoAbility"):FireServer("Charge")
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Rojo.Animation, char.Humanoid):Play()
				wait(5)
				game:GetService("ReplicatedStorage"):WaitForChild("RojoAbility"):FireServer("Release", {char.HumanoidRootPart.CFrame})
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Rojo.AnimationRecoil, char.Humanoid):Play()
				char.HumanoidRootPart.Anchored = false
			elseif Value == "Attack Fake" then
				game:GetService("ReplicatedStorage"):WaitForChild("RojoAbility"):FireServer("Charge")
				char.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Rojo.Animation, char.Humanoid):Play()
			end
		end    
	})

	Misc:AddButton({
		Name = "Free All Animations",
		Callback = function()
			
			local EP
			
			local Floss = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Floss, char.Humanoid)
			local Groove = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Groove, char.Humanoid)
			local Headless = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Headless, char.Humanoid)
			local Helicopter = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Helicopter, char.Humanoid)
			local Kick = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Kick, char.Humanoid)
			local L = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.L, char.Humanoid)
			local Laugh = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Laugh, char.Humanoid)
			local Parker = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Parker, char.Humanoid)
			local Spasm = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Spasm, char.Humanoid)
			local Thriller = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Thriller, char.Humanoid)
			plr.Chatted:connect(function(msg)
				if char:FindFirstChild("HumanoidRootPart") then
					Floss = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Floss, char.Humanoid)
					Groove = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Groove, char.Humanoid)
					Headless = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Headless, char.Humanoid)
					Helicopter = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Helicopter, char.Humanoid)
					Kick = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Kick, char.Humanoid)
					L = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.L, char.Humanoid)
					Laugh = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Laugh, char.Humanoid)
					Parker = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Parker, char.Humanoid)
					Spasm = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Spasm, char.Humanoid)
					Thriller = char.Humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Thriller, char.Humanoid)
					if string.lower(msg) == "/e floss" then
						Floss:Play()
					elseif string.lower(msg) == "/e groove" then
						Groove:Play()
					elseif string.lower(msg) == "/e headless" then
						Headless:Play()
					elseif string.lower(msg) == "/e helicopter" then
						Helicopter:Play()
					elseif string.lower(msg) == "/e kick" then
						Kick:Play()
					elseif string.lower(msg) == "/e l" then
						L:Play()
					elseif string.lower(msg) == "/e laugh" then
						Laugh:Play()
					elseif string.lower(msg) == "/e parker" then
						Parker:Play()
					elseif string.lower(msg) == "/e spasm" then
						Spasm:Play()
					elseif string.lower(msg) == "/e thriller" then
						Thriller:Play()
					end
					EP = char.HumanoidRootPart.Position
				end
			end)
			game:GetService("RunService").Heartbeat:Connect(function()
				if EP ~= nil and char:FindFirstChild("HumanoidRootPart") and Floss.IsPlaying or Groove.IsPlaying or Headless.IsPlaying or Helicopter.IsPlaying or Kick.IsPlaying or L.IsPlaying or Laugh.IsPlaying or Parker.IsPlaying or Spasm.IsPlaying or Thriller.IsPlaying then
					Magnitude = (char.HumanoidRootPart.Position - EP).Magnitude
					if Magnitude > 1 then
						Floss:Stop(); Groove:Stop(); Headless:Stop(); Helicopter:Stop(); Kick:Stop(); L:Stop(); Laugh:Stop(); Parker:Stop(); Spasm:Stop(); Thriller:Stop()
					end
				end
			end)
		end    
	})

	Misc:AddButton({
		Name = "Destroy All Tycoon",
		Callback = function()
			for i,v in pairs(workspace:GetDescendants()) do
				if v.Name == "Destruct" and v:FindFirstChild("ClickDetector") then
					for i = 1,110 do
						fireclickdetector(v.ClickDetector)
					end
				end
			end
		end    
	})

	Misc:AddTextbox({
		Name = "Glove to Equip",
		Default = "Default",
		TextDisappear = true,
		Callback = function(Value)
			getgenv().EquipGlove = Value
		end	  
	})

	Misc:AddButton({
		Name = "Equip Glove",
		Callback = function()
			if char:FindFirstChild("entered") == nil then
				local gloveToEquip

				if getgenv().EquipGlove then
					local Lobby = workspace:FindFirstChild("Lobby")
					
					if Lobby then
						if Lobby:FindFirstChild(getgenv().EquipGlove) then
							gloveToEquip = Lobby[getgenv().EquipGlove]
						else
							for i, v in pairs(Lobby:GetChildren()) do
								if v.Name:lower() == getgenv().EquipGlove:lower() then
									gloveToEquip = v
									break
								elseif v.Name:gsub(" ", ""):lower() == getgenv().EquipGlove:lower() then
									gloveToEquip = v
									break
								elseif v.Name:gsub(" ", ""):lower() == getgenv().EquipGlove:gsub(" ", ""):lower() then
									gloveToEquip = v
									break
								else
									gloveToEquip = Lobby:FindFirstChild("Default")
								end
							end
						end
					end
					
					if gloveToEquip then
						fireclickdetector(gloveToEquip.ClickDetector)
					end
					
				end

			else
				OrionLib:MakeNotification({Name = "Error",Content = "You aren't in the lobby.",Image = "rbxassetid://7733658504",Time = 5})
			end
		end    
	})

	Misc:AddButton({
		Name = "Serverhop",
		Callback = function()
			local serverList = {}
			for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
				if v.playing and type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
					serverList[#serverList + 1] = v.id
				end
			end
			if #serverList > 0 then
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, serverList[math.random(1, #serverList)])
			end
		end
	})

	Misc:AddButton({
		Name = "Destroy Light & Sky",
		Callback = function()
			for _, v in pairs(game.Lighting:GetChildren()) do
				v:Destroy()
			end
		end    
	})

	Misc:AddDropdown({
		Name = "Enter",
		Default = "Arena",
		Options = {"Arena", "Arena Default"},
		Callback = function(Value)
			AutoEnter = Value
		end    
	})

	Misc:AddToggle({
		Name = "Auto Enter",
		Default = false,
		Callback = function(Value)		
			getgenv().AutoEnter = Value
			while getgenv().AutoEnter and AutoEnter == "Arena" do
				repeat task.wait() until char
				if not char:FindFirstChild("entered") and char:FindFirstChild("HumanoidRootPart") then
					repeat task.wait()
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
					until char:FindFirstChild("entered")
				end
				task.wait()
			end
			while getgenv().AutoEnter and AutoEnter == "Arena Default" do
				repeat task.wait() until char
				if not char:FindFirstChild("entered") and char:FindFirstChild("HumanoidRootPart") then
					repeat task.wait()
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport2.TouchInterest.Parent, 0)
						firetouchinterest(char:WaitForChild("Head"), workspace.Lobby.Teleport2.TouchInterest.Parent, 1)
					until char:FindFirstChild("entered")
				end
				task.wait()
			end
		end    
	})

	Misc:AddSlider({
		Name = "Reach Slap Aura",
		Min = 10,
		Max = 50,
		Default = 25,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "Reach",
		Callback = function(Value)
			getgenv().ReachSlapArua = Value
		end    
	})

	Misc:AddDropdown({
		Name = "Slap Aura Friend",
		Default = "Fight",
		Options = {"Fight", "Not Fight"},
		Callback = function(Value)
			SlapAuraFriend = Value
		end    
	})

	Misc:AddDropdown({
		Name = "Slap Aura Character",
		Default = "Head",
		Options = {"HumanoidRootPart", "Head", "Left Arm", "Left Leg", "Right Arm", "Right Leg"},
		Callback = function(Value)
			SlapAuraCharacter = Value
		end    
	})

	Misc:AddDropdown({
		Name = "Slap Aura Choose",
		Default = "Normal",
		Options = {"Normal", "Reverse"},
		Callback = function(Value)
			getgenv().SlapAuraChoose = Value
		end    
	})

	Misc:AddToggle({
		Name = "Slap Aura",
		Default = false,
		Callback = function(Value)
			local SlapAura = Value
			if getgenv().SlapAuraChoose == "Normal" then
				while SlapAura and SlapAuraFriend == "Fight" and getgenv().SlapAuraChoose == "Normal" do
					pcall(function()
						for i,v in pairs(Players:GetChildren()) do
							if v ~= plr and char:FindFirstChild("HumanoidRootPart") and v.Character then
								if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false and v.Character:FindFirstChild("Mirage") == nil then
									if v.Character.Head:FindFirstChild("UnoReverseCard") == nil or GetEquippedGlove() == "Error" then
										Magnitude = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
										if getgenv().ReachSlapArua >= Magnitude then
											gloveHits[GetEquippedGlove()]:FireServer(v.Character:WaitForChild(SlapAuraCharacter),true)
										end
									end
								end
							end
						end
					end)
					pcall(function()
						for _, c in pairs(workspace:GetChildren()) do
							if string.find(c.Name, "Å") and c:FindFirstChild("HumanoidRootPart") then
								local Magnitude1 = (char.HumanoidRootPart.Position - c.HumanoidRootPart.Position).Magnitude
								if getgenv().ReachSlapArua >= Magnitude1 then
									gloveHits[GetEquippedGlove()]:FireServer(c:WaitForChild(SlapAuraCharacter),true)
								end
							end
						end
					end)
					pcall(function()
						if game.Workspace:FindFirstChild("Balls") then
							for i, g in pairs(workspace:GetChildren()) do
								if g.Name == "Balls" then
									for i, z in pairs(g:GetChildren()) do
										if string.find(z.Name, "'s Ball") then
											Magnitude = (char.HumanoidRootPart.Position - z.Position).Magnitude
											if getgenv().ReachSlapArua >= Magnitude then
												game:GetService("ReplicatedStorage").Events.BeachBall:FireServer(z, Vector3.new(game:GetService("Workspace").CurrentCamera.CFrame.LookVector.X, 0, game:GetService("Workspace").CurrentCamera.CFrame.LookVector.Z).Unit * 0.2)
											end
										end
									end
								end
							end
						end
					end)
					task.wait(.1)
				end
				while SlapAura and SlapAuraFriend == "Not Fight" and getgenv().SlapAuraChoose == "Normal" do
					pcall(function()
						for i, v in pairs(Players:GetChildren()) do
							if v ~= plr and char:FindFirstChild("HumanoidRootPart") and v.Character then
								if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and not plr:IsFriendsWith(v.UserId) and v.Character.Ragdolled.Value == false and v.Character:FindFirstChild("Mirage") == nil then
									if v.Character.Head:FindFirstChild("UnoReverseCard") == nil or GetEquippedGlove() == "Error" then
										Magnitude = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
										if getgenv().ReachSlapArua >= Magnitude then
											gloveHits[GetEquippedGlove()]:FireServer(v.Character:WaitForChild(SlapAuraCharacter),true)
										end
									end
								end
							end
						end
					end)
					pcall(function()
						for i, c in pairs(workspace:GetChildren()) do
							if string.find(c.Name, "Å") and c:FindFirstChild("HumanoidRootPart") then
								local Magnitude1 = (char.HumanoidRootPart.Position - c.HumanoidRootPart.Position).Magnitude
								if getgenv().ReachSlapArua >= Magnitude1 then
									gloveHits[GetEquippedGlove()]:FireServer(c:WaitForChild(SlapAuraCharacter),true)
								end
							end
						end
					end)
					pcall(function()
						if game.Workspace:FindFirstChild("Balls") then
							for i, g in pairs(workspace:GetChildren()) do
								if g.Name == "Balls" then
									for i, z in pairs(g:GetChildren()) do
										if string.find(z.Name, "'s Ball") then
											Magnitude = (char.HumanoidRootPart.Position - z.Position).Magnitude
											if getgenv().ReachSlapArua >= Magnitude then
												game:GetService("ReplicatedStorage").Events.BeachBall:FireServer(z, Vector3.new(game:GetService("Workspace").CurrentCamera.CFrame.LookVector.X, 0, game:GetService("Workspace").CurrentCamera.CFrame.LookVector.Z).Unit * 0.2)
											end
										end
									end
								end
							end
						end
					end)
					task.wait(.1)
				end
			elseif getgenv().SlapAuraChoose == "Reverse" then
				while SlapAura and getgenv().SlapAuraChoose == "Reverse" do
					for i,v in pairs(Players:GetChildren()) do
						if v ~= plr and char:FindFirstChild("HumanoidRootPart") and v.Character then
							if v.Character:FindFirstChild("entered") and char:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") then
								if v.Character.Head:FindFirstChild("UnoReverseCard") and char.Head:FindFirstChild("UnoReverseCard") then
									Magnitude = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
									if getgenv().ReachSlapArua >= Magnitude then
										game.ReplicatedStorage.ReverseHit:FireServer(v.Character:WaitForChild(SlapAuraCharacter),true)
									end
								end
							end
						end
					end
					task.wait()
				end
			end
		end    
	})

	Misc:AddSlider({
		Name = "Reach Shukuchi",
		Min = 1,
		Max = 130,
		Default = 50,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "Reach",
		Callback = function(Value)
			getgenv().ReachShukuchi = Value
		end    
	})

	Misc:AddDropdown({
		Name = "Shukuchi Friend",
		Default = "Fight",
		Options = {"Fight", "Not Fight"},
		Callback = function(Value)
			ShukuchiFriend = Value
		end    
	})

	AutoShukuchi = Misc:AddToggle({
		Name = "Auto Shukuchi Player",
		Default = false,
		Callback = function(Value)
			getgenv().AutoShukuchi = Value
			if ShukuchiFriend == "Fight" then
				if GetEquippedGlove() == "Shukuchi" then
					while getgenv().AutoShukuchi and GetEquippedGlove() == "Shukuchi" and ShukuchiFriend == "Fight" do
						for i,v in pairs(Players:GetPlayers()) do
							if v ~= plr and char:FindFirstChild("HumanoidRootPart") and v.Character then
								if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Head:FindFirstChild("RedEye") == nil and not plr:IsFriendsWith(v.UserId) and v.Character:FindFirstChild("Mirage") == nil then
									if v.Character.Head:FindFirstChild("UnoReverseCard") == nil then
										Magnitude = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
										if getgenv().ReachShukuchi >= Magnitude then
											game:GetService("ReplicatedStorage").SM:FireServer(v)
										end
									end
								end
							end
						end
						task.wait()
					end
				elseif getgenv().AutoShukuchi == true then
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Shukuchi equipped.",Image = "rbxassetid://7733658504",Time = 5})
					wait(0.05)
					AutoShukuchi:Set(false)
				end
			elseif ShukuchiFriend == "Not Fight" then
				if GetEquippedGlove() == "Shukuchi" then
					while getgenv().AutoShukuchi and GetEquippedGlove() == "Shukuchi" and ShukuchiFriend == "Not Fight" do
						for i,v in pairs(Players:GetPlayers()) do
							if v ~= plr and char:FindFirstChild("HumanoidRootPart") and v.Character then
								if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Head:FindFirstChild("RedEye") == nil and v.Character:FindFirstChild("Mirage") == nil then
									if v.Character.Head:FindFirstChild("UnoReverseCard") == nil then
										Magnitude = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
										if getgenv().ReachShukuchi >= Magnitude then
											game:GetService("ReplicatedStorage").SM:FireServer(v)
										end
									end
								end
							end
						end
						task.wait()
					end
				elseif getgenv().AutoShukuchi == true then
					OrionLib:MakeNotification({Name = "Error",Content = "You don't have Shukuchi equipped.",Image = "rbxassetid://7733658504",Time = 5})
					wait(0.05)
					AutoShukuchi:Set(false)
				end
			end
		end    
	})

	Misc:AddSlider({
		Name = "Reach HitBox",
		Min = 2,
		Max = 30,
		Default = 10,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "Reach",
		Callback = function(Value)
			getgenv().ReachHitbox = Value
		end    
	})

	Misc:AddToggle({
		Name = "Hitbox Player",
		Default = false,
		Callback = function(Value)
			getgenv().HitboxPlayer = Value
			while getgenv().HitboxPlayer do
				for i,v in pairs(Players:GetChildren()) do
					if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
						v.Character.HumanoidRootPart.Size = Vector3.new(getgenv().ReachHitbox,getgenv().ReachHitbox,getgenv().ReachHitbox)
						v.Character.HumanoidRootPart.Transparency = 0.75
					end
				end
				task.wait()
			end
			if getgenv().HitboxPlayer == false then
				for i,v in pairs(Players:GetChildren()) do
					if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
						v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
						v.Character.HumanoidRootPart.Transparency = 1
					end
				end
			end
		end    
	})

	Misc:AddSlider({
		Name = "Extend Glove",
		Min = 2,
		Max = 50,
		Default = 5,
		Color = Color3.fromRGB(255,255,255),
		Increment = 1,
		ValueName = "Extend",
		Callback = function(Value)
			getgenv().GloveExtendReach = Value
		end    
	})

	Misc:AddDropdown({
		Name = "Extend Option",
		Default = "Meat Stick",
		Options = {"Meat Stick","Pancake","Growth","North Korea Wall","Slight Extend"},
		Callback = function(Value)
			GloveExtendOption = Value
		end    
	})

	Misc:AddToggle({
		Name = "Extend Glove",
		Default = false,
		Callback = function(Value)
			getgenv().GloveExtendGet = Value
			while getgenv().GloveExtendGet do
				if plr:WaitForChild("Backpack"):FindFirstChildOfClass("Tool") ~= nil then
					for _,v in pairs(plr.Backpack:GetChildren()) do
						if v:IsA("Tool") and v.Name ~= "Radio" then
							if v:FindFirstChild("Glove") ~= nil then
								if GloveExtendOption == "Meat Stick" then
									v:FindFirstChild("Glove").Size = Vector3.new(0, getgenv().GloveExtendReach, 2)
								elseif GloveExtendOption == "Pancake" then
									v:FindFirstChild("Glove").Size = Vector3.new(0, getgenv().GloveExtendReach, getgenv().GloveExtendReach)
								elseif GloveExtendOption == "Growth" then
									v:FindFirstChild("Glove").Size = Vector3.new(getgenv().GloveExtendReach,getgenv().GloveExtendReach,getgenv().GloveExtendReach)
								elseif GloveExtendOption == "North Korea Wall" then
									v:FindFirstChild("Glove").Size = Vector3.new(getgenv().GloveExtendReach,0,getgenv().GloveExtendReach)
								elseif GloveExtendOption == "Slight Extend" then
									v:FindFirstChild("Glove").Size = Vector3.new(3, 3, 3.7)
								end
								v:FindFirstChild("Glove").Transparency = 0.5
							end
						end
					end
				else
					for _,v in pairs(char:GetChildren()) do
						if v:IsA("Tool") and v.Name ~= "Radio" then
							if v:FindFirstChild("Glove") ~= nil then
								if GloveExtendOption == "Meat Stick" then
									v:FindFirstChild("Glove").Size = Vector3.new(0, getgenv().GloveExtendReach, 2)
								elseif GloveExtendOption == "Pancake" then
									v:FindFirstChild("Glove").Size = Vector3.new(0, getgenv().GloveExtendReach, getgenv().GloveExtendReach)
								elseif GloveExtendOption == "Growth" then
									v:FindFirstChild("Glove").Size = Vector3.new(getgenv().GloveExtendReach,getgenv().GloveExtendReach,getgenv().GloveExtendReach)
								elseif GloveExtendOption == "North Korea Wall" then
									v:FindFirstChild("Glove").Size = Vector3.new(getgenv().GloveExtendReach,0,getgenv().GloveExtendReach)
								elseif GloveExtendOption == "Slight Extend" then
									v:FindFirstChild("Glove").Size = Vector3.new(3, 3, 3.7)
								end
								v:FindFirstChild("Glove").Transparency = 0.5
							end
						end
					end
				end
				task.wait()
			end
			if getgenv().GloveExtendGet == false then
				if plr:WaitForChild("Backpack"):FindFirstChildOfClass("Tool") ~= nil then
					for _,v in pairs(plr.Backpack:GetChildren()) do
						if v:IsA("Tool") and v.Name ~= "Radio" then
							if v:FindFirstChild("Glove") ~= nil then
								v:FindFirstChild("Glove").Size = Vector3.new(2.5, 2.5, 1.7)
								v:FindFirstChild("Glove").Transparency = 0
							end
						end
					end
				else
					for _,v in pairs(char:GetChildren()) do
						if v:IsA("Tool") and v.Name ~= "Radio" then
							if v:FindFirstChild("Glove") ~= nil then
								v:FindFirstChild("Glove").Size = Vector3.new(2.5, 2.5, 1.7)
								v:FindFirstChild("Glove").Transparency = 0
							end
						end
					end
				end
			end
		end    
	})

	Misc:AddColorpicker({
		Name = "Color ESP",
		Default = Color3.fromRGB(111, 255, 0),
		Callback = function(Value)
			getgenv().ColorESP = Value
		end	  
	})

	Misc:AddToggle({
		Name = "ESP Glove",
		Default = false,
		Callback = function(Value)
			getgenv().GloveESP = Value
			if getgenv().GloveESP == false then
				for i, v in ipairs(Players:GetChildren()) do
					if v.Character and v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild("GloveEsp") then
						v.Character.Head.GloveEsp:Destroy()
					end
				end
			end
			while getgenv().GloveESP do
				for i,v in ipairs(Players:GetChildren()) do
					if v ~= plr and v.Character and v.Character:FindFirstChild("Head") then
						if v.Character.Head:FindFirstChild("GloveEsp") and v.Character.Head.GloveEsp:FindFirstChild("TextLabel") and v.Character.Head.GloveEsp.TextLabel.TextColor3 ~= getgenv().ColorESP then
							v.Character.Head.GloveEsp.TextLabel.TextColor3 = getgenv().ColorESP
						end
						if v.Character.Head:FindFirstChild("GloveEsp") and v.Character.Head.GloveEsp:FindFirstChild("TextLabel") and v.Character.Head.GloveEsp.TextLabel.Text ~= "Glove [ "..v.leaderstats.Glove.Value.." ]" then
							v.Character.Head.GloveEsp.TextLabel.Text = "Glove [ "..v.leaderstats.Glove.Value.." ]"
						end
						if v.Character.Head:FindFirstChild("GloveEsp") == nil then
							local GloveEsp = Instance.new("BillboardGui", v.Character.Head)
							GloveEsp.Adornee = v.Character.Head
							GloveEsp.Name = "GloveEsp"
							GloveEsp.Size = UDim2.new(0, 100, 0, 150)
							GloveEsp.StudsOffset = Vector3.new(0, 1, 0)
							GloveEsp.AlwaysOnTop = true
							GloveEsp.StudsOffset = Vector3.new(0, 3, 0)
							local GloveEspText = Instance.new("TextLabel", GloveEsp)
							GloveEspText.BackgroundTransparency = 1
							GloveEspText.Size = UDim2.new(0, 100, 0, 100)
							GloveEspText.TextSize = 20
							GloveEspText.Font = Enum.Font.FredokaOne
							GloveEspText.TextColor3 = getgenv().ColorESP
							GloveEspText.TextStrokeTransparency = 0.5
							GloveEspText.Text = "[ "..v.leaderstats.Glove.Value.." ]"
						end
					end
				end
				task.wait()
			end
		end    
	})

	Misc:AddTextbox({
		Name = "Auto Change Nametag",
		Default = "Nametag",
		TextDisappear = false,
		Callback = function(Value)
			game.Workspace.NametagChanged.Value = Value
		end	  
	})

	Misc:AddToggle({
		Name = " Auto Change Nametag",
		Default = false,
		Callback = function(Value)
			local AutoChangeNameTag = Value
			if AutoChangeNameTag == true and char:FindFirstChild("Nametag",true) then
				char.Head.Nametag.TextLabel.Text = game.Workspace.NametagChanged.Value
			end
			workspace.NametagChanged.Changed:Connect(function()
				if AutoChangeNameTag == true and char:FindFirstChild("Nametag",true) then
					char.Head.Nametag.TextLabel.Text = game.Workspace.NametagChanged.Value
				end
			end)
			plr.CharacterAdded:Connect(function()
				if AutoChangeNameTag == true then
					repeat task.wait() until char:FindFirstChild("Nametag",true)
					char.Head.Nametag.TextLabel.Text = game.Workspace.NametagChanged.Value
				end
			end)
		end    
	})

	Misc:AddDropdown({
		Name = "Tycoon Auto",
		Default = "All",
		Options = {"All","Your"},
		Callback = function(Value)
			getgenv().TycoonAuto = Value
		end    
	})

	Misc:AddToggle({
		Name = "Auto Click Tycoon",
		Default = false,
		Callback = function(Value)
			getgenv().AutoClickTycoon = Value
			if getgenv().TycoonAuto == "All" then
				while getgenv().AutoClickTycoon and getgenv().TycoonAuto == "All" do
					for _,v in pairs(game.Workspace:GetChildren()) do
						if string.find(v.Name, "ÅTycoon") and v:FindFirstChild("Click") then
							fireclickdetector(v.Click.ClickDetector, 0)
							fireclickdetector(v.Click.ClickDetector, 1)
						end
					end
					task.wait()
				end
			elseif getgenv().TycoonAuto == "Your" then
				while getgenv().AutoClickTycoon and getgenv().TycoonAuto == "Your" do
					for _,v in pairs(game.Workspace:GetChildren()) do
						if v.Name:match(plr.Name) and v:FindFirstChild("Click") then
							fireclickdetector(v.Click.ClickDetector, 0)
							fireclickdetector(v.Click.ClickDetector, 1)
						end
					end
					for _,v in pairs(game.Workspace:GetChildren()) do
						if v.Name:match(plr.Name) then
							for i,x in pairs(v:GetChildren()) do
								if x.Name == "TycoonDrop" then
									x.CFrame = v.End.CFrame
								end
							end
						end
					end
					task.wait()
				end
			end
		end    
	})

	Misc:AddToggle({
		Name = "Auto Destroy Tycoon",
		Default = false,
		Callback = function(Value)
			getgenv().AutoDestroyTycoon = Value
			if getgenv().TycoonAuto == "All" then
				while getgenv().AutoDestroyTycoon do
					for _,v in pairs(game.Workspace:GetChildren()) do
						if string.find(v.Name, "ÅTycoon") and v:FindFirstChild("Destruct") then
							fireclickdetector(v.Destruct.ClickDetector, 0)
							fireclickdetector(v.Destruct.ClickDetector, 1)
						end
					end
					task.wait()
				end
			elseif getgenv().TycoonAuto == "Your" then
				while getgenv().AutoDestroyTycoon do
					for _,v in pairs(game.Workspace:GetChildren()) do
						if v.Name:match(plr.Name) and v:FindFirstChild("Destruct") then
							fireclickdetector(v.Destruct.ClickDetector, 0)
							fireclickdetector(v.Destruct.ClickDetector, 1)
						end
					end
					task.wait()
				end
			end
		end    
	})

	if game.Workspace:FindFirstChild("NoChanged") == nil then
		local NoChanged = Instance.new("BoolValue", workspace)
		NoChanged.Name = "NoChanged"
	end
	Anti:AddToggle({
		Name = "All Toggle Anti",
		Default = false,
		Callback = function(Value)
			game.Workspace.NoChanged.Value = Value
		end    
	})

	if getgenv().AntiVoidChoose == nil then
		getgenv().AntiVoidChoose = "Normal"
	end
	Anti:AddDropdown({
		Name = "Anti Void",
		Default = "Normal",
		Options = {"Normal","Retro","Water","Psycho","Bob"},
		Callback = function(Value)
			if getgenv().AntiVoid == true then
				AntiVoid:Set(false)
				wait(0.05)
				getgenv().AntiVoidChoose = Value
				wait(0.03)
				AntiVoid:Set(true)
			elseif getgenv().AntiVoid == false then
				getgenv().AntiVoidChoose = Value
			end
		end    
	})

	Anti:AddSlider({
		Name = "Transparency Anti Void",
		Min = 0,
		Max = 1,
		Default = 0.5,
		Color = Color3.fromRGB(255,255,255),
		Increment = 0.1,
		ValueName = "Transparency",
		Callback = function(Value)
			getgenv().Transparency = Value
			if getgenv().AntiVoid == true then
				if getgenv().AntiVoidChoose == "Normal" then
					game.Workspace["VoidPart"].Transparency = Value
					game.Workspace["VoidPart"]["TAntiVoid"].Transparency = Value
				elseif getgenv().AntiVoidChoose == "Retro" then
					game.Workspace["Psycho"]["Retro1"].Transparency = Value
					game.Workspace["Psycho"]["Retro1"]["Retro2"].Transparency = Value
					game.Workspace["Psycho"]["Retro1"]["Retro3"].Transparency = Value
				elseif getgenv().AntiVoidChoose == "Water" then
					game.Workspace["Psycho"]["Kraken"].Transparency = Value
				elseif getgenv().AntiVoidChoose == "Psycho" then
					game.Workspace["Psycho"].Transparency = Value
				elseif getgenv().AntiVoidChoose == "Bob" then
					game.Workspace["VoidPart"]["TAntiVoid"].Transparency = Value
					game.Workspace["BobWalk1"].Transparency = Value
					for i,v in pairs(game.Workspace.BobWalk1:GetChildren()) do
						v.Transparency = getgenv().Transparency
					end
				end
			end
		end    
	})

	AntiVoid = Anti:AddToggle({
		Name = "Anti Void",
		Default = false,
		Callback = function(Value)
			getgenv().AntiVoid = Value
			if getgenv().AntiVoidChoose == "Normal" then
				game.Workspace["VoidPart"].CanCollide = Value
				game.Workspace["VoidPart"]["TAntiVoid"].CanCollide = Value
				if Value == false then
					game.Workspace["VoidPart"].Transparency = 1
					game.Workspace["VoidPart"]["TAntiVoid"].Transparency = 1
				else
					game.Workspace["VoidPart"].Transparency = getgenv().Transparency
					game.Workspace["VoidPart"]["TAntiVoid"].Transparency = getgenv().Transparency
				end
			elseif getgenv().AntiVoidChoose == "Retro" then
				game.Workspace["Psycho"]["Retro1"].CanCollide = Value
				game.Workspace["Psycho"]["Retro1"]["Retro2"].CanCollide = Value
				game.Workspace["Psycho"]["Retro1"]["Retro3"].CanCollide = Value
				if Value == true then
					game.Workspace["Psycho"]["Retro1"].Transparency = getgenv().Transparency
					game.Workspace["Psycho"]["Retro1"]["Retro2"].Transparency = getgenv().Transparency
					game.Workspace["Psycho"]["Retro1"]["Retro3"].Transparency = getgenv().Transparency
				else
					game.Workspace["Psycho"]["Retro1"].Transparency = 1
					game.Workspace["Psycho"]["Retro1"]["Retro2"].Transparency = 1
					game.Workspace["Psycho"]["Retro1"]["Retro3"].Transparency = 1
				end
			elseif getgenv().AntiVoidChoose == "Water" then
				game.Workspace["Psycho"]["Kraken"].CanCollide = Value
				if Value == true then
					game.Workspace["Psycho"]["Kraken"].Transparency = getgenv().Transparency
				else
					game.Workspace["Psycho"]["Kraken"].Transparency = 1
				end
			elseif getgenv().AntiVoidChoose == "Psycho" then
				game.Workspace["Psycho"].CanCollide = Value
				if Value == true then
					game.Workspace["Psycho"].Transparency = getgenv().Transparency
				else
					game.Workspace["Psycho"].Transparency = 1
				end
			elseif getgenv().AntiVoidChoose == "Bob" then
				game.Workspace["VoidPart"]["TAntiVoid"].CanCollide = Value
				game.Workspace["BobWalk1"].CanCollide = Value
				for i,v in pairs(game.Workspace.BobWalk1:GetChildren()) do
					v.CanCollide = Value
				end
				if Value == true then
					game.Workspace["VoidPart"]["TAntiVoid"].Transparency = getgenv().Transparency
					game.Workspace["BobWalk1"].Transparency = getgenv().Transparency
					for i,v in pairs(game.Workspace.BobWalk1:GetChildren()) do
						v.Transparency = getgenv().Transparency
					end
				else
					game.Workspace["VoidPart"]["TAntiVoid"].Transparency = 1
					game.Workspace["BobWalk1"].Transparency = 1
					for i,v in pairs(game.Workspace.BobWalk1:GetChildren()) do
						v.Transparency = 1
					end
				end
			end
		end    
	})

	AntiPortal = Anti:AddToggle({
		Name = "Anti Portal",
		Default = false,
		Callback = function(Value)
			getgenv().AntiPortal = Value
			if getgenv().AntiPortal == true then
				for i,v in pairs(workspace.Lobby:GetChildren()) do
					if v.Name == "Teleport2" and v.Name == "Teleport3" and v.Name == "Teleport4" and v.Name == "Teleport6" then
						if v.CanTouch == true then
							v.CanTouch = false
						end
					end
				end
			else
				for i,v in pairs(workspace.Lobby:GetChildren()) do
					if v.Name == "Teleport2" and v.Name == "Teleport3" and v.Name == "Teleport4" and v.Name == "Teleport6" then
						if v.CanTouch == false then
							v.CanTouch = true
						end
					end
				end
			end
		end    
	})

	AntiAdmin = Anti:AddToggle({
		Name = "Anti Mod | Admin",
		Default = false,
		Callback = function(Value)
			getgenv().AntiMods = Value
			while getgenv().AntiMods do
				for i,v in pairs(Players:GetChildren()) do
					if v:GetRankInGroup(9950771) >= 2 then
						getgenv().AntiKick = false
						plr:Kick("High Rank Player Detected.".." [ "..v.Name.." ]")
						break
					end
				end
				task.wait()
			end
		end    
	})

	AntiKick = Anti:AddToggle({
		Name = "Anti Kick",
		Default = false,
		Callback = function(Value)
			getgenv().AntiKick = Value
			while getgenv().AntiKick do
				for i,v in pairs(game.CoreGui.RobloxPromptGui.promptOverlay:GetDescendants()) do
					if v.Name == "ErrorPrompt" then
						game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
					end
				end
				task.wait()
			end
		end    
	})

	AntiAfk = Anti:AddToggle({
		Name = "Anti Afk",
		Default = false,
		Callback = function(Value)
			getgenv().AntiAfk = Value
			for i,v in next, getconnections(plr.Idled) do
				if getgenv().AntiAfk then
					v:Disable()
				else
					v:Enable()
				end
			end
		end    
	})

	AntiObby = Anti:AddToggle({
		Name = "Anti Obby",
		Default = false,
		Callback = function(Value)
			getgenv().AntiObby = Value
			while getgenv().AntiObby do
				for _, v in pairs(game.Workspace:GetChildren()) do
					if string.find(v.Name, "LavaSpinner") or string.find(v.Name, "LavaBlock") then
						if v.CanTouch == true then
							v.CanTouch = false
						end
					end
				end
				task.wait()
			end
			if getgenv().AntiObby == false then
				for _, v in pairs(game.Workspace:GetChildren()) do
					if string.find(v.Name, "LavaSpinner") or string.find(v.Name, "LavaBlock") then
						if v.CanTouch == false then
							v.CanTouch = true
						end
					end
				end
			end
		end    
	})

	AntiRock = Anti:AddToggle({
		Name = "Anti Megarock | Custom",
		Default = false,
		Callback = function(Value)
			getgenv().AntiRock = Value
			while getgenv().AntiRock do
				for _,v in pairs(Players:GetChildren()) do
					if v.Character:FindFirstChild("rock") then
						v.Character:FindFirstChild("rock").CanTouch = false
						v.Character:FindFirstChild("rock").CanQuery = false
					end
				end
				task.wait()
			end
		end    
	})

	AntiSbeve = Anti:AddToggle({
		Name = "Anti Sbeve",
		Default = false,
		Callback = function(Value)
			getgenv().AntiSbeve = Value
			while getgenv().AntiSbeve do
				for _,v in pairs(Players:GetChildren()) do
					if v ~= plr and v.Character:FindFirstChild("stevebody") then
						v.Character:FindFirstChild("stevebody").CanTouch = false
						v.Character:FindFirstChild("stevebody").CanQuery = false
						v.Character:FindFirstChild("stevebody").CanCollide = false
					end
				end
				task.wait()
			end
		end    
	})

	AntiBallBaller = Anti:AddToggle({
		Name = "Anti Ball Baller",
		Default = false,
		Callback = function(Value)
			getgenv().AntiBallBaller = Value
			while getgenv().AntiBallBaller do
				for i,v in pairs(game.Workspace:GetChildren()) do
					if v.Name == "ClonedBall" then
						v.CanTouch = false
						v.CanCollide = true
					end
				end
				task.wait()
			end
		end    
	})

	AntiBus = Anti:AddToggle({
		Name = "Anti Bus",
		Default = false,
		Callback = function(Value)
			getgenv().AntiBus = Value
			while getgenv().AntiBus do
				for i,v in pairs(game.Workspace:GetChildren()) do
					if v.Name == "BusModel" then
						v.CanTouch = false
					end
				end
				task.wait()
			end
		end    
	})

	AntiLure = Anti:AddToggle({
		Name = "Anti Lure",
		Default = false,
		Callback = function(Value)
			getgenv().AntiLure = Value
			while getgenv().AntiLure do
				for i,v in pairs(game.Workspace:GetChildren()) do
					if string.find(v.Name, "_lure") and v:FindFirstChild("Root") and v:FindFirstChild("watercircle") then
						v.Root.CFrame = char.HumanoidRootPart.CFrame
						v.watercircle.CFrame = char.HumanoidRootPart.CFrame
					end
				end
				task.wait()
			end
		end    
	})

	AntiMail = Anti:AddToggle({
		Name = "Anti Mail",
		Default = false,
		Callback = function(Value)
			char.YouHaveGotMail.Disabled = Value
			getgenv().AntiMail = Value
			while getgenv().AntiMail do
				if char:FindFirstChild("YouHaveGotMail") then
					char.YouHaveGotMail.Disabled = true
				end
				task.wait()
			end
		end    
	})

	AntiMittenBl = Anti:AddToggle({
		Name = "Anti Mitten Blind",
		Default = false,
		Callback = function(Value)
			getgenv().AntiMittenBlind = Value
			while getgenv().AntiMittenBlind do
				if plr.PlayerGui:FindFirstChild("MittenBlind") then
					plr.PlayerGui:FindFirstChild("MittenBlind"):Destroy()
				end
				task.wait()
			end
		end    
	})

	AntiKnock = Anti:AddToggle({
		Name = "Anti Knockoff",
		Default = false,
		Callback = function(Value)
			getgenv().AntiKnock = Value
			while getgenv().AntiKnock do
				if game.Workspace.CurrentCamera and char and char:FindFirstChildOfClass("Humanoid") and game.Workspace.CurrentCamera.CameraSubject ~= char:FindFirstChildOfClass("Humanoid") and game.Workspace.CurrentCamera.CameraSubject == game.Workspace:FindFirstChild(plr.Name.."'s_falsehead") then
					game.Workspace.CurrentCamera.CameraSubject = char:FindFirstChildOfClass("Humanoid")
				end
				task.wait()
			end
		end    
	})

	AntiJack = Anti:AddToggle({
		Name = "Anti Hallow - Jack",
		Default = false,
		Callback = function(Value)
			plr.PlayerScripts.HallowJackAbilities.Disabled = Value
		end    
	})

	AntiBooster = Anti:AddToggle({
		Name = "Anti Booster",
		Default = false,
		Callback = function(Value)
			getgenv().AntiBooster = Value
			while getgenv().AntiBooster do
				for i,v in pairs(char:GetDescendants()) do
					if v.Name == "BoosterObject" then
						v:Destroy()
					end
				end
				task.wait()
			end
		end    
	})

	AntiSquid = Anti:AddToggle({
		Name = "Anti Squid",
		Default = false,
		Callback = function(Value)
			getgenv().AntiSquid = Value
			if getgenv().AntiSquid == false then
				plr.PlayerGui.SquidInk.Enabled = true
			end
			while getgenv().AntiSquid do
				if plr.PlayerGui:FindFirstChild("SquidInk") then
					plr.PlayerGui.SquidInk.Enabled = false
				end
				task.wait()
			end
		end    
	})

	AntiConveyor = Anti:AddToggle({
		Name = "Anti Conveyor",
		Default = false,
		Callback = function(Value)
			plr.PlayerScripts.ConveyorVictimized.Disabled = Value
		end    
	})

	AntiNightmareAndPotion = Anti:AddToggle({
		Name = "Anti Nightmare & Potion",
		Default = false,
		Callback = function(Value)
			if Value == true then
				plr.PlayerScripts.VFXListener.NightmareEffect.Parent = game.Lighting
			else
				plr.PlayerScripts.VFXListener.NightmareEffect.Parent = plr.PlayerScripts.VFXListener
			end
		end    
	})

	AntiIceAndPotion = Anti:AddToggle({
		Name = "Anti Ice & Potion",
		Default = false,
		Callback = function(Value)
			getgenv().AntiIce = Value
			while getgenv().AntiIce do
				for i,v in pairs(char:GetChildren()) do
					if v.Name == "Icecube" then
						v:Destroy()
						char.Humanoid.PlatformStand = false
						char.Humanoid.AutoRotate = true
					end
				end
				task.wait()
			end
		end    
	})

	AntiTime = Anti:AddToggle({
		Name = "Anti Time Stop & Stop",
		Default = false,
		Callback = function(Value)
			getgenv().AntiTimestop = Value
			while getgenv().AntiTimestop do
				for i,v in pairs(char:GetChildren()) do
					if v.ClassName == "Part" then
						v.Anchored = false
					end
				end
				task.wait()
			end
		end    
	})

	AntiNull = Anti:AddToggle({
		Name = "Anti Null",
		Default = false,
		Callback = function(Value)
			getgenv().AntiNull = Value
			while getgenv().AntiNull do
				for i,v in pairs(game.Workspace:GetChildren()) do
					if v.Name == "Imp" and v:FindFirstChild("Body") then
						gloveHits[GetEquippedGlove()]:FireServer(v.Body,true)
					end
				end
				task.wait()
			end
		end    
	})

	AntiRun = Anti:AddToggle({
		Name = "Anti Run",
		Default = false,
		Callback = function(Value)
			getgenv().AutoExit = Value
			while getgenv().AutoExit do
				if char:FindFirstChild("InLabyrinth") ~= nil then
					for _, v in next, workspace:GetChildren() do
						if string.find(v.Name, "Labyrinth") and v:FindFirstChild("Doors") then
							for _, y in ipairs(v.Doors:GetChildren()) do
								if y:FindFirstChild("Hitbox") and y.Hitbox:FindFirstChild("TouchInterest") then
									firetouchinterest(char:WaitForChild("HumanoidRootPart"), y.Hitbox, 0)
									firetouchinterest(char:WaitForChild("HumanoidRootPart"), y.Hitbox, 1)
								end
							end
						end
					end
				end
				task.wait()
			end
		end    
	})

	AntiBrick = Anti:AddToggle({
		Name = "Anti Brick",
		Default = false,
		Callback = function(Value)
			getgenv().AntiBrick = Value
			while getgenv().AntiBrick do
				for i,v in pairs(game.Workspace:GetChildren()) do
					if v.Name == "Union" then
						v.CanTouch = false
						v.CanQuery = false
					end
				end
				task.wait()
			end
		end    
	})

	AntiRecord = Anti:AddToggle({
		Name = "Anti Record",
		Default = false,
		Callback = function(Value)
			getgenv().AntiRecord = Value
		end    
	})
	for i,p in pairs(Players:GetChildren()) do
		if p ~= plr then
			p.Chatted:Connect(function(message)
				local Words = message:split(" ")
				if getgenv().AntiRecord == true then
					for i, v in pairs(Words) do
						if v:lower():match("recording") or v:lower():match(" rec") or v:lower():match("record") or v:lower():match("discor") or v:lower():match(" disco") or v:lower():match(" disc") or v:lower():match("ticket") or v:lower():match("tickets") or v:lower():match(" ds") or v:lower():match(" dc") or v:lower():match("dizzy") or v:lower():match("dizzycord") or v:lower():match(" clip") or v:lower():match("proof") or v:lower():match("evidence") then
							AntiKick:Set(false)
							plr:Kick("Possible player recording detected.".." [ "..p.Name.." ]".." [ "..message.." ]")
						end
					end
				end
			end)
		end
	end
	Players.PlayerAdded:Connect(function(Player)
		Player.Chatted:Connect(function(message)
			local Words = message:split(" ")
			if getgenv().AntiRecord == true then
				for i, v in pairs(Words) do
					if v:lower():match("recording") or v:lower():match(" rec") or v:lower():match("record") or v:lower():match("discor") or v:lower():match(" disco") or v:lower():match(" disc") or v:lower():match("ticket") or v:lower():match("tickets") or v:lower():match(" ds") or v:lower():match(" dc") or v:lower():match("dizzy") or v:lower():match("dizzycord") or v:lower():match(" clip") or v:lower():match("proof") or v:lower():match("evidence") then
						AntiKick:Set(false)
						plr:Kick("Possible player recording detected.".." [ "..Player.Name.." ]".." [ "..message.." ]")
					end
				end
			end
		end)
	end)

	AntiReda = Anti:AddToggle({
		Name = "Anti [REDACTED]",
		Default = false,
		Callback = function(Value)
			plr.PlayerScripts.Well.Disabled = Value
		end    
	})

	AntiBrazil = Anti:AddToggle({
		Name = "Anti Brazil",
		Default = false,
		Callback = function(Value)
			getgenv().AntiBrazil = Value
			while getgenv().AntiBrazil do
				for i,v in pairs(game.Workspace.Lobby.brazil:GetChildren()) do
					if v.CanTouch == true then
						v.CanTouch = false
					end
				end
				task.wait()
			end
			if getgenv().AntiBrazil == false then
				for i,v in pairs(game.Workspace.Lobby.brazil:GetChildren()) do
					if v.CanTouch == false then
						v.CanTouch = true
					end
				end
			end
		end    
	})

	AntiZa = Anti:AddToggle({
		Name = "Anti Za Hando",
		Default = false,
		Callback = function(Value)
			getgenv().AntiZaHando = Value
			while getgenv().AntiZaHando do
				for i,v in pairs(game.Workspace:GetChildren()) do
					if v.ClassName == "Part" and v.Name == "Part" then
						v:Destroy()
					end
				end
				task.wait()
			end
		end    
	})

	AntiFort = Anti:AddToggle({
		Name = "Anti Fort",
		Default = false,
		Callback = function(Value)
			getgenv().AntiFort = Value
			while getgenv().AntiFort do
				for i,v in pairs(game.Workspace:GetChildren()) do
					if v.Name == "Part" then
						v.CanCollide = false
					end
				end
				task.wait()
			end
		end    
	})

	AntiReaper = Anti:AddToggle({
		Name = "Anti Reaper",
		Default = false,
		Callback = function(Value)
			getgenv().AntiReaper = Value
			while getgenv().AntiReaper do
				for i,v in pairs(char:GetDescendants()) do
					if v.Name == "DeathMark" then
						game:GetService("ReplicatedStorage").ReaperGone:FireServer(game:GetService("Players").LocalPlayer.Character.DeathMark)
						game:GetService("Lighting"):WaitForChild("DeathMarkColorCorrection"):Destroy() 
					end
				end
				task.wait()
			end
		end    
	})

	AntiPusher = Anti:AddToggle({
		Name = "Anti Pusher",
		Default = false,
		Callback = function(Value)
			getgenv().AntiPusher = Value
			while getgenv().AntiPusher do
				for i,v in pairs(game.Workspace:GetChildren()) do
					if v.Name == "wall" then
						v.CanCollide = false
					end
				end
				task.wait()
			end
		end    
	})

	AntiDefend = Anti:AddToggle({
		Name = "Anti Defend",
		Default = false,
		Callback = function(Value)
			getgenv().NoclipBarrier = Value
			if getgenv().NoclipBarrier == false then
				for i,v in pairs(game.Workspace:GetChildren()) do
					if string.find(v.Name, "ÅBarrier") then
						if v.CanCollide == false then
							v.CanCollide = true
						end
					end
				end
			end
			while getgenv().NoclipBarrier do
				for i,v in pairs(game.Workspace:GetChildren()) do
					if string.find(v.Name, "ÅBarrier") then
						if v.CanCollide == true then
							v.CanCollide = false
						end
					end
				end
				task.wait()
			end
		end    
	})

	AntiAttackPlank = Anti:AddToggle({
		Name = "Anti Attack Plank",
		Default = false,
		Callback = function(Value)
			getgenv().AntiPlank = Value
			while getgenv().AntiPlank do
				for i,v in pairs(game.Workspace:GetChildren()) do
					if string.find(v.Name, "'s Plank") and v.ClassName == "Part" then
						v.CanTouch = false
						v.CanQuery = false
					end
				end
				task.wait()
			end
		end    
	})

	AntiBubble = Anti:AddToggle({
		Name = "Anti Bubble",
		Default = false,
		Callback = function(Value)
			getgenv().AntiBubble = Value
			while getgenv().AntiBubble do
				for i,v in pairs(workspace:GetChildren()) do
					if v.Name == "BubbleObject" and v:FindFirstChild("Weld") then
						v:FindFirstChild("Weld"):Destroy()
					end
				end
				task.wait()
			end
		end    
	})

	AntiStun = Anti:AddToggle({
		Name = "Anti Stun",
		Default = false,
		Callback = function(Value)
			getgenv().AntiStun = Value
			while getgenv().AntiStun do
				if char:FindFirstChild("Humanoid") and game.Workspace:FindFirstChild("Shockwave") and char.Ragdolled.Value == false then
					char.Humanoid.PlatformStand = false
				end
				task.wait()
			end
		end    
	})

	AntiCOD = Anti:AddToggle({
		Name = "Anti Cube Of Death",
		Default = false,
		Callback = function(Value)
			if Value == true then
				if game.Workspace:FindFirstChild("the cube of death(i heard it kills)", 1) and game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"]:FindFirstChild("Part") then
					game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].CanTouch = false
					game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].Part.CanTouch = false
				end
			else
				if game.Workspace:FindFirstChild("the cube of death(i heard it kills)", 1) and game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"]:FindFirstChild("Part") then
					game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].CanTouch = true
					game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].Part.CanTouch = true
				end
			end
		end    
	})

	AntiDeath = Anti:AddToggle({
		Name = "Anti Death Barriers",
		Default = false,
		Callback = function(Value)
			if Value == true then
				for i,v in pairs(game.Workspace.DEATHBARRIER:GetChildren()) do
					if v.ClassName == "Part" and v.Name == "BLOCK" then
						v.CanTouch = false
					end
				end
				workspace.DEATHBARRIER.CanTouch = false
				workspace.DEATHBARRIER2.CanTouch = false
				workspace.dedBarrier.CanTouch = false
				workspace.ArenaBarrier.CanTouch = false
				workspace.AntiDefaultArena.CanTouch = false
			else
				for i,v in pairs(game.Workspace.DEATHBARRIER:GetChildren()) do
					if v.ClassName == "Part" and v.Name == "BLOCK" then
						v.CanTouch = true
					end
				end
				workspace.DEATHBARRIER.CanTouch = true
				workspace.DEATHBARRIER2.CanTouch = true
				workspace.dedBarrier.CanTouch = true
				workspace.ArenaBarrier.CanTouch = true
				workspace.AntiDefaultArena.CanTouch = true
			end
		end    
	})

	AntiRagdoll = Anti:AddToggle({
		Name = "Anti Ragdoll",
		Default = false,
		Callback = function(Value)
			getgenv().AntiRagdoll = Value
			while getgenv().AntiRagdoll do
				if char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Torso") and char:FindFirstChild("Ragdolled") then
					if char:FindFirstChild("Ragdolled") and char:WaitForChild("Ragdolled").Value == true then
						repeat task.wait()
							if char:FindFirstChild("Torso") then
								char.Torso.Anchored = true
							end
						until char:FindFirstChild("Ragdolled") and char:WaitForChild("Ragdolled").Value == false
						if char:FindFirstChild("Torso") then
							char.Torso.Anchored = false
						end
					end
				end
				task.wait()
			end
		end    
	})

	Troll:AddDropdown({
		Name = "Glove Sound",
		Default = "Ghost",
		Options = {"Ghost", "Thanos", "Space", "Scythe", "Golden", "Hitman", "Prop", "Error Death", "Zombie"},
		Callback = function(Value)
			GloveSound = Value
		end    
	})

	Troll:AddToggle({
		Name = "Auto Spam Glove Sound",
		Default = false,
		Callback = function(Value)
			local GloveSoundSpam = Value
			while GloveSoundSpam and GloveSound == "Ghost" do
				game.ReplicatedStorage.Ghostinvisibilityactivated:FireServer()
				game.ReplicatedStorage.Ghostinvisibilitydeactivated:FireServer()
				task.wait()
			end
			while GloveSoundSpam and GloveSound == "Thanos" do
				game:GetService("ReplicatedStorage").Illbeback:FireServer()
				task.wait()
			end
			while GloveSoundSpam and GloveSound == "Space" do
				game:GetService("ReplicatedStorage").ZeroGSound:FireServer()
				task.wait()
			end
			while GloveSoundSpam and GloveSound == "Scythe" do
				game:GetService("ReplicatedStorage").Scythe:FireServer("ScytheWeapon")
				task.wait()
			end
			while GloveSoundSpam and GloveSound == "Golden" do
				game:GetService("ReplicatedStorage").Goldify:FireServer(true)
				task.wait()
			end
			while GloveSoundSpam and GloveSound == "Hitman" do
				game:GetService("ReplicatedStorage"):WaitForChild("HitmanAbility"):FireServer("ReplicateGoldenRevolver",{0})
				task.wait()
			end
			while GloveSoundSpam and GloveSound == "Prop" do
				game:GetService("ReplicatedStorage").Prop:FireServer()
				task.wait()
			end
			while GloveSoundSpam and GloveSound == "Error Death" do
				game.ReplicatedStorage.ErrorDeath:FireServer()
				task.wait()
			end
			while GloveSoundSpam and GloveSound == "Zombie" do
				game:GetService("ReplicatedStorage").b:FireServer("ReplicateSound_Zombie")
				task.wait()
			end
		end    
	})

	Credits:AddParagraph("Share Link Zalo","Join Link Zalo Message All People Or Friend | Tham Gia Link Zalo Nhắn Tin Tất Cả Mọi Người Hoặc Bạn Bè")
	Credits:AddParagraph("Message Zalo","You Have To Message Zalo In VietNamese | Bạn Phải Nhắn Tin Zalo Bằng Tiếng Việt")
	Credits:AddParagraph("Deputy Group Zalo","[ Tấn Lộc ( Owner ) ] or [ Giang ] or [ Tiến ] or [ Hoàng Kha ]")
	Credits:AddParagraph("Share Link Slap Battles Group","Join Link Zalo Message All People Or Friend | Tham Gia Link Zalo Nhắn Tin Tất Cả Mọi Người Hoặc Bạn Bè")
	Credits:AddParagraph("Message Slap Battles Group","You Have To Message Zalo In VietNamese Or English | Bạn Phải Nhắn Tin Zalo Bằng Tiếng Việt hoặc Tiếng Anh")
	Credits:AddLabel("Owner Credits Script By Giang")

	Credits:AddButton({
		Name = "Copy Join Zalo",
		Callback = function()
			setclipboard("https://zalo.me/g/qlukiy407")
		end    
	})

	Credits:AddButton({
		Name = "Copy Join Slap Battles Group",
		Callback = function()
			setclipboard("https://discord.com/invite/xdCKBcS6")
		end    
	})

	Credits:AddButton({
		Name = "[ Destroy GUI ] [ Toggle Gui ]",
		Callback = function()
			getgenv().AutoSetInfo = false
			OrionLib:Destroy()
			if plr.PlayerGui:FindFirstChild("ToggleUi") then
				plr.PlayerGui:FindFirstChild("ToggleUi"):Destroy()
			end
		end 
	})

	---ToggleAllAnti---
	game.Workspace.NoChanged.Changed:Connect(function()
		AntiVoid:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiPortal:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiRun:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiAdmin:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiKick:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiAfk:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiObby:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiRock:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiSbeve:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiBallBaller:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiAttackPlank:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiBus:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiMail:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiLure:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiJack:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiKnock:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiBooster:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiSquid:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiConveyor:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiNightmareAndPotion:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiTime:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiIceAndPotion:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiMittenBl:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiNull:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiBrick:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiRecord:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiReda:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiBrazil:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiZa:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiReaper:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiPusher:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiDefend:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiFort:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiBubble:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiStun:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiCOD:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiDeath:Set(game.Workspace.NoChanged.Value)
	end)

	game.Workspace.NoChanged.Changed:Connect(function()
		AntiRagdoll:Set(game.Workspace.NoChanged.Value)
	end)
	
	do
		---SafeSpotBox---

		if workspace:FindFirstChild("SafeBox") == nil then
			local S = Instance.new("Part")
			S.Name = "SafeBox"
			S.Anchored = true
			S.CanCollide = true
			S.Transparency = .5
			S.Position = Vector3.new(-5500, -5000, -5000)
			S.Size = Vector3.new(21, 5, 21)
			S.Parent = workspace

			local S1 = Instance.new("Part")
			S1.Name = "S1"
			S1.Anchored = true
			S1.CanCollide = true
			S1.Transparency = .5
			S1.Position = Vector3.new(-5499.91, -4991.5, -4989.09)
			S1.Size = Vector3.new(20, 13, 2)
			S1.Parent = workspace:FindFirstChild("SafeBox")

			local S2 = Instance.new("Part")
			S2.Name = "S2"
			S2.Anchored = true
			S2.CanCollide = true
			S2.Transparency = .5
			S2.Position = Vector3.new(-5510.27979, -4991.5, -5000.08984, -4.47034836e-07, 0, 0.999999881, 0, 1, 0, -0.999999881, 0, -3.69319451e-07)
			S2.Size = Vector3.new(21, 14, 2)
			S2.Rotation = Vector3.new(0, -90, 0)
			S2.Parent = workspace:FindFirstChild("SafeBox")

			local S3 = Instance.new("Part")
			S3.Name = "S3"
			S3.Anchored = true
			S3.CanCollide = true
			S3.Transparency = .5
			S3.Position = Vector3.new(-5499.3, -4991.5, -5011.12)
			S3.Size = Vector3.new(21, 13, 2)
			S3.Parent = workspace:FindFirstChild("SafeBox")

			local S4 = Instance.new("Part")
			S4.Name = "S4"
			S4.Anchored = true
			S4.CanCollide = true
			S4.Transparency = .5
			S4.Position = Vector3.new(-5489.97559, -4991.5, -4999.52637, -4.37113883e-08, 0, 1, 0, 1, 0, -1, 0, -4.37113883e-08)
			S4.Size = Vector3.new(22, 13, 2)
			S4.Rotation = Vector3.new(0, -90, 0)
			S4.Parent = workspace:FindFirstChild("SafeBox")

			local S5 = Instance.new("Part")
			S5.Name = "S5"
			S5.Anchored = true
			S5.CanCollide = true
			S5.Transparency = .5
			S5.Position = Vector3.new(-5499.39, -4984, -5000.07)
			S5.Size = Vector3.new(24, 3, 24)
			S5.Parent = workspace:FindFirstChild("SafeBox")
		end

		---Bed---

		if workspace:FindFirstChild("Bed") == nil then
			local Bed = Instance.new("Part")
			Bed.Name = "Bed"
			Bed.Anchored = true
			Bed.Position = Vector3.new(-100019.5, 104, -1500)
			Bed.Size = Vector3.new(0.01, 0.01, 10)
			Bed.Parent = workspace

			local B1 = Instance.new("Part")
			B1.Name = "Bed1"
			B1.Anchored = true
			B1.Position = Vector3.new(-100025, 104, -1500)
			B1.Size = Vector3.new(1, 6, 7)
			B1.BrickColor = BrickColor.new("Burnt Sienna")
			B1.Parent = workspace:FindFirstChild("Bed")

			local B2 = Instance.new("Part")
			B2.Name = "Bed2"
			B2.Anchored = true
			B2.Position = Vector3.new(-100023, 104.5, -1500)
			B2.Size = Vector3.new(2, 1, 6)
			B2.BrickColor = BrickColor.new("Mid gray")
			B2.Parent = workspace:FindFirstChild("Bed")

			local B3 = Instance.new("Part")
			B3.Name = "Bed3"
			B3.Anchored = true
			B3.Position = Vector3.new(-100019, 104, -1500)
			B3.Size = Vector3.new(11, 1, 7)
			B3.BrickColor = BrickColor.new("Crimson")
			B3.Parent = workspace:FindFirstChild("Bed")

			local B4 = Instance.new("Part")
			B4.Name = "Bed4"
			B4.Anchored = true
			B4.Position = Vector3.new(-100013, 104, -1500)
			B4.Size = Vector3.new(1, 6, 7)
			B4.BrickColor = BrickColor.new("Burnt Sienna")
			B4.Parent = workspace:FindFirstChild("Bed")

			local B5 = Instance.new("Part")
			B5.Name = "Bed5"
			B5.Anchored = true
			B5.Position = Vector3.new(-100019, 103, -1500)
			B5.Size = Vector3.new(11, 1, 7)
			B5.BrickColor = BrickColor.new("Dark orange")
			B5.Parent = workspace:FindFirstChild("Bed")
		end

		---SafeSpot---

		if workspace:FindFirstChild("Safespot") == nil then
			local Safespot = Instance.new("Part",workspace)
			Safespot.Name = "Safespot"
			Safespot.Position = Vector3.new(10000,-50,10000)
			Safespot.Size = Vector3.new(500,10,500)
			Safespot.Anchored = true
			Safespot.CanCollide = true
			Safespot.Transparency = .5

			local Safespot1 = Instance.new("Part",workspace)
			Safespot1.Name = "DefendPart"
			Safespot1.Position = Vector3.new(10000.2, 13, 9752.45)
			Safespot1.Size = Vector3.new(500, 117, 5)
			Safespot1.Anchored = true
			Safespot1.CanCollide = true
			Safespot1.Transparency = .5
			Safespot1.Parent = game.workspace.Safespot

			local Safespot2 = Instance.new("Part",workspace)
			Safespot2.Name = "DefendPart1"
			Safespot2.Position = Vector3.new(10248.2, 13, 10002.4)
			Safespot2.Size = Vector3.new(5, 117, 496)
			Safespot2.Anchored = true
			Safespot2.CanCollide = true
			Safespot2.Transparency = .5
			Safespot2.Parent = game.workspace.Safespot

			local Safespot3 = Instance.new("Part",workspace)
			Safespot3.Name = "DefendPart2"
			Safespot3.Position = Vector3.new(9998.13, 13, 10247.2)
			Safespot3.Size = Vector3.new(497, 117, 6)
			Safespot3.Anchored = true
			Safespot3.CanCollide = true
			Safespot3.Transparency = .5
			Safespot3.Parent = game.workspace.Safespot

			local Safespot4 = Instance.new("Part",workspace)
			Safespot4.Name = "DefendPart3"
			Safespot4.Position = Vector3.new(9752.71, 13, 9999.28)
			Safespot4.Size = Vector3.new(7, 117, 490)
			Safespot4.Anchored = true
			Safespot4.CanCollide = true
			Safespot4.Transparency = .5
			Safespot4.Parent = game.workspace.Safespot

			local Safespot5 = Instance.new("Part",workspace)
			Safespot5.Name = "DefendPart4"
			Safespot5.Position = Vector3.new(10001.1, 76, 9999.66)
			Safespot5.Size = Vector3.new(491, 10, 491)
			Safespot5.Anchored = true
			Safespot5.CanCollide = true
			Safespot5.Transparency = .5
			Safespot5.Parent = game.workspace.Safespot
		end

		---AntiVoidBadge---

		if workspace:FindFirstChild("Psycho") == nil then
			local Psycho = Instance.new("Part", workspace)
			Psycho.Position = Vector3.new(17800.9082, 2947, -226.017517, -0.248515129, 0.00487846136, -0.968615651, 0.966844261, -0.0594091415, -0.248359889, -0.0587562323, -0.998221755, 0.0100474358)
			Psycho.Name = "Psycho"
			Psycho.Size = Vector3.new(2000, 1, 2000)
			Psycho.Material = "ForceField"
			Psycho.Anchored = true
			Psycho.Transparency = 1
			Psycho.CanCollide = false

			local Kraken = Instance.new("Part", Psycho)
			Kraken.Position = Vector3.new(221, 29, -12632)
			Kraken.Name = "Kraken"
			Kraken.Size = Vector3.new(2000, 1, 2000)
			Kraken.Material = "ForceField"
			Kraken.Anchored = true
			Kraken.Transparency = 1
			Kraken.CanCollide = false

			local Retro1 = Instance.new("Part", Psycho)
			Retro1.Position = Vector3.new(-16643.62890625, 770.0464477539062, 4707.8193359375)
			Retro1.Name = "Retro1"
			Retro1.Size = Vector3.new(2000, 1, 2000)
			Retro1.Material = "ForceField"
			Retro1.Anchored = true
			Retro1.Transparency = 1
			Retro1.CanCollide = false

			local Retro2 = Instance.new("Part", Retro1)
			Retro2.Position = Vector3.new(-16862.791015625, -7.879573822021484, 4791.55517578125)
			Retro2.Name = "Retro2"
			Retro2.Size = Vector3.new(2000, 1, 2000)
			Retro2.Material = "ForceField"
			Retro2.Anchored = true
			Retro2.Transparency = 1
			Retro2.CanCollide = false

			local Retro3 = Instance.new("Part", Retro1)
			Retro3.Position = Vector3.new(-28023.3046875, -219.92381286621094, 4906.6015625)
			Retro3.Name = "Retro3"
			Retro3.Size = Vector3.new(2000, 1, 2000)
			Retro3.Material = "ForceField"
			Retro3.Anchored = true
			Retro3.Transparency = 1
			Retro3.CanCollide = false
		end

		---Anti Void---

		if workspace:FindFirstChild("BobWalk1") == nil then
			local BobWalk1 = Instance.new("Part", workspace)
			BobWalk1.CanCollide = false
			BobWalk1.Anchored = true
			BobWalk1.CFrame = CFrame.new(23.2798462, -19.8447475, 1.83554196, -1, 0, 0, 0, -1, 0, 0, 0, 1)
			BobWalk1.Size = Vector3.new(1139.2593994140625, 1.5, 2048)
			BobWalk1.Name = "BobWalk1"
			BobWalk1.Transparency = 1

			local BobWalk2 = Instance.new("Part", BobWalk1)
			BobWalk2.CanCollide = false
			BobWalk2.Anchored = true
			BobWalk2.CFrame = CFrame.new(-458.458344, -9.25, 1.83554196, -1, 0, 0, 0, -1, 0, 0, 0, 1)
			BobWalk2.Size = Vector3.new(1139.2593994140625, 1.5, 2048)
			BobWalk2.Name = "BobWalk2"
			BobWalk2.Transparency = 1

			local BobWalk3 = Instance.new("Part", BobWalk1)
			BobWalk3.CanCollide = false
			BobWalk3.Anchored = true
			BobWalk3.CFrame = CFrame.new(-690.65979, 47.25, 1.83554196, -1, 0, 0, 0, -1, 0, 0, 0, 1)
			BobWalk3.Size = Vector3.new(674.8563232421875, 0.6048492789268494, 2048)
			BobWalk3.Name = "BobWalk3"
			BobWalk3.Transparency = 1

			local BobWalk4 = Instance.new("Part", BobWalk1)
			BobWalk4.CanCollide = false
			BobWalk4.Anchored = true
			BobWalk4.CFrame = CFrame.new(402.964996, 29.25, 222.310089, -1, 0, 0, 0, -1, 0, 0, 0, 1)
			BobWalk4.Size = Vector3.new(379.88922119140625, 1.5, 160.8837127685547)
			BobWalk4.Name = "BobWalk4"
			BobWalk4.Transparency = 1

			local BobWalk5 = Instance.new("Part", BobWalk1)
			BobWalk5.CanCollide = false
			BobWalk5.Anchored = true
			BobWalk5.Orientation = Vector3.new(0, 0, 171.728)
			BobWalk5.CFrame = CFrame.new(178.719162, -18.9417267, 1.83554196, -0.989596844, -0.143868446, 0, 0.143868446, -0.989596844, 0, 0, 0, 1)
			BobWalk5.Size = Vector3.new(143.94830322265625, 1.5, 2048)
			BobWalk5.Name = "BobWalk5"
			BobWalk5.Transparency= 1

			local BobWalk6 = Instance.new("Part", BobWalk1)
			BobWalk6.CanCollide = false
			BobWalk6.Anchored = true
			BobWalk6.Orientation = Vector3.new(0, 0, 144.782)
			BobWalk6.CFrame = CFrame.new(-309.152832, 15.4761791, 1.83554196, -0.816968799, -0.576681912, 0, 0.576681912, -0.816968799, 0, 0, 0, 1)
			BobWalk6.Size = Vector3.new(110.13511657714844, 2.740000009536743, 2048)
			BobWalk6.Name = "BobWalk6"
			BobWalk6.Transparency = 1

			local BobWalk7 = Instance.new("Part", BobWalk1)
			BobWalk7.CanCollide = false
			BobWalk7.Anchored = true
			BobWalk7.Orientation = Vector3.new(0, 0, -147.002)
			BobWalk7.CFrame = CFrame.new(174.971924, 5.34897423, 222.310089, -0.838688731, 0.544611216, 0, -0.544611216, -0.838688731, 0, 0, 0, 1)
			BobWalk7.Size = Vector3.new(89.76103210449219, 1.5, 160.8837127685547)
			BobWalk7.Name = "BobWalk7"
			BobWalk7.Transparency = 1

			local BobWalk8 = Instance.new("Part", BobWalk1)
			BobWalk8.CanCollide = false
			BobWalk8.Anchored = true
			BobWalk8.Orientation = Vector3.new(0.001, -90.002, -138.076)
			BobWalk8.CFrame = CFrame.new(402.965027, 5.49165154, 74.8157959, 2.98023224e-05, -1.14142895e-05, -1, -0.668144584, -0.744031429, -1.14142895e-05, -0.744031489, 0.668144584, -2.98023224e-05)
			BobWalk8.Size = Vector3.new(74.23055267333984, 1, 379.88922119140625)
			BobWalk8.Name = "BobWalk8"
			BobWalk8.Transparency = 1

			local BobWalk9 = Instance.new("Part", BobWalk1)
			BobWalk9.CanCollide = false
			BobWalk9.Anchored = true
			BobWalk9.CFrame = CFrame.new(402.964996, 29.9136467, 121.981705, -1, 0, 0, 0, -1, 0, 0, 0, 1)
			BobWalk9.Size = Vector3.new(379.88922119140625, 1.5, 39.77305603027344)
			BobWalk9.Name = "BobWalk9"
			BobWalk9.Transparency = 1

			local BobWalk10 = Instance.new("WedgePart", BobWalk1)
			BobWalk10.CanCollide = false
			BobWalk10.Anchored = true
			BobWalk10.Orientation = Vector3.new(-30.453, 117.775, -102.906)
			BobWalk10.CFrame = CFrame.new(134.084229, -17.8583984, 94.3953705, 0.541196942, -0.354067981, 0.762719929, -0.840263784, -0.192543149, 0.506837189, -0.0325982571, -0.915184677, -0.401714325)
			BobWalk10.Size = Vector3.new(1, 88.66793823242188, 34.42972946166992)
			BobWalk10.Name = "BobWalk10"
			BobWalk10.Transparency = 1

			local BobWalk11 = Instance.new("WedgePart", BobWalk1)
			BobWalk11.CanCollide = false
			BobWalk11.Anchored = true
			BobWalk11.Orientation = Vector3.new(-29.779, 117.596, -13.193)
			BobWalk11.CFrame = CFrame.new(168.441879, 2.46393585, 125.815231, -0.350553155, -0.534268022, 0.769201458, -0.198098332, 0.845035911, 0.496660322, -0.915352523, 0.0217281878, -0.402067661)
			BobWalk11.Size = Vector3.new(1, 0.9999924302101135, 82.1865463256836)
			BobWalk11.Name = "BobWalk11"
			BobWalk11.Transparency = 1

			local BobWalk12 = Instance.new("WedgePart", BobWalk1)
			BobWalk12.CanCollide = false
			BobWalk12.Anchored = true
			BobWalk12.Orientation = Vector3.new(26.893, -124.388, -108.64)
			BobWalk12.CFrame = CFrame.new(206.315063, 26.9295502, 105.471031, 0.534210563, -0.415855825, -0.73599112, -0.845072925, -0.285055399, -0.452321947, -0.021697551, 0.863601387, -0.503708005)
			BobWalk12.Size = Vector3.new(1, 13.53612232208252, 9.847718238830566)
			BobWalk12.Name = "BobWalk12"
			BobWalk12.Transparency = 1

			local BobWalk13 = Instance.new("WedgePart", BobWalk1)
			BobWalk13.CanCollide = false
			BobWalk13.Anchored = true
			BobWalk13.Orientation = Vector3.new(-26.893, 55.613, 108.64)
			BobWalk13.CFrame = CFrame.new(165.965088, 2.12955856, 77.8575592, -0.53421092, -0.415855944, 0.735991359, 0.845073164, -0.285055757, 0.452322066, 0.0216975808, 0.863601625, 0.503708005)
			BobWalk13.Size = Vector3.new(1, 13.53612232208252, 99.8001480102539)
			BobWalk13.Name = "BobWalk13"
			BobWalk13.Transparency = 1

			local BobWalk14 = Instance.new("WedgePart", BobWalk1)
			BobWalk14.CanCollide = false
			BobWalk14.Anchored = true
			BobWalk14.Orientation = Vector3.new(-0.001, 90.003, 48.072)
			BobWalk14.CFrame = CFrame.new(172.67041, 5.49164963, 74.8157959, -4.58955765e-05, 2.05039978e-05, 1, 0.743987858, 0.668193102, 2.05039978e-05, -0.668193102, 0.743987858, -4.58955765e-05)
			BobWalk14.Size = Vector3.new(1, 74.23055267333984, 80.699951171875)
			BobWalk14.Name = "BobWalk14"
			BobWalk14.Transparency = 1

			local BobWalk15 = Instance.new("WedgePart", BobWalk1)
			BobWalk15.CanCollide = false
			BobWalk15.Anchored = true
			BobWalk15.Orientation = Vector3.new(0, 0, 106.498)
			BobWalk15.CFrame = CFrame.new(212.753906, 30.0632439, 121.981705, -0.283976078, -0.95883137, 0, 0.95883137, -0.283976078, 0, 0, 0, 1)
			BobWalk15.Size = Vector3.new(1, 0.8520558476448059, 39.773048400878906)
			BobWalk15.Name = "BobWalk15"
			BobWalk15.Transparency = 1

			local BobWalk16 = Instance.new("WedgePart", BobWalk1)
			BobWalk16.CanCollide = false
			BobWalk16.Anchored = true
			BobWalk16.Orientation = Vector3.new(29.777, -62.406, -75.066)
			BobWalk16.CFrame = CFrame.new(212.884216, 30.1233234, 121.984734, 0.544644356, 0.33412537, -0.769235253, -0.838644743, 0.223680317, -0.496630788, 0.00612583756, 0.915602207, 0.402038693)
			BobWalk16.Size = Vector3.new(1, 36.08900451660156, 16.739320755004883)
			BobWalk16.Name = "BobWalk16"
			BobWalk16.Transparency = 1

			local BobWalk17 = Instance.new("WedgePart", BobWalk1)
			BobWalk17.CanCollide = false
			BobWalk17.Anchored = true
			BobWalk17.Orientation = Vector3.new(-29.777, 117.594, 75.066)
			BobWalk17.CFrame = CFrame.new(174.83577, 5.55865097, 141.871262, -0.544644356, 0.33412537, 0.769235253, 0.838644743, 0.223680317, 0.496630788, -0.00612583756, 0.915602207, -0.402038693)
			BobWalk17.Size = Vector3.new(1, 36.08900451660156, 82.1865463256836)
			BobWalk17.Name = "BobWalk17"
			BobWalk17.Transparency = 1

			local BobWalk18 = Instance.new("WedgePart", BobWalk1)
			BobWalk18.CanCollide = false
			BobWalk18.Anchored = true
			BobWalk18.Orientation = Vector3.new(30.453, -62.225, 102.906)
			BobWalk18.CFrame = CFrame.new(165.427338, 2.97219658, 77.884697, -0.541196942, -0.354067981, -0.762719929, 0.840263784, -0.192543149, -0.506837189, 0.0325982571, -0.915184677, 0.401714325)
			BobWalk18.Size = Vector3.new(1, 88.66793823242188, 47.76289749145508)
			BobWalk18.Name = "BobWalk18"
			BobWalk18.Transparency = 1
		end

		if workspace:FindFirstChild("VoidPart") == nil then
			local VoidPart = Instance.new("Part", workspace)
			VoidPart.Position = Vector3.new(-80.5, -10.005, -246.5)
			VoidPart.Name = "VoidPart"
			VoidPart.Size = Vector3.new(2048, 1, 2048)
			VoidPart.Material = "ForceField"
			VoidPart.Anchored = true
			VoidPart.Transparency = 1
			VoidPart.CanCollide = false

			local VoidPart1 = Instance.new("Part", VoidPart)
			VoidPart1.Position = Vector3.new(0,-50026.5,0)
			VoidPart1.Name = "VoidPart1"
			VoidPart1.Size = Vector3.new(2048,70,2048)
			VoidPart1.Anchored = true
			VoidPart1.Transparency = 1
			VoidPart1.CanCollide = false

			local TournamentAntiVoid = Instance.new("Part", VoidPart)
			TournamentAntiVoid.Name = "TAntiVoid"
			TournamentAntiVoid.Size = Vector3.new(2048, 15, 2048)
			TournamentAntiVoid.Position = Vector3.new(3450, 59.009, 68)
			TournamentAntiVoid.Anchored = true
			TournamentAntiVoid.Transparency = 1
			TournamentAntiVoid.CanCollide = false
		end
	end
end


------------------------------------------------------------------------
if gethui():FindFirstChild("Orion") then
	for _, i in pairs(gethui():GetChildren()) do
		if i.Name == "Orion" then
			for i,v in pairs(i:GetDescendants()) do
				if v.ClassName == "Frame" and v.BackgroundTransparency < 0.3 then
					v.BackgroundTransparency = 0.2
				end
			end
		end
	end
end
------------------------------------------------------------------------
