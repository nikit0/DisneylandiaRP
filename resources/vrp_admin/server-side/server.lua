-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- /ad
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ad',function(source,args,rawCommand)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"admin.permissao") then
			local admin = vRP.getUsersByPermission("admin.permissao")
			for l,w in pairs(admin) do
				local nadmin = vRP.getUserSource(parseInt(w))
				if nadmin then
					async(function()
						TriggerClientEvent('chatMessage',nadmin,"ADMIN - ^1"..identity.name.." "..identity.firstname,{255,70,50},rawCommand:sub(3))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /staff
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('staff',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
		local model = vRPclient.getModelPlayer(source)
        if model == "mp_m_freemode_01" then
            TriggerClientEvent("updateRoupas",source,{ 0,0,0,0,0,0,0,0,33,0,15,0,8,7,208,12,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 })
        elseif model == "mp_f_freemode_01" then
            TriggerClientEvent("updateRoupas",source,{ -1,0,-1,0,-1,0,2,0,16,0,7,0,4,7,2,2,0,0,-1,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 })
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEAR INVENTORY 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("clearinv",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if user_id then
            if args[1] then
                local identity = vRP.getUserIdentity(parseInt(args[1]))    
                if vRP.request(source,"Deseja limpar o inventário do Passaporte: <b>"..vRP.format(parseInt(args[1])).." "..identity.name.." "..identity.firstname.."</b> ?",30) then
                    local nplayer = vRP.getUserSource(parseInt(args[1]))
                    if nplayer ~= nil then
                        TriggerClientEvent("SetClearInventory",nplayer)
                        TriggerClientEvent("Notify",source,"sucesso","Você limpou o inventário do Passaporte: <b>"..vRP.format(parseInt(args[1])).." "..identity.name.." "..identity.firstname.."</b>.")
                    else
                        TriggerClientEvent("Notify",source,"aviso","Passaporte: <b>"..vRP.format(parseInt(args[1])).."</b> indisponível no momento.")
                    end
                end
            else
                TriggerClientEvent("SetClearInventory",source)
                TriggerClientEvent("Notify",source,"sucesso","Você limpou todo o seu <b>Inventário</b>.")
            end  
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEAR CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('clearchest',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] then
            local identity2 = vRP.getUserIdentity(parseInt(args[2]))
            if vRP.request(source,"Deseja limpar o baú <b>"..args[1].."</b> ?",30) then
                vRP.execute("creative/rem_srv_data",{ dkey = "chest:"..tostring(args[1]) })
                TriggerClientEvent("Notify",source,"sucesso","Você limpou o baú <b>"..args[1].."</b>.")
                SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[LIMPOU BAU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESET PLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('resetplayer',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if user_id then
            if args[1] then
                local identity = vRP.getUserIdentity(parseInt(args[1]))
                if vRP.request(source,"Deseja resetar o Passaporte: <b>"..parseInt(args[1]).." "..identity.name.." "..identity.firstname.."</b> ?",30) then
                    local id = vRP.getUserSource(parseInt(args[1]))
                    TriggerClientEvent("SetClearInventory",id)
                    if id ~= nil then  
                        vRP.kick(id,"Você foi expulso da cidade.")
                    end
                    local myHomes = vRP.query("homes/get_homeuserid",{ user_id = parseInt(args[1]) })
                    if parseInt(#myHomes) >= 1 then
                        for k,v in pairs(myHomes) do
                            local ownerHomes = vRP.query("homes/get_homeuserowner",{ user_id = parseInt(args[1]), home = tostring(v.home) })
                            if ownerHomes[1] then
                                vRP.execute("homes/rem_allpermissions",{ home = tostring(ownerHomes[1].home) })   
                                vRP.execute("vRP/rem_allhouses",{ user_id = parseInt(args[1]) })

                                vRP.execute("vRP/rem_srv_data",{ user_id = "%chest:"..tostring(ownerHomes[1].home).."%" })
                                vRP.execute("vRP/rem_srv_data",{ user_id = "%outfit:"..tostring(ownerHomes[1].home).."%" })
                            else
                                vRP.execute("vRP/rem_allhouses",{ user_id = parseInt(args[1]) })
                            end
                        end
                    end

                    vRP.execute("vRP/rem_allcars",{ user_id = parseInt(args[1]) })
                    vRP.execute("vRP/rem_srv_data",{ user_id = "%chest:u"..args[1].."%" })
                    vRP.execute("vRP/rem_srv_data",{ user_id = "%custom:u"..args[1].."%" })

                    vRP.execute("vRP/upd_rg_phone",{ user_id = parseInt(args[1]), registration = vRP.generateRegistrationNumber(), phone = vRP.generatePhoneNumber() })
                    vRP.execute("vRP/rem_user_dkey",{ user_id = parseInt(args[1]), dkey = "currentCharacterMode" })
                    vRP.execute("vRP/rem_user_dkey",{ user_id = parseInt(args[1]), dkey = "vRP:datatable" })
                    vRP.execute("vRP/rem_user_dkey",{ user_id = parseInt(args[1]), dkey = "vRP:multas" })
                    vRP.execute("vRP/rem_user_dkey",{ user_id = parseInt(args[1]), dkey = "vRP:prisao" })
                    vRP.execute("vRP/rem_user_dkey",{ user_id = parseInt(args[1]), dkey = "vRP:spawnController" })
                    vRP.execute("vRP/rem_user_dkey",{ user_id = parseInt(args[1]), dkey = "vRP:tattoos" })
                    vRP.execute("vRP/set_money",{ user_id = parseInt(args[1]), wallet = 1000, bank = 2000, paypal = 0 })
                    TriggerClientEvent("Notify",source,"sucesso","Você resetou o Passaporte: <b>"..parseInt(args[1]).." "..identity.name.." "..identity.firstname.."</b>.")
                end          
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESET APPEARANCE
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand('resetap',function(source,args,rawCommand)
-- 	local user_id = vRP.getUserId(source)
-- 	if vRP.hasPermission(user_id,"admin.permissao") then
--         if args[1] then
--             local identity = vRP.getUserIdentity(parseInt(args[1]))
--             if vRP.request(source,"Deseja resetar a aparência do Passaporte: <b>"..args[1].." "..identity.name.." "..identity.firstname.."</b> ?",30) then
--                 vRP.setUData(parseInt(args[1]),"vRP:spawnController",json.encode(0))
--                 TriggerClientEvent("Notify",source,"sucesso","Você resetou a aparência do Passaporte: <b>"..parseInt(args[1]).." "..identity.name.." "..identity.firstname.."</b>.")
--             end    
-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET HEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('sethealth',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] then
            vRPclient.setHealth(source,args[1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVE COINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('givecoins',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") and user_id == 1 or user_id == 2 then
        local nplayer = vRP.getUserSource(parseInt(args[1]))
        if args[1] and args[2] then
            TriggerClientEvent("Notify",source,"sucesso","Você enviou <b>"..vRP.format(parseInt(args[2])).."</b> Coins para o <b>ID:</b> "..parseInt(args[1]))
            if nplayer then
                TriggerClientEvent("Notify",nplayer,"sucesso","Você recebeu <b>"..vRP.format(parseInt(args[2])).."</b> Coins de DeadShot e nikit0")
            end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET PROCURADO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('setprocurado',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		vRP.searchTimer(user_id,parseInt(10))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET PLATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('setplate',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if user_id then
            if args[1] then
                TriggerClientEvent("setPlateText",source,args[1])
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CUFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('setcuff',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient._setHandcuffed(source,true)
			TriggerClientEvent("setalgemas",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNCUFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('setuncuff',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient._setHandcuffed(source,false)
			TriggerClientEvent("removealgemas",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET NAME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('setname',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if user_id then
            if args[1] and args[2] and args[3] and args[4] then
                local identity = vRP.getUserIdentity(parseInt(args[1]))
                if vRP.request(source,"Deseja mudar o <b>Nome/Sobrenome/Idade</b> do Passaporte: <b>"..vRP.format(parseInt(args[1])).." "..identity.name.." "..identity.firstname.."</b> para <b>"..args[2].." "..args[3].." "..args[4].."</b> ?",30) then
                    vRP.execute("vRP/upd_user_identity",{ user_id = parseInt(args[1]), name = args[2], firstname = args[3], age = args[4] })
                    TriggerClientEvent("Notify",source,"sucesso","Você mudou o <b>Nome/Sobrenome/Idade</b> do Passaporte: <b>"..vRP.format(parseInt(args[1])).." "..identity.name.." "..identity.firstname.."</b> para <b>"..args[2].." "..args[3].." "..args[4].."</b>.")
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
local player_customs = {}
RegisterCommand('vroupas',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local custom = vRPclient.getCustomization(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
        if player_customs[source] then
            player_customs[source] = nil
            vRPclient._removeDiv(source,"customization")
        else 
            local content = ""
            for k,v in pairs(custom) do
                content = content..k.." => "..json.encode(v).."<br/>" 
            end

            player_customs[source] = true
            vRPclient._setDiv(source,"customization",".div_customization{ margin: auto; padding: 4px; width: 250px; margin-top: 200px; margin-right: 50px; background: rgba(15,15,15,0.7); color: #ffff; font-weight: bold; }",content)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('blips',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        TriggerClientEvent("blips:showBlips",source)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USER HOMES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('userhomes',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
            local nuser_id = parseInt(args[1])
            local identity = vRP.getUserIdentity(nuser_id)
            TriggerClientEvent("Notify",source,"sucesso","Casas do passaporte: <b>"..nuser_id.." "..identity.name.." "..identity.firstname.."</b>",20000)
            if nuser_id then 
                local homes = vRP.query("homes/get_homeuserid",{ user_id = parseInt(nuser_id) })
                for k,v in pairs(homes) do
                    TriggerClientEvent("Notify",source,"importante","<b>Casa:</b> "..tostring(v.home),20000)
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD HOMES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('addhomes',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] and args[2] then
            local identity2 = vRP.getUserIdentity(parseInt(args[2]))
            if vRP.request(source,"Deseja adicionar a casa <b>"..args[1].."</b> para o Passaporte: <b>"..parseInt(args[2]).." "..identity2.name.." "..identity2.firstname.."</b> ?",30) then
    			vRP.execute("homes/buy_permissions",{ home = tostring(args[1]), user_id = parseInt(args[2]), tax = parseInt(os.time()) })
    			TriggerClientEvent("Notify",source,"sucesso","Você adicionou a casa <b>"..args[1].."</b> para o Passaporte: <b>"..parseInt(args[2]).." "..identity2.name.." "..identity2.firstname.."</b>.")
                SendWebhookMessage(webhookviphomes,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ADICIONOU]: "..tostring(args[1]).." \n[PARA O ID]: "..parseInt(args[2]).." "..identity2.name.." "..identity2.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
            end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REM HOMES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('remhomes',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] then
            local identity2 = vRP.getUserIdentity(parseInt(args[2]))
            if vRP.request(source,"Deseja remover a casa <b>"..args[1].."</b> do Passaporte: <b>"..parseInt(args[2]).." "..identity2.name.." "..identity2.firstname.."</b> ?",30) then
                vRP.execute("creative/rem_srv_data",{ dkey = "chest:"..tostring(args[1]) })
                vRP.execute("creative/rem_srv_data",{ dkey = "outfit:"..tostring(args[1]) })
                vRP.execute("homes/rem_allpermissions",{ home = tostring(args[1]) })
    			TriggerClientEvent("Notify",source,"sucesso","Você removeu a casa <b>"..args[1].."</b> do Passaporte: <b>"..parseInt(args[2]).." "..identity2.name.." "..identity2.firstname.."</b>.")
                SendWebhookMessage(webhookviphomes,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..tostring(args[1]).." \n[DO ID]: "..parseInt(args[2]).." "..identity2.name.." "..identity2.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
            end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USER VEHS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('uservehs',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
            local nuser_id = parseInt(args[1])
            local identity = vRP.getUserIdentity(nuser_id)
            TriggerClientEvent("Notify",source,"sucesso","Carros do passaporte: <b>"..nuser_id.." "..identity.name.." "..identity.firstname.."</b>",20000)
            if nuser_id > 0 then 
                local vehicle = vRP.query("creative/get_vehicle",{ user_id = parseInt(nuser_id) })
                for k,v in pairs(vehicle) do
                    TriggerClientEvent("Notify",source,"importante","<b>Modelo:</b> "..vRP.vehicleName(v.vehicle).." <b>("..v.vehicle..")</b>",20000)
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD VEHS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('addvehs',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] and args[2] then
            local identity2 = vRP.getUserIdentity(parseInt(args[2]))
            if vRP.request(source,"Deseja adicionar o veículo <b>"..vRP.vehicleName(args[1]).."</b> para o Passaporte: <b>"..parseInt(args[2]).." "..identity2.name.." "..identity2.firstname.."</b> ?",30) then
                if vRP.vehicleClass(tostring(args[1])) == "rental" and args[3] then
                    vRP.execute("creative/add_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time()) })
                    vRP.execute("setRentalTime",{ user_id = parseInt(args[2]), vehicle = args[1], rental_time = parseInt(os.time()+parseInt(args[3])*24*60*60) })
                    TriggerClientEvent("Notify",source,"sucesso","Você adicionou o veículo <b>"..vRP.vehicleName(args[1]).."</b> para o Passaporte: <b>"..parseInt(args[2]).." "..identity2.name.." "..identity2.firstname.."</b> por <b>"..args[3].."</b> dias.")
                    SendWebhookMessage(webhookvipcar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ADICIONOU]: "..vRP.vehicleName(args[1]).." \n[PARA O ID]: "..parseInt(args[2]).." "..identity2.name.." "..identity2.firstname.." por "..args[3].." dias "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                else
                    vRP.execute("creative/add_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time()) })
                    TriggerClientEvent("Notify",source,"sucesso","Você adicionou o veículo <b>"..vRP.vehicleName(args[1]).."</b> para o Passaporte: <b>"..parseInt(args[2]).." "..identity2.name.." "..identity2.firstname.."</b>.")
                    SendWebhookMessage(webhookvipcar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ADICIONOU]: "..vRP.vehicleName(args[1]).." \n[PARA O ID]: "..parseInt(args[2]).." "..identity2.name.." "..identity2.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REM VEHS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('remvehs',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] and args[2] then
            local identity2 = vRP.getUserIdentity(parseInt(args[2]))
            if vRP.request(source,"Deseja remover o veículo <b>"..vRP.vehicleName(args[1]).."</b> do Passaporte: <b>"..parseInt(args[2]).." "..identity2.name.." "..identity2.firstname.."</b> ?",30) then
    			vRP.execute("creative/rem_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1] })
                TriggerClientEvent("Notify",source,"sucesso","Você removeu o veículo <b>"..vRP.vehicleName(args[1]).."</b> do Passaporte: <b>"..parseInt(args[2]).." "..identity2.name.." "..identity2.firstname.."</b>.") 
                SendWebhookMessage(webhookvipcar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..vRP.vehicleName(args[1]).." \n[DO ID]: "..parseInt(args[2]).." "..identity2.name.." "..identity2.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('estoque',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") and vRP.hasPermission(user_id,"conce.permissao") then
        if args[1] and args[2] then
            if vRP.vehicleClass(tostring(args[1])) == "exclusive" or vRP.vehicleClass(tostring(args[1])) == "rental" then
                TriggerClientEvent("Notify",source,"negado","<b>"..vRP.vehicleName(tostring(args[1])).."</b> não pode ser adicionado no estoque por ser um veículo <b>Exclusivo ou Alugado</b>.",10000)
                return
            else
                if vRP.request(source,"Deseja adicionar mais <b>"..args[2].."</b> no estoque, para o veículo <b>"..vRP.vehicleName(tostring(args[1])).."</b> ?",30) then
                    vRP.execute("set_stock",{ spawn = args[1], stock = parseInt(args[2]) })
                    TriggerClientEvent("Notify",source,"sucesso","Você colocou mais <b>"..args[2].."</b> no estoque, para o veículo <b>"..vRP.vehicleName(tostring(args[1])).."</b>.") 
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('admfuel',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"admin.permissao") then
			TriggerClientEvent("admfuel",source)
		end	
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cleararea',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local x,y,z = vRPclient.getPosition(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        TriggerClientEvent("syncarea",-1,x,y,z)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- APAGAO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('apagao',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local player = vRP.getUserSource(user_id)
        if vRP.hasPermission(user_id,"admin.permissao") and args[1] ~= nil then
            local cond = tonumber(args[1])
            --TriggerEvent("cloud:setApagao",cond)
            TriggerClientEvent("cloud:setApagao",-1,cond)                    
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RAIOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('raios', function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local player = vRP.getUserSource(user_id)
        if vRP.hasPermission(user_id,"admin.permissao") and args[1] ~= nil then
            local vezes = tonumber(args[1])
            TriggerClientEvent("cloud:raios",-1,vezes)           
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TROCAR SEXO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('skin',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if parseInt(args[1]) then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                TriggerClientEvent("skinmenu",nplayer,args[2])
                TriggerClientEvent("Notify",source,"sucesso","Voce setou a skin <b>"..args[2].."</b> no passaporte: <b>"..parseInt(args[1]).."</b>.")
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('toggledebug',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		if vRP.hasPermission(user_id,"admin.permissao") then
			TriggerClientEvent("ToggleDebug",player)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEOBJ
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteobj")
AddEventHandler("trydeleteobj",function(index)
    TriggerClientEvent("syncdeleteobj",-1,index)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('fix',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local vehicle = vRPclient.getNearestVehicle(source,11)
	if vehicle then
		if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
			TriggerClientEvent('reparar',source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('god',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
		if args[1] then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer then
				vRPclient.killGod(nplayer)
				vRPclient.setHealth(nplayer,300)
				TriggerClientEvent("resetBleeding",nplayer)
                TriggerClientEvent("resetDiagnostic",nplayer)
                TriggerClientEvent("removeColeteUser",nplayer)
			end
		else
			vRPclient.killGod(source)
			vRPclient.setHealth(source,300)
			TriggerClientEvent("resetBleeding",source)
			TriggerClientEvent("resetDiagnostic",source)
			TriggerClientEvent("removeColeteUser",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD ALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('godall',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
    	local usersg = vRP.getUsers()
        for k,v in pairs(usersg) do
            local godall = vRP.getUserSource(parseInt(k))
            if godall ~= nil then
                async(function()
                    vRPclient.killGod(godall)
                    vRPclient.setHealth(godall,300)
                    TriggerClientEvent("resetBleeding",godall)
                    TriggerClientEvent("resetDiagnostic",godall)
                end)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wl",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
        if args[1] then
            vRP.setWhitelisted(parseInt(args[1]),true)
            TriggerClientEvent("Notify",source,"sucesso","Voce aprovou o passaporte: <b>"..args[1].."</b> na whitelist.")
            TriggerEvent("Disneylandia:logDiscord","admin","```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[APROVOU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","Admin")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNWL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unwl',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
		if args[1] then
			vRP.setWhitelisted(parseInt(args[1]),false)
			TriggerClientEvent("Notify",source,"sucesso","Voce retirou o passaporte: <b>"..args[1].."</b> da whitelist.")
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kick',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] then
			local id = vRP.getUserSource(parseInt(args[1]))
			if id then
				vRP.kick(id,"Você foi expulso da cidade.")
				TriggerClientEvent("Notify",source,"sucesso","Voce kickou o passaporte: <b>"..args[1].."</b> da cidade.")
				SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[KICKOU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK ALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kickall',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        local users = vRP.getUsers()
        for k,v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            if id ~= nil then
                async(function()
                    vRP.kick(id,"Você foi vitima do terremoto.")
                end)
            end
        end
    end
end)
----------------------------------------------------------------------------------------------------------------------------------------- 
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ban',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] then
            local reason = vRP.prompt(source,"Motivo:","")
            local time = vRP.prompt(source,"Tempo:","")
            if reason == "" or time == "" then
                return
            end
            if reason == "Hacker" or reason == "Duping" then
                vRP.setBanned(parseInt(args[1]),true,1)
            else
                vRP.setBanned(parseInt(args[1]),true,0)
            end
            vRP.setWhitelisted(parseInt(args[1]),false)
			TriggerClientEvent("Notify",source,"sucesso","Voce baniu o passaporte: <b>"..args[1].."</b> da cidade.")
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[BANIU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
            SendWebhookMessage(webhookban,"```prolog\n[ID]: "..args[1].." \n[MOTIVO]: "..reason.." \n[TEMPO]: "..time.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
            local id = vRP.getUserSource(parseInt(args[1]))
            if id then  
                vRP.kick(id,"Você foi expulso da cidade.")
            end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unban',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] then
			vRP.setBanned(parseInt(args[1]),false)
			TriggerClientEvent("Notify",source,"sucesso","Voce desbaniu o passaporte: <b>"..args[1].."</b> da cidade.")
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DESBANIU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('money',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] then
            vRP.giveMoney(user_id,parseInt(args[1]),true)
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[FEZ]: $"..vRP.format(parseInt(args[1])).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('nc',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
        if user_id == 2 or user_id == 15 or user_id == 16 then
            vRPclient.toggleNoclip(source,true)
        else
            vRPclient.toggleNoclip(source,false)
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterCommand('hash',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        TriggerClientEvent('vehash',source)
    end
end)]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tuning',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        TriggerClientEvent('vehtuning',source)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dog',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id == 11 then
		TriggerClientEvent("DOG-GOD",source)
	else
		TriggerClientEvent("Notify",source,"negado","Você <b>NÃO</b> é o <b>DOG GOD</b>.",8000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpcds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local fcoords = vRP.prompt(source,"Cordenadas:","")
		if fcoords == "" then
			return
		end
		local coords = {}
		for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
			table.insert(coords,parseInt(coord))
		end
		vRPclient.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		local lugar = vRP.prompt(source,"Lugar:","")
		if lugar == "" then
			return
		end
		SendWebhookMessage(webhookcds,"```prolog\n[PASSAPORTE]: "..user_id.." \n[LUGAR]: "..lugar.." \n[CDS]: [] = { ['x'] = "..tD(x)..", ['y'] = "..tD(y)..", ['z'] = "..tD(z).." }, \r```")
	end
end)
RegisterCommand('cdsn',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
        local x,y,z = vRPclient.getPosition(source)
        local heading = vRPclient.getUserHeading(source)
		local lugar = vRP.prompt(source,"Lugar:","vector3("..tD(x)..","..tD(y)..","..tD(z).."), heading = "..tD(heading).."")
		if lugar == "" then
			return
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS HOUSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cdsh',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		local lugar = vRP.prompt(source,"Lugar:","")
		if lugar == "" then
			return
		end
	    SendWebhookMessage(webhookcds,"```prolog\n[PASSAPORTE]: "..user_id.." \n[LUGAR]: "..lugar.." \n[CDSH]: [] = { ['x'] = "..tD(x)..", ['y'] = "..tD(y)..", ['z'] = "..tD(z)..", ['name'] = "..lugar..", \r```")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS GARAGEM HEADING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cdsg',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		local lugar = vRP.prompt(source,"Lugar:","")
		local heading = vRPclient.getUserHeading(source)
		if lugar == "" then
			return
		end
		SendWebhookMessage(webhookcds,"```prolog\n[PASSAPORTE]: "..user_id.." \n[LUGAR]: "..lugar.." \n[CDSG]: [1] = { ['x'] = "..tD(x)..", ['y'] = "..tD(y)..", ['z'] = "..tD(z)..", ['h'] = "..tD(heading).." }\n}, \r```")
	end
end)

RegisterCommand('cdsr',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		local lugar = vRP.prompt(source,"Lugar:","")
		if lugar == "" then
			return
		end
		SendWebhookMessage(webhookcds,"```prolog\n { name = "..lugar..", coords = vector3("..tD(x)..","..tD(y)..","..tD(z)..") }, \r```")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS CORRIDAS
-----------------------------------------------------------------------------------------------------------------------------------------
local count = 0
RegisterCommand('count',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        count = 0
        SendWebhookMessage(webhookcds,"```prolog\nPROXIMA CORRIDA```")
    end
end)

RegisterServerEvent("cds:corridas")
AddEventHandler("cds:corridas",function(coords)
    count = count + 1
    local x,y,z = vRPclient.getPosition(source)
    SendWebhookMessage(webhookcds,"```prolog\n["..count.."] = { coords = "..coords.." }, \r```")
end)

function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('group',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
        if args[1] and args[2] then
            local identity2 = vRP.getUserIdentity(parseInt(args[1]))
            if vRP.request(source,"Deseja adicionar o Passaporte: <b>"..vRP.format(parseInt(args[1])).." "..identity2.name.." "..identity2.firstname.."</b> no grupo <b>"..args[2].."</b> ?",30) then
                vRP.addUserGroup(parseInt(args[1]),args[2])
                TriggerClientEvent("Notify",source,"sucesso","Voce adicionou o Passaporte: <b>"..vRP.format(parseInt(args[1])).."</b> no grupo <b>"..args[2].."</b>.")
                SendWebhookMessage(webhookadmin,"```prolog\n[ADMIN]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ADICIONOU]: "..parseInt(args[1]).." "..identity2.name.." "..identity2.firstname.." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ungroup',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
        if args[1] and args[2] then
            local identity2 = vRP.getUserIdentity(parseInt(args[1]))
            if vRP.request(source,"Deseja remover o Passaporte: <b>"..vRP.format(parseInt(args[1])).." "..identity2.name.." "..identity2.firstname.."</b> do grupo <b>"..args[2].."</b> ?",30) then
                vRP.removeUserGroup(parseInt(args[1]),args[2])
                TriggerClientEvent("Notify",source,"sucesso","Voce removeu o Passaporte: <b>"..vRP.format(parseInt(args[1])).."</b> do grupo <b>"..args[2].."</b>.")
                SendWebhookMessage(webhookadmin,"```prolog\n[ADMIN]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..parseInt(args[1]).." "..identity2.name.." "..identity2.firstname.." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpall',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        local usersg = vRP.getUsers()
        for k,v in pairs(usersg) do
            local tplayer = vRP.getUserSource(parseInt(k))
            local x,y,z = vRPclient.getPosition(source)
            if tplayer ~= nil and tplayer ~= source then
                async(function()
                    vRPclient.teleport(tplayer,x,y,z)
                end)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tptome',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			local x,y,z = vRPclient.getPosition(source)
			if tplayer then
				vRPclient.teleport(tplayer,x,y,z)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpto',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			if tplayer then
				vRPclient.teleport(source,vRPclient.getPosition(tplayer))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpway',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
		TriggerClientEvent('tptoway',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('car',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] then
            TriggerEvent("setPlateEveryone",identity.registration)
			TriggerClientEvent('spawnarveiculo',source,args[1])
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SPAWNOU]: "..(args[1]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELNPCS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('delnpcs',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		TriggerClientEvent('delnpcs',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('adm',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
		local mensagem = vRP.prompt(source,"Mensagem:","")
		if mensagem == "" then
			return
		end
		SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[MENSAGEM]: "..mensagem.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        if args[1] == "all" then
            TriggerClientEvent("vrp_sound:source",-1,'warning',0.5)
            SendWebhookMessage(webhookadminanuncio,"```prolog\n[ANUNCIO]: "..mensagem.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```@everyone")
        end
		vRPclient.setDiv(-1,"adm",".div_adm { background: rgba(255,50,50,0.8); font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 10%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 16px; }","<bold>"..mensagem.."</bold><br><br>Mensagem enviada por: Administrador")
		SetTimeout(60000,function()
			vRPclient.removeDiv(-1,"adm")
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /pon
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pon",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
        local users = vRP.getUsers()
        local players = ""
        local quantidade = GetNumPlayerIndices()
        for k,v in pairs(users) do
            players = players..k..", "
        end
        TriggerClientEvent('chatMessage',source,"TOTAL ONLINE",{255,160,0},quantidade)
        TriggerClientEvent('chatMessage',source,"ID's ONLINE",{255,160,0},players)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /ason
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ason',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local admin = vRP.getUsersByPermission("admin.permissao")
    local nadmin = 0
    local admin_nomes = ""

    local suporte = vRP.getUsersByPermission("suporte.permissao")
    local nsuporte = 0
    local suporte_nomes = ""
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
        for k,v in pairs(admin) do
            local identity = vRP.getUserIdentity(parseInt(v))
            admin_nomes = admin_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
            nadmin = nadmin + 1
        end
        TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..nadmin.." Admins</b> online.<br> "..admin_nomes)
    end

    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
        for k,v in pairs(suporte) do
            local identity = vRP.getUserIdentity(parseInt(v))
            suporte_nomes = suporte_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
            nsuporte = nsuporte + 1
        end
        TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..nsuporte.." Suportes</b> online.<br> "..suporte_nomes)
    end
end)