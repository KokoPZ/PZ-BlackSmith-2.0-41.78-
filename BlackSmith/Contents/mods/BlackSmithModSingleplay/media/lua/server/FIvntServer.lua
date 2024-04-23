local FIvntServer = {}

local logfile = "timestamp_economy.log"
local msg = ""

function FIvntServer.OnInitGlobalModData()
    ModData.getOrCreate("MaterialFIvntM")
    ModData.getOrCreate("MeltingMaterial")
    ModData.getOrCreate("SyncFurnace")
    ModData.getOrCreate("SyncMaterial")
    ModData.getOrCreate("SyncActionInProgress")
    ModData.getOrCreate("SyncTime")
    ModData.getOrCreate("LastFurnaceID")
    ModData.getOrCreate("FurnaceOffTime")
    ModData.getOrCreate("FurnaceTemp")
    ModData.getOrCreate("FurnaceTempState")
end
Events.OnInitGlobalModData.Add(FIvntServer.OnInitGlobalModData)

function FIvntServer.CreateLastFurnaceID(player,args)
    local username = player:getUsername()
    local account = ModData.get("LastFurnaceID")[username]
    if not account then
        ModData.get("LastFurnaceID")[username] = {LastFurnaceID = 0}
    end
    ModData.transmit("LastFurnaceID")
end

function FIvntServer.InputLastFurnaceID(player,args)
    local username = player:getUsername()
    local account = ModData.get("LastFurnaceID")[username]
    if not account then print("accountNotfound") return end
    account.LastFurnaceID = args[1]

    ModData.transmit("LastFurnaceID")
end

function FIvntServer.CreateSharingIvnt(player,args)
    local username = args[1]
    local account = ModData.get("MaterialFIvntM")[username]
    if account then
        print("account allready")
    else
        ModData.get("MaterialFIvntM")[username] = {Fuel = 0, Material1 = 0, Material2 = 0, Material3 = 0, Material4 = 0, Material5 = 0}
        ModData.get("MeltingMaterial")[username] = {MeltingFuel = 0, MeltingMaterial1 = 0, MeltingMaterial2 = 0, MeltingMaterial3 = 0, MeltingMaterial4 = 0, MeltingMaterial5 = 0}
        ModData.get("SyncFurnace")[username] = {FurnaceState = false}
        ModData.get("SyncMaterial")[username] = {SelectMaterial = "nil"}
        ModData.get("SyncActionInProgress")[username] = {ActionInProgress = false}
        ModData.get("SyncTime")[username] = {LastCheckTime = 0}
        ModData.get("FurnaceOffTime")[username] = {FurnaceOffTime = 0}
        ModData.get("FurnaceTemp")[username] = {FurnaceTemp = 0}
        ModData.get("FurnaceTempState")[username] = {FurnaceTempState = "Nofire"}
    end
    ModData.transmit("MaterialFIvntM")
    ModData.transmit("MeltingMaterial")
    ModData.transmit("SyncFurnace")
    ModData.transmit("SyncMaterial")
    ModData.transmit("SyncActionInProgress")
    ModData.transmit("SyncTime")
    ModData.transmit("FurnaceOffTime")
    ModData.transmit("FurnaceTemp")
    ModData.transmit("FurnaceTempState")
end

function FIvntServer.InputSyncFurnace(player,args)
    local username = args[1]
    local account = ModData.get("SyncFurnace")[username]
    if not account then print("accountNotfound") return end
    account.FurnaceState = args[2]

    ModData.transmit("SyncFurnace")
end
function FIvntServer.InputSyncMaterial(player,args)
    local username = args[1]
    local account = ModData.get("SyncMaterial")[username]
    if not account then print("accountNotfound") return end
    account.SelectMaterial = args[2]

    ModData.transmit("SyncMaterial")
end
function FIvntServer.InputSyncActionInProgress(player,args)
    local username = args[1]
    local account = ModData.get("SyncActionInProgress")[username]
    if not account then print("accountNotfound") return end
    account.ActionInProgress = args[2]

    ModData.transmit("SyncActionInProgress")
