-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNC TACKLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_tackle:tryTackle")
AddEventHandler("vrp_tackle:tryTackle",function(target)
	TriggerClientEvent("vrp_tackle:getTackled",target,source)
	TriggerClientEvent("vrp_tackle:playTackle",source)
end)