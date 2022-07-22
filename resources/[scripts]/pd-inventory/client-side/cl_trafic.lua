local _currTrafic
local fixposition
local lastcraft
local onprocess = false

CreateThread(function()
    while true do
        local idle = 500
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for _, v in pairs(cfg.traficCoordinates) do
            local dist = GetDistanceBetweenCoords(pos, v.coords, true)
            if dist <= 3 and not isInInventory then
                idle = 0
                DrawMarker(23, v.coords.x, v.coords.y, v.coords.z - 0.98, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 255, 0, 0, 50, 0, 0, 0, 0)

                if dist <= 1.2 then
                    if IsControlJustPressed(0, 38) and vrpServer.checkIntPermissionsTrafic(v.perm) then
                        openTrafic(v.type)
                        _currTrafic = v.type
                    end
                end
            end
        end
        Wait(idle)
    end
end)

RegisterNUICallback("TraficItem", function(data, cb)
    if type(data.number) == "number" and math.floor(data.number) == data.number and _currTrafic and data.number > 0 and onprocess == false then
        TriggerEvent("b03461cc:pd-inventory:walkTrafic", data.data.item, data.number)
        onprocess = true
    end
end)

function openTrafic(craft)
    local weight, data, _, max = vrpServer.getInv(gridZone)

    isInInventory = true

    SendNUIMessage({ action = "display", type = "trafic" })
    SetNuiFocus(true, true)

    local data2 = vrpServer.loadTrafic(craft)

    SendNUIMessage({ action = "setText", text = 'ply-' .. GetPlayerServerId(PlayerId()), weight = weight, max = max })
    SendNUIMessage({ action = "setItems", itemList = data })

    SendNUIMessage({ action = "setSecondText", text = 'craft-' .. craft })
    SendNUIMessage({ action = "setSecondItems", itemSList = data2 })
end

RegisterNetEvent('b03461cc:pd-inventory:walkTrafic')
AddEventHandler('b03461cc:pd-inventory:walkTrafic', function(item, number)
    vRP._playAnim(false, { "mini@repair", "fixing_a_ped" }, true)
    TriggerEvent("progress", number * 10000)
    SetTimeout(number * 10000, function()
        TriggerServerEvent("b03461cc:pd-inventory:traficItem", item, _currTrafic, number)
        vRP.stopAnim(false)
        onprocess = false

        Wait(300)
        updateInventory()
    end)
end)
