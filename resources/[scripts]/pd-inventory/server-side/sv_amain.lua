Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

vrpServer = {}
Tunnel.bindInterface("pd-inventory", vrpServer)
idgens = Tools.newIDGenerator()
vCLIENT = Tunnel.getInterface("pd-inventory")
vGARAGE = Tunnel.getInterface("vrp_garages")
vDIAGNOSTIC = Tunnel.getInterface("vrp_diagnostic")
------------------------------------------------------------------------------------------------------------------------------------------------------
-- Shared Functions
------------------------------------------------------------------------------------------------------------------------------------------------------
function vrpServer.giveMax(user_id, var)
	local max = vRP.query("vRP/get_max_inv", { user_id = user_id })[1].max
	if var then
		vRP.execute("vRP/give_max_inv", { max = var, user_id = user_id })
	end
end

function vrpServer.getWeight()
	local source = source
	local user_id = vRP.getUserId(source)
	local weight = 0.0

	if user_id then
		local query = vRP.query("vRP/get_inv", { user_id = user_id })

		local data = json.decode(query[1].itemlist)
		for k, v in pairs(data) do
			weight = weight + (itemlist[v.item].weight * v.amount)
		end

		return weight
	end
end

function vrpServer.getInv(zone)
	local source = source
	local user_id = vRP.getUserId(source)
	local weight = 0.0


	if user_id then
		local query = vRP.query("vRP/get_inv", { user_id = user_id })
		if not query[1] then -- New User
			vRP.execute("vRP/new_inv", { user_id = user_id, itemlist = "{}", max = 6 })
			query = { [1] = { itemlist = "{}" } }
		end
		local max = vRP.query("vRP/get_max_inv", { user_id = user_id })[1].max

		local data = json.decode(query[1].itemlist)
		local res  = {}
		for k, v in pairs(data) do
			v.item   = k
			v.weight = itemlist[v.item].weight * v.amount
			v.name   = itemlist[v.item].name
			v.icon   = itemlist[v.item].icon
			v.desc   = itemlist[v.item].desc

			table.insert(res, v)

			weight = weight + (itemlist[v.item].weight * v.amount)
		end

		local x, y, z = vRPclient.getPosition(source)
		local drop = getDropList(zone, x, y, z)
		local resDrop = {}
		for k, v in pairs(drop) do
			v.item   = k
			v.weight = itemlist[v.item].weight * v.amount
			v.name   = itemlist[v.item].name
			v.icon   = itemlist[v.item].icon
			v.desc   = itemlist[v.item].desc

			table.insert(resDrop, v)
		end


		return weight, json.encode(res), json.encode(resDrop), max
	end
end

