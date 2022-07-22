RegisterNetEvent("b03461cc:pd-inventory:traficItem")
AddEventHandler("b03461cc:pd-inventory:traficItem", function(item, type, number)
    local source = source
    local user_id = vRP.getUserId(source)
    local ritem = cfg.traficTypes[type].items[item].ritem
    local amount = cfg.traficTypes[type].items[item].amount
    local ramount = cfg.traficTypes[type].items[item].ramount
    local price = cfg.traficTypes[type].items[item].price
    if user_id then
        if cfg.traficTypes[type] then
            if cfg.traficTypes[type].items[item].times == 1 then
                if getItemAmount(user_id,item) >= amount * number and getItemAmount(user_id,ritem) >= ramount * number then
                    consumeItem(user_id, item, amount * number, true, "Lavou")
                    consumeItem(user_id, ritem, ramount * number)
                    vRP.giveMoney(user_id,parseInt(amount * number)*0.95,true)
                else
                    TriggerClientEvent("Notify", source, "negado", "<b>Dinheiro Sujo</b> ou <b>Keys Invasão</b> insuficientes.")
                end
            else
                if ritem ~= 0 and ramount ~= 0 then
                    if getItemAmount(user_id, ritem) >= ramount then
                        if checkWeightAmount(user_id, item, amount) then
                            if price then 
                                if vRP.tryPayment(user_id,parseInt(price)) then
                                    consumeItem(user_id, ritem, ramount, true,  "Montou")
                                    giveItem(user_id, item, amount, true, "Recebeu")
                                else 
                                    TriggerClientEvent("Notify", source, "negado", "<b>Dinheiro Insuficiente</b>")
                                    return 
                                end 
                            else
                                consumeItem(user_id, ritem, ramount, true,  "Montou")
                                giveItem(user_id, item, amount, true, "Recebeu")
                            end
                        end
                    else
                        TriggerClientEvent("Notify", source, "negado", "Você não possui <b>"..itemlist[ritem].name.." x"..ramount.."</b>")
                    end
                else
                    if checkWeightAmount(user_id, item, amount) then
                        giveItem(user_id, item, amount, true, "Recebeu")
                    end
                end
            end
        end
    end
end)

function vrpServer.loadTrafic(craft)
	local inv = {}
    local type = cfg.traficTypes[craft].items

    for k,v in pairs(type) do
		local desc = itemlist[v.item].desc or ""
		if desc ~= "" then desc = desc .. "<br>" end

		v.amount = v.amount
		v.weight = itemlist[v.item].weight
		v.icon = itemlist[v.item].icon
		v.name = itemlist[v.item].name
		v.desc = desc .. "Montar: "..v.amount.. "<br>Necessário: "..v.ramount

		table.insert(inv, v)
	end

	return json.encode(inv)
end

function vrpServer.checkIntPermissionsTrafic(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.searchReturn(source,user_id) then
			return vRP.hasPermission(user_id,perm)
		end
	end
end