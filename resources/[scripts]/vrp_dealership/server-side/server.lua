-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_dealership", src)
vCLIENT = Tunnel.getInterface("vrp_dealership")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local motos = {}
local carros = {}
local import = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for k, v in pairs(vRP.vehicleGlobal()) do
		if v.class == "carros" then
			table.insert(carros, { k = v.spawn, nome = v.name, price = parseInt(v.price), chest = parseInt(v.chestweight) or 50, stock = parseInt(v.stock) })
		end
		if v.class == "motos" then
			table.insert(motos, { k = v.spawn, nome = v.name, price = parseInt(v.price), chest = parseInt(v.chestweight) or 50, stock = parseInt(v.stock) })
		end
		if v.class == "import" then
			table.insert(import, { k = v.spawn, nome = v.name, price = parseInt(v.price), chest = parseInt(v.chestweight) or 50, stock = parseInt(v.stock) })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function src.updateVehicles(vname, vehtype)
	if vehtype == "carros" then
		for k, v in pairs(carros) do
			if v.k == vname then
				table.remove(carros, k)
				local data = vRP.vehicleData(vname)
				local vehicle = data.stock
				if vehicle ~= nil then
					table.insert(carros, { k = vname, nome = vRP.vehicleName(vname), price = parseInt(vRP.vehiclePrice(vname)), chest = parseInt(data.chestweight) or 50, stock = parseInt(data.stock) })
				end
			end
		end
	elseif vehtype == "motos" then
		for k, v in pairs(motos) do
			if v.k == vname then
				table.remove(motos, k)
				local data = vRP.vehicleData(vname)
				local vehicle = data.stock
				if vehicle ~= nil then
					table.insert(motos, { k = vname, nome = vRP.vehicleName(vname), price = parseInt(vRP.vehiclePrice(vname)), chest = parseInt(data.chestweight) or 50, stock = parseInt(data.stock) })
				end
			end
		end
	elseif vehtype == "import" then
		for k, v in pairs(import) do
			if v.k == vname then
				table.remove(import, k)
				local data = vRP.vehicleData(vname)
				local vehicle = data.stock
				if vehicle ~= nil then
					table.insert(import, { k = vname, nome = vRP.vehicleName(vname), price = parseInt(vRP.vehiclePrice(vname)), chest = parseInt(data.chestweight) or 50, stock = parseInt(data.stock) })
				end
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CARROS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.Carros()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return carros
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MOTOS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.Motos()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return motos
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function src.Import()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return import
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VENDAS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.Possuidos()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local veiculos = {}
		local vehicle = vRP.query("vRP/get_vehicle", { user_id = parseInt(user_id) })
		for k, v in pairs(vehicle) do
			if vRP.vehicleClass(tostring(v.vehicle)) == "carros" or vRP.vehicleClass(tostring(v.vehicle)) == "motos" or vRP.vehicleClass(tostring(v.vehicle)) == "import" then
				local bau = vRP.vehicleData(v.vehicle)
				table.insert(veiculos, { k = v.vehicle, nome = vRP.vehicleName(v.vehicle), price = parseInt(vRP.vehiclePrice(v.vehicle)), chest = parseInt(bau.chestweight) })
			end
		end
		return veiculos
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- BUYDEALER
-----------------------------------------------------------------------------------------------------------------------------------------
function src.buyDealer(name)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local value = vRP.getUData(parseInt(user_id), "vRP:multas")
		local multas = json.decode(value) or 0
		if multas > 0 then
			TriggerClientEvent("Notify", source, "negado", "Você tem multas pendentes.", 10000)
			return
		end

		local maxvehs = vRP.query("vRP/con_maxvehs", { user_id = parseInt(user_id) })
		local maxcars = vRP.query("vRP/get_users", { user_id = parseInt(user_id) })
		if vRP.hasPermission(user_id, "conce.permissao") then
			if parseInt(maxvehs[1].qtd) >= parseInt(maxcars[1].garagem) + 100 then
				TriggerClientEvent("Notify", source, "importante", "Atingiu o número máximo de veículos em sua garagem.", 8000)
				return
			end
		elseif vRP.hasPermission(user_id, "ouro.permissao") then
			if parseInt(maxvehs[1].qtd) >= parseInt(maxcars[1].garagem) + 3 then
				TriggerClientEvent("Notify", source, "importante", "Atingiu o número máximo de veículos em sua garagem.", 8000)
				return
			end
		elseif vRP.hasPermission(user_id, "platina.permissao") then
			if parseInt(maxvehs[1].qtd) >= parseInt(maxcars[1].garagem) + 6 then
				TriggerClientEvent("Notify", source, "importante", "Atingiu o número máximo de veículos em sua garagem.", 8000)
				return
			end
		else
			if parseInt(maxvehs[1].qtd) >= parseInt(maxcars[1].garagem) then
				TriggerClientEvent("Notify", source, "importante", "Atingiu o número máximo de veículos em sua garagem.", 8000)
				return
			end
		end

		local vehicle = vRP.query("vRP/get_vehicles", { user_id = parseInt(user_id), vehicle = name })
		if vehicle[1] then
			TriggerClientEvent("Notify", source, "importante", "Você já possui um <b>" .. vRP.vehicleName(name) .. "</b> em sua garagem.", 10000)
			return
		else
			local rows2 = vRP.vehicleData(name)
			if parseInt(rows2.stock) <= 0 then
				TriggerClientEvent("Notify", source, "aviso", "Estoque de <b>" .. vRP.vehicleName(name) .. "</b> indisponivel.", 8000)
				return
			end

			local tax = vRP.hasPermission(user_id, "conce.permissao") and 0.85 or 1.3
			if vRP.tryFullPayment(user_id, vRP.vehiclePrice(name) * tax) then
				vRP.execute("vRP/set_stock", { spawn = name, stock = parseInt(rows2.stock) - 1 })
				vRP.execute("vRP/add_vehicle", { user_id = parseInt(user_id), vehicle = name, ipva = parseInt(os.time()) })
				TriggerClientEvent("Notify", source, "sucesso", "Você comprou um <b>" .. vRP.vehicleName(name) .. "</b> por <b>$ " .. vRP.format(parseInt(vRP.vehiclePrice(name) * tax)) .. " dólares</b>.", 10000)
				src.updateVehicles(name, vRP.vehicleData(name).class)
				if vRP.vehicleClass(name) == "carros" then
					TriggerClientEvent('dealership:Update', source, 'updateCarros')
				elseif vRP.vehicleClass(name) == "motos" then
					TriggerClientEvent('dealership:Update', source, 'updateMotos')
				elseif vRP.vehicleClass(name) == "import" then
					TriggerClientEvent('dealership:Update', source, 'updateImport')
				end
				TriggerClientEvent("dealership:Close", source)
			else
				TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente.", 10000)
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SELLDEALER
-----------------------------------------------------------------------------------------------------------------------------------------
function src.sellDealer(name)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle = vRP.query("vRP/get_vehicles", { user_id = parseInt(user_id), vehicle = name })
		local rows2 = vRP.vehicleData(name)

		local value = vRP.getUData(parseInt(user_id), "vRP:multas")
		local multas = json.decode(value) or 0
		if multas > 0 then
			TriggerClientEvent("Notify", source, "negado", "Você tem multas pendentes.", 10000)
			return
		end

		if parseInt(os.time()) >= parseInt(vehicle[1].ipva + 24 * 15 * 60 * 60) then
			TriggerClientEvent("Notify", source, "negado", "Seu <b>Vehicle Tax</b> está atrasado.", 10000)
			return
		end

		if vehicle[1] then
			-- if vRP.vehicleClass(tostring(name)) == "exclusive" or vRP.vehicleClass(tostring(name)) == "rental" or vRP.vehicleClass(tostring(name)) == "vip" then
			-- 	TriggerClientEvent("Notify",source,"negado","<b>"..vRP.vehicleName(tostring(name)).."</b> não pode ser vendido</b>.",10000)
			-- 	return
			-- end

			local tax = vRP.hasPermission(user_id, "conce.permissao") and 0.85 or 0.7
			vRP.execute("vRP/rem_vehicle", { user_id = parseInt(user_id), vehicle = name })
			vRP.execute("vRP/rem_veh_srv_data", { dkey = "custom:u" .. parseInt(user_id) .. "veh_" .. name })
			vRP.execute("vRP/rem_veh_srv_data", { dkey = "chest:u" .. parseInt(user_id) .. "veh_" .. name })
			vRP.execute("vRP/set_stock", { spawn = name, stock = parseInt(rows2.stock) + 1 })
			vRP.giveMoney(user_id, parseInt(vRP.vehiclePrice(name) * tax))
			TriggerClientEvent("Notify", source, "sucesso", "Você vendeu um <b>" .. vRP.vehicleName(name) .. "</b> por <b>$" .. vRP.format(parseInt(vRP.vehiclePrice(name) * tax)) .. " dólares</b>.", 10000)
			src.updateVehicles(name, vRP.vehicleData(name).class)
			TriggerClientEvent('dealership:Update', source, 'updatePossuidos')
			TriggerClientEvent("dealership:Close", source)
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id, "conce.permissao")
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function src.getPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, "conce.permissao") then
			return true
		end

		-- local conce = vRP.getUsersByPermission("conce.permissao")
		-- if parseInt(#conce) >= 1 then
		-- 	TriggerClientEvent("Notify",source,"aviso","Vendedores da concessionária estão na cidade, o auto-atendimento está indisponível.",10000)
		-- 	return false
		-- end
		-- return true
	end
end
