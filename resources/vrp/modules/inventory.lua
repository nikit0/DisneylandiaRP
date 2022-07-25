function vRP.itemNameList(item)
	if itemlist[item] ~= nil then
		return itemlist[item].nome
	end
end

function vRP.itemIndexList(item)
	if itemlist[item] ~= nil then
		return itemlist[item].index
	end
end

function vRP.itemTypeList(item)
	if itemlist[item] ~= nil then
		return itemlist[item].type
	end
end

function vRP.itemBodyList(item)
	if itemlist[item] ~= nil then
		return itemlist[item]
	end
end

vRP.items = {}
function vRP.defInventoryItem(idname, name, weight)
	if weight == nil then
		weight = 0
	end
	local item = { name = name, weight = weight }
	vRP.items[idname] = item
end

function vRP.computeItemName(item, args)
	if type(item.name) == "string" then
		return item.name
	else
		return item.name(args)
	end
end

function vRP.computeItemWeight(item, args)
	if type(item.weight) == "number" then
		return item.weight
	else
		return item.weight(args)
	end
end

function vRP.parseItem(idname)
	return splitString(idname, "|")
end

function vRP.getItemDefinition(idname)
	local args = vRP.parseItem(idname)
	local item = vRP.items[args[1]]
	if item then
		return vRP.computeItemName(item, args), vRP.computeItemWeight(item, args)
	end
	return nil, nil
end

function vRP.getItemWeight(idname)
	local args = vRP.parseItem(idname)
	local item = vRP.items[args[1]]
	if item then
		return vRP.computeItemWeight(item, args)
	end
	return 0
end

function vRP.computeItemsWeight(items)
	local weight = 0
	for k, v in pairs(items) do
		local iweight = vRP.getItemWeight(k)
		weight = weight + iweight * v.amount
	end
	return weight
end

function vRP.giveInventoryItem(user_id, idname, amount)
	local amount = parseInt(amount)
	local data = vRP.getUserDataTable(user_id)
	if data and amount > 0 then
		local entry = data.inventory[idname]
		if entry then
			entry.amount = entry.amount + amount
		else
			data.inventory[idname] = { amount = amount }
		end
	end
end

function vRP.tryGetInventoryItem(user_id, idname, amount)
	local amount = parseInt(amount)
	local data = vRP.getUserDataTable(user_id)
	if data and amount > 0 then
		local entry = data.inventory[idname]
		if entry and entry.amount >= amount then
			entry.amount = entry.amount - amount

			if entry.amount <= 0 then
				data.inventory[idname] = nil
			end
			return true
		end
	end
	return false
end

function vRP.getInventoryItemAmount(user_id, idname)
	local data = vRP.getUserDataTable(user_id)
	if data and data.inventory then
		local entry = data.inventory[idname]
		if entry then
			return entry.amount
		end
	end
	return 0
end

function vRP.getInventory(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data then
		return data.inventory
	end
end

function vRP.getInventoryWeight(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data and data.inventory then
		return vRP.computeItemsWeight(data.inventory)
	end
	return 0
end

function vRP.expToLevel(exp)
	return (math.sqrt(1 + 8 * exp / 4) - 1) / 2
end

function vRP.getInventoryMaxWeight(user_id)
	return math.floor(vRP.expToLevel(90))
end

RegisterServerEvent("clearInventory")
AddEventHandler("clearInventory", function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("vRP/clear_inv", { itemlist = "{}", user_id = user_id })

		vRP.setMoney(user_id, 0)
		vRPclient._clearWeapons(source)
		vRPclient._setHandcuffed(source, false)
		vRPclient.setArmour(source, 0)

		if not vRP.hasPermission(user_id, "mochila.permissao") then
			vRP.execute("vRP/give_max_inv", { max = 6, user_id = user_id })
		end
	end
end)

AddEventHandler("vRP:playerJoin", function(user_id, source, name)
	local data = vRP.getUserDataTable(user_id)
	if not data.inventory then
		data.inventory = {}
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.vehicleGlobal()
	return vRP.query("vRP/get_all_vehicles")
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLENAME
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.vehicleName(spawn)
	local vname = vRP.query("vRP/get_vehicle_data", { spawn = spawn })
	return vname[1].name
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEPRICE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.vehiclePrice(spawn)
	local vname = vRP.query("vRP/get_vehicle_data", { spawn = spawn })
	return vname[1].price
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLECLASS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.vehicleClass(spawn)
	local vname = vRP.query("vRP/get_vehicle_data", { spawn = spawn })
	return vname[1].class
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.vehicleData(spawn)
	local vname = vRP.query("vRP/get_vehicle_data", { spawn = spawn })
	return vname[1]
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEHASH
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.vehicleHash(hash)
	local vname = vRP.query("vRP/get_vehicle_hash", { hash = hash })
	return vname[1]
end
