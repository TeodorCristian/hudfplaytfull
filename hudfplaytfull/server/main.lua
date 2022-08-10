local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPSPipicaca = {}
Tunnel.bindInterface("vRPPipicaca",vRPSPipicaca)
Proxy.addInterface("vRPPipicaca",vRPSPipicaca)
vRP = Proxy.getInterface("vRP")

RegisterNetEvent("get_Status")
AddEventHandler("get_Status",function()
    local _src = source
    local user_id = vRP.getUserId({_src})
    local player = vRP.getUserSource({user_id})
    local hunger = vRP.getHunger({user_id})
    local thirst = vRP.getThirst({user_id})
    if user_id ~= nil then
        TriggerClientEvent("vrp_status", player, {hunger = hunger, thirst = thirst})
    end
end)

