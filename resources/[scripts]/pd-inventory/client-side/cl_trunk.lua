isInTrunk = false

RegisterNetEvent("vrp.inventoryhud:refreshTrunk")
AddEventHandler("vrp.inventoryhud:refreshTrunk", function()
    updateTrunk()
end)

function openTrunk()
    local weight,data,_ = vrpServer.getInv(gridZone)
    --if not IsPedInAnyVehicle(PlayerPedId(), false) then
        local data2,max2,weight2,placa = vrpServer.loadTrunk()
        if data2 then
            isInInventory = true
            SendNUIMessage({ action = "display", type = "trunk" })
            SetNuiFocus(true, true)
            
            SendNUIMessage({ action = "setText", text = 'ply-' .. GetPlayerServerId(PlayerId()), weight = weight, max = max })
            SendNUIMessage({ action = "setItems", itemList = data })
            
            SendNUIMessage({ action = "setSecondText", text = 'trunk-' .. placa, weight = weight2, max = max2 })
            SendNUIMessage({ action = "setSecondItems", itemSList = data2 })
        end
    -- else
    --     local data2,max2,weight2,placa = vrpServer.loadTrunk2()
    --     if data2 then
    --         isInInventory = true
    --         SendNUIMessage({ action = "display", type = "trunk" })
    --         SetNuiFocus(true, true)
            
    --         SendNUIMessage({ action = "setText", text = 'ply-' .. GetPlayerServerId(PlayerId()), weight = weight, max = max })
    --         SendNUIMessage({ action = "setItems", itemList = data })
            
    --         SendNUIMessage({ action = "setSecondText", text = 'glovebox-' .. placa, weight = weight2, max = max2 })
    --         SendNUIMessage({ action = "setSecondItems", itemSList = data2 })
    --     end
    -- end
end

function updateTrunk()
    local weight,data,_,max = vrpServer.getInv(gridZone)
    local data2,max2,weight2,placa = vrpServer.loadTrunk()

    SendNUIMessage({ action = "setText", text = 'ply-' .. GetPlayerServerId(PlayerId()), weight = weight, max = max })
    SendNUIMessage({ action = "setItems", itemList = data })
    
    SendNUIMessage({ action = "setSecondText", text = 'trunk-' ..placa, weight = weight2, max = max2 })
    SendNUIMessage({ action = "setSecondItems", itemSList = data2 })
end

RegisterNUICallback("PutIntoTrunk", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("b03461cc:pd-inventory:putItem", data.data.item, data.number,veh)
    end

    Wait(500)

    updateInventory()
	updateTrunk()
end)

RegisterNUICallback("TakeFromTrunk", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("b03461cc:pd-inventory:getItem", data.data.item, data.number)
    end

    Wait(500)
    
    updateInventory()
	updateTrunk()
end)