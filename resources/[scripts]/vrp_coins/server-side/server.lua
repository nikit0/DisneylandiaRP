-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXAO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_coins", src)
Proxy.addInterface("vrp_coins", src)
-----------------------------------------------------------------------------------------------------------------------------------------
--  assets
-----------------------------------------------------------------------------------------------------------------------------------------
local coinsShop = {
    -- Vips
    ["gold15"] = { ['price'] = 1000 },
    ["gold30"] = { ['price'] = 2000 },
    ["platinum15"] = { ['price'] = 3000 },
    ["platinum30"] = { ['price'] = 5000 },
    -- Extras
    ["vipaparencia"] = { ['price'] = 750 },
    ["vipplaca"] = { ['price'] = 1500 },
    ["vipgaragem"] = { ['price'] = 2000 },
    -- Carros DL RENTAL
    ["bmwz4"] = { ['price'] = 1000 },
    ["dodgeram2500"] = { ['price'] = 1000 },
    ["ferraricalifornia"] = { ['price'] = 1000 },
    ["fordmustang"] = { ['price'] = 1000 },
    ["jeepgladiator"] = { ['price'] = 1000 },
    ["nissansilvias15"] = { ['price'] = 1000 },
    ["porschemacan"] = { ['price'] = 1000 },
    ["teslamodelx"] = { ['price'] = 1000 },
    ["vwamarok"] = { ['price'] = 1000 },
    -- Carros DL RENTAL+
    ["bmwgs1200r"] = { ['price'] = 1750 },
    ["bmwm5f90"] = { ['price'] = 1750 },
    ["bugattichiron"] = { ['price'] = 1750 },
    ["corvettec8"] = { ['price'] = 1750 },
    ["lamborghinievo"] = { ['price'] = 1750 },
    ["lamborghinievos"] = { ['price'] = 1750 },
    ["lancerevolutionx"] = { ['price'] = 1750 },
    ["mazdarx7"] = { ['price'] = 1750 },
    ["mclarensenna"] = { ['price'] = 1750 },
    ["toyotasupra"] = { ['price'] = 1750 },
    ["yamahar1"] = { ['price'] = 1750 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
--  COMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('viptime', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local rows = vRP.query("vRP/get_vip_time", { id = user_id })
    if #rows and rows[1].vip_time ~= 0 then
        TriggerClientEvent("Notify", source, "importante", "VIP: " .. vRP.getDayHours(parseInt(rows[1].vip_time - os.time())))
    end
end)

RegisterCommand('rentaltime', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local rows = vRP.query("vRP/get_rental_time", { user_id = user_id })
    if #rows then
        for k, v in pairs(rows) do
            if vRP.vehicleClass(tostring(v.vehicle)) == "rental" then
                TriggerClientEvent("Notify", source, "importante", "Carro: <b>" .. vRP.vehicleName(v.vehicle) .. "</b>\nTempo: " .. vRP.getDayHours(parseInt(v.rental_time - os.time())))
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK VIP TIME
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    local rows = vRP.query("vRP/get_vip_time", { id = user_id })
    if #rows then
        -- Checa o grupo do player, se for Gold / Platinum
        local user_groups = vRP.getUserGroups(user_id)
        local group
        for k, _ in pairs(user_groups) do
            if k == "Gold" then
                group = "Gold"
            elseif k == "Platinum" then
                group = "Platinum"
            end
        end
        -- Checa o tempo do VIP
        if rows[1].vip_time ~= 0 and os.time() >= rows[1].vip_time then
            vRP.removeUserGroup(parseInt(user_id), group)
            vRP.execute("vRP/add_priority", { id = user_id, priority = 0 })
            vRP.execute("vRP/update_vip_time", { id = user_id, vip_time = 0 })
        end
    end
    -- Checa o tempo do Veículo
    local rows2 = vRP.query("vRP/get_rental_time", { user_id = user_id })
    if #rows2 then
        for k, v in pairs(rows2) do
            if vRP.vehicleClass(tostring(v.vehicle)) == "rental" then
                if v.rental_time ~= 0 and os.time() >= v.rental_time then
                    vRP.execute("vRP/rem_vehicle", { user_id = parseInt(user_id), vehicle = v.vehicle })
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--  GIVE ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function src.giveItemVip(type, time)
    local user_id = vRP.getUserId(source)
    local ucoins
    if user_id then
        if type and time then
            if src.remCoins(coinsShop[type .. time].price) then
                exports["pd-inventory"]:giveItem(user_id, "vip" .. type .. time, 1, true)
                ucoins = vRP.getCoins(user_id)
            end
        end
    end
    return ucoins
end

-----------------------------------------------------------------------------------------------------------------------------------------
--  GIVE ITEM APARENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.giveItem(item)
    local user_id = vRP.getUserId(source)
    local ucoins
    if user_id then
        if src.remCoins(coinsShop[item].price) then
            exports["pd-inventory"]:giveItem(user_id, item, 1, true)
            ucoins = vRP.getCoins(user_id)
        end
    end
    return ucoins
end

-----------------------------------------------------------------------------------------------------------------------------------------
--  REMOVE COINS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.remCoins(amount)
    local user_id = vRP.getUserId(source)
    local coins = vRP.getCoins(user_id)
    if coins >= amount then
        vRP.withdrawCoins(user_id, amount)
        return true
    else
        return false
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
--  QTD COINS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.getCoins()
    local user_id = vRP.getUserId(source)
    return vRP.getCoins(user_id)
end

-----------------------------------------------------------------------------------------------------------------------------------------
--  GIVE VEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.giveVehicle(vehicle)
    local user_id = vRP.getUserId(source)
    local ucoins
    if vehicle then
        if src.remCoins(coinsShop[vehicle.name].price) then
            vRP.execute("vRP/add_vehicle", { user_id = parseInt(user_id), vehicle = vehicle.name, ipva = parseInt(os.time()) })
            vRP.execute("vRP/set_rental_time", { user_id = parseInt(user_id), vehicle = vehicle.name, rental_time = parseInt(os.time() + 30 * 24 * 60 * 60) })
            ucoins = vRP.getCoins(user_id)
        end
    end
    return ucoins
end