end
function FIvntServer.InputSyncTime(player,args)
    local username = args[1]
    local account = ModData.get("SyncTime")[username]
    if not account then print("accountNotfound") return end
    account.LastCheckTime = args[2]

    ModData.transmit("SyncTime")
end
function FIvntServer.InputFurnaceOffTime(player,args)
    local username = args[1]
    local account = ModData.get("FurnaceOffTime")[username]
    if not account then print("accountNotfound") return end
    account.FurnaceOffTime = args[2]

    ModData.transmit("FurnaceOffTime")
end
function FIvntServer.InputFurnaceTemp(player,args)
    local username = args[1]
    local account = ModData.get("FurnaceTemp")[username]
    if not account then print("accountNotfound") return end
    account.FurnaceTemp = args[2]

    ModData.transmit("FurnaceTemp")
end
function FIvntServer.InputFurnaceTempState(player,args)
    local username = args[1]
    local account = ModData.get("FurnaceTempState")[username]
    if not account then print("accountNotfound") return end
    account.FurnaceTempState = args[2]

    ModData.transmit("FurnaceTempState")
end

function FIvntServer.Inject(player,args)
    local username = args[1]
    local account = ModData.get("MaterialFIvntM")[username]
    if not account then return end
    account.Fuel = account.Fuel+args[2]
    account.Material1 = account.Material1+args[3]
    account.Material2 = account.Material2+args[4]
    account.Material3 = account.Material3+args[5]
    account.Material4 = account.Material4+args[6]
    account.Material5 = account.Material5+args[7]

    ModData.transmit("MaterialFIvntM")
end

function FIvntServer.Remove(player,args)
    local username = args[1]
    local account = ModData.get("MaterialFIvntM")[username]
    if not account then return end
    if account.Fuel >= args[2] then
        account.Fuel = account.Fuel-args[2]
    end
    if account.Material1 >= args[3] then
        account.Material1 = account.Material1-args[3]
    end
    if account.Material2 >= args[4] then
        account.Material2 = account.Material2-args[4]
    end
    if account.Material3 >= args[5] then
        account.Material3 = account.Material3-args[5]
    end
    if account.Material4 >= args[6] then
        account.Material4 = account.Material4-args[6]
    end
    if account.Material5 >= args[7] then
        account.Material5 = account.Material5-args[7]
    end

    ModData.transmit("MaterialFIvntM")
end

function FIvntServer.MeltingInject(player,args)
    local username = args[1]
    local account = ModData.get("MeltingMaterial")[username]
    if not account then return end
    account.MeltingFuel = account.MeltingFuel+args[2]
    account.MeltingMaterial1 = account.MeltingMaterial1+args[3]
    account.MeltingMaterial2 = account.MeltingMaterial2+args[4]
    account.MeltingMaterial3 = account.MeltingMaterial3+args[5]
    account.MeltingMaterial4 = account.MeltingMaterial4+args[6]
    account.MeltingMaterial5 = account.MeltingMaterial5+args[7]

    ModData.transmit("MeltingMaterial")
end

function FIvntServer.Make(player,args)
    local username = args[1]
    local account = ModData.get("MeltingMaterial")[username]
    if not account then return end
    if account.MeltingFuel >= args[2] then
        account.MeltingFuel = account.MeltingFuel-args[2]
    end
    if account.MeltingMaterial1 >= args[3] then
        account.MeltingMaterial1 = account.MeltingMaterial1-args[3]
    end
    if account.MeltingMaterial2 >= args[4] then
        account.MeltingMaterial2 = account.MeltingMaterial2-args[4]
    end
    if account.MeltingMaterial3 >= args[5] then
        account.MeltingMaterial3 = account.MeltingMaterial3-args[5]
    end
    if account.MeltingMaterial4 >= args[6] then
        account.MeltingMaterial4 = account.MeltingMaterial4-args[6]
    end
    if account.MeltingMaterial5 >= args[7] then
        account.MeltingMaterial5 = account.MeltingMaterial5-args[7]
    end

    ModData.transmit("MeltingMaterial")
end

local function FIvntS_OnClientCommand(module, command, player, args)
    if module == "FIvntS" and FIvntServer[command] then
        FIvntServer[command](player, args)
    end
end

Events.OnClientCommand.Add(FIvntS_OnClientCommand)