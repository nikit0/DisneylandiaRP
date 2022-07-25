-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- /REVISTAR
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- 	-- local identity = vRP.getUserIdentity(user_id)
-- 	-- local weapons = vRPclient.getWeapons(nplayer)
-- 	-- local money = vRP.getMoney(nuser_id)
-- 	-- local data = vRP.getUserDataTable(nuser_id)
-- 	-- TriggerClientEvent('chatMessage',source,"",{},"^4- -  ^5M O C H I L A^4  - - - - - - - - - - - - - - - - - - - - - - - - - - -  [  ^3"..string.format("%.2f",vRP.getInventoryWeight(nuser_id)).."kg^4  /  ^3"..string.format("%.2f",vRP.getInventoryMaxWeight(nuser_id)).."kg^4  ]  - -")
-- 	-- if data and data.inventory then
-- 	-- 	for k,v in pairs(data.inventory) do
-- 	-- 		TriggerClientEvent('chatMessage',source,"",{},"     "..vRP.format(parseInt(v.amount)).."x "..itemlist[k].nome)
-- 	-- 	end
-- 	-- end
-- 	-- TriggerClientEvent('chatMessage',source,"",{},"^4- -  ^5E Q U I P A D O^4  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
-- 	-- for k,v in pairs(weapons) do
-- 	-- 	if v.ammo < 1 then
-- 	-- 		TriggerClientEvent('chatMessage',source,"",{},"     1x "..itemlist["wbody|"..k].nome)
-- 	-- 	else
-- 	-- 		TriggerClientEvent('chatMessage',source,"",{},"     1x "..itemlist["wbody|"..k].nome.." | "..vRP.format(parseInt(v.ammo)).."x Munições")
-- 	-- 	end
-- 	-- end
-- 	-- TriggerClientEvent('chatMessage',source,"",{},"     $"..vRP.format(parseInt(money)).." Dólares")
-- 	-- TriggerClientEvent("Notify",nplayer,"aviso","Revistado por <b>"..identity.name.." "..identity.firstname.."</b>.")


-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- -- Funções
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- function vrpInv.getPlayerInventory(user_id)
-- 	if user_id then
-- 		local inv = vRP.getInventory(user_id)
-- 		local data = {}

-- 		for k, v in pairs(inv) do
-- 			data[k] = {["count"] = parseInt(v.amount), ["label"] = vRP.getItemName(k), ["weight"] = vRP.getItemWeight(k)}
-- 		end

-- 		return data
-- 	end
-- end

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- -- Event Handlers
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- RegisterServerEvent("vrp.inventoryhud:tradeTakeItem")
-- AddEventHandler("vrp.inventoryhud:tradeTakeItem", function(target, itemName, itemCount)
-- 	local user_id = vRP.getUserId(source)
-- 	local source = vRP.getUserSource(user_id)
-- 	local nplayer = vRP.getUserSource(target)
-- 	local identity = vRP.getUserIdentity(user_id)

-- 	local max = vRP.getInventoryMaxWeight(user_id)
-- 	local weight = vRP.getInventoryWeight(user_id)

-- 	if (vRP.getItemWeight(itemName) * itemCount) + weight > max then
-- 		TriggerClientEvent("Notify",source,"negado","Mochila cheia.")
-- 		return
-- 	end

-- 	if vRP.tryGetInventoryItem(target, itemName, itemCount, true) then
-- 		vRP.giveInventoryItem(user_id, itemName, itemCount, true)
-- 		TriggerClientEvent("Notify",nplayer,"aviso","<b>("..user_id..") "..identity.name.." "..identity.firstname.."</b> removeu "..itemCount.."X "..vRP.getItemName(itemName)..".")
-- 	end

-- 	TriggerClientEvent("vrp.inventoryhud:refreshPlayer", target)
-- end)

-- RegisterServerEvent("vrp.inventoryhud:tradeGiveItem")
-- AddEventHandler("vrp.inventoryhud:tradeGiveItem", function(target, itemName, itemCount)
-- 	local user_id = vRP.getUserId(source)
-- 	local source = vRP.getUserSource(user_id)
-- 	local nplayer = vRP.getUserSource(target)
-- 	local identity = vRP.getUserIdentity(user_id)

-- 	local max = vRP.getInventoryMaxWeight(target)
-- 	local weight = vRP.getInventoryWeight(target)

-- 	if (vRP.getItemWeight(itemName) * itemCount) + weight > max then
-- 		TriggerClientEvent("Notify",source,"negado","Mochila cheia.")
-- 		return
-- 	end

-- 	if vRP.tryGetInventoryItem(user_id, itemName, itemCount, true) then
-- 		vRP.giveInventoryItem(target, itemName, itemCount, true)
-- 		TriggerClientEvent("Notify",nplayer,"aviso","<b>("..user_id..") "..identity.name.." "..identity.firstname.."</b> enviou "..itemCount.."X "..vRP.getItemName(itemName)..".")
-- 	end

-- 	TriggerClientEvent("vrp.inventoryhud:refreshPlayer", target)
-- end)

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- Comandos
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- RegisterCommand("revistar", function(source)
-- 	local user_id = vRP.getUserId(source)
-- 	local nplayer = vRPclient.getNearestPlayer(source,2)
-- 	local nuser_id = vRP.getUserId(nplayer)

-- 	if nuser_id then
-- 		local identity = vRP.getUserIdentity(nuser_id)
-- 		local id = vRP.getUserIdentity(user_id)

-- 		TriggerClientEvent("vrp.inventoryhud:openPlayer",source,nuser_id,identity.name.." "..identity.firstname)
-- 		TriggerClientEvent("Notify",nplayer,"aviso","Revistado por <b>("..user_id..") "..id.name.." "..id.firstname.."</b>.")
-- 	end
-- end)

RegisterNetEvent("b03461cc:pd-inventory:sendItem")
AddEventHandler("b03461cc:pd-inventory:sendItem", function(itemName, itemCount)
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source, 1)
	local nuser_id = vRP.getUserId(nplayer)
	if nuser_id then
		if itemCount == 0 then itemCount = getItemAmount(user_id, itemName) end
		if checkWeightAmount(nuser_id, itemName, itemCount) then
			if getItemAmount(user_id, itemName) >= itemCount and itemCount > 0 then
				consumeItem(user_id, itemName, itemCount, true)
				vRPclient._playAnim(source, true, { "mp_common", "givetake1_a" }, false)
				giveItem(nuser_id, itemName, itemCount, true)
				vRPclient._playAnim(nplayer, true, { "mp_common", "givetake1_a" }, false)
				TriggerClientEvent("b03461cc:pd-inventory:updateInventory", nplayer)
			end
		else
			TriggerClientEvent("Notify", source, "negado", "O inventário da pessoa está <b>Cheio</b>.", 8000)
		end
	else
		TriggerClientEvent("Notify", source, "negado", "A pessoa está muito longe.", 8000)
	end
end)

RegisterCommand('revistar', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isInVehicle(source) or vRPclient.isHandcuffed(source) then
		return
	end
	local nplayer = vRPclient.getNearestPlayer(source, 2)
	if nplayer then
		local nuser_id = vRP.getUserId(nplayer)
		if nuser_id then

			local identity = vRP.getUserIdentity(user_id)
			local weapons = vRPclient.getWeapons(nplayer)
			local money = vRP.getMoney(nuser_id)
			local query = json.decode(vRP.query("vRP/get_inv", { user_id = nuser_id })[1].itemlist)
			if vRPclient.getHealth(nplayer) <= 101 then
				TriggerClientEvent('cancelando', source, true, true)
				vRPclient._playAnim(source, false, { "amb@medic@standing@tendtodead@idle_a", "idle_a" }, true)
				TriggerClientEvent("progress", source, 5000, "revistando")
				SetTimeout(5000, function()
					TriggerClientEvent('chatMessage', source, "", {}, "^4- -  ^5M O C H I L A^4  - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
					if query then
						for k, v in pairs(query) do
							TriggerClientEvent('chatMessage', source, "", {}, "     " .. vRP.format(parseInt(query[k].amount)) .. "x " .. itemlist[k].name)
						end
					end
					TriggerClientEvent('chatMessage', source, "", {}, "^4- -  ^5E Q U I P A D O^4  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
					for k, v in pairs(weapons) do
						if v.ammo < 1 then
							TriggerClientEvent('chatMessage', source, "", {}, "     1x " .. itemlist[string.sub(string.lower(k), 8)].name)
						else
							TriggerClientEvent('chatMessage', source, "", {}, "     1x " .. itemlist[string.sub(string.lower(k), 8)].name .. " | " .. vRP.format(parseInt(v.ammo)) .. "x Munições")
						end
					end
					vRPclient._stopAnim(source, false)
					TriggerClientEvent('cancelando', source, false, false)
					TriggerClientEvent('chatMessage', source, "", {}, "     $" .. vRP.format(parseInt(money)) .. " Dólares")
				end)
			else
				TriggerClientEvent('cancelando', source, true, true)
				TriggerClientEvent('cancelando', nplayer, true, true)
				TriggerClientEvent('carregar', nplayer, source)
				vRPclient._playAnim(source, false, { "misscarsteal4@director_grip", "end_loop_grip" }, true)
				vRPclient._playAnim(nplayer, false, { "random@mugging3", "handsup_standing_base" }, true)
				TriggerClientEvent("progress", source, 5000, "revistando")
				SetTimeout(5000, function()
					TriggerClientEvent('chatMessage', source, "", {}, "^4- -  ^5M O C H I L A^4  - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
					if #query then
						for k, v in pairs(query) do
							TriggerClientEvent('chatMessage', source, "", {}, "     " .. vRP.format(parseInt(query[k].amount)) .. "x " .. itemlist[k].name)
						end
					end
					TriggerClientEvent('chatMessage', source, "", {}, "^4- -  ^5E Q U I P A D O^4  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
					for k, v in pairs(weapons) do
						if v.ammo < 1 then
							TriggerClientEvent('chatMessage', source, "", {}, "     1x " .. itemlist[string.sub(string.lower(k), 8)].name)
						else
							TriggerClientEvent('chatMessage', source, "", {}, "     1x " .. itemlist[string.sub(string.lower(k), 8)].name .. " | " .. vRP.format(parseInt(v.ammo)) .. "x Munições")
						end
					end

					vRPclient._stopAnim(source, false)
					vRPclient._stopAnim(nplayer, false)
					TriggerClientEvent('cancelando', source, false, false)
					TriggerClientEvent('cancelando', nplayer, false, false)
					TriggerClientEvent('carregar', nplayer, source)
					TriggerClientEvent('chatMessage', source, "", {}, "     $" .. vRP.format(parseInt(money)) .. " Dólares")
				end)
			end
		end
		TriggerClientEvent("Notify", nplayer, "aviso", "Você está sendo <b>Revistado</b>.")
		--TriggerClientEvent("Notify",nplayer,"aviso","Revistado por <b>"..identity.name.." "..identity.firstname.."</b>.",8000)
	end
end)
