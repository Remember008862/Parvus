repeat task.wait() until game.IsLoaded
repeat task.wait() until game.GameId ~= 0

if Parvus and Parvus.Loaded then
    Parvus.Utilities.UI:Push({
        Title = "Parvus Hub",
        Description = "Script already running!",
        Duration = 5
    }) return
end

if Parvus and (Parvus.Game and not Parvus.Loaded) then
    Parvus.Utilities.UI:Push({
        Title = "Parvus Hub",
        Description = "Something went wrong!",
        Duration = 5
    }) return
end

local PlayerService = game:GetService("Players")
repeat task.wait() until PlayerService.LocalPlayer
local LocalPlayer = PlayerService.LocalPlayer

local Branch, NotificationTime, IsLocal = ...
--local ClearTeleportQueue = clear_teleport_queue
local QueueOnTeleport = queue_on_teleport

local function GetFileSafe(File)
    local ok, body = pcall(function()
        if IsLocal and type(readfile) == "function" and isfile("Parvus/" .. File) then
            return readfile("Parvus/" .. File)
        end
        return game:HttpGet(("%s%s"):format(Parvus.Source, File))
    end)
    if not ok or type(body) ~= "string" then
        warn("GetFileSafe failed for", File, "error:", body)
        return nil
    end
    return body
end

local function LoadScript(Script)
    return loadstring(GetFile(Script .. ".lua"), Script)()
end

local function GetGameInfo()
    for Id, Info in pairs(Parvus.Games) do
        if tostring(game.GameId) == Id then
            return Info
        end
    end

    return Parvus.Games.Universal
end
local function LoadScriptSafe(Script)
    local code = GetFileSafe(Script .. ".lua")
    if type(code) ~= "string" then
        warn("LoadScriptSafe: could not fetch " .. Script)
        return nil
    end
    local fn, loaderr = loadstring(code, Script)
    if not fn then
        warn("LoadScriptSafe: loadstring failed for " .. Script .. " -> " .. tostring(loaderr))
        return nil
    end
    local ok, rerr = pcall(fn)
    if not ok then
        warn("LoadScriptSafe: runtime error in " .. Script .. " -> " .. tostring(rerr))
        return nil
    end
    return true
end
print("Pre Game Finished")
    task.wait(5)
getgenv().Parvus = {
    Source = "https://raw.githubusercontent.com/Remember008862/Parvus/main/",
    Games = {
        ["Universal"] = { Name = "Universal", Script = "Universal" },
        ["1168263273"] = { Name = "Bad Business", Script = "Games/BB" },
        ["3360073263"] = { Name = "Bad Business PTR", Script = "Games/BB" },
        ["1586272220"] = { Name = "Steel Titans", Script = "Games/ST" },
        ["807930589"] = { Name = "The Wild West", Script = "Games/TWW" },
        ["580765040"] = { Name = "RAGDOLL UNIVERSE", Script = "Games/RU" },
        ["187796008"] = { Name = "Those Who Remain", Script = "Games/TWR" },
        ["358276974"] = { Name = "Apocalypse Rising 2", Script = "Games/AR2" },
        ["3495983524"] = { Name = "Apocalypse Rising 2 Dev.", Script = "Games/AR2" },
        ["1054526971"] = { Name = "Blackhawk Rescue Mission 5", Script = "Games/BRM5" }
    }
}
print("post game finished")
wait(5)

Parvus.Utilities = LoadScriptSafe("Utilities/Main")
Parvus.Utilities.UI = LoadScriptSafe("Utilities/UI")
Parvus.Utilities.Physics = LoadScriptSafe("Utilities/Physics")
Parvus.Utilities.Drawing = LoadScriptSafe("Utilities/Drawing")

Parvus.Cursor = GetFileSafe("Utilities/ArrowCursor.png")
local template = GetFileSafe("Utilities/Loadstring")
if not template then
    warn("Missing Loadstring template; aborting safe loader setup")
else
    local ok, built = pcall(function()
        return template:format(Parvus.Source, Branch or "main", NotificationTime or 30, tostring(IsLocal))
    end)
    if not ok then
        warn("Formatting Loadstring template failed:", built)
    else
        Parvus. = built
        safePrint("Parvus.Loadstring built successfully")
    end
end
Parvus.GetFileSafe = Parvus.GetFileSafe:format(
    Parvus.Source, Branch, NotificationTime, tostring(IsLocal)
)
print("post util finished")
wait(5)
LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.InProgress then
        --ClearTeleportQueue()
        QueueOnTeleport(Parvus.GetFileSafe)
    end
end)

Parvus.Game = GetGameInfo()
LoadScriptSafe(Parvus.Game.Script)
Parvus.Loaded = true

Parvus.Utilities.UI:Push({
    Title = "Parvus Hub",
    Description = Parvus.Game.Name .. " loaded!\n\nThis script is open sourced\nIf you have paid for this script\nOr had to go thru ads\nYou have been scammed.",
    Duration = NotificationTime
})

print("Loader Finished")
while true do 
    task.wait(10)
end










