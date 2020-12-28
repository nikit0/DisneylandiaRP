local currentChest

RegisterCommand("chest",function(source,args)
	local ped = PlayerPedId()
	local cds = GetEntityCoords(ped)
	for k,v in pairs(cfg.staticChests) do
		local distance = Vdist(cds,v.coords)
		if distance <= 2.0 then
			chestTimer = 3
			if vrpServer.checkIntPermissionsChest(v.perm) then
				currentChest = k
				openChest(k)
			end
		end
	end
end)

function openChest()
	local weight,data,_,max = vrpServer.getInv(gridZone)
	local data2,weight2 = vrpServer.loadChest(currentChest)
	if data2 then
		isInInventory = true
		SendNUIMessage({ action = "display", type = "chest" })
		SetNuiFocus(true, true)
		
		SendNUIMessage({ action = "setText", text = 'ply-' .. GetPlayerServerId(PlayerId()), weight = weight, max = max })
		SendNUIMessage({ action = "setItems", itemList = data })
		
		SendNUIMessage({ action = "setSecondText", text = 'chest-' .. currentChest, weight = weight2, max = cfg.staticChests[currentChest].max })
		SendNUIMessage({ action = "setSecondItems", itemSList = data2 })
	end
end

function updateChest()
	local data2,weight2 = vrpServer.loadChest(currentChest)

	SendNUIMessage({ action = "display", type = "chest" })

    SendNUIMessage({ action = "setSecondText", text = 'chest-' .. currentChest, weight = weight2, max = cfg.staticChests[currentChest].max })
    SendNUIMessage({ action = "setSecondItems", itemSList = data2 })
end

RegisterNUICallback("PutIntoChest", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("b03566cd:pd-inventory:putItem", data.data.item, data.number)
    end

    Wait(500)

    updateInventory()
	updateChest()
end)

RegisterNUICallback("TakeFromChest", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
	end
	
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("b03566cd:pd-inventory:getItem", data.data.item, data.number)
    end

    Wait(500)
    
    updateInventory()
	updateChest()
end)