function vrpServer.getIdentity()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		local job = vRP.getUserGroupByType(user_id, "job")
		local cash = vRP.getMoney(user_id)
		local bank = vRP.getBankMoney(user_id)
		local paypal = vRP.getPaypalMoney(user_id)
		local tax = json.decode(vRP.getUData(user_id, "vRP:multas")) or 0
		local job = vRP.getUserGroupByType(user_id, "job")
		local vipName = vRP.getUserGroupByType(user_id, "vip")
		local vipTime = vRP.query("vRP/get_vip_time", { id = user_id })
		local coins = vRP.getCoins(user_id)

		if identity or (#vipTime and vipTime[1].vip_time ~= 0) then
			return identity.name, identity.firstname, identity.user_id, identity.age, identity.registration, identity.phone, vRP.format(parseInt(cash)), vRP.format(parseInt(bank)), vRP.format(parseInt(paypal)), vRP.format(parseInt(tax)), job, vipName, getDayHours(parseInt(vipTime[1].vip_time - os.time())), vRP.format(parseInt(coins))
		end
	end
end

function getDayHours(seconds)
	if seconds > 0 then
		local days = math.floor(seconds / 86400)
		seconds = seconds - days * 86400
		local hours = math.floor(seconds / 3600)

		if days > 0 then
			return string.format("%d Dias e %d Horas", days, hours)
		else
			return string.format("%d Horas", hours)
		end
	else
		return string.format("Nenhum")
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('item', function(source, args)
	local user_id = vRP.getUserId(source)

	if vRP.hasPermission(user_id, "admin.permissao") then
		if args[1] and args[2] then
			giveItem(user_id, args[1], parseInt(args[2]), true, "Recebeu", true)
			TriggerClientEvent("b03461cc:pd-inventory:updateInventory", source)
		end
	end
end)
--------------------------------------------------------------------------------------------------------------------------
-- Exports
--------------------------------------------------------------------------------------------------------------------------
function getItemAmount(user_id, item)
	local amount = 0

	local query = json.decode(vRP.query("vRP/get_inv", { user_id = user_id })[1].itemlist)
	for k, v in pairs(query) do
		if k == item then
			amount = parseInt(v.amount)
			break
		end
	end

	return amount
end

function getItemName(item)
	return itemlist[item].name
end

function consumeItem(user_id, item, amount, notify, var)
	amount = parseInt(amount)
	local source = vRP.getUserSource(user_id)
	local query = json.decode(vRP.query("vRP/get_inv", { user_id = user_id })[1].itemlist)
	for k, v in pairs(query) do
		if k == item then
			local newAmount = v.amount - amount

			if newAmount <= 0 then
				query[k] = nil
			else
				query[k].amount = newAmount
			end

			vRP.execute("vRP/update_inv", { user_id = user_id, itemlist = json.encode(query) })
			if notify then
				if var then
					TriggerClientEvent("ItemNotify", source, itemlist[item].name, itemlist[item].icon, "" .. var .. " x" .. amount)
				else
					TriggerClientEvent("ItemNotify", source, itemlist[item].name, itemlist[item].icon, "Enviou x" .. amount)
				end
			end
			return true
		end
	end
	TriggerClientEvent("Notify", source, "negado", "Não Possui <b>" .. itemlist[item].name .. " x" .. amount .. "</b>")
	return false
end

function checkWeightAmount(user_id, item, amount)
	local source = vRP.getUserSource(user_id)
	local max = vRP.query("vRP/get_max_inv", { user_id = user_id })[1].max
	local query = json.decode(vRP.query("vRP/get_inv", { user_id = user_id })[1].itemlist)
	local weight = 0.0
	if query[item] then
		query[item].amount = query[item].amount + amount
	else
		query[item] = { amount = amount }
	end

	for k, v in pairs(query) do
		weight = weight + (itemlist[k].weight * v.amount)
	end

	if weight > max then
		TriggerClientEvent("Notify", source, "negado", "<b>Inventário cheio</b>")
		return false
	else
		return true
	end
end

function checkChestWeightAmount(user_id, item, amount, max_weight, name)
	local source = vRP.getUserSource(user_id)
	local query = json.decode(vRP.getSData(name)) or {}
	local weight = 0.0
	if query[item] then
		query[item].amount = query[item].amount + amount
	else
		query[item] = { amount = amount }
	end

	for k, v in pairs(query) do
		weight = weight + (itemlist[k].weight * v.amount)
	end

	if weight > max_weight then
		TriggerClientEvent("Notify", source, "negado", "<b>Baú Cheio</b>")
		return false
	else
		return true
	end
end

function giveItem(user_id, item, amount, notify, var, police)
	amount = parseInt(amount)
	local source = vRP.getUserSource(user_id)
	if itemlist[item] then
		local weight = 0.0
		local max = vRP.query("vRP/get_max_inv", { user_id = user_id })[1].max
		local query = json.decode(vRP.query("vRP/get_inv", { user_id = user_id })[1].itemlist)

		if query[item] then
			query[item].amount = query[item].amount + amount
		else
			query[item] = { amount = amount }
		end

		if not police then
			for k, v in pairs(query) do
				weight = weight + (itemlist[k].weight * v.amount)
				if weight > max then
					TriggerClientEvent("Notify", source, "aviso", "<b>Inventário cheio</b>")
					return
				end
			end
		end

		vRP.execute("vRP/update_inv", { user_id = user_id, itemlist = json.encode(query) })
		if notify then
			if var then
				TriggerClientEvent("ItemNotify", source, itemlist[item].name, itemlist[item].icon, "" .. var .. " x" .. amount)
			else
				TriggerClientEvent("ItemNotify", source, itemlist[item].name, itemlist[item].icon, "Recebeu x" .. amount)
			end
		end
	end
end

function tableTostring(tbl)
	local result, done = {}, {}

	local function val_to_str(v)
		if "string" == type(v) then
			v = string.gsub(v, "\n", "\\n")

			if string.match(string.gsub(v, "[^'\"]", ""), '^"+$') then
				return "'" .. v .. "'"
			end

			return '"' .. string.gsub(v, '"', '\\"') .. '"'
		else
			return "table" == type(v) and tableTostring(v) or
				tostring(v)
		end
	end

	local function key_to_str(k)
		if "string" == type(k) and string.match(k, "^[_%a][_%a%d]*$") then
			return k
		else
			return "[" .. val_to_str(k) .. "]"
		end
	end

	for k, v in ipairs(tbl) do
		table.insert(result, val_to_str(v))
		done[k] = true
	end

	for k, v in pairs(tbl) do
		if not done[k] then
			table.insert(result, key_to_str(k) .. "=" .. val_to_str(v))
		end

	end
	return "{" .. table.concat(result, ",") .. "}"
end

--[[vRP.prepare("transinventory1", "SELECT dvalue FROM vrp_user_data WHERE dkey = \"vRP:datatable\" AND user_id = @user_id")
vRP.prepare("transinventory2","INSERT INTO vrp_user_inventory(user_id,itemlist,max) VALUES(@user_id,@itemlist,@max)")
vRP.prepare("transinventory3", "UPDATE vrp_user_inventory SET itemlist = @itemlist WHERE user_id = @user_id")
vRP.prepare("transinventory4", "SELECT * FROM vrp_user_inventory WHERE user_id = @user_id")
function caralho()
    for i=1,957 do
		vRP.execute("transinventory2",{ user_id = i, itemlist = "[]", max = 90 })
        local rows = vRP.query("transinventory1", { user_id = i })
		if rows[1] then
			local invNew = {}
			rows = json.decode(rows[1].dvalue)
			for k,v in pairs(rows.inventory) do
				invNew[k] = v
				if string.find(k,"wbody|WEAPON_") then
					invNew[k] = nil

					local name = string.lower(k)
					name = string.gsub(name, "wbody|weapon_","")
					print(name,v.amount)
					invNew[name] = v
				elseif string.find(k, "wammo") then
					invNew[k] = nil

					local name = string.lower(k)
					name = string.gsub(name, "wammo|weapon_","ammo_")
					print(name)
					invNew[name] = v
				elseif string.find(k,"wbody|GADGET_") then
					invNew[k] = nil

					local name = string.lower(k)
					name = string.gsub(name, "wbody|gadget_","")
					print(name,v.amount)
					invNew[name] = v
				end
			end
            vRP.execute("transinventory3", { user_id = i, itemlist = json.encode(invNew) })
        end
	end
    print("END")
end
CreateThread(function()
    caralho()
end)]]

exports("getItemAmount", getItemAmount)
exports("getItemName", getItemName)
exports("checkWeightAmount", checkWeightAmount)
exports("tblTostring", tableTostring)
exports("consumeItem", consumeItem)
exports("giveItem", giveItem)
--exports["pd-inventory"]:getItemName(
