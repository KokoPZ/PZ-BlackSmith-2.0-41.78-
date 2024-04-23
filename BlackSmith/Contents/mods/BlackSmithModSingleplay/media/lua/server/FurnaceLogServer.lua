if not isServer() then return end

local FurnaceLogServer = {}

local logfile = "shops_transactions.log"
local msg = ""

function FurnaceLogServer.TransactionFurnaceLog(player,args)
    msg = args[1]
    if Valhalla and Valhalla.Commands then
        local args = {file = logfile, line = msg}
        Valhalla.Commands.writeToLog(nil, args)
        return
    end
    print(msg)
end

local function FLS_OnClientCommand(module, command, player, args)
    if module == "FLS" and FurnaceLogServer[command] then
        FurnaceLogServer[command](player, args)
    end
end

Events.OnClientCommand.Add(FLS_OnClientCommand)