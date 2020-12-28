local vaults = {}
local userVaults = {}
local openVaults = {}

function vrpServer.loadVault(vaultName)
	local user_id = vRP.getUserId(source)
	local source = vRP.getUserSource(user_id)
	local data = {}

	vaults[tostring(vaultName)] = true
    userVaults[user_id] = tostring(vaultName)
	vaultName = "chest:"..tostring(vaultName)

	for k,v in pairs(openVaults) do
		if k ~= user_id and v == vaultName then
			TriggerClientEvent("Notify",source,"negado","<b>O Baú está sendo usado por outra pessoa.</b>")
			return false
		end
	end	

	openVaults[user_id] = vaultName

	local data1 = vRP.getSData(vaultName)
	local items = json.decode(data1) or {}

    local actual = 0

	for k,v in pairs(items) do
		v.item = k
		v.weight = itemlist[v.item].weight
		v.icon = itemlist[v.item].icon
		v.name = itemlist[v.item].name
		v.desc = itemlist[v.item].desc

		actual = actual + (v.weight * v.amount)
		table.insert(data, v)
	end
	return json.encode(data),actual
end

AddEventHandler("vRP:playerLeave",function(user_id,source)
	if openVaults[user_id] then
		openVaults[user_id] = nil
	end
end)

function vrpServer.closeVaults()
	local source = source
	local user_id = vRP.getUserId(source)
	if openVaults[user_id] then
		openVaults[user_id] = nil
	end
end

function vrpServer.checkIntPermissionsVault(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.searchReturn(source,user_id) then
			local myResult = vRP.query("homes/get_homeuser",{ user_id = parseInt(user_id), home = tostring(homeName) })
			if myResult[1] or vRP.hasPermission(user_id,"policia.permissao") then
				return true
			end
		end
	end
	return false
end

function vrpServer.getChest()
	local source = source
	local user_id = vRP.getUserId(source)
	return userVaults[user_id]
end

RegisterNetEvent("b15798xx:pd-inventory:putItem")
AddEventHandler("b15798xx:pd-inventory:putItem", function(itemName, itemCount)
	local user_id = vRP.getUserId(source)
	local source = vRP.getUserSource(user_id)
	local identity = vRP.getUserIdentity(user_id)
	local vaultname = "chest:"..userVaults[user_id]
	local name = userVaults[user_id]
	local max_weight = parseInt(cfg.homesChests[name].max)
	local items = json.decode(vRP.getSData(vaultname)) or {}
	if not actual then actual = 0 end
	local add = false

	for k,v in pairs(items) do
		if k == itemName then
			add = true
		end
	end
	
	if itemCount == 0 then itemCount = getItemAmount(user_id, itemName) end


	if checkChestWeightAmount(user_id, itemName, itemCount, max_weight, vaultname) then
		if getItemAmount(user_id, itemName) >= itemCount and itemCount > 0 then
			if add then
				items[itemName].amount = items[itemName].amount + itemCount
			else
				items[itemName] = {amount = itemCount}
			end

			if consumeItem(user_id, itemName, itemCount) then
				vRP.setSData(vaultname, json.encode(items))
				SendWebhookMessage(webhookchesthomes,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.format(parseInt(itemCount)).." "..getItemName(itemName).." \n[CASA]: "..(tostring(userVaults[user_id])).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)

RegisterNetEvent("b15798xx:pd-inventory:getItem")
AddEventHandler("b15798xx:pd-inventory:getItem", function(itemName, itemCount)
	local user_id = vRP.getUserId(source)
	local source = vRP.getUserSource(user_id)
	local identity = vRP.getUserIdentity(user_id)
	local vaultname = "chest:"..userVaults[user_id]
	local items = json.decode(vRP.getSData(vaultname)) or {}
	if itemCount == 0 then itemCount = items[itemName].amount end
	if checkWeightAmount(user_id, itemName, itemCount) and itemCount > 0 then
		-- local max = vRP.getInventoryMaxWeight(user_id)
		-- local weight = vRP.getInventoryWeight(user_id)

		-- if (vRP.getItemWeight(itemName) * itemCount) + weight > max then
		-- 	TriggerClientEvent("Notify",source,"negado","Mochila cheia.")
		-- 	return
		-- end

		if itemCount == 0 then itemCount = items[itemName].amount end

		if items[itemName].amount > itemCount then
			items[itemName].amount = items[itemName].amount - itemCount
		elseif items[itemName].amount == itemCount and itemCount > 0 then
			items[itemName] = nil
		else
			TriggerClientEvent("Notify",source,"aviso","Ocorreu algum erro! Tente abrir o porta-malas novamente.")
			return
		end
		giveItem(user_id, itemName, itemCount)
		vRP.setSData(vaultname, json.encode(items))
		SendWebhookMessage(webhookchesthomes,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.format(parseInt(itemCount)).." "..getItemName(itemName).." \n[CASA]: "..(tostring(userVaults[user_id])).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	end
end)
