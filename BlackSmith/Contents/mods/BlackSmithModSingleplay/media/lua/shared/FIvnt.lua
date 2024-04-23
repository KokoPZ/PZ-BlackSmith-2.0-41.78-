FIvnt = FIvnt or {}

function FIvnt.getUserAccount(username)
    local MaterialFIvnt = ModData.get("MaterialFIvntM")
    if not MaterialFIvnt then return nil end
    return MaterialFIvnt[username]
end

function FIvnt.getUserFIvnt(username)
    local account = FIvnt.getUserAccount(username)
    local Fuel = 0
    local Material1 = 0
    local Material2 = 0
    local Material3 = 0
    local Material4 = 0
    local Material5 = 0
    if not account then return Fuel,Material1,Material2,Material3,Material4,Material5 end
    if account.Fuel then
        Fuel = account.Fuel
    end
    if account.Material1 then
        Material1 = account.Material1
    end
    if account.Material2 then
        Material2 = account.Material2
    end
    if account.Material3 then
        Material3 = account.Material3
    end
    if account.Material4 then
        Material4 = account.Material4
    end
    if account.Material5 then
        Material5 = account.Material5
    end
    return Fuel,Material1,Material2,Material3,Material4,Material5
end

function FIvnt.getLastFurnaceID(username)
    local LastFurnaceID = ModData.get("LastFurnaceID")
    if not LastFurnaceID then return nil end
    return LastFurnaceID[username]
end
function FIvnt.OutputLastFurnaceID(username)
    local account = FIvnt.getLastFurnaceID(username)
    local LastFurnaceID = 0
    if not account then print("not LastFurnaceID") return LastFurnaceID end
    LastFurnaceID = account.LastFurnaceID
    return LastFurnaceID
end

function FIvnt.getFurnaceInfo(username)
    local FurnaceInfo = ModData.get("SyncFurnace")
    if not FurnaceInfo then return nil end
    return FurnaceInfo[username]
end
function FIvnt.getMaterialInfo(username)
    local FurnaceInfo = ModData.get("SyncMaterial")
    if not FurnaceInfo then return nil end
    return FurnaceInfo[username]
end
function FIvnt.getActionInProgressInfo(username)
    local FurnaceInfo = ModData.get("SyncActionInProgress")
    if not FurnaceInfo then return nil end
    return FurnaceInfo[username]
end
function FIvnt.getTimeInfo(username)
    local FurnaceInfo = ModData.get("SyncTime")
    if not FurnaceInfo then return nil end
    return FurnaceInfo[username]
end
function FIvnt.getFurnaceOffTime(username)
    local FurnaceInfo = ModData.get("FurnaceOffTime")
    if not FurnaceInfo then return nil end
    return FurnaceInfo[username]
end
function FIvnt.getFurnaceTemp(username)
    local FurnaceInfo = ModData.get("FurnaceTemp")
    if not FurnaceInfo then return nil end
    return FurnaceInfo[username]
end
function FIvnt.getFurnaceTempInfo(username)
    local FurnaceInfo = ModData.get("FurnaceTempState")
    if not FurnaceInfo then return nil end
    return FurnaceInfo[username]
end

function FIvnt.OutputSyncFurnace(username)
    local account = FIvnt.getFurnaceInfo(username)
    local FurnaceState = false
    if not account then print("not Output FurnaceState") return FurnaceState end
    FurnaceState = account.FurnaceState
    return FurnaceState
end

function FIvnt.OutputSyncMaterial(username)
    local account = FIvnt.getMaterialInfo(username)
    local SelectMaterial = nil
    if not account then print("not Output SelectMaterial") return SelectMaterial end
    SelectMaterial = account.SelectMaterial
    return SelectMaterial
end

function FIvnt.OutputSyncActionInProgress(username)
    local account = FIvnt.getActionInProgressInfo(username)
    local ActionInProgress = false
    if not account then print("not Output ActionInProgress") return ActionInProgress end
    ActionInProgress = account.ActionInProgress
    return ActionInProgress
end

function FIvnt.OutputSyncTime(username)
    local account = FIvnt.getTimeInfo(username)
    local LastCheckTime = nil
    if not account then print("not Output LastCheckTime") return LastCheckTime end
    LastCheckTime = account.LastCheckTime
    return LastCheckTime
end

function FIvnt.OutputFurnaceOffTime(username)
    local account = FIvnt.getFurnaceOffTime(username)
    local FurnaceOffTime = 0
    if not account then print("not Output FurnaceOffTime") return FurnaceOffTime end
    FurnaceOffTime = account.FurnaceOffTime
    return FurnaceOffTime
end

function FIvnt.OutputFurnaceTemp(username)
    local account = FIvnt.getFurnaceTemp(username)
    local FurnaceTemp = 0
    if not account then print("not Output FurnaceTemp") return FurnaceTemp end
    FurnaceTemp = account.FurnaceTemp
    return FurnaceTemp
end

function FIvnt.OutputFurnaceTempState(username)
    local account = FIvnt.getFurnaceTempInfo(username)
    local FurnaceTempState = nil
    if not account then print("not Output FurnaceTempState") return FurnaceTempState end
    FurnaceTempState = account.FurnaceTempState
    return FurnaceTempState
end

function FIvnt.getUserMeltingMaterial(username)
    local MeltingMaterial = ModData.get("MeltingMaterial")
    if not MeltingMaterial then return nil end
    return MeltingMaterial[username]
end

function FIvnt.getUserMelting(username)
    local account = FIvnt.getUserMeltingMaterial(username)
    local MeltingFuel = 0
    local MeltingMaterial1 = 0
    local MeltingMaterial2 = 0
    local MeltingMaterial3 = 0
    local MeltingMaterial4 = 0
    local MeltingMaterial5 = 0
    if not account then return MeltingFuel,MeltingMaterial1,MeltingMaterial2,MeltingMaterial3,MeltingMaterial4,MeltingMaterial5 end
    if account.MeltingFuel then
        MeltingFuel = account.MeltingFuel
    end
    if account.MeltingMaterial1 then
        MeltingMaterial1 = account.MeltingMaterial1
    end
    if account.MeltingMaterial2 then
        MeltingMaterial2 = account.MeltingMaterial2
    end
    if account.MeltingMaterial3 then
        MeltingMaterial3 = account.MeltingMaterial3
    end
    if account.MeltingMaterial4 then
        MeltingMaterial4 = account.MeltingMaterial4
    end
    if account.MeltingMaterial5 then
        MeltingMaterial5 = account.MeltingMaterial5
    end
    return MeltingFuel,MeltingMaterial1,MeltingMaterial2,MeltingMaterial3,MeltingMaterial4,MeltingMaterial5
end

function FIvnt.getAccountsList()
    local accounts = {}
    local MaterialFIvnt = ModData.get("MaterialFIvntM")
    if not MaterialFIvnt then return accounts end
    for k,v in pairs(MaterialFIvnt) do
        table.insert(accounts,k)
    end
    return accounts
end