-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXAO
-----------------------------------------------------------------------------------------------------------------------------------------
vRPclient = Tunnel.getInterface("vRP")
vCLIENT = Tunnel.getInterface("vrp_policia")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local idgens = Tools.newIDGenerator()
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookprender = "https://discordapp.com/api/webhooks/590476415061852160/7DEwYk7ReQ_RfGwVEaOko6pPwVg7CKOnUhYoEjruDzn0rv-3AIvYaZIR2QpRFGBz80_z"
local webhookmultas = "https://discordapp.com/api/webhooks/624102579105955860/daGhq-dhXz3B9iWF1CDgPBoDBZKzeRxI_ONdkHPOkSjxaDAL8Iwwtw9zzyn7UCaEF1-j"
local webhookocorrencias = "https://discordapp.com/api/webhooks/616146265646039040/fz1LziwY2A5uoneQN5efBOmlt2uWlaviIihIuf_Ui3PlLzaR8sjI7xtUU4Z2SBNF1Hzn"
local webhookdetido = "https://discordapp.com/api/webhooks/612084569180471296/5-bxlD9bEDqH7ri8YR_IxAHM16OvhgmTV1UtS3za0JAp4HpoN4NkCpEGhGYSQZxDl_rb"
local webhookpolicia = "https://discordapp.com/api/webhooks/624333914143457300/WHmIZeCcHy0m666zp2ednPaKfbbkjDCDMalb_-cIVMbkXeix94v6eD2JvMzkuqeuY44l"
local webhookparamedico = "https://discordapp.com/api/webhooks/624334236933029900/G3WuTyWoXktdG8xvbV5YZSlGcKob4QIGiCAfbqv4RDW1EA7YdpWXDMfEOLUl_OZLZNW2"
local webhookmecanico = "https://discordapp.com/api/webhooks/615738661924765725/jKOys6iSBFWSmt2nafrF2A1_OxAig6rZUkQFb6OT-9YMpmK96myAiLCZupNTrg88i2Yn"
local webhookjuiz = "https://discordapp.com/api/webhooks/629674264466948116/MjZaCqRolmZiH3ykzt_tLGD1BhLLeWKGGzTt6BurTL_dMlr6fOCsocXvkW5wy7wcD4-Q"
local webhookadvogado = "https://discordapp.com/api/webhooks/629674340539170836/9dfmg7ffkQ7TEHou4iP9dq1UHpFRdmPa9s3GYXMPlb-sEAdNLoxiy7Qi8VXyi1o7MSZh"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- /promotion
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('promotion',function(source,args,rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
	local nuser_id = args[1]
	
    if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") then
		if args[1] and args[2] then
			if user_id == 21 or user_id == 200 then
                vRP.setUData(parseInt(nuser_id),"vRP:PolicePromotion",json.encode(parseInt(args[2])))
                TriggerClientEvent("Notify",source,"sucesso","Você promoveu o passaporte: <b>"..nuser_id.."</b> no cargo <b>"..args[2].."</b>.")
            elseif user_id == 12 or user_id == 13 then
                vRP.setUData(parseInt(nuser_id),"vRP:ParamedicPromotion",json.encode(parseInt(args[2])))
                TriggerClientEvent("Notify",source,"sucesso","Você promoveu o passaporte: <b>"..nuser_id.."</b> no cargo <b>"..args[2].."</b>.")
			end
		elseif args[1] then
			if user_id == 21 or user_id == 200 then
				local rankPolice = vRP.getUData(parseInt(nuser_id),"vRP:PolicePromotion",json.encode(parseInt(nuser_id)))
                TriggerClientEvent("Notify",source,"importante","Você olhou o passaporte: <b>"..nuser_id.."</b>: Cargo <b>"..rankPolice.."</b>.")
            elseif user_id == 12 or user_id == 13 then
				local rankParamedic = vRP.getUData(parseInt(nuser_id),"vRP:ParamedicPromotion",json.encode(parseInt(nuser_id)))
                TriggerClientEvent("Notify",source,"importante","Você olhou o passaporte: <b>"..nuser_id.."</b>: Cargo <b>"..rankParamedic.."</b>.")
			end
        end
    else
        TriggerClientEvent("Notify",source,"negado","Você não tem permissão para promover um cargo.")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WORKINGTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
local policework = {}
local paramedicwork = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(policework) do
			if v > 0 then
				policework[k] = v - 1
			else
				local workingtime = vRP.getUData(parseInt(k),"vRP:PoliceWorkTime",json.encode(parseInt(k)))
				if workingtime ~= "" then
					workingtime = workingtime + 1
					vRP.setUData(parseInt(k),"vRP:PoliceWorkTime",json.encode(parseInt(workingtime)))
				else
					vRP.setUData(parseInt(k),"vRP:PoliceWorkTime",json.encode(parseInt(1)))
				end
				policework[k] = 3600
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(paramedicwork) do
			if v > 0 then
				paramedicwork[k] = v - 1
			else
				local workingtime = vRP.getUData(parseInt(k),"vRP:ParamedicWorkTime",json.encode(parseInt(k)))
				if workingtime ~= "" then
					workingtime = workingtime + 1
					vRP.setUData(parseInt(k),"vRP:ParamedicWorkTime",json.encode(parseInt(workingtime)))
				else
					vRP.setUData(parseInt(k),"vRP:ParamedicWorkTime",json.encode(parseInt(1)))
				end
				paramedicwork[k] = 3600
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WORKING LEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			policework[user_id] = nil
		elseif vRP.hasPermission(user_id,"paramedico.permissao") then
			paramedicwork[user_id] = nil
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /workingtime
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('workingtime',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if args[1] then
		local identity = vRP.getUserIdentity(args[1])
		if user_id == 21 or user_id == 200 then
			local workingtime = vRP.getUData(parseInt(args[1]),"vRP:PoliceWorkTime",json.encode(parseInt(args[1])))
			TriggerClientEvent("Notify",source,"importante","<b>"..identity.name.." "..identity.firstname.."</b> has <b>"..workingtime.."</b> hours worked as a <b>Police Officer</b>.")
		elseif user_id == 12 or user_id == 13 then
			local workingtime = vRP.getUData(parseInt(args[1]),"vRP:ParamedicWorkTime",json.encode(parseInt(args[1])))
			TriggerClientEvent("Notify",source,"importante"," <b>"..identity.name.." "..identity.firstname.."</b> has <b>"..workingtime.."</b> hours worked as a <b>Paramedic</b>.")
		end
	else
		if vRP.hasPermission(user_id,"policia.permissao") then
			local workingtime = vRP.getUData(parseInt(user_id),"vRP:PoliceWorkTime",json.encode(parseInt(user_id)))
			TriggerClientEvent("Notify",source,"importante","You have <b>"..workingtime.."</b> hours worked as a <b>Police Officer</b>.")
		elseif vRP.hasPermission(user_id,"paramedico.permissao") then
			local workingtime = vRP.getUData(parseInt(user_id),"vRP:ParamedicWorkTime",json.encode(parseInt(user_id)))
			TriggerClientEvent("Notify",source,"importante","You have <b>"..workingtime.."</b> hours worked as a <b>Paramedic</b>.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /placa
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('placa',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"policia.permissao") then
		if args[1] then
			local user_id = vRP.getUserByRegistration(args[1])
			if user_id then
				local identity = vRP.getUserIdentity(user_id)
				local x,y,z = vRPclient.getPosition(source)
				if identity then
					TriggerClientEvent("NotifyPush",source,{ code = 28, title = "Verificando veículo", x = x, y = y, z = z, badge = identity.user_id.." "..identity.name.." "..identity.firstname.." - "..identity.age.." ("..identity.phone..")", veh = identity.registration })
				end
			else
				TriggerClientEvent("Notify",source,"importante","Placa inválida ou veículo de americano.")
			end
		else
			local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
			local placa_user = vRP.getUserByRegistration(placa)
			if placa then
				if placa_user then
					local identity = vRP.getUserIdentity(placa_user)
					local x,y,z = vRPclient.getPosition(source)
					if identity then
						TriggerClientEvent("NotifyPush",source,{ code = 28, title = "Verificando veículo", x = x, y = y, z = z, badge = identity.user_id.." "..identity.name.." "..identity.firstname.." - "..identity.age.." ("..identity.phone..")", veh = identity.registration })
					end
				else
					TriggerClientEvent("Notify",source,"importante","Placa inválida ou veículo de americano.")
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /ptr
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ptr",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local policiais = vRP.getUsersByPermission("policia.permissao")
	local policiais_nomes = ""

	local acaopoliciais = vRP.getUsersByPermission("acaopolicia.permissao")
	local acaopoliciais_nomes = ""

	local paramedicos = vRP.getUsersByPermission("paramedico.permissao")
	local paramedicos_nomes = ""
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") then
		for k,v in ipairs(policiais) do
			local identity = vRP.getUserIdentity(parseInt(v))
 			policiais_nomes = policiais_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
		end
		TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..#policiais.." Policiais</b> em serviço.<br> "..policiais_nomes)
	end

	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") then
		for k,v in ipairs(acaopoliciais) do
			local identity = vRP.getUserIdentity(parseInt(v))
 			acaopoliciais_nomes = acaopoliciais_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
		end
		TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..#acaopoliciais.." Policiais</b> em ação.<br> "..acaopoliciais_nomes)
	end

	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") then
		for k,v in ipairs(paramedicos) do
			local identity = vRP.getUserIdentity(parseInt(v))
 			paramedicos_nomes = paramedicos_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
		end
		TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..#paramedicos.." Paramédicos</b> em serviço.<br> "..paramedicos_nomes)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /p
-----------------------------------------------------------------------------------------------------------------------------------------
local policia = {}
local acaopolicia = {}
local paramedico = {}
RegisterServerEvent('DLGames:1020Police')
AddEventHandler('DLGames:1020Police',function()
	local source = source
	local user_id = vRP.getUserId(source)
	local uplayer = vRP.getUserSource(user_id)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPclient.getPosition(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"policia.permissao") then
		local policia = vRP.getUsersByPermission("policia.permissao") 
		for l,w in pairs(policia) do
			local npolicia = vRP.getUserSource(parseInt(w))
			if npolicia and npolicia ~= uplayer then
				async(function()
					local id = idgens:gen()
					policia[id] = vRPclient.addBlip(npolicia,x,y,z,153,84,"Localização de "..identity.name.." "..identity.firstname,0.5,false)
					TriggerClientEvent("Notify",npolicia,"importante","Localização recebida de <b>"..identity.name.." "..identity.firstname.."</b>.")
					vRPclient._playSound(npolicia,"Out_Of_Bounds_Timer","DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")
					SetTimeout(60000,function() vRPclient.removeBlip(npolicia,policia[id]) idgens:free(id) end)
				end)
			end
		end
		TriggerClientEvent("Notify",source,"sucesso","Localização enviada com sucesso.")
		vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
	end
	if vRP.hasPermission(user_id,"acaopolicia.permissao") then
		local acaopolicia = vRP.getUsersByPermission("acaopolicia.permissao") 
		for k,v in pairs(acaopolicia) do
			local nacaopolicia = vRP.getUserSource(parseInt(v))
			if nacaopolicia and nacaopolicia ~= uplayer then
				async(function()
					local id = idgens:gen()
					acaopolicia[id] = vRPclient.addBlip(nacaopolicia,x,y,z,153,84,"Localização de "..identity.name.." "..identity.firstname,0.5,false)
					TriggerClientEvent("Notify",nacaopolicia,"importante","Localização recebida de <b>"..identity.name.." "..identity.firstname.."</b>.")
					vRPclient._playSound(nacaopolicia,"Out_Of_Bounds_Timer","DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")
					SetTimeout(60000,function() vRPclient.removeBlip(nacaopolicia,acaopolicia[id]) idgens:free(id) end)
				end)
			end
		end
		TriggerClientEvent("Notify",source,"sucesso","Localização enviada com sucesso.")
		vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
	end
	if vRP.hasPermission(user_id,"paramedico.permissao") then
		local paramedico = vRP.getUsersByPermission("paramedico.permissao")
		for l,w in pairs(paramedico) do
			local nparamedico = vRP.getUserSource(parseInt(w))
			if nparamedico and nparamedico ~= uplayer then
				async(function()
					local id = idgens:gen()
					paramedico[id] = vRPclient.addBlip(nparamedico,x,y,z,153,61,"Localização de "..identity.name.." "..identity.firstname,0.5,false)
					TriggerClientEvent("Notify",nparamedico,"importante","Localização recebida de <b>"..identity.name.." "..identity.firstname.."</b>.")
					vRPclient._playSound(nparamedico,"Out_Of_Bounds_Timer","DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")
					SetTimeout(60000,function() vRPclient.removeBlip(nparamedico,paramedico[id]) idgens:free(id) end)
				end)
			end
		end
		TriggerClientEvent("Notify",source,"sucesso","Localização enviada com sucesso.")
		vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /911
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('911',function(source,args,rawCommand)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"juiz.permissao") or vRP.hasPermission(user_id,"advogado.permissao") then
			if user_id then
				TriggerClientEvent('chatMessage',-1,"PDL - ^1"..identity.name.." "..identity.firstname,{64,64,255},rawCommand:sub(4))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /pd
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('pd',function(source,args,rawCommand)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"policia.permissao") then
			local policiais = vRP.getUsersByPermission("policia.permissao")
			for l,w in pairs(policiais) do
				local npoliciais = vRP.getUserSource(parseInt(w))
				if npoliciais then
					async(function()
						TriggerClientEvent('chatMessage',npoliciais,identity.name.." "..identity.firstname,{64,179,255},rawCommand:sub(3))
					end)
				end
			end
		end
		--[[if vRP.hasPermission(user_id,"acaopolicia.permissao") then
			local acaopoliciais = vRP.getUsersByPermission("acaopolicia.permissao")
			for k,v in pairs(acaopoliciais) do
				local nacaopoliciais = vRP.getUserSource(parseInt(v))
				if nacaopoliciais then
					async(function()
						TriggerClientEvent('chatMessage',nacaopoliciais,identity.name.." "..identity.firstname,{255,191,128},rawCommand:sub(3))
					end)
				end
			end
		end]]
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /112
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('112',function(source,args,rawCommand)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"paramedico.permissao") then
			if user_id then
				TriggerClientEvent('chatMessage',-1,"CMDL - ^1"..identity.name.." "..identity.firstname,{255,70,135},rawCommand:sub(4))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /pr
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('pr',function(source,args,rawCommand)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"paramedico.permissao") then
			local paramedico = vRP.getUsersByPermission("paramedico.permissao")
			for l,w in pairs(paramedico) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,identity.name.." "..identity.firstname,{255,175,175},rawCommand:sub(3))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYTOW
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterCommand('paytow',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			local nuser_id = vRP.getUserId(nplayer)
			if nuser_id then
				vRP.giveMoney(nuser_id,200)
				vRPclient._playAnim(source,true,{"mp_common","givetake1_a"},false)
				vRPclient._playAnim(nplayer,true,{"mp_common","givetake1_a"},false)
				TriggerClientEvent("Notify",source,"sucesso","Efetuou o pagamento pelo serviço do mecânico.")
				TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>$200 dólares</b> pelo serviço de mecânico.")
			end
		end
	end
end)]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- /toggle
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('toggle1',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"policia.permissao") then
		TriggerEvent("vrp_sysblips:ExitService",source)
		vRP.addUserGroup(user_id,"PaisanaPolicia")
		vRPclient.giveWeapons(source,{},true)
		vRPclient.setArmour(source,0)
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[POLICIAL]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		policework[user_id] = nil
	elseif vRP.hasPermission(user_id,"paisanapolicia.permissao") then
		TriggerClientEvent("vrp_sysblips:ToggleService",source,"Policial em Serviço",47)
		vRP.addUserGroup(user_id,"Policia")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[POLICIAL]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		policework[user_id] = 3600
	elseif vRP.hasPermission(user_id,"paramedico.permissao") then
		TriggerEvent("vrp_sysblips:ExitService",source)
		vRP.addUserGroup(user_id,"PaisanaParamedico")
		vRPclient.giveWeapons(source,{},true)
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookparamedico,"```prolog\n[PARAMEDICO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		paramedicwork[user_id] = nil
	elseif vRP.hasPermission(user_id,"paisanaparamedico.permissao") and (vRPclient.checkDistance(source,312.67,-593.25,43.3,10) or vRPclient.checkDistance(source,-253.41,6333.33,32.43,10)) then
		TriggerClientEvent("vrp_sysblips:ToggleService",source,"Paramédico",61)
		vRP.addUserGroup(user_id,"Paramedico")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookparamedico,"```prolog\n[PARAMEDICO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		paramedicwork[user_id] = 3600
	elseif vRP.hasPermission(user_id,"mecanico.permissao") then
		vRP.addUserGroup(user_id,"PaisanaMecanico")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookmecanico,"```prolog\n[MECANICO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	elseif vRP.hasPermission(user_id,"paisanamecanico.permissao") and (vRPclient.checkDistance(source,953.37,-967.59,39.77,5) or vRPclient.checkDistance(source,100.99,6619.02,32.44,5)) then
		vRP.addUserGroup(user_id,"Mecanico")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookmecanico,"```prolog\n[MECANICO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	elseif vRP.hasPermission(user_id,"juiz.permissao") then
		vRP.addUserGroup(user_id,"PaisanaJuiz")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookjuiz,"```prolog\n[JUIZ]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	elseif vRP.hasPermission(user_id,"paisanajuiz.permissao") then
		vRP.addUserGroup(user_id,"Juiz")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookjuiz,"```prolog\n[JUIZ]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")	
	elseif vRP.hasPermission(user_id,"advogado.permissao") then
		vRP.addUserGroup(user_id,"PaisanaAdvogado")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		SendWebhookMessage(webhookadvogado,"```prolog\n[ADVOGADO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	elseif vRP.hasPermission(user_id,"paisanaadvogado.permissao") then
		vRP.addUserGroup(user_id,"Advogado")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
		SendWebhookMessage(webhookadvogado,"```prolog\n[ADVOGADO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")		
	--[[elseif vRP.hasPermission(user_id,"taxista.permissao") then
		vRP.addUserGroup(user_id,"PaisanaTaxista")
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
	elseif vRP.hasPermission(user_id,"paisanataxista.permissao") then
		vRP.addUserGroup(user_id,"Taxista")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")]]
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /toggle2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('toggle2',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"policia.permissao") then
		TriggerEvent("vrp_sysblips:ExitService",source)
		TriggerClientEvent("Notify",source,"aviso","Você saiu de serviço.")
		Citizen.Wait(1000)
		TriggerClientEvent("vrp_sysblips:ToggleService",source,"Policial em Ação",3)
		vRP.addUserGroup(user_id,"AcaoPolicia")
		TriggerClientEvent("Notify",source,"importante","Você entrou em <b>Ação</b>.")
		SendWebhookMessage(webhookpolicia,"```prolog\n[POLICIAL]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] \n[===========ENTROU EM ACAO===========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
	else
		if vRP.hasPermission(user_id,"acaopolicia.permissao") then
			TriggerEvent("vrp_sysblips:ExitService",source)
			TriggerClientEvent("Notify",source,"aviso","Você saiu da <b>Ação</b>.")		
			Citizen.Wait(1000)
			TriggerClientEvent("vrp_sysblips:ToggleService",source,"Policial em Serviço",47)
			vRP.addUserGroup(user_id,"Policia")
			TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
			SendWebhookMessage(webhookpolicia,"```prolog\n[POLICIAL]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[============SAIU DA ACAO============] \n[==========ENTROU EM SERVICO=========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /reanimar
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('reanimar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") then
		TriggerClientEvent('reanimar',source)
	end
end)

RegisterServerEvent("reanimar:pagamento1")
AddEventHandler("reanimar:pagamento1",function()
	local user_id = vRP.getUserId(source)
	if user_id then
		--pagamento = math.random(50,80)
		--vRP.giveMoney(user_id,pagamento)
		TriggerClientEvent("Notify",source,"sucesso","Você reanimou o americano.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /multar
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('multar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") then
		vRPclient._CarregarObjeto(source,"amb@code_human_in_bus_passenger_idles@female@tablet@idle_a","idle_b","prop_cs_tablet",49,60309)
		local id = vRP.prompt(source,"Passaporte:","")
		local valor = vRP.prompt(source,"Valor:","")
		local motivo = vRP.prompt(source,"Motivo:","")
		if id == "" or valor == "" or motivo == "" then
			vRPclient._DeletarObjeto(source)
			return
		end

		local value = vRP.getUData(parseInt(id),"vRP:multas")
		local multas = json.decode(value) or 0
		vRP.setUData(parseInt(id),"vRP:multas",json.encode(parseInt(multas)+parseInt(valor)))
		local oficialid = vRP.getUserIdentity(user_id)
		local identity = vRP.getUserIdentity(parseInt(id))
		local nplayer = vRP.getUserSource(parseInt(id))
		if vRP.request(source,"Deseja multar o Passaporte: <b>"..id.." "..identity.name.." "..identity.firstname.."</b> em <b>$"..vRP.format(parseInt(valor)).."</b> dólares ?",30) then
			SendWebhookMessage(webhookmultas,"```prolog\n[OFICIAL]: "..user_id.." "..oficialid.name.." "..oficialid.firstname.." \n[==============MULTOU==============] \n[PASSAPORTE]: "..id.." "..identity.name.." "..identity.firstname.." \n[VALOR]: $"..vRP.format(parseInt(valor)).." \n[MOTIVO]: "..motivo.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

			randmoney = math.random(250,300)
			vRP.giveMoney(user_id,parseInt(randmoney))
			TriggerClientEvent("Notify",source,"sucesso","Multa aplicada com sucesso.")
			TriggerClientEvent("Notify",source,"importante","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b> de bonificação.")
			vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
			if nplayer ~= nil then
				TriggerClientEvent("Notify",nplayer,"importante","Você foi multado em <b>$"..vRP.format(parseInt(valor)).." dólares</b>.<br><b>Motivo:</b> "..motivo..".")
			end
		end
		vRPclient._DeletarObjeto(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /ocorrencia
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ocorrencia',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"policia.permissao") then
		vRPclient._CarregarObjeto(source,"amb@code_human_in_bus_passenger_idles@female@tablet@idle_a","idle_b","prop_cs_tablet",49,60309)
		local id = vRP.prompt(source,"Passaporte:","")
		local ocorrencia = vRP.prompt(source,"Ocorrência:","")
		if id == "" or ocorrencia == "" then
			vRPclient._DeletarObjeto(source)
			return
		end

		local oficialid = vRP.getUserIdentity(user_id)
		local identity = vRP.getUserIdentity(parseInt(id))
		local nplayer = vRP.getUserSource(parseInt(id))
		if vRP.request(source,"Deseja registrar a ocorrência do Passaporte <b>"..id.." "..identity.name.." "..identity.firstname.."</b> ?",30) then
			SendWebhookMessage(webhookocorrencias,"```prolog\n[OFICIAL]: "..user_id.." "..oficialid.name.." "..oficialid.firstname.." \n[==============OCORRENCIA==============] \n[PASSAPORTE]: "..id.." "..identity.name.." "..identity.firstname.." \n[IDENTIDADE]: "..identity.registration.." \n[TELEFONE]: "..identity.phone.." \n[OCORRENCIA]: "..ocorrencia.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

			randmoney = math.random(650,750)
			vRP.giveMoney(user_id,parseInt(randmoney))
			TriggerClientEvent("Notify",source,"sucesso","Ocorrência registrada com sucesso.")
			TriggerClientEvent("Notify",source,"importante","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b> de bonificação.")
			vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
			if nplayer ~= nil then
				TriggerClientEvent("Notify",nplayer,"importante","Sua <b>Ocorrência</b> foi registrada com sucesso.")
				vRPclient.playSound(nplayer,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
			end
		end
		vRPclient._DeletarObjeto(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /detido
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('detido',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"policia.permissao") then
		vRPclient._CarregarObjeto(source,"amb@code_human_in_bus_passenger_idles@female@tablet@idle_a","idle_b","prop_cs_tablet",49,60309)
		local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,5)
		local motivo = vRP.prompt(source,"Motivo:","")
		if motivo == "" then
			vRPclient._DeletarObjeto(source)
			return
		end

		local oficialid = vRP.getUserIdentity(user_id)
		if vehicle then
			local puser_id = vRP.getUserByRegistration(placa)
			local rows = vRP.query("creative/get_vehicles",{ user_id = parseInt(puser_id), vehicle = vname })
			if rows[1] then
				if parseInt(rows[1].detido) == 1 then
					TriggerClientEvent("Notify",source,"importante","Este veículo já se encontra detido.",8000)
				else
					local identity = vRP.getUserIdentity(puser_id)
					local nplayer = vRP.getUserSource(parseInt(puser_id))
					if vRP.request(source,"Deseja apreender o veículo <b>"..vRP.vehicleName(vname).."</b> do Passaporte: <b>"..puser_id.." "..identity.name.." "..identity.firstname.."</b> ?",30) then
						SendWebhookMessage(webhookdetido,"```prolog\n[OFICIAL]: "..user_id.." "..oficialid.name.." "..oficialid.firstname.." \n[==============PRENDEU==============] \n[CARRO]: "..vRP.vehicleName(vname).." \n[PASSAPORTE]: "..puser_id.." "..identity.name.." "..identity.firstname.." \n[MOTIVO]: "..motivo.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						vRP.execute("creative/set_detido",{ user_id = parseInt(puser_id), vehicle = vname, detido = 1, time = parseInt(os.time()) })

						randmoney = math.random(250,300)
						vRP.giveMoney(user_id,parseInt(randmoney))
						TriggerClientEvent("Notify",source,"sucesso","Carro apreendido com sucesso.")
						TriggerClientEvent("Notify",source,"importante","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b> de bonificação.")
						vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
						if nplayer ~= nil then
							TriggerClientEvent("Notify",nplayer,"importante","Seu Veículo foi <b>Detido</b>.<br><b>Motivo:</b> "..motivo..".")
							vRPclient.playSound(nplayer,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
						end
					end
				end
				vRPclient._DeletarObjeto(source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /prender
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('prender',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") then
		vRPclient._CarregarObjeto(source,"amb@code_human_in_bus_passenger_idles@female@tablet@idle_a","idle_b","prop_cs_tablet",49,60309)
		local id = vRP.prompt(source,"Passaporte:","")
		local tempo = vRP.prompt(source,"Tempo:","")
		local crimes = vRP.prompt(source,"Crimes:","")
		if id == "" or tempo == "" or crimes == "" then
			vRPclient._DeletarObjeto(source)
			return
		end

		local oficialid = vRP.getUserIdentity(user_id)
		local identity = vRP.getUserIdentity(parseInt(id))
		local nplayer = vRP.getUserSource(parseInt(id))
		if vRP.request(source,"Deseja prender o Passaporte: <b>"..id.." "..identity.name.." "..identity.firstname.."</b> por <b>"..vRP.format(parseInt(tempo)).." meses</b> ?",30) then
			SendWebhookMessage(webhookprender,"```prolog\n[OFICIAL]: "..user_id.." "..oficialid.name.." "..oficialid.firstname.." \n[==============PRENDEU==============] \n[PASSAPORTE]: "..id.." "..identity.name.." "..identity.firstname.." \n[TEMPO]: "..vRP.format(parseInt(tempo)).." Meses \n[CRIMES]: "..crimes.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

			vRP.setUData(parseInt(id),"vRP:prisao",json.encode(parseInt(tempo)))
			prison_lock(parseInt(id))
			TriggerClientEvent("vrp_sound:source",source,'jaildoor',0.7)

			randmoney = math.random(650,750)
			vRP.giveMoney(user_id,parseInt(randmoney))
			TriggerClientEvent("Notify",source,"sucesso","Prisão efetuada com sucesso.")
			TriggerClientEvent("Notify",source,"importante","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b> de bonificação.")
			vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
			if nplayer ~= nil then
				vRPclient.setHandcuffed(nplayer,false)
				TriggerClientEvent('prisioneiro',nplayer,true)
				vRPclient.teleport(nplayer,1680.1,2513.0,45.5)
				TriggerClientEvent('removealgemas',nplayer)
				TriggerClientEvent("vrp_sound:source",nplayer,'jaildoor',0.7)
				TriggerClientEvent("Notify",nplayer,"importante","Você foi preso por <b>"..vRP.format(parseInt(tempo)).." meses</b>.<br><b>Motivo:</b> "..crimes..".")
				vRPclient.playSound(nplayer,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
				SetTimeout(1000,function()
					local model = vRPclient.getModelPlayer(nplayer)
					if model == "mp_m_freemode_01" then
						TriggerClientEvent("updateRoupas",nplayer,{ -1,0,-1,0,0,0,15,0,64,6,15,0,1,0,238,0,-1,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 })
					elseif model == "mp_f_freemode_01" then
						TriggerClientEvent("updateRoupas",nplayer,{ -1,0,0,0,0,0,4,0,66,6,7,0,1,1,247,0,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 })
					end
				end)
			end
		end
		vRPclient._DeletarObjeto(source) 
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /rg
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rg',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"polpar.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") or vRP.hasPermission(user_id,"conce.permissao") or vRP.hasPermission(user_id,"juiz.permissao") then
		if args[1] then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer == nil then
				TriggerClientEvent("Notify",source,"aviso","Passaporte <b>"..vRP.format(parseInt(args[1])).."</b> indisponível no momento.")
				return
			end
			nuser_id = vRP.getUserId(nplayer)
			if nuser_id then
				local value = vRP.getUData(nuser_id,"vRP:multas")
				local valormultas = json.decode(value) or 0
				local identity = vRP.getUserIdentity(nuser_id)
				local carteira = vRP.getMoney(nuser_id)
				local banco = vRP.getBankMoney(nuser_id)
				vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 8%; right: 2.5%; position: absolute; border: 1px solid rgba(255,255,255,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #d1257d; }","<div class=\"local\"><b>Nome:</b> "..identity.name.." "..identity.firstname.." ( "..vRP.format(identity.user_id).." )</div><div class=\"local2\"><b>Identidade:</b> "..identity.registration.."</div><div class=\"local\"><b>Idade:</b> "..identity.age.." Anos</div><div class=\"local2\"><b>Telefone:</b> "..identity.phone.."</div><div class=\"local\"><b>Multas pendentes:</b> "..vRP.format(parseInt(valormultas)).."</div><div class=\"local2\"><b>Carteira:</b> "..vRP.format(parseInt(carteira)).."</div>")
				vRP.request(source,"Você deseja fechar o registro geral ?",1000)
				vRPclient.removeDiv(source,"completerg")
			end
		else
			local nplayer = vRPclient.getNearestPlayer(source,2)
			local nuser_id = vRP.getUserId(nplayer)
			if nuser_id then
				local value = vRP.getUData(nuser_id,"vRP:multas")
				local valormultas = json.decode(value) or 0
				local identityv = vRP.getUserIdentity(user_id)
				local identity = vRP.getUserIdentity(nuser_id)
				local carteira = vRP.getMoney(nuser_id)
				local banco = vRP.getBankMoney(nuser_id)
				TriggerClientEvent("Notify",nplayer,"importante","Seu documento está sendo verificado por <b>"..identityv.name.." "..identityv.firstname.."</b>.")
				vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 8%; right: 2.5%; position: absolute; border: 1px solid rgba(255,255,255,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #d1257d; }","<div class=\"local\"><b>Nome:</b> "..identity.name.." "..identity.firstname.." ( "..vRP.format(identity.user_id).." )</div><div class=\"local2\"><b>Identidade:</b> "..identity.registration.."</div><div class=\"local\"><b>Idade:</b> "..identity.age.." Anos</div><div class=\"local2\"><b>Telefone:</b> "..identity.phone.."</div><div class=\"local\"><b>Multas pendentes:</b> "..vRP.format(parseInt(valormultas)).."</div><div class=\"local2\"><b>Carteira:</b> "..vRP.format(parseInt(carteira)).."</div>")
				vRP.request(source,"Você deseja fechar o registro geral ?",1000)
				vRPclient.removeDiv(source,"completerg")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALGEMAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_policia:algemar")
AddEventHandler("vrp_policia:algemar",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if nplayer then
		if exports["pd-inventory"]:getItemAmount(user_id,"algemas") >= 1 then
			if vRPclient.isHandcuffed(nplayer) then
				TriggerClientEvent('carregar',nplayer,source)
				vRPclient._playAnim(source,false,{"mp_arresting","a_uncuff"},false)
				SetTimeout(5000,function()
					vRPclient.toggleHandcuff(nplayer)
					TriggerClientEvent('carregar',nplayer,source)
					TriggerClientEvent("vrp_sound:source",source,'uncuff',0.1)
					TriggerClientEvent("vrp_sound:source",nplayer,'uncuff',0.1)
					TriggerClientEvent('removealgemas',nplayer)
				end)
			else
				if vCLIENT.checkSurrendered(nplayer) then
					TriggerClientEvent('cancelando',source,true,true)
					TriggerClientEvent('cancelando',nplayer,true,true)
					TriggerClientEvent('carregar',nplayer,source)
					vRPclient._playAnim(source,false,{"mp_arrest_paired","cop_p2_back_left"},false)
					vRPclient._playAnim(nplayer,false,{"mp_arrest_paired","crook_p2_back_left"},false)
					SetTimeout(3500,function()
						vRPclient._stopAnim(source,false)
						vRPclient.toggleHandcuff(nplayer)
						TriggerClientEvent('carregar',nplayer,source)
						TriggerClientEvent('cancelando',source,false,false)
						TriggerClientEvent('cancelando',nplayer,false,false)
						TriggerClientEvent("vrp_sound:source",source,'cuff',0.1)
						TriggerClientEvent("vrp_sound:source",nplayer,'cuff',0.1)
						TriggerClientEvent('setalgemas',nplayer)
					end)
				else
					TriggerClientEvent("Notify",source,"negado","O inidividuo precisa estar <b>rendido</b>.",source)
				end
			end
		else
			if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") then
				if vRPclient.isHandcuffed(nplayer) then
					TriggerClientEvent('carregar',nplayer,source)
					vRPclient._playAnim(source,false,{"mp_arresting","a_uncuff"},false)
					SetTimeout(5000,function()
						vRPclient.toggleHandcuff(nplayer)
						TriggerClientEvent('carregar',nplayer,source)
						TriggerClientEvent("vrp_sound:source",source,'uncuff',0.1)
						TriggerClientEvent("vrp_sound:source",nplayer,'uncuff',0.1)
						TriggerClientEvent('removealgemas',nplayer)
					end)
				else
					if vCLIENT.checkSurrendered(nplayer) then
						TriggerClientEvent('cancelando',source,true,true)
						TriggerClientEvent('cancelando',nplayer,true,true)
						TriggerClientEvent('carregar',nplayer,source)
						vRPclient._playAnim(source,false,{"mp_arrest_paired","cop_p2_back_left"},false)
						vRPclient._playAnim(nplayer,false,{"mp_arrest_paired","crook_p2_back_left"},false)
						SetTimeout(3500,function()
							vRPclient._stopAnim(source,false)
							vRPclient.toggleHandcuff(nplayer)
							TriggerClientEvent('carregar',nplayer,source)
							TriggerClientEvent('cancelando',source,false,false)
							TriggerClientEvent('cancelando',nplayer,false,false)
							TriggerClientEvent("vrp_sound:source",source,'cuff',0.1)
							TriggerClientEvent("vrp_sound:source",nplayer,'cuff',0.1)
							TriggerClientEvent('setalgemas',nplayer)
						end)
					else
						TriggerClientEvent("Notify",source,"negado","O inidividuo precisa estar <b>rendido</b>.")
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARREGAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_policia:carregar")
AddEventHandler("vrp_policia:carregar",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if nplayer then
		if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"polpar.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") then
			TriggerClientEvent('carregar',nplayer,source)
		else
			if exports["pd-inventory"]:getItemAmount(user_id,"cordas") >= 1 then
				if vRPclient.isHandcuffed(nplayer) or vRPclient.getHealth(nplayer) <= 101 then
					TriggerClientEvent('carregar',nplayer,source)
				else
					TriggerClientEvent("Notify",source,"aviso","A pessoa precisa estar <b>Algemada</b> ou <b>Inconsciente</b>.")
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /rmascara
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rmascara',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			TriggerClientEvent('rmascara',nplayer)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /rchapeu
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rchapeu',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			TriggerClientEvent('rchapeu',nplayer)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /rcolete
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rcolete',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			vRPclient.setArmour(nplayer,0)
			TriggerClientEvent("removeColeteUser",nplayer)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /rcapuz
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rcapuz',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			if vRPclient.isCapuz(nplayer) then
				vRPclient.setCapuz(nplayer)
				TriggerClientEvent("Notify",source,"sucesso","Capuz colocado com sucesso.")
			else
				TriggerClientEvent("Notify",source,"importante","A pessoa não está com o capuz na cabeça.")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /cv
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cv',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"polpar.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,10)
		if nplayer then
			vRPclient.putInNearestVehicleAsPassenger(nplayer,7)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /rv
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rv',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"polpar.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,10)
		if nplayer then
			vRPclient.ejectVehicle(nplayer)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /apreender
-----------------------------------------------------------------------------------------------------------------------------------------
local itemlist = {
	"dinheirosujo",
	"algemas",
	"cordas",
	"capuz",
	"lockpick",
	"masterpick",
	"orgao",
	"etiqueta",
	"pendrive",
	"relogioroubado",
	"pulseiraroubada",
	"anelroubado",
	"colarroubado",
	"brincoroubado",
	"carteiraroubada",
	"tabletroubado",
	"sapatosroubado",
	"carregadorroubado",
	"vibradorroubado",
	"perfumeroubado",
	"maquiagemroubada",
	"armacaodearma",
	"pecadearma",
	"maconha",
	"metanfetamina",
	"cocaina",
	"lsd",
	"logsinvasao",
	"acessodeepweb",
	"keysinvasao",
	"pendriveinformacoes",
	"radio",
	"placa",
	"keycard",
	"capsula",
	"polvora",
	"turtlemeat",
	"dagger",
	"bat",
	"bottle",
	"crowbar",
	"flashlight",
	"golfclub",
	"hammer",
	"hatchet",
	"knuckle",
	"knife",
	"machete",
	"switchblade",
	"nightstick",
	"wrench",
	"battleaxe",
	"poolcue",
	"stone_hatchet",
	"pistol",
	"combatpistol",
	"carbinerifle",
	"smg",
	"pumpshotgun_mk2",
	"stungun",
	"nightstick",
	"snspistol",
	"microsmg",
	"assaultrifle",
	"fireextinguisher",
	"flare",
	"revolver",
	"pistol_mk2",
	"vintagepistol",
	"musket",
	"gusenberg",
	"assaultsmg",
	"combatpdw",
	"compactrifle",
	"carbinerifle_mk2",
 	"machinepistol",
	"ammo_dagger",
	"ammo_bat",
	"ammo_bottle",
	"ammo_crowbar",
	"ammo_flashlight",
	"ammo_golfclub",
	"ammo_hammer",
	"ammo_hatchet",
	"ammo_knuckle",
	"ammo_knife",
	"ammo_machete",
	"ammo_switchblade",
	"ammo_nightstick",
	"ammo_wrench",
	"ammo_battleaxe",
	"ammo_poolcue",
	"ammo_stone_hatchet",
	"ammo_pistol",
	"ammo_combatpistol",
	"ammo_carbinerifle",
	"ammo_smg",
	"ammo_pumpshotgun",
	"ammo_pumpshotgun_mk2",
	"ammo_stungun",
	"ammo_nightstick",
	"ammo_snspistol",
	"ammo_microsmg",
	"ammo_assaultrifle",
	"ammo_fireextinguisher",
	"ammo_flare",
	"ammo_revolver",
	"ammo_pistol_mk2",
	"ammo_vintagepistol",
	"ammo_musket",
	"ammo_gusenberg",
	"ammo_assaultsmg",
	"ammo_combatpdw",
	"ammo_machinepistol",
	"ammo_carbinerifle_mk2",
	"ammo_compactrifle"
}

RegisterCommand('apreender',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isInVehicle(source) or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			local nuser_id = vRP.getUserId(nplayer)
			if nuser_id then

				TriggerClientEvent('cancelando',source,true,true)
				TriggerClientEvent('cancelando',nplayer,true,true)
				TriggerClientEvent('carregar',nplayer,source)
				vRPclient._playAnim(source,false,{"misscarsteal4@director_grip","end_loop_grip"},true)
				vRPclient._playAnim(nplayer,true,{"random@arrests@busted","idle_a"},true)
				TriggerClientEvent("progress",source,5000,"apreendendo")
				SetTimeout(5000,function()

					local weapons = vRPclient.replaceWeapons(nplayer,{})
					for k,v in pairs(weapons) do
						exports["pd-inventory"]:giveItem(nuser_id, string.sub(string.lower(k),8), 1, true)
						if v.ammo > 0 then
							string.lower("ammo_"..string.lower(k))
							exports["pd-inventory"]:giveItem(nuser_id, "ammo_"..string.sub(string.lower(k),8), v.ammo, true)
						end
					end
					
					for k,v in pairs(itemlist) do
						local amount = exports["pd-inventory"]:getItemAmount(nuser_id, v)
						if amount > 0 then
							exports["pd-inventory"]:consumeItem(nuser_id, v, parseInt(amount), true) 
							exports["pd-inventory"]:giveItem(user_id,v,amount, true,"Recebeu",true)
						end
					end

					vRPclient._stopAnim(source,false)
					vRPclient._stopAnim(nplayer,false)
					TriggerClientEvent('cancelando',source,false,false)
					TriggerClientEvent('cancelando',nplayer,false,false)
					TriggerClientEvent('carregar',nplayer,source)
					TriggerClientEvent("Notify",nplayer,"importante","Todos os seus pertences foram apreendidos.")
					TriggerClientEvent("Notify",source,"importante","Apreendeu todos os pertences da pessoa.")
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /arsenal
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('arsenal',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		TriggerClientEvent('arsenal',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /extras
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('extras',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"policia.permissao") then
		if vRPclient.isInVehicle(source) then
			TriggerClientEvent('extras',source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYEXTRAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryextras")
AddEventHandler("tryextras",function(index,extra)
    TriggerClientEvent("syncextras",-1,index,parseInt(extra))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /cone
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cone',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"polpar.permissao") or vRP.hasPermission(user_id,"conce.permissao") or vRP.hasPermission(user_id,"mecanico.permissao") then
		TriggerClientEvent('cone',source,args[1])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /barreira
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('barreira',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"polpar.permissao") or vRP.hasPermission(user_id,"conce.permissao") or vRP.hasPermission(user_id,"mecanico.permissao") then
		TriggerClientEvent('barreira',source,args[1])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /spike
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('spike',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"policia.permissao") then
		TriggerClientEvent('spike',source,args[1])
	end
end)
--------------------------------------------------------------------------------------------------------------------------------------------------
-- DISPAROS
--------------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('atirando')
AddEventHandler('atirando',function(x,y,z)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"acaopolicia.permissao") then
			return
		end
		local policia = vRP.getUsersByPermission("policia.permissao")
		for l,w in pairs(policia) do
			local player = vRP.getUserSource(w)
			if player then
				async(function()
					TriggerClientEvent('notificacao',player,x,y,z,user_id)
					--TriggerClientEvent("NotifyPush",player,{ code = 10, title = "Ocorrência em andamento", x = x, y = y, z = z, badge = "Disparos de arma de fogo" })
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /anuncio
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('anuncio',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"conce.permissao") then
		local identity = vRP.getUserIdentity(user_id)
		local mensagem = vRP.prompt(source,"Mensagem:","")
		if mensagem == "" then
			return
		end
		vRPclient.setDiv(-1,"anuncio",".div_anuncio { background: rgba(0,128,192,0.8); font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 20%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 16px; }","<bold>"..mensagem.."</bold><br><br>Mensagem enviada por: "..identity.name.." "..identity.firstname)
		SetTimeout(30000,function()
			vRPclient.removeDiv(-1,"anuncio")
		end)
	end
end)
--------------------------------------------------------------------------------------------------------------------------------------------------
-- PRISÃO
--------------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	local player = vRP.getUserSource(parseInt(user_id))
	if player then
		SetTimeout(30000,function()
			local value = vRP.getUData(parseInt(user_id),"vRP:prisao")
			local tempo = json.decode(value) or -1

			if tempo == -1 then
				return
			end

			if tempo > 0 then
				TriggerClientEvent('prisioneiro',player,true)
				vRPclient.teleport(player,1680.1,2513.0,46.5)
				prison_lock(parseInt(user_id))
			end
		end)
	end
end)

function prison_lock(target_id)
	local player = vRP.getUserSource(parseInt(target_id))
	if player then
		SetTimeout(60000,function()
			local value = vRP.getUData(parseInt(target_id),"vRP:prisao")
			local tempo = json.decode(value) or 0
			if parseInt(tempo) >= 1 then
				TriggerClientEvent("Notify",player,"importante","Ainda vai passar <b>"..parseInt(tempo).." meses</b> preso.")
				vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(parseInt(tempo)-1))
				prison_lock(parseInt(target_id))
			elseif parseInt(tempo) == 0 then
				TriggerClientEvent('prisioneiro',player,false)
				vRPclient.teleport(player,1850.5,2604.0,45.5)
				vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(-1))
				TriggerClientEvent("Notify",player,"importante","Sua sentença terminou, esperamos não ve-lo novamente.")
			end
			vRPclient.PrisionGod(player)
		end)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIMINUIR PENA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("diminuirpena1")
AddEventHandler("diminuirpena1",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local value = vRP.getUData(parseInt(user_id),"vRP:prisao")
	local tempo = json.decode(value) or 0
	if tempo >= 10 then
		vRP.setUData(parseInt(user_id),"vRP:prisao",json.encode(parseInt(tempo)-4))
		TriggerClientEvent("Notify",source,"importante","Sua pena foi reduzida em <b>4 meses</b>, continue o trabalho.")
	else
		TriggerClientEvent("Notify",source,"importante","Atingiu o limite da redução de pena, não precisa mais trabalhar.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /preset
-----------------------------------------------------------------------------------------------------------------------------------------
local presets = {
	["1"] = {
		["male"] = { 121,0,-1,0,-1,0,4,0,25,0,58,0,21,0,26,0,13,0,-1,0,13,0,5,5,-1,-1,-1,-1,-1,-1 },
		["female"] = { 121,0,-1,0,-1,0,14,0,41,0,35,0,59,1,25,0,14,0,-1,0,13,0,11,0,-1,-1,-1,-1,-1,-1 }
	},
	["2"] = {
		["male"] = { 121,0,-1,0,1,0,0,0,47,0,57,0,25,0,93,0,-1,0,-1,0,10,0,5,0,-1,-1,-1,-1,-1,-1 },
		["female"] = { 121,0,-1,0,1,0,14,0,49,0,34,0,25,0,84,0,-1,0,-1,0,10,0,11,0,-1,-1,-1,-1,-1,-1 }
	},
	["3"] = {
		["male"] = { 121,0,-1,0,1,0,19,0,31,0,38,1,25,0,118,0,0,0,-1,0,10,0,5,0,-1,-1,-1,-1,-1,-1 },
		["female"] = { 121,0,-1,0,1,0,20,0,30,0,34,0,25,0,25,0,0,0,-1,0,10,2,11,0,-1,-1,-1,-1,-1,-1 }
	},
	["4"] = {
		["male"] = { 121,0,-1,0,-1,0,4,0,25,1,58,0,21,0,26,1,13,0,-1,0,13,1,5,5,-1,-1,-1,-1,-1,-1 },
		["female"] = { 121,0,-1,0,-1,0,14,0,41,1,35,0,59,1,25,1,14,0,-1,0,13,1,11,0,-1,-1,-1,-1,-1,-1 }
	},
	["5"] = {
		["male"] = { 121,1,-1,0,1,0,0,0,47,1,57,0,25,0,93,1,-1,0,-1,0,10,1,5,0,-1,-1,-1,-1,-1,-1 },
		["female"] = { 121,0,-1,0,1,0,14,0,49,1,34,0,25,0,84,1,-1,0,-1,0,10,1,11,0,-1,-1,-1,-1,-1,-1 }
	},
	["6"] = {
		["male"] = { -1,0,-1,0,126,0,81,0,10,0,38,0,51,0,118,2,-1,0,-1,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 },
		["female"] = { 0,0,0,0,14,3,93,0,6,0,27,0,0,0,25,2,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 }
	},
	["7"] = {
		["male"] = { -1,0,-1,0,126,0,81,0,10,0,38,0,51,0,118,3,-1,0,-1,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 },
		["female"] = { 0,0,0,0,14,3,93,0,6,0,27,0,0,0,25,3,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 }
	},
	["8"] = {
		["male"] = { -1,0,-1,0,126,0,81,0,10,0,38,0,51,0,118,4,-1,0,-1,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 },
		["female"] = { 0,0,0,0,14,3,93,0,6,0,27,0,0,0,25,4,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 }
	},
	["9"] = {
		["male"] = { -1,0,-1,0,126,0,81,0,20,0,38,0,7,0,118,5,-1,0,-1,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 },
		["female"] = { 0,0,0,0,14,3,93,0,23,0,27,0,0,2,25,5,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 }
	},
	["10"] = {
		["male"] = { -1,0,-1,0,126,0,4,0,4,4,96,0,1,1,142,2,-1,0,-1,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 },
		["female"] = { 0,0,0,0,14,3,7,0,73,1,64,2,0,0,139,2,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 }
	},
	["11"] = {
		["male"] = { 0,0,21,10,30,0,74,0,97,19,38,0,24,0,146,2,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 },
		["female"] = { 0,0,21,10,14,0,85,0,100,19,27,0,66,3,141,4,-1,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 }
	},
	["12"] = {
		["male"] = { -1,0,-1,0,126,0,74,0,3,3,15,0,7,0,16,1,-1,0,-1,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 },
		["female"] = { -1,0,-1,0,14,3,96,0,50,2,15,0,10,1,141,1,-1,0,-1,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 }
	},
	["13"] = {
		["male"] = { -1,0,46,0,29,2,4,0,24,0,31,0,10,0,30,0,-1,0,-1,0,-1,-1,7,0,-1,-1,-1,-1,-1,-1 },
		["female"] = { -1,0,-1,0,-1,3,26,0,6,0,23,1,42,0,90,0,-1,0,-1,0,-1,-1,2,5,-1,-1,-1,-1,-1,-1 }
	}
}

RegisterCommand("preset",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.getArmour(source) >= 1 or vRPclient.isInVehicle(source) or vRPclient.isHandcuffed(source) then
		return
	end
	if vRP.hasPermission(user_id,"polpar.permissao") or vRP.hasPermission(user_id,"juiz.permissao") then
		if args[1] then
			if args[1] == "save" then
				local custom = vRPclient.getCustomPlayer(source)
				if custom then
					vRP.setUData(parseInt(user_id),"vRP:defaultVisual",json.encode(custom))
					TriggerClientEvent("Notify",source,"sucesso","Preset salvo com sucesso.",8000)
				end
			elseif presets[tostring(args[1])] then
				local model = vRPclient.getModelPlayer(source)
				if model == "mp_m_freemode_01" then
					TriggerClientEvent("updateRoupas",source,presets[tostring(args[1])]["male"])
				elseif model == "mp_f_freemode_01" then
					TriggerClientEvent("updateRoupas",source,presets[tostring(args[1])]["female"])
				end
			end
		else
			local consulta = vRP.getUData(parseInt(user_id),"vRP:defaultVisual")
			local resultado = json.decode(consulta) or {}
			if resultado then
				TriggerClientEvent("updateRoupas",source,resultado)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /a
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("a",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] == "rayp" then
			vRPclient.giveWeapons(source,{["WEAPON_RAYPISTOL"] = { ammo = 0 }})	
		elseif args[1] == "fire" then
			vRPclient.giveWeapons(source,{["WEAPON_FIREWORK"] = { ammo = 250 }})
		elseif args[1] == "sniper" then
			vRPclient.giveWeapons(source,{["WEAPON_HEAVYSNIPER_MK2"] = { ammo = 250 }})
		elseif args[1] == "appistol" then
			vRPclient.giveWeapons(source,{["WEAPON_APPISTOL"] = { ammo = 250 }})
		elseif args[1] == "gas" then
			vRPclient.giveWeapons(source,{["WEAPON_BZGAS"] = { ammo = 1 }})
		end
	end
end)