-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXAO
-----------------------------------------------------------------------------------------------------------------------------------------
vRPclient = Tunnel.getInterface("vRP")
vCLIENT = Tunnel.getInterface("vrp_player")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local idgens = Tools.newIDGenerator()
-----------------------------------------------------------------------------------------------------------------------------------------
-- /o
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("o", function(source, args, rawCommand)
	vCLIENT.insertObjects(source, tostring(args[1]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /job
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("job", function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local juizes = vRP.getUsersByPermission("juiz.permissao")
	local juizes_nomes = ""

	local advogados = vRP.getUsersByPermission("advogado.permissao")
	local advogados_nomes = ""

	local mecanicos = vRP.getUsersByPermission("mecanico.permissao")
	local mecanicos_nomes = ""
	if vRP.hasPermission(user_id, "admin.permissao") or vRP.hasPermission(user_id, "juiz.permissao") then
		for k, v in pairs(juizes) do
			local identity = vRP.getUserIdentity(parseInt(v))
			juizes_nomes = juizes_nomes .. " " .. v .. ": <b>" .. identity.name .. " " .. identity.firstname .. "</b><br>"
		end
		TriggerClientEvent("Notify", source, "importante", "Atualmente <b>" .. #juizes .. " Juizes</b> em serviço.<br> " .. juizes_nomes)
	end

	if vRP.hasPermission(user_id, "admin.permissao") or vRP.hasPermission(user_id, "advogado.permissao") then
		for k, v in pairs(advogados) do
			local identity = vRP.getUserIdentity(parseInt(v))
			advogados_nomes = advogados_nomes .. " " .. v .. ": <b>" .. identity.name .. " " .. identity.firstname .. "</b><br>"
		end
		TriggerClientEvent("Notify", source, "importante", "Atualmente <b>" .. #advogados .. " Advogados</b> em serviço.<br> " .. advogados_nomes)
	end

	if vRP.hasPermission(user_id, "admin.permissao") or vRP.hasPermission(user_id, "mecanico.permissao") then
		for k, v in pairs(mecanicos) do
			local identity = vRP.getUserIdentity(parseInt(v))
			mecanicos_nomes = mecanicos_nomes .. " " .. v .. ": <b>" .. identity.name .. " " .. identity.firstname .. "</b><br>"
		end
		TriggerClientEvent("Notify", source, "importante", "Atualmente <b>" .. #mecanicos .. " Mecânicos</b> em serviço.<br> " .. mecanicos_nomes)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /illegal
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("illegal", function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local roxos = vRP.getUsersByPermission("PurplePermission")
	local roxos_nomes = ""

	local amarelos = vRP.getUsersByPermission("YellowPermission")
	local amarelos_nomes = ""

	local vermelhos = vRP.getUsersByPermission("RedPermission")
	local vermelhos_nomes = ""

	local mafia = vRP.getUsersByPermission("mafia.permissao")
	local mafia_nomes = ""

	local serpentes = vRP.getUsersByPermission("serpentes.permissao")
	local serpentes_nomes = ""

	local motoclub = vRP.getUsersByPermission("motoclub.permissao")
	local motoclub_nomes = ""

	local yakuza = vRP.getUsersByPermission("yakuza.permissao")
	local yakuza_nomes = ""
	if vRP.hasPermission(user_id, "admin.permissao") then
		for k, v in pairs(roxos) do
			local identity = vRP.getUserIdentity(parseInt(v))
			roxos_nomes = roxos_nomes .. " " .. v .. ": <b>" .. identity.name .. " " .. identity.firstname .. "</b><br>"
		end
		TriggerClientEvent("Notify", source, "importante", "Atualmente <b>" .. #roxos .. " Roxos</b> em serviço.<br> " .. roxos_nomes)

		for k, v in pairs(amarelos) do
			local identity = vRP.getUserIdentity(parseInt(v))
			amarelos_nomes = amarelos_nomes .. " " .. v .. ": <b>" .. identity.name .. " " .. identity.firstname .. "</b><br>"
		end
		TriggerClientEvent("Notify", source, "importante", "Atualmente <b>" .. #amarelos .. " Amarelos</b> em serviço.<br> " .. amarelos_nomes)

		for k, v in pairs(vermelhos) do
			local identity = vRP.getUserIdentity(parseInt(v))
			vermelhos_nomes = vermelhos_nomes .. " " .. v .. ": <b>" .. identity.name .. " " .. identity.firstname .. "</b><br>"
		end
		TriggerClientEvent("Notify", source, "importante", "Atualmente <b>" .. #vermelhos .. " Vermelhos</b> em serviço.<br> " .. vermelhos_nomes)

		for k, v in pairs(mafia) do
			local identity = vRP.getUserIdentity(parseInt(v))
			mafia_nomes = mafia_nomes .. " " .. v .. ": <b>" .. identity.name .. " " .. identity.firstname .. "</b><br>"
		end
		TriggerClientEvent("Notify", source, "importante", "Atualmente <b>" .. #mafia .. " Serpentes</b> em serviço.<br> " .. mafia_nomes)

		for k, v in pairs(serpentes) do
			local identity = vRP.getUserIdentity(parseInt(v))
			serpentes_nomes = serpentes_nomes .. " " .. v .. ": <b>" .. identity.name .. " " .. identity.firstname .. "</b><br>"
		end
		TriggerClientEvent("Notify", source, "importante", "Atualmente <b>" .. #serpentes .. " Serpentes</b> em serviço.<br> " .. serpentes_nomes)

		for k, v in pairs(motoclub) do
			local identity = vRP.getUserIdentity(parseInt(v))
			motoclub_nomes = motoclub_nomes .. " " .. v .. ": <b>" .. identity.name .. " " .. identity.firstname .. "</b><br>"
		end
		TriggerClientEvent("Notify", source, "importante", "Atualmente <b>" .. #motoclub .. " Motoclub</b> em serviço.<br> " .. motoclub_nomes)

		for k, v in pairs(yakuza) do
			local identity = vRP.getUserIdentity(parseInt(v))
			yakuza_nomes = yakuza_nomes .. " " .. v .. ": <b>" .. identity.name .. " " .. identity.firstname .. "</b><br>"
		end
		TriggerClientEvent("Notify", source, "importante", "Atualmente <b>" .. #yakuza .. " Yakuza</b> em serviço.<br> " .. yakuza_nomes)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /informante
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("informante", function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local policiais = vRP.getUsersByPermission("policia.permissao")
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRPclient.checkDistance(source, -69.88, -1230.79, 28.95, 1.5) then
		if exports["pd-inventory"]:consumeItem(user_id, "dinheirosujo", 5000, true) then
			TriggerClientEvent("Notify", source, "sucesso", "Você pagou <b>$5.000 dólares sujos</b>, pelas informações dos policiais.")
			TriggerClientEvent("Notify", source, "importante", "Atualmente <b>" .. #policiais .. " Policiais</b> em serviço.<br>")
		else
			TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /invasao
-----------------------------------------------------------------------------------------------------------------------------------------
local guetos = {}
RegisterCommand("invasao", function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local uplayer = vRP.getUserSource(user_id)
	local x, y, z = vRPclient.getPosition(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if vRP.hasPermission(user_id, "PurplePermission") or vRP.hasPermission(user_id, "marabuntas.permissao") or vRP.hasPermission(user_id, "RedPermission") or vRP.hasPermission(user_id, "YellowPermission") then
		local policia = vRP.getUsersByPermission("policia.permissao")
		for l, w in pairs(policia) do
			local player = vRP.getUserSource(parseInt(w))
			if player and player ~= uplayer then
				async(function()
					local id = idgens:gen()
					if vRP.hasPermission(user_id, "PurplePermission") then
						guetos[id] = vRPclient.addBlip(player, x, y, z, 437, 27, "Localização da invasão", 0.8, false)
						TriggerClientEvent("Notify", player, "negado", "Localização da invasão entre gangues recebida de <b>Ballas</b>.")
					elseif vRP.hasPermission(user_id, "YellowPermission") then
						guetos[id] = vRPclient.addBlip(player, x, y, z, 437, 46, "Localização da invasão", 0.8, false)
						TriggerClientEvent("Notify", player, "negado", "Localização da invasão entre gangues recebida de <b>Vagos</b>.")
					elseif vRP.hasPermission(user_id, "RedPermission") then
						guetos[id] = vRPclient.addBlip(player, x, y, z, 437, 25, "Localização da invasão", 0.8, false)
						TriggerClientEvent("Notify", player, "negado", "Localização da invasão entre gangues recebida de <b>Families</b>.")
					elseif vRP.hasPermission(user_id, "marabuntas.permissao") then
						guetos[id] = vRPclient.addBlip(player, x, y, z, 437, 38, "Localização da invasão", 0.8, false)
						TriggerClientEvent("Notify", player, "negado", "Localização da invasão entre gangues recebida de <b>Marabuntas</b>.")
					end
					vRPclient._playSound(player, "5s_To_Event_Start_Countdown", "GTAO_FM_Events_Soundset")
					vRPclient._playSound(source, "5s_To_Event_Start_Countdown", "GTAO_FM_Events_Soundset")
					SetTimeout(60000, function() vRPclient.removeBlip(player, guetos[id]) idgens:free(id) end)
				end)
			end
		end
		TriggerClientEvent("Notify", source, "sucesso", "Localização enviada com sucesso.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /id
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('id', function(source, rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source, 2)
	local nuser_id = vRP.getUserId(nplayer)
	if nuser_id then
		local identity = vRP.getUserIdentity(nuser_id)
		vRPclient.setDiv(source, "completerg", ".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 8%; right: 2.5%; position: absolute; border: 1px solid rgba(255,255,255,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #d1257d; }", "<div class=\"local\"><b>Passaporte:</b> ( " .. vRP.format(identity.user_id) .. " )</div>")
		if not vRP.hasPermission(user_id, "admin.permissao") and not vRP.hasPermission(user_id, "suporte.permissao") then
			TriggerClientEvent("Notify", nplayer, "importante", "Seu passaporte está sendo <b>Verificado</b>.")
		end
		vRP.request(source, "Você deseja fechar o registro geral ?", 1000)
		vRPclient.removeDiv(source, "completerg")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /debug
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('debug', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isInVehicle(source) or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if user_id and vRPclient.getHealth(source) >= 300 then
		local data = vRP.getUserDataTable(user_id)
		local x, y, z = vRPclient.getPosition(source)
		if data then
			vRPclient._setCustomization(source, data.customization)
			--TriggerClientEvent("syncarea",-1,x,y,z,2)
		end
	end
	TriggerClientEvent("debug:nui", source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SALÁRIO
-----------------------------------------------------------------------------------------------------------------------------------------
local salarios = {
	{ ['permissao'] = "ouro.permissao", ['payment'] = 2500 },
	{ ['permissao'] = "platina.permissao", ['payment'] = 4000 },
	{ ['permissao'] = "policia.permissao", ['payment'] = 3000 },
	{ ['permissao'] = "acaopolicia.permissao", ['payment'] = 1250 },
	{ ['permissao'] = "paramedico.permissao", ['payment'] = 3000 },
	{ ['permissao'] = "mecanico.permissao", ['payment'] = 1000 },
	{ ['permissao'] = "juiz.permissao", ['payment'] = 7500 },
	{ ['permissao'] = "advogado.permissao", ['payment'] = 3000 }
}

RegisterServerEvent("vrp_player:salaryPayment")
AddEventHandler("vrp_player:salaryPayment", function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k, v in pairs(salarios) do
			if vRP.hasPermission(user_id, v.permissao) then
				local maxpayment = 7500
				if v.permissao == "policia.permissao" then
					local amount = v.payment
					local promotion = vRP.getUData(parseInt(user_id), "vRP:PolicePromotion")
					local bonus = 500
					if parseInt(promotion) ~= 0 or parseInt(promotion) ~= nil then
						for x = 1, parseInt(promotion) do
							amount = amount + bonus
						end
					end
					if amount >= maxpayment then
						amount = maxpayment
					end
					vRP.giveBankMoney(user_id, parseInt(amount), true)
					TriggerClientEvent("vrp_sound:source", source, 'coins', 0.5)
					--TriggerClientEvent("Notify",source,"importante","Obrigado por colaborar com a cidade, seu salario de <b>$"..vRP.format(parseInt(amount)).." dólares</b> foi depositado.")
				elseif v.permissao == "paramedico.permissao" then
					local amount = v.payment
					local promotion = vRP.getUData(parseInt(user_id), "vRP:ParamedicPromotion")
					local bonus = 500
					if parseInt(promotion) ~= 0 or parseInt(promotion) ~= nil then
						for x = 1, parseInt(promotion) do
							amount = amount + bonus
						end
					end
					if amount >= maxpayment then
						amount = maxpayment
					end
					vRP.giveBankMoney(user_id, parseInt(amount), true)
					TriggerClientEvent("vrp_sound:source", source, 'coins', 0.5)
					--TriggerClientEvent("Notify",source,"importante","Obrigado por colaborar com a cidade, seu salario de <b>$"..vRP.format(parseInt(amount)).." dólares</b> foi depositado.")
				end
				if v.permissao ~= "policia.permissao" and v.permissao ~= "paramedico.permissao" then
					vRP.giveBankMoney(user_id, parseInt(v.payment), true)
					TriggerClientEvent("vrp_sound:source", source, 'coins', 0.5)
					--TriggerClientEvent("Notify",source,"importante","Obrigado por colaborar com a cidade, seu salario de <b>$"..vRP.format(parseInt(v.payment)).." dólares</b> foi depositado.")
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOCARJACK
-----------------------------------------------------------------------------------------------------------------------------------------
--[[local veiculos = {}
RegisterServerEvent("TryDoorsEveryone")
AddEventHandler("TryDoorsEveryone",function(veh,doors,placa)
	if not veiculos[placa] then
		TriggerClientEvent("SyncDoorsEveryone",-1,veh,doors)
		veiculos[placa] = true
	end
end)]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- AFKSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("kickAFK")
AddEventHandler("kickAFK", function()
	local source = source
	local user_id = vRP.getUserId(source)
	if not vRP.hasPermission(user_id, "admin.permissao") then
		DropPlayer(source, "Voce foi desconectado por ficar ausente.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PINGSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterServerEvent("kickPing")
AddEventHandler("kickPing",function()
	local source = source
	local user_id = vRP.getUserId(source)
	ping = GetPlayerPing(source)
	if ping >= 350 then
		DropPlayer(source,"Voce foi desconectado por causa do seu ping (Limite: 350ms. Seu Ping: "..ping.."ms)")
	end
end)]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARTY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('party', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id, "admin.permissao") or vRP.hasPermission(user_id, "disneynews.permissao") then
		local identity = vRP.getUserIdentity(user_id)
		local mensagem = vRP.prompt(source, "Mensagem:", "")
		if mensagem == "" then
			return
		end
		vRPclient.setDiv(-1, "party", "@keyframes blinking { 0%{ background-color: #ff3d50; opacity: 0.8; } 25%{ background-color: #d22d99; opacity: 0.8; } 50%{ background-color: #55d66b; opacity: 0.8; } 75%{ background-color: #22e5e0; opacity: 0.8; } 100%{ background-color: #222291; opacity: 0.8; }  } .div_party { font-size: 11px; font-family: arial; color: rgba(255,255,255,1); padding: 20px; bottom: 30%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; animation: blinking 1s infinite; } bold { font-size: 16px; }", "<bold>" .. mensagem .. "</bold><br><br>Mensagem enviada por: " .. identity.name .. " " .. identity.firstname)
		SetTimeout(25000, function()
			vRPclient.removeDiv(-1, "party")
		end)
	else
		if vRP.request(source, "Deseja pagar <b>$10.000 dólares</b> para anunciar sua festa ?", 30) then
			local identity = vRP.getUserIdentity(user_id)
			local mensagem = vRP.prompt(source, "Mensagem:", "")
			if mensagem == "" then
				return
			end
			vRP.tryFullPayment(user_id, 10000)
			TriggerClientEvent("Notify", source, "sucesso", "Você pagou <b>$10.000 dólares</b> pelo anuncio de sua festa.")
			vRPclient.setDiv(-1, "party", "@keyframes blinking { 0%{ background-color: #ff3d50; opacity: 0.8; } 25%{ background-color: #d22d99; opacity: 0.8; } 50%{ background-color: #55d66b; opacity: 0.8; } 75%{ background-color: #22e5e0; opacity: 0.8; } 100%{ background-color: #222291; opacity: 0.8; }  } .div_party { font-size: 11px; font-family: arial; color: rgba(255,255,255,1); padding: 20px; bottom: 30%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; animation: blinking 1s infinite; } bold { font-size: 16px; }", "<bold>" .. mensagem .. "</bold><br><br>Mensagem enviada por: " .. identity.name .. " " .. identity.firstname)
			SetTimeout(25000, function()
				vRPclient.removeDiv(-1, "party")
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /sequestro
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('sequestro', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source, 5)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isInVehicle(source) or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if nplayer then
		if vRPclient.isHandcuffed(nplayer) then
			if not vRPclient.getNoCarro(source) then
				local vehicle = vRPclient.getNearestVehicle(source, 7)
				if vehicle then
					if vRPclient.getCarroClass(source, vehicle) then
						vRPclient.setMalas(nplayer)
					end
				end
			elseif vRPclient.isMalas(nplayer) then
				vRPclient.setMalas(nplayer)
			end
		else
			TriggerClientEvent("Notify", source, "aviso", "A pessoa precisa estar algemada para colocar ou retirar do Porta-Malas.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /enviar
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('enviar', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source, 2)
	local nuser_id = vRP.getUserId(nplayer)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if nuser_id and parseInt(args[1]) > 0 then
		if vRP.tryPayment(user_id, parseInt(args[1]), true) then
			vRP.giveMoney(nuser_id, parseInt(args[1]), true)
			vRPclient._playAnim(source, true, { "mp_common", "givetake1_a" }, false)
			vRPclient._playAnim(nplayer, true, { "mp_common", "givetake1_a" }, false)
		else
			TriggerClientEvent("Notify", source, "negado", "Não tem a quantia que deseja enviar.", 8000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /garmas
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('garmas', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if user_id then
		if vRP.request(source, "Deseja guardar todo o seu armamento ?", 30) then
			local weapons = vRPclient.replaceWeapons(source, {})
			local ammo
			for k, v in pairs(weapons) do
				exports["pd-inventory"]:giveItem(user_id, string.sub(string.lower(k), 8), 1, true)
				if v.ammo > 0 then
					ammo = "ammo_" .. string.sub(string.lower(k), 8)
					exports["pd-inventory"]:giveItem(user_id, ammo, v.ammo, true, "Recebeu", true)
				end
			end
			TriggerClientEvent("Notify", source, "sucesso", "Guardou seu armamento na mochila.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /roubar
-----------------------------------------------------------------------------------------------------------------------------------------
local policeitems = {
	["combatpistol"] = true,
	["ammo_combatpistol"] = true,
	["stungun"] = true,
	["ammo_stungun"] = true,
	["nightstick"] = true,
	["flashlight"] = true,
	["fireextinguisher"] = true,
	["ammo_fireextinguisher"] = true,
	["revolver_mk2"] = true,
	["ammo_revolver_mk2"] = true,
	["smg"] = true,
	["ammo_smg"] = true,
	["combatpdw"] = true,
	["ammo_combatpdw"] = true,
	["pumpshotgun_mk2"] = true,
	["ammo_pumpshotgun_mk2"] = true,
	["carbinerifle"] = true,
	["ammo_carbinerifle"] = true,
	["bzgas"] = true
}

RegisterCommand('roubar', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source, 2)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isInVehicle(source) or vRPclient.isHandcuffed(source) then --or -- vRP.searchReturn(source,user_id) then
		return
	end
	if nplayer then
		local nuser_id = vRP.getUserId(nplayer)
		local policeService = vRP.getUsersByPermission("policia.permissao")
		local policeAction = vRP.getUsersByPermission("acaopolicia.permissao")
		if #policeService >= 1 or #policeAction >= 1 then
			--if vRP.request(nplayer,"Você está sendo roubado, deseja passar tudo ?",30) then
			local vida = vRPclient.getHealth(nplayer)
			if vida <= 101 then
				TriggerClientEvent('cancelando', source, true, true)
				vRPclient._playAnim(source, false, { "amb@medic@standing@tendtodead@idle_a", "idle_a" }, true)
				TriggerClientEvent("progress", source, 15000, "roubando")
				SetTimeout(15000, function()
					local weapons = vRPclient.replaceWeapons(nplayer, {})
					local ammo
					for k, v in pairs(weapons) do
						exports["pd-inventory"]:giveItem(nuser_id, string.sub(string.lower(k), 8), 1, true)
						if v.ammo > 0 then
							ammo = "ammo_" .. string.sub(string.lower(k), 8)
							exports["pd-inventory"]:giveItem(nuser_id, ammo, v.ammo, true)
						end
					end
					local query = vRP.query("pd-getInv", { user_id = nuser_id })
					local ndata = json.decode(query[1].itemlist)
					if ndata ~= nil then
						for k, v in pairs(ndata) do
							if not policeitems[k] then
								if exports["pd-inventory"]:checkWeightAmount(user_id, k, v.amount) then
									exports["pd-inventory"]:consumeItem(nuser_id, k, v.amount, true)
									exports["pd-inventory"]:giveItem(user_id, k, v.amount, true)
								end
							end
						end
					end
					local nmoney = vRP.getMoney(nuser_id)
					if vRP.tryPayment(nuser_id, nmoney) then
						vRP.giveMoney(user_id, nmoney)
					end
					vRP.searchTimer(user_id, parseInt(120))
					vRPclient.stopAnim(source, false)
					TriggerClientEvent('cancelando', source, false, false)
					TriggerClientEvent("Notify", source, "sucesso", "Roubo concluido com sucesso.")
				end)
			else
				if vRP.request(nplayer, "Você está sendo roubado, deseja passar tudo ?", 30) then
					TriggerClientEvent('cancelando', source, true, true)
					vRPclient._playAnim(source, false, { "oddjobs@shop_robbery@rob_till", "loop" }, true)
					vRPclient._playAnim(nplayer, false, { "random@mugging3", "handsup_standing_base" }, true)
					TriggerClientEvent("progress", source, 15000, "roubando")
					SetTimeout(15000, function()
						local weapons = vRPclient.replaceWeapons(nplayer, {})
						local ammo
						for k, v in pairs(weapons) do
							exports["pd-inventory"]:giveItem(nuser_id, string.sub(string.lower(k), 8), 1, true)
							if v.ammo > 0 then
								ammo = "ammo_" .. string.sub(string.lower(k), 8)
								exports["pd-inventory"]:giveItem(nuser_id, ammo, v.ammo, true)
							end
						end
						local query = vRP.query("pd-getInv", { user_id = nuser_id })
						local ndata = json.decode(query[1].itemlist)
						if ndata ~= nil then
							for k, v in pairs(ndata) do
								if not policeitems[k] then
									if exports["pd-inventory"]:checkWeightAmount(user_id, k, v.amount) then
										exports["pd-inventory"]:consumeItem(nuser_id, k, v.amount, true)
										exports["pd-inventory"]:giveItem(user_id, k, v.amount, true)
									end
								end
							end
						end
						local nmoney = vRP.getMoney(nuser_id)
						if vRP.tryPayment(nuser_id, nmoney) then
							vRP.giveMoney(user_id, nmoney)
						end
						vRP.searchTimer(user_id, parseInt(120))
						vRPclient.stopAnim(source, false)
						vRPclient.stopAnim(nplayer, false)
						TriggerClientEvent('cancelando', source, false)
						TriggerClientEvent('cancelando', nplayer, false)
						TriggerClientEvent("Notify", source, "sucesso", "Roubo concluido com sucesso.")
					end)
				else
					TriggerClientEvent("Notify", source, "importante", "A pessoa está resistindo ao roubo.")
				end
			end
			--else
			--TriggerClientEvent("Notify",source,"importante","A pessoa está resistindo ao roubo.")
			--end
		else
			TriggerClientEvent("Notify", source, "aviso", "Número insuficiente de policiais no momento.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUBMITCALLER
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
RegisterServerEvent("submitCaller")
AddEventHandler("submitCaller", function(number, message)
	local source = source
	local answered = false
	local user_id = vRP.getUserId(source)
	local uplayer = vRP.getUserSource(user_id)
	if user_id then
		local x, y, z = vRPclient.getPosition(source)
		local players = {}
		vRPclient._DeletarObjeto(source)
		if number == "policia" then
			players = vRP.getUsersByPermission("policia.permissao")
		elseif number == "paramedico" then
			players = vRP.getUsersByPermission("paramedico.permissao")
			if #players == 0 then
				TriggerClientEvent("Notify", source, "importante", "Atualmente não há <b>Paramédicos</b> em serviço.")
				return true
			end
		elseif number == "mecanico" then
			players = vRP.getUsersByPermission("mecanico.permissao")
			if #players == 0 then
				TriggerClientEvent("Notify", source, "importante", "Atualmente não há <b>Mecânicos</b> em serviço.")
				return true
			end
		elseif number == "taxista" then
			players = vRP.getUsersByPermission("taxista.permissao")
			if #players == 0 then
				TriggerClientEvent("Notify", source, "importante", "Atualmente não há <b>Taxistas</b> em serviço.")
				return true
			end
		elseif number == "juiz" then
			players = vRP.getUsersByPermission("juiz.permissao")
			if #players == 0 then
				TriggerClientEvent("Notify", source, "importante", "Atualmente não há <b>Juizes</b> em serviço.")
				return true
			end
		elseif number == "advogado" then
			players = vRP.getUsersByPermission("advogado.permissao")
			if #players == 0 then
				TriggerClientEvent("Notify", source, "importante", "Atualmente não há <b>Advogados</b> em serviço.")
				return true
			end
		elseif number == "css" then
			players = vRP.getUsersByPermission("conce.permissao")
			if #players == 0 then
				TriggerClientEvent("Notify", source, "importante", "Atualmente não há <b>Vendedores</b> em serviço.")
				return true
			end
		elseif number == "taxiaereo" then
			players = vRP.getUsersByPermission("fedex.permissao")
			if #players == 0 then
				TriggerClientEvent("Notify", source, "importante", "Atualmente não há <b>Pilotos</b> em serviço.")
				return true
			end
		end
		local identitys = vRP.getUserIdentity(user_id)
		TriggerClientEvent("Notify", source, "sucesso", "Chamado enviado com sucesso.")
		vRPclient.playSound(source, "Event_Message_Purple", "GTAO_FM_Events_Soundset")
		for l, w in pairs(players) do
			local player = vRP.getUserSource(parseInt(w))
			local nuser_id = vRP.getUserId(player)
			if player and player ~= uplayer then
				async(function()
					vRPclient.playSound(player, "Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds")
					TriggerClientEvent('chatMessage', player, "CHAMADO", { 19, 197, 43 }, "Enviado por ^1" .. identitys.name .. " " .. identitys.firstname .. "^0, " .. message)
					local ok = vRP.request(player, "Aceitar o chamado de <b>" .. identitys.name .. " " .. identitys.firstname .. "</b> ?", 30)
					if ok then
						if not answered then
							answered = true
							local identity = vRP.getUserIdentity(nuser_id)
							TriggerClientEvent("Notify", source, "importante", "Chamado atendido por <b>" .. identity.name .. " " .. identity.firstname .. "</b>, aguarde no local.")
							vRPclient.playSound(source, "Event_Message_Purple", "GTAO_FM_Events_Soundset")
							vRPclient._setGPS(player, x, y)
						else
							TriggerClientEvent("Notify", player, "importante", "Chamado ja foi atendido por outra pessoa.")
							vRPclient.playSound(player, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET")
						end
					end
					local id = idgens:gen()
					blips[id] = vRPclient.addBlip(player, x, y, z, 358, 71, "Chamado", 0.6, false)
					SetTimeout(300000, function() vRPclient.removeBlip(player, blips[id]) idgens:free(id) end)
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYTOW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trytow")
AddEventHandler("trytow", function(nveh, rveh)
	TriggerClientEvent("synctow", -1, nveh, rveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trytrunk")
AddEventHandler("trytrunk", function(nveh)
	TriggerClientEvent("synctrunk", -1, nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trywins")
AddEventHandler("trywins", function(nveh)
	TriggerClientEvent("syncwins", -1, nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryhood")
AddEventHandler("tryhood", function(nveh)
	TriggerClientEvent("synchood", -1, nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydoors")
AddEventHandler("trydoors", function(nveh, door)
	TriggerClientEvent("syncdoors", -1, nveh, door)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /mec
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mec', function(source, args, rawCommand)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id, "mecanico.permissao") then
			if user_id then
				TriggerClientEvent('chatMessage', -1, "DL SportRace - ^1" .. identity.name .. " " .. identity.firstname, { 255, 128, 0 }, rawCommand:sub(4))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /mr
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mr', function(source, args, rawCommand)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id, "mecanico.permissao") then
			local mecanico = vRP.getUsersByPermission("mecanico.permissao")
			for l, w in pairs(mecanico) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage', player, identity.name .. " " .. identity.firstname, { 255, 191, 128 }, rawCommand:sub(3))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /dn
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dn', function(source, args, rawCommand)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id, "disneynews.permissao") then
			local disneynews = vRP.getUsersByPermission("disneynews.permissao")
			for l, w in pairs(disneynews) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage', player, identity.name .. " " .. identity.firstname, { 255, 102, 102 }, rawCommand:sub(3))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /me
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('ChatMe')
AddEventHandler('ChatMe', function(text)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if user_id then
		local players = vRPclient.getNearestPlayers(source, 10)
		TriggerClientEvent('DisplayMe', source, text, source)
		for k, v in pairs(players) do
			TriggerClientEvent('DisplayMe', k, text, source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /roll
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('ChatRoll')
AddEventHandler('ChatRoll', function(text)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if user_id then
		local players = vRPclient.getNearestPlayers(source, 10)
		TriggerClientEvent('DisplayRoll', source, text, source)
		for k, v in pairs(players) do
			TriggerClientEvent('DisplayRoll', k, text, source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /card
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('card', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if user_id then
		local cd = math.random(1, 13)
		local naipe = math.random(1, 4)
		local players = vRPclient.getNearestPlayers(source, 10)
		TriggerClientEvent('CartasMe', source, source, identity.name, cd, naipe)
		for k, v in pairs(players) do
			TriggerClientEvent('CartasMe', k, source, identity.name, cd, naipe)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /mascara
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mascara', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id, "roupas") >= 1 then
			TriggerClientEvent("setmascara", source, args[1], args[2])
		else
			TriggerClientEvent("Notify", source, "negado", "Você não possui <b>Roupas Secundárias</b> na mochila.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /blusa
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand('blusa',function(source,args,rawCommand)
-- 	local user_id = vRP.getUserId(source)
-- 	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
-- 		return
-- 	end
-- 	if user_id then
-- 		if exports["pd-inventory"]:getItemAmount(user_id,"roupas") >= 1 then
-- 			TriggerClientEvent("setblusa",source,args[1],args[2])
-- 		else
-- 			TriggerClientEvent("Notify",source,"negado","Você não possui <b>Roupas Secundárias</b> na mochila.")
-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /colete
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('colete', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if user_id then
		if not args[1] and not args[2] then
			if vRPclient.getArmour(source) >= 90 then
				vRPclient._playAnim(source, true, { "clothingshirt", "try_shirt_positive_d" }, false)
				Wait(2500)
				vRPclient.setArmour(source, 0)
				exports["pd-inventory"]:giveItem(user_id, "colete", 1, true, "Guardou", true)
				TriggerClientEvent("removeColeteUser", source)
			end
		else
			if vRPclient.getArmour(source) >= 1 then
				TriggerClientEvent("setColeteUser", source, args[1], args[2])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /jaqueta
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand('jaqueta',function(source,args,rawCommand)
-- 	local user_id = vRP.getUserId(source)
-- 	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
-- 		return
-- 	end
-- 	if user_id then
-- 		if exports["pd-inventory"]:getItemAmount(user_id,"roupas") >= 1 then
-- 			TriggerClientEvent("setjaqueta",source,args[1],args[2])
-- 		else
-- 			TriggerClientEvent("Notify",source,"negado","Você não possui <b>Roupas Secundárias</b> na mochila.")
-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /maos
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('maos', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id, "roupas") >= 1 then
			TriggerClientEvent("setmaos", source, args[1], args[2])
		else
			TriggerClientEvent("Notify", source, "negado", "Você não possui <b>Roupas Secundárias</b> na mochila.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /maose
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('maose', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id, "roupas") >= 1 then
			TriggerClientEvent("setmaose", source, args[1], args[2])
		else
			TriggerClientEvent("Notify", source, "negado", "Você não possui <b>Roupas Secundárias</b> na mochila.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /maosd
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('maosd', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id, "roupas") >= 1 then
			TriggerClientEvent("setmaosd", source, args[1], args[2])
		else
			TriggerClientEvent("Notify", source, "negado", "Você não possui <b>Roupas Secundárias</b> na mochila.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /calca
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand('calca',function(source,args,rawCommand)
-- 	local user_id = vRP.getUserId(source)
-- 	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
-- 		return
-- 	end
-- 	if user_id then
-- 		if exports["pd-inventory"]:getItemAmount(user_id,"roupas") >= 1 then
-- 			TriggerClientEvent("setcalca",source,args[1],args[2])
-- 		else
-- 			TriggerClientEvent("Notify",source,"negado","Você não possui <b>Roupas Secundárias</b> na mochila.")
-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /acessorios
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('acessorios', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id, "roupas") >= 1 then
			TriggerClientEvent("setacessorios", source, args[1], args[2])
		else
			TriggerClientEvent("Notify", source, "negado", "Você não possui <b>Roupas Secundárias</b> na mochila.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /sapatos
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand('sapatos',function(source,args,rawCommand)
-- 	local user_id = vRP.getUserId(source)
-- 	if vRPclient.getHealth(source) <= 101 or vRPclient.isInVehicle(source) or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
-- 		return
-- 	end
-- 	if user_id then
-- 		if exports["pd-inventory"]:getItemAmount(user_id,"roupas") >= 1 then
-- 			TriggerClientEvent("setsapatos",source,args[1],args[2])
-- 		else
-- 			TriggerClientEvent("Notify",source,"negado","Você não possui <b>Roupas Secundárias</b> na mochila.")
-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /chapeu
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('chapeu', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id, "roupas") >= 1 and args[1] ~= 39 then
			TriggerClientEvent("setchapeu", source, args[1], args[2])
		else
			TriggerClientEvent("Notify", source, "negado", "Você não possui <b>Roupas Secundárias</b> na mochila.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /oculos
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('oculos', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id, "roupas") >= 1 then
			TriggerClientEvent("setoculos", source, args[1], args[2])
		else
			TriggerClientEvent("Notify", source, "negado", "Você não possui <b>Roupas Secundárias</b> na mochila.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /roupas
-----------------------------------------------------------------------------------------------------------------------------------------
local roupas = {
	["mecanico"] = {
		["male"] = { -1, 0, -1, 0, 109, 0, 19, 0, 59, 9, 89, 0, 25, 0, 0, 0, -1, 0, -1, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 },
		["female"] = { -1, 0, -1, 0, -1, 0, 44, 0, 61, 9, 54, 0, 66, 3, 73, 0, -1, 0, -1, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 }
	},
	["piloto"] = {
		["male"] = { -1, 0, -1, 0, 10, 2, 11, 0, 13, 0, 15, 0, 10, 0, 13, 0, 0, 0, -1, 0, 113, 1, 5, 0, -1, -1, -1, -1, -1, -1 },
		["female"] = { -1, 0, -1, 0, 22, 0, 3, 0, 6, 0, 38, 0, 29, 0, 57, 0, -1, 0, -1, 0, 112, 1, 11, 3, -1, -1, -1, -1, -1, -1 }
	},
	["paciente"] = {
		["male"] = { 0, 0, 0, 0, 0, 0, 15, 0, 61, 0, 15, 0, 16, 0, 104, 0, 0, 0, 0, 0, -1, -1, 0, 0, -1, -1, -1, -1, -1, -1 },
		["female"] = { 0, 0, 0, 0, 0, 0, 15, 0, 57, 0, 7, 0, 5, 0, 105, 0, 0, 0, 0, 0, -1, -1, 15, 0, -1, -1, -1, -1, -1, -1 }
	},
	["pelado"] = {
		["male"] = { 121, 1, 0, 0, 0, 0, 15, 0, 72, 0, 85, 0, 34, 0, 15, 0, 0, 0, 0, 0, -1, -1, 0, 0, -1, -1, -1, -1, -1, -1 },
		["female"] = { 0, 0, 0, 0, 0, 0, 15, 0, 21, 0, 7, 0, 35, 0, 82, 0, 0, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 }
	},
}

RegisterCommand("roupas", function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local tempo = json.decode(vRP.getUData(parseInt(user_id), "vRP:prisao")) or 0
	if vRPclient.getHealth(source) <= 101 or vRPclient.getArmour(source) >= 1 or vRPclient.isInVehicle(source) or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if parseInt(tempo) >= 1 then
		TriggerClientEvent("Notify", source, "negado", "Você não pode trocar de roupas, enquanto está <b>Preso</b>.", 8000)
		return
	end
	if args[1] then
		if args[1] == "save" then
			local custom = vRPclient.getCustomPlayer(source)
			if custom then
				vRP.setUData(parseInt(user_id), "vRP:defaultVisual", json.encode(custom))
				TriggerClientEvent("Notify", source, "sucesso", "Roupas salvo com sucesso.", 8000)
			end
		elseif roupas[tostring(args[1])] then
			TriggerClientEvent("progress", source, 4000, "")
			TriggerClientEvent('cancelando', source, true, true)
			vRPclient._playAnim(source, false, { "clothingshoes", "try_shoes_positive_d" }, false)
			SetTimeout(4000, function()
				local model = vRPclient.getModelPlayer(source)
				if model == "mp_m_freemode_01" then
					TriggerClientEvent("updateRoupas", source, roupas[tostring(args[1])]["male"])
				elseif model == "mp_f_freemode_01" then
					TriggerClientEvent("updateRoupas", source, roupas[tostring(args[1])]["female"])
				end
				vRPclient.stopAnim(source, false)
				TriggerClientEvent('cancelando', source, false, false)
			end)
		end
	else
		TriggerClientEvent("progress", source, 4000, "")
		TriggerClientEvent('cancelando', source, true, true)
		vRPclient._playAnim(source, false, { "clothingshoes", "try_shoes_positive_d" }, false)
		SetTimeout(4000, function()
			local consulta = vRP.getUData(parseInt(user_id), "vRP:defaultVisual")
			local resultado = json.decode(consulta) or {}
			if resultado then
				TriggerClientEvent("updateRoupas", source, resultado)
			end
			vRPclient.stopAnim(source, false)
			TriggerClientEvent('cancelando', source, false, false)
		end)
	end
end)

RegisterCommand("roupas2", function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isInVehicle(source) or vRPclient.isHandcuffed(source) or vRP.searchReturn(source, user_id) then
		return
	end
	if vRP.hasPermission(user_id, "admin.permissao") or vRP.hasPermission(user_id, "paramedico.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source, 2)
		if nplayer then
			if args[1] then
				if roupas[tostring(args[1])] then
					local model = vRPclient.getModelPlayer(nplayer)
					if model == "mp_m_freemode_01" then
						TriggerClientEvent("updateRoupas", nplayer, roupas[tostring(args[1])]["male"])
					elseif model == "mp_f_freemode_01" then
						TriggerClientEvent("updateRoupas", nplayer, roupas[tostring(args[1])]["female"])
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /paypal
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('paypal', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if args[1] == "sacar" and parseInt(args[2]) > 0 then
			if vRP.getPaypalMoney(user_id) >= parseInt(args[2]) then
				vRP.giveBankMoney(user_id, parseInt(args[2]))
				vRP.paypalWithdraw(user_id, parseInt(args[2]))
				TriggerClientEvent("Notify", source, "sucesso", "Efetuou o saque de <b>$" .. vRP.format(parseInt(args[2])) .. " dólares</b> da sua conta paypal.", 8000)
			else
				TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente em sua conta do paypal.", 8000)
			end
		elseif args[1] == "trans" and parseInt(args[2]) > 0 and parseInt(args[3]) > 0 then
			local player = vRP.getUserSource(parseInt(args[2]))
			if player == nil then
				TriggerClientEvent("Notify", source, "aviso", "Passaporte <b>" .. vRP.format(parseInt(args[2])) .. "</b> indisponível no momento.", 8000)
				return
			end
			if vRP.request(source, "Deseja transferir <b>$" .. vRP.format(parseInt(args[3])) .. " dólares</b> para o passaporte: <b>" .. vRP.format(parseInt(args[2])) .. "</b> ?", 30) then
				local banco = vRP.getBankMoney(user_id)
				local paypal = vRP.getPaypalMoney(parseInt(args[2]))
				local identity = vRP.getUserIdentity(parseInt(args[2]))
				local identity2 = vRP.getUserIdentity(user_id)
				if banco >= parseInt(args[3]) then
					vRP.setBankMoney(user_id, parseInt(banco - args[3]))
					vRP.setPaypalMoney(parseInt(args[2]), parseInt(paypal + args[3]))
					TriggerClientEvent("Notify", source, "sucesso", "Enviou <b>$" .. vRP.format(parseInt(args[3])) .. " dólares</b> ao passaporte <b>" .. vRP.format(parseInt(args[2])) .. " " .. identity.name .. " " .. identity.firstname .. "</b>.", 8000)
					local nplayer = vRP.getUserSource(parseInt(args[2]))
					if nplayer then
						TriggerClientEvent("Notify", nplayer, "importante", "Passaporte: <b>" .. user_id .. " " .. identity2.name .. " " .. identity2.firstname .. "</b> transferiu <b>$" .. vRP.format(parseInt(args[3])) .. " dólares</b> para sua conta do paypal.", 8000)
					end
				else
					TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente.", 8000)
				end
			end
		end
	end
end)