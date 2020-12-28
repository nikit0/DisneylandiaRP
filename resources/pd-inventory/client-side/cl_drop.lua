local dropList = {}

RegisterNetEvent("b03461cc:pd-inventory:remove")
AddEventHandler("b03461cc:pd-inventory:remove",function(zone, id)
	if dropList[zone][tostring(id)] then
		dropList[zone][tostring(id)] = nil
	end
end)

RegisterNetEvent("b03461cc:pd-inventory:createForAll")
AddEventHandler("b03461cc:pd-inventory:createForAll",function(id,zone,marker)
	if not dropList[zone] then dropList[zone] = {} end
	dropList[zone][tostring(id)] = marker
end)

local cooldown = false
Citizen.CreateThread(function()
	while true do
		idle = 500

		if dropList[gridZone] then
			idle = 1

			for k,v in pairs(dropList[gridZone]) do
				local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
				local _,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
				if GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true) <= 3.5 then
					DrawMarker(20,v.x,v.y,cdz+0.15,0,0,0,0,180.0,130.0,0.25,0.5,0.25,255,255,255,200,0,0,0,0)
				end
			end
		end
		
		Citizen.Wait(idle)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------
-- Drop Callbacks
------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("DropItem", function(data, cb)
    if IsPedSittingInAnyVehicle(PlayerPedId()) then
        return
    end
    
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("b03461cc:pd-inventory:dropItem", GetEntityCoords(PlayerPedId()), gridZone, data.data.item, data.number)
    end
    
    Wait(300)

	updateInventory()
	updateDrop()
end)

RegisterNUICallback("PickupItem", function(data, cb)
    
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("b03461cc:pd-inventory:pickupItem", GetEntityCoords(PlayerPedId()), gridZone, data.data.item, data.number)
    end

    Wait(300)

    updateInventory()
    updateDrop()
end)