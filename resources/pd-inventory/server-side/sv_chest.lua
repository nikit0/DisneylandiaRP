local chests = {}
local userChests = {}
local openStaticChests = {}

function vrpServer.loadChest(chestName)
	local user_id = vRP.getUserId(source)
	local source = vRP.getUserSource(user_id)
	local data = {}

	chests[tostring(chestName)] = true
    userChests[user_id] = tostring(chestName)
	chestName = "chest:"..tostring(chestName)
	
	for k,v in pairs(openStaticChests) do
		if v == chestName and k ~= user_id then
			TriggerClientEvent("Notify",source,"negado","<b>O Baú está sendo usado por outra pessoa.</b>")
			return false
		end
	end
	
	openStaticChests[user_id] = chestName
	
	local data1 = vRP.getSData(chestName)
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
	if openStaticChests[user_id] then
		openStaticChests[user_id] = nil
	end
end)

function vrpServer.closeStaticChests()
	local source = source
	local user_id = vRP.getUserId(source)
	if openStaticChests[user_id] then
		openStaticChests[user_id] = nil
	end
end

function vrpServer.checkIntPermissionsChest(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.searchReturn(source,user_id) then
			return vRP.hasPermission(user_id,perm)
		end
	end
end

function vrpServer.getChest()
	local source = source
	local user_id = vRP.getUserId(source)
	return userChests[user_id]
end

RegisterNetEvent("b03566cd:pd-inventory:putItem")
AddEventHandler("b03566cd:pd-inventory:putItem", function(itemName, itemCount)
	local user_id = vRP.getUserId(source)
	local source = vRP.getUserSource(user_id)
	local identity = vRP.getUserIdentity(user_id)
	local chestname = "chest:"..userChests[user_id]
	local name = userChests[user_id]
	local max_weight = parseInt(cfg.staticChests[name].max)
	local items = json.decode(vRP.getSData(chestname)) or {}
	if not actual then actual = 0 end
	local add = false

	for k,v in pairs(items) do
		if k == itemName then
			add = true
		end
	end
	
	if itemCount == 0 then itemCount = getItemAmount(user_id, itemName) end
	
	if checkChestWeightAmount(user_id, itemName, itemCount, max_weight, chestname) then
		if getItemAmount(user_id, itemName) >= itemCount and itemCount > 0 then
			if add then
				items[itemName].amount = items[itemName].amount + itemCount
			else
				items[itemName] = {amount = itemCount}
			end

			consumeItem(user_id, itemName, itemCount)
			vRP.setSData(chestname, json.encode(items))
			if name == "Policia" or name == "Sheriff" then
				SendWebhookMessage(webhookchestpolice,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.format(parseInt(itemCount)).." "..getItemName(itemName).." \n[BAU]: "..name.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			else
				SendWebhookMessage(webhookchestgang,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.format(parseInt(itemCount)).." "..getItemName(itemName).." \n[BAU]: "..name.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)

RegisterNetEvent("b03566cd:pd-inventory:getItem")
AddEventHandler("b03566cd:pd-inventory:getItem", function(itemName, itemCount)
	local user_id = vRP.getUserId(source)
	local source = vRP.getUserSource(user_id)
	local identity = vRP.getUserIdentity(user_id)
	local chestname = "chest:"..userChests[user_id]
	local name = userChests[user_id]
	local items = json.decode(vRP.getSData(chestname)) or {}
	if itemCount == 0 then itemCount = items[itemName].amount end
	if checkWeightAmount(user_id, itemName, itemCount) and itemCount > 0 then
		-- local max = vRP.getInventoryMaxWeight(user_id)
		-- local weight = vRP.getInventoryWeight(user_id)

		-- if (vRP.getItemWeight(itemName) * itemCount) + weight > max then
		-- 	TriggerClientEvent("Notify",source,"negado","Mochila cheia.")
		-- 	return
		-- end


		if items[itemName].amount > itemCount then
			items[itemName].amount = items[itemName].amount - itemCount
		elseif items[itemName].amount == itemCount and itemCount > 0 then
			items[itemName] = nil
		else
			TriggerClientEvent("Notify",source,"aviso","Ocorreu algum erro! Tente abrir o porta-malas novamente.")
			return
		end

		vRP.setSData(chestname, json.encode(items))	
		giveItem(user_id, itemName, itemCount)
		if name == "Policia" or name == "Sheriff" then
			SendWebhookMessage(webhookchestpolice,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.format(parseInt(itemCount)).." "..getItemName(itemName).." \n[BAU]: "..name.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```<@&584135183213527050>")
		else
			SendWebhookMessage(webhookchestgang,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.format(parseInt(itemCount)).." "..getItemName(itemName).." \n[BAU]: "..name.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
