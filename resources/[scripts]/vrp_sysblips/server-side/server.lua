-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local sysBlips = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_sysblips:UpdateCoords")
AddEventHandler("vrp_sysblips:UpdateCoords",function(x,y,z,service,color)
	local source = source
	sysBlips[source] = { service,color,x,y,z }
	TriggerClientEvent("vrp_sysblips:UpdateBlips",source,sysBlips)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXITSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_sysblips:ExitService")
AddEventHandler("vrp_sysblips:ExitService",function(source)
	if sysBlips[source] then
		sysBlips[source] = nil
		TriggerClientEvent("vrp_sysblips:RemoveBlips",-1,source)
		TriggerClientEvent("vrp_sysblips:UpdateBlips",-1,sysBlips)
	end

	TriggerClientEvent("vrp_sysblips:ClearBlips",source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function()
	if sysBlips[source] then
		sysBlips[source] = nil
		TriggerClientEvent("vrp_sysblips:RemoveBlips",-1,source)
		TriggerClientEvent("vrp_sysblips:UpdateBlips",-1,sysBlips)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
-- AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
-- 	if vRP.hasPermission(user_id,"Police") then
-- 		TriggerClientEvent("vrp_sysblips:ToggleService",source,"Police",3)
-- 	elseif vRP.hasPermission(user_id,"Paramedic") then
-- 		TriggerClientEvent("vrp_sysblips:ToggleService",source,"Paramedic",83)
-- 	end
-- end)