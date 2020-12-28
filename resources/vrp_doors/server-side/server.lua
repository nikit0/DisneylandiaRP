local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM OPEN DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('vrpdoorsystem:open')
AddEventHandler('vrpdoorsystem:open',function(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,doors[id].perm) then
		vRPclient._playAnim(source,true,{"veh@mower@base","start_engine"},false)
		Citizen.Wait(2200)

		doors[id].lock = not doors[id].lock
		TriggerClientEvent('vrpdoorsystem:statusSend',-1,id,doors[id].lock)
		if doors[id].other ~= nil then
			local idsecond = doors[id].other
			doors[idsecond].lock = doors[id].lock
			TriggerClientEvent('vrpdoorsystem:statusSend',-1,idsecond,doors[id].lock)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM OPEN GATES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('vrpgatesystem:open')
AddEventHandler('vrpgatesystem:open',function(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,gates[id].perm) then
		vRPclient._playAnim(source,true,{"anim@mp_player_intmenu@key_fob@","fob_click"},false)

		gates[id].lock = not gates[id].lock
		TriggerClientEvent('vrpgatesystem:statusSend',-1,id,gates[id].lock)
		if gates[id].other ~= nil then
			local idsecond = gates[id].other
			gates[idsecond].lock = gates[id].lock
			TriggerClientEvent('vrpgatesystem:statusSend',-1,idsecond,gates[id].lock)
		end
	end
end)