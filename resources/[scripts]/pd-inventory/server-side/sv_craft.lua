RegisterNetEvent("b03461cc:pd-inventory:craftItem")
AddEventHandler("b03461cc:pd-inventory:craftItem", function(item, type, number)
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
		if cfg.craftTypes[type] and cfg.craftTypes[type].items[item] ~= nil then
			local amount = cfg.craftTypes[type].items[item]
            if getItemAmount(user_id, item) >= 3 and item ~= item.."2" then
                if checkWeightAmount(user_id, item.."2", 3) then
                    consumeItem(user_id, item, 3, true,  "Forjou")
                    giveItem(user_id, item.."2", 1, true, "Recebeu")
                end
            end
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Funções
------------------------------------------------------------------------------------------------------------------------------------------------------

function vrpServer.loadCraft(craft)
	local inv = {}
	local type = cfg.craftTypes[craft].items

	for k,v in pairs(type) do
		local desc = itemlist[v.item].desc or ""
		if desc ~= "" then desc = desc .. "<br>" end

		v.amount = v.amount
		v.weight = itemlist[v.item].weight
		v.icon = itemlist[v.item].icon
		v.name = itemlist[v.item].name
		v.desc = desc .. "Forjar: 3" 

		table.insert(inv, v)
	end

	return json.encode(inv)
end