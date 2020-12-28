local _currShop

Citizen.CreateThread(function()
    while true do
        local idle = 500
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        
        for _,v in pairs(cfg.buyCoordinates) do
            local dist = GetDistanceBetweenCoords(pos, v.coords, true)
            if dist <= 5 and not isInInventory then
                idle = 0
                DrawMarker(23, v.coords.x, v.coords.y, v.coords.z-0.98,0,0,0,0,0,0,0.8,0.8,0.8,0,50,150,50,0,0,0,0)

                if dist <= 1 then
                    if IsControlJustPressed(0, 38) then
                        openShop(v.type)
                        _currShop = v.type
                    end
                end
            end
        end

        for _,v in pairs(cfg.sellCoordinates) do
            local dist = GetDistanceBetweenCoords(pos, v.coords, true)
            if dist <= 5 and not isInInventory then
                idle = 0
                DrawMarker(23, v.coords.x, v.coords.y, v.coords.z-0.98,0,0,0,0,0,0,0.8,0.8,0.8,0,50,150,50,0,0,0,0)

                if dist <= 1 then
                    if IsControlJustPressed(0, 38) then
                        sellShop(v.type)
                        _currShop = v.type
                    end
                end
            end
        end
        Citizen.Wait(idle)
    end
end)

RegisterNUICallback("BuyItem", function(data, cb)
    
    if type(data.number) == "number" and math.floor(data.number) == data.number and _currShop and data.number > 0 then
        TriggerServerEvent("b03461cc:pd-inventory:buyItem", data.data.item, _currShop, data.number)
    end

    Wait(300)

    updateInventory()
end)

RegisterNUICallback("SellItem", function(data, cb)
    
    if type(data.number) == "number" and math.floor(data.number) == data.number and _currShop and data.number > 0 then
        TriggerServerEvent("b03461cc:pd-inventory:sellItem", data.data.item, _currShop, data.number)
    end

    Wait(300)

    updateInventory()
end)

function openShop(shop)
    local weight,data,_ = vrpServer.getInv(gridZone)
    
    isInInventory = true

    SendNUIMessage({ action = "display", type = "shop" })
    SetNuiFocus(true, true)

    local data2 = vrpServer.loadShop(shop)

    SendNUIMessage({ action = "setText", text = 'ply-' .. GetPlayerServerId(PlayerId()), weight = weight, max = max })
    SendNUIMessage({ action = "setItems", itemList = data })

    SendNUIMessage({ action = "setSecondText", text = 'shop-' .. shop })
    SendNUIMessage({ action = "setSecondItems", itemSList = data2 })
end

function sellShop(shop)
    local weight,data,_ = vrpServer.getInv(gridZone)
    
    isInInventory = true

    SendNUIMessage({ action = "display", type = "sell" })
    SetNuiFocus(true, true)

    local data2 = vrpServer.loadShop(shop)

    SendNUIMessage({ action = "setText", text = 'ply-' .. GetPlayerServerId(PlayerId()), weight = weight, max = max })
    SendNUIMessage({ action = "setItems", itemList = data })

    SendNUIMessage({ action = "setSecondText", text = 'shop-' .. shop })
    SendNUIMessage({ action = "setSecondItems", itemSList = data2 })
end