RegisterNetEvent("b03461cc:pd-inventory:buyItem")
AddEventHandler("b03461cc:pd-inventory:buyItem", function(item, type, number)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)

	if user_id then
		if cfg.storeTypes[type] then
			if cfg.storeTypes[type].permission then
				if vRP.hasPermission(user_id, cfg.storeTypes[type].permission) then
					local price = cfg.storeTypes[type].items[item].price
					if vRP.tryPayment(user_id, price * number, true) then
						giveItem(user_id, item, number, true, "Comprou")
					else
						TriggerClientEvent("Notify", source, "aviso", "<b>Dinheiro insuficiente</b>")
					end
				else
					TriggerClientEvent("Notify", source, "aviso", "<b>Você não pode comprar nessa loja</b>")
				end
			else
				local price = cfg.storeTypes[type].items[item].price
				if string.find(type,"Illegal") then
					if checkWeightAmount(user_id, "dinheirosujo", number) then
						if getItemAmount(user_id,"dinheirosujo") >= price * number then
							consumeItem(user_id, "dinheirosujo", price * number, true, "Pagou")
							giveItem(user_id, item, number, true, "Comprou")
						else
							TriggerClientEvent("Notify", source, "aviso", "<b>Dinheiro insuficiente</b>")
						end
					end
				else
					if checkWeightAmount(user_id, item, number) then
						if vRP.tryPayment(user_id, price * number, true) then
							giveItem(user_id, item, number, true,  "Comprou")
						else
							TriggerClientEvent("Notify", source, "aviso", "<b>Dinheiro insuficiente</b>")
						end
					end
				end
			end
		end
	end
end)

RegisterNetEvent("b03461cc:pd-inventory:sellItem")
AddEventHandler("b03461cc:pd-inventory:sellItem", function(item, type, number)
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
		if cfg.storeTypes[type] and cfg.storeTypes[type].items[item] ~= nil then
			local price = cfg.storeTypes[type].items[item].price
			if string.find(type,"illegal") then
				if checkWeightAmount(user_id, "dinheirosujo", price * number) then
					if getItemAmount(user_id, item) >= number then
						giveItem(user_id, "dinheirosujo", price * number, true, "Recebeu")
						consumeItem(user_id, item, number, true, "Vendeu")
					end
				end
			else
				if getItemAmount(user_id, item) >= number then
					vRP.giveMoney(user_id,price * number, true)
					consumeItem(user_id, item, number, true,  "Vendeu")
				end
			end
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Funções
------------------------------------------------------------------------------------------------------------------------------------------------------

function vrpServer.loadShop(shop)
	local inv = {}
	local type = cfg.storeTypes[shop].items

	for k,v in pairs(type) do
		local desc = itemlist[v.item].desc or ""
		if desc ~= "" then desc = desc .. "<br>" end

		v.amount = v.amount
		v.weight = itemlist[v.item].weight
		v.icon = itemlist[v.item].icon
		v.name = itemlist[v.item].name
		v.desc = desc .. "Preço: $" .. v.price

		table.insert(inv, v)
	end

	return json.encode(inv)
end