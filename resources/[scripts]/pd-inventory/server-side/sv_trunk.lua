------------------------------------------------------------------------------------------------------------------------------------------------------
-- Funções
------------------------------------------------------------------------------------------------------------------------------------------------------

local chests = {}
local uchests = {}
local openchests = {}

function vrpServer.loadTrunk()
	local user_id = vRP.getUserId(source)
	local source = vRP.getUserSource(user_id)

	local _,vnetid,mPlaca,mName,mLock,mBanido = vRPclient.vehList(source,7)
	local data = {}

	if mLock == 1 then
		if mPlaca then
			if mName then
				if mBanido then
					TriggerClientEvent("Notify",source,"negado","<b>Veículos de serviço ou alugados não podem utilizar o Porta-Malas</b>")
					return
				end
				local mPlacaUser = vRP.getUserByRegistration(mPlaca)
				if mPlacaUser then
					local chestname = "chest:u"..mPlacaUser.."veh_"..string.lower(mName)

					for k,v in pairs(openchests) do
						if v == chestname and k ~= user_id then
							TriggerClientEvent("Notify",source,"negado","<b>O Porta-Malas está sendo usado por outra pessoa.</b>")
							return false
						end
					end

					openchests[user_id] = chestname
					chests[chestname] = true
					vGARAGE.vehicleClientTrunk(-1,vnetid,false)
					vRPclient._playAnim(source,false,{"amb@prop_human_bum_bin@base","base"},true)


					local items = vRP.getSData(chestname)
					local max_weight = vRP.vehicleData(mName).chestweight or 50
					actual = 0


					if items ~= "" then
						items = json.decode(items)
						for k,v in pairs(items) do

							v.item = k
							v.weight = itemlist[v.item].weight
							v.icon = itemlist[v.item].icon
							v.name = itemlist[v.item].name
							v.desc = itemlist[v.item].desc

							actual = actual + (v.weight * v.amount)
							table.insert(data, v)
						end
					end

					return json.encode(data), max_weight, actual, mPlaca
				end
			end
		end
	end
end

AddEventHandler("vRP:playerLeave",function(user_id,source)
	if openchests[user_id] then
		openchests[user_id] = nil
	end
end)

function vrpServer.closeTrunkChests()
	local source = source
	local user_id = vRP.getUserId(source)
	if openchests[user_id] then
		local vehicle,vnetid = vRPclient.vehList(source,7)
		if vehicle then
			vGARAGE.vehicleClientTrunk(-1,vnetid,true)
			vRPclient._playAnim(source,false,{"amb@prop_human_bum_bin@exit","exit"},false)
		end
		openchests[user_id] = nil
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------
-- Eventos
------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("b03461cc:pd-inventory:putItem")
AddEventHandler("b03461cc:pd-inventory:putItem", function(itemName, itemCount)
	local user_id = vRP.getUserId(source)
	local source = vRP.getUserSource(user_id)
	local identity = vRP.getUserIdentity(user_id)
	local _,_,mPlaca,mName,mLock,mBanido,trunk = vRPclient.vehList(source,7)
	local mPlacaUser = vRP.getUserByRegistration(mPlaca)
	local chestname = "chest:u"..mPlacaUser.."veh_"..string.lower(mName)
	local max_weight = vRP.vehicleData(mName).chestweight or 50
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
		end
	end
end)

RegisterNetEvent("b03461cc:pd-inventory:getItem")
AddEventHandler("b03461cc:pd-inventory:getItem", function(itemName, itemCount)
	local user_id = vRP.getUserId(source)
	local source = vRP.getUserSource(user_id)
	local identity = vRP.getUserIdentity(user_id)
	local _,_,mPlaca,mName,mLock,mBanido,trunk = vRPclient.vehList(source,7)
	local mPlacaUser = vRP.getUserByRegistration(mPlaca)
	local chestname = "chest:u"..mPlacaUser.."veh_"..string.lower(mName)
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
	end
end)
