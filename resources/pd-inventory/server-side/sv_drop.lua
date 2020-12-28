local items = {}
local zones = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(zones) do
			if v > 0 then
				zones[k] = v - 1
			end
		end
	end
end)

RegisterNetEvent("b03461cc:pd-inventory:pickupItem")
AddEventHandler("b03461cc:pd-inventory:pickupItem", function(coords, zone, item, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if not zones[zone] or zones[zone] == 0 then
		zones[zone] = 1
		if user_id then
			local _,id = getDropList(zone, coords.x, coords.y, coords.z)

			if amount == 0 then
				amount = items[zone][tostring(id)].slots[item].amount
			end
			
			if items[zone][tostring(id)].slots[item].amount >= amount then
				if checkWeightAmount(user_id, item, amount) and amount > 0 then
					vRPclient._playAnim(source, true, {"pickup_object","putdown_low"}, false)
					giveItem(user_id, item, amount, true, "Pegou")
					items[zone][tostring(id)].slots[item].amount = items[zone][tostring(id)].slots[item].amount - amount
					
					if items[zone][tostring(id)].slots[item].amount == 0 then
						items[zone][tostring(id)].slots[item] = nil
					end

					if tableTostring(items[zone][tostring(id)].slots) == "{}" then
						TriggerClientEvent('b03461cc:pd-inventory:remove',-1,zone,id)
						idgens:free(id)
						items[zone][tostring(id)] = nil
					end
				end
			end
		end
	else
		return
	end
end)

RegisterNetEvent("b03461cc:pd-inventory:dropItem")
AddEventHandler("b03461cc:pd-inventory:dropItem", function(coords, zone, item, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)

	if user_id then
		if getItemAmount(user_id, item) >= amount and amount >= 0 then
			vRPclient._playAnim(source, true, {"pickup_object","pickup_low"}, false)
			if amount == 0 then
				amount = getItemAmount(user_id, item)
				dropItem(user_id, zone, coords.x, coords.y, coords.z, item, amount)
				SendWebhookMessage(webhookdrop,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DROPOU]: "..vRP.format(parseInt(amount)).." "..getItemName(item).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			else
				dropItem(user_id, zone, coords.x, coords.y, coords.z, item, amount)
				SendWebhookMessage(webhookdrop,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DROPOU]: "..vRP.format(parseInt(amount)).." "..getItemName(item).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)

function dropItem(user_id, zone, px, py, pz, item, amount)
	local drop, _id = getDropList(zone, px, py, pz)
	for k,v in pairs(drop) do
		if v then
			local id = _id
			local newList = items[zone]
			
			if newList[tostring(id)].slots[item] then
				newList[tostring(id)].slots[item].amount = newList[tostring(id)].slots[item].amount + amount
				consumeItem(user_id, item, amount,true, "Dropou")
				return
			else
				local newItem = { tempo = 900, item = item, amount = amount }
				newList[tostring(id)].slots[item] = newItem
				TriggerClientEvent('b03461cc:pd-inventory:createForAll',-1,id,zone,newList[tostring(id)])
				consumeItem(user_id, item, amount,true, "Dropou")
				return
			end
		end
	end

	local id = idgens:gen()
	if not items[zone] then items[zone] = {} end
	local newList = items[zone]

	local newItem = { tempo = 900, item = item, amount = amount }
	newList[tostring(id)] = { id = id, x = px, y = py, z = pz, slots = { [item] = newItem }}
	TriggerClientEvent('b03461cc:pd-inventory:createForAll',-1,id,zone,newList[tostring(id)])
	consumeItem(user_id, item, amount,true, "Dropou")
end

AddEventHandler("b03461cc:pd-inventory:dropItemEvent", function(coords, zone, item, amount)
	dropItemEvent(zone, coords.x, coords.y, coords.z, item, amount)
end)

function dropItemEvent(zone, px, py, pz, item, amount)
	local drop, _id = getDropList(zone, px, py, pz)
	for k,v in pairs(drop) do
		if v then
			local id = _id
			local newList = items[zone]
			
			if newList[tostring(id)].slots[item] then
				newList[tostring(id)].slots[item].amount = newList[tostring(id)].slots[item].amount + amount
				return
			else
				local newItem = { tempo = 900, item = item, amount = amount }
				newList[tostring(id)].slots[item] = newItem
				TriggerClientEvent('b03461cc:pd-inventory:createForAll',-1,id,zone,newList[tostring(id)])
				return
			end
		end
	end

	local id = idgens:gen()
	if not items[zone] then items[zone] = {} end
	local newList = items[zone]

	local newItem = { tempo = 900, item = item, amount = amount }
	newList[tostring(id)] = { id = id, x = px, y = py, z = pz, slots = { [item] = newItem }}
	TriggerClientEvent('b03461cc:pd-inventory:createForAll',-1,id,zone,newList[tostring(id)])
end

function getDropList(zone, x, y, z)
	if not items[zone] then items[zone] = {} end

	for k,v in pairs(items[zone]) do
		if getDistance(v.x, v.y, v.z, x, y, z) <= 0.5 then
			return v.slots or {}, v.id
		end
	end

	return {}
end

function getDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) + (z1 - z2)*(z1 - z2))
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(items) do
			for i,j in pairs(items[k]) do
				for a,b in pairs(j.slots) do
					if b.tempo > 0 then
						b.tempo = b.tempo - 1
						if b.tempo <= 0 then
							j.slots[a] = nil
							if tableTostring(j.slots) == "{}" then
								TriggerClientEvent('b03461cc:pd-inventory:remove',-1,k,j.id)
								idgens:free(j.id)
								v[tostring(j.id)] = nil
							end
						end
					end
				end
			end
		end
	end
end)