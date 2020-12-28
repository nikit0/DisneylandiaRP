local currentVault

RegisterCommand("vault",function(source,args)
	local ped = PlayerPedId()
	local cds = GetEntityCoords(ped)
	for k,v in pairs(cfg.homesChests) do
		local distance = Vdist(cds,v.coords)
		if distance <= 2.0 then
			chestTimer = 3
            if vrpServer.checkIntPermissionsVault(k) then
                currentVault = k
				openVault(k)
			end
		end
	end
end)

function openVault()
	local weight,data,_,max = vrpServer.getInv(gridZone)
	local data2,weight2 = vrpServer.loadVault(currentVault)
	if data2 then
		isInInventory = true
		SendNUIMessage({ action = "display", type = "vault" })
		SetNuiFocus(true, true)
		
		SendNUIMessage({ action = "setText", text = 'ply-' .. GetPlayerServerId(PlayerId()), weight = weight, max = max })
		SendNUIMessage({ action = "setItems", itemList = data })
		
		SendNUIMessage({ action = "setSecondText", text = 'vault-' .. currentVault, weight = weight2, max = cfg.homesChests[currentVault].max })
		SendNUIMessage({ action = "setSecondItems", itemSList = data2 })
	end
end

function updateVault()
	local data2,weight2 = vrpServer.loadVault(currentVault)
	local weight,data,_,max = vrpServer.getInv(gridZone)

	SendNUIMessage({ action = "display", type = "vault" })

	SendNUIMessage({ action = "setText", text = 'ply-' .. GetPlayerServerId(PlayerId()), weight = weight, max = max })
	SendNUIMessage({ action = "setItems", itemList = data })
	
	SendNUIMessage({ action = "setSecondText", text = 'vault-' .. currentVault, weight = weight2, max = cfg.homesChests[currentVault].max })
	SendNUIMessage({ action = "setSecondItems", itemSList = data2 })
end

RegisterNUICallback("PutIntoVault", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("b15798xx:pd-inventory:putItem", data.data.item, data.number)
    end

    Wait(500)

    updateInventory()
	updateVault()
end)

RegisterNUICallback("TakeFromVault", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
	end
	
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("b15798xx:pd-inventory:getItem", data.data.item, data.number)
    end

    Wait(500)
    
    updateInventory()
	updateVault()
end)
