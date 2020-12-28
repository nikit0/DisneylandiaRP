-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- -- Eventos
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- RegisterNetEvent("vrp.inventoryhud:openPlayer")
-- AddEventHandler("vrp.inventoryhud:openPlayer", function(target, targetName)
--     uTarget = target
--     uName = targetName
--     setPlayerInventoryData(target, targetName)
--     openPlayerInventory()
-- end)

-- RegisterNetEvent("vrp.inventoryhud:refreshPlayer")
-- AddEventHandler("vrp.inventoryhud:refreshPlayer", function(target, name)
--     setPlayerInventoryData(target, name)
--     --print(target, name)
-- end)

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- -- Funções
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- function refreshPlayerInventory()
--     setPlayerInventoryData(uTarget, uName)
-- end

-- function openPlayerInventory()
--     loadPlayerInventory()
--     isInInventory = true

--     SendNUIMessage({ action = "display", type = "player" })
--     SetNuiFocus(true, true)
-- end

-- function setPlayerInventoryData(target, targetName)

--     max, act = vrpInv.getWeight(target)
--     iweight = "Weight: " .. act .. " / " .. max

--     SendNUIMessage({ action = "setSecondaryWeights", sweights = "<strong>ply-"..target.."</strong><br>" .. iweight })

--     local items = vrpInv.getPlayerInventory(target)
--     local inventory = {}

--     if items ~= nil then
--         for k,v in pairs(items) do
--             if v.count ~= nil then
--                 items[k].name = k --img
--                 items[k].usable = false
--                 items[k].canRemove = false
--                 table.insert(inventory, items[k])
--             end
--         end
--     end

--     SendNUIMessage({ action = "setSecondInventoryItems", itemSList = inventory })
-- end

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- -- Callbacks
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- RegisterNUICallback("PutIntoPlayer", function(data, cb)
--     if IsPedSittingInAnyVehicle(playerPed) then
--         return
--     end

--     if type(data.number) == "number" and math.floor(data.number) == data.number then
--         local count = tonumber(data.number)

--         TriggerServerEvent("vrp.inventoryhud:tradeGiveItem", uTarget, data.item.name, count)
--     end

--     Wait(250)

--     refreshPlayerInventory()
--     loadPlayerInventory()
-- end)

-- RegisterNUICallback("TakeFromPlayer", function(data, cb)
--     if IsPedSittingInAnyVehicle(playerPed) then
--         return
--     end

--     if type(data.number) == "number" and math.floor(data.number) == data.number then
--         local count = tonumber(data.number)

--         TriggerServerEvent("vrp.inventoryhud:tradeTakeItem", uTarget, data.item.name, count)
--     end

--     Wait(250)

--     refreshPlayerInventory()
--     loadPlayerInventory()
-- end)

-- function updateTrunk()
--     local weight,data,_,max = vrpServer.getInv(gridZone)

--     SendNUIMessage({ action = "setText", text = 'ply-' .. GetPlayerServerId(PlayerId()), weight = weight, max = max })
--     SendNUIMessage({ action = "setItems", itemList = data })
-- end

RegisterNUICallback("SendItem",function(data,cb)
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("b03461cc:pd-inventory:sendItem",data.data.item, data.number)
    end
    
    Wait(300)

	updateInventory()
end)