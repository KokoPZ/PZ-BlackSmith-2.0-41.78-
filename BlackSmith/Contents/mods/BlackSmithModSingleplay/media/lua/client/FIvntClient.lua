if not isClient() then return end

local FIvntClient = {}

function FIvntClient.OnReceiveGlobalModData(key, modData)
    if not modData then return end
    ModData.remove(key)
    ModData.add(key, modData)
end
Events.OnReceiveGlobalModData.Add(FIvntClient.OnReceiveGlobalModData)

function FIvntClient.OnConnected()
	ModData.request("MaterialFIvntM")
    ModData.request("MeltingMaterial")
end

local function FIvntS_OnServerCommand(module, command, args)
    if module== "FIvntS" and FIvntClient[command] then
        FIvntClient[command](args)
    end
end

Events.OnServerCommand.Add(FIvntS_OnServerCommand)
Events.OnConnected.Add(FIvntClient.OnConnected)