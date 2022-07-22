-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local pets = {
	["rottweiler"] = { name = "Rottweiler", funcao = "rottweiler", price = 9000 },
	["gato"] = { name = "Gato", funcao = "gato", price = 5000 },
	["lobo"] = { name = "Lobo", funcao = "lobo", price = 6000 },
	["coelho"] = { name = "Coelho", funcao = "coelho", price = 3000 },
	["husky"] = { name = "Husky", funcao = "husky", price = 8000 },
	["porco"] = { name = "Porco", funcao = "porco", price = 2500 },
	["poodle"] = { name = "Poodle", funcao = "poodle", price = 4000 },
	["pug"] = { name = "Pug", funcao = "pug", price = 4500 },
	["retriever"] = { name = "Retriever", funcao = "retriever", price = 8000 },
	["caoalsatian"] = { name = "Cão Alsatian", funcao = "caoalsatian", price = 7500 },
	["westie"] = { name = "Westie", funcao = "westie", price = 6000 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOME DO ANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_pets:animalname")
AddEventHandler("vrp_pets:animalname",function(source,method)
	local source = source
	local player = vRP.getUserId(source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MORTE DO ANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_pets:dead")
AddEventHandler("vrp_pets:dead",function()
	local source = source
	local player = vRP.getUserId(source)
	vRP.execute("disneylandia/update_pets",{ id = player })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALIMENTAR O ANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('vrp_pets:alimentar')
AddEventHandler('vrp_pets:alimentar',function()
	local source = source
	local player = vRP.getUserId(source)
	exports["pd-inventory"]:consumeItem(player, "racao", 1, true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPRAR O ANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_pets:buypet")
AddEventHandler("vrp_pets:buypet",function()
	local source = source
	local player = vRP.getUserId(source)
	local menudata = {}
	
	menudata.name = "Loja de Animais"
	menudata.css = { align = 'top-left' }

	for k,v in pairs(pets) do
		menudata[v.name] = {function(choice)
			local playerMoney = vRP.getMoney(source)
			if vRP.tryPayment(player,v.price) then
				vRP.execute("disneylandia/get_pets",{ pets = pets[k].funcao, id = player })
				TriggerClientEvent("Notify",source,"sucesso","Você comprou um <b>"..pets[k].name.."</b> por <b>$"..vRP.format(parseInt(v.price)).." dólares</b>.")
			else 
				TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
			end
			vRP.closeMenu(source)
		end,"<text01>Valor: </text01><text02><b>$"..vRP.format(parseInt(v.price)).."</b></text02>"}
	end
	vRP.openMenu(source,menudata)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENU GERAL DO ANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_pets:petMenu")
AddEventHandler("vrp_pets:petMenu",function(status,come,isInVehicle)
	local source = source
	local player = vRP.getUserId(source)
	local menudata = {}

	menudata.name = "Pets"
	menudata.css = { align = 'top-left' }

	if come == 1 then
		if status > 100 then
			status = 100
		end
		
		menudata["Dar comida"] = {function(choice)
			if exports["pd-inventory"]:getItemAmount(player, "racao") >= 1 then
				TriggerClientEvent("vrp_pets:givefood",source)
			end
		end,"<text01>Alimentado: </text01><text02><b>"..status.."%</b></text02>",TriggerClientEvent("Notify",source,"sucesso","Alimentado: <b>"..status.."%</b>")}
		
		menudata["Juntar ou Separar"] = {function(choice)
			TriggerClientEvent("vrp_pets:attachdettach",source)
		end}

		if isInVehicle then
			menudata["Tirar do carro"] = {function(choice)
				TriggerClientEvent("vrp_pets:enterleaveveh",source)
			end}
		else
			menudata["Colocar no carro"] = {function(choice)
				TriggerClientEvent("vrp_pets:enterleaveveh",source)
			end}
		end

		menudata["Dar uma ordem"] = {function(choice)
			local rows = vRP.query("disneylandia/get_users",{ id = player })
			if #rows > 0 then
				TriggerClientEvent("vrp_pets:orders",source,rows[1].pets)
			end
		end}
	else
		menudata["Chamar seu Pet"] = {function(choice)
			if come == 0 then
				local rows = vRP.query("disneylandia/get_users",{ id = player })
				if #rows > 0 then
					TriggerClientEvent("vrp_pets:callPet",source,rows[1].pets)
				end
				vRP.closeMenu(source)
			end
		end}
	end
	vRP.openMenu(source,menudata)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MENU GERAL DO ANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_pets:ordersMenu")
AddEventHandler("vrp_pets:ordersMenu",function(data,model,inanimation)
	local source = source
	local player = vRP.getUserId(source)
	local menudata = {}

	menudata.name = "Ordens do Pet"
	menudata.css = { align = 'top-left' }

	if not inanimation then
		if model ~= 1462895032 then
			menudata["Procurar a bola"] = {function(choice)
				TriggerClientEvent("vrp_pets:findball",source)
				vRP.closeMenu(source)
			end}
		end
		-- menudata["Seguir-me"] = {function(choice)
		-- 	TriggerClientEvent("vrp_pets:followme",source)
		-- end}
		menudata["Entrar na casinha"] = {function(choice)
			TriggerClientEvent("vrp_pets:goHome",source)
			vRP.closeMenu(source)
		end}

		if (data == "rottweiler") then
			menudata["Sentar"] = {function(choice)
				TriggerClientEvent("vrp_pets:seat",source,1)
				vRP.closeMenu(source)
			end}
			menudata["Deitar"] = {function(choice)
				TriggerClientEvent("vrp_pets:laydown",source,1)
				vRP.closeMenu(source)
			end}
		end
		if (data == "gato") then
			menudata["Deitar"] = {function(choice)
				TriggerClientEvent("vrp_pets:laydown",source,2)
				vRP.closeMenu(source)
			end}
		end
		if (data == "lobo") then
			menudata["Deitar"] = {function(choice)
				TriggerClientEvent("vrp_pets:laydown",source,3)
				vRP.closeMenu(source)
			end}
		end
		if (data == "pug") then
			menudata["Sentar"] = {function(choice)
				TriggerClientEvent("vrp_pets:seat",source,2)
				vRP.closeMenu(source)
			end}
		end
		if (data == "retriever") then
			menudata["Sentar"] = {function(choice)
				TriggerClientEvent("vrp_pets:seat",source,3)
				vRP.closeMenu(source)
			end}
		end
	else
		menudata["Levantar"] = {function(choice)
			TriggerClientEvent("vrp_pets:standup",source)
			vRP.closeMenu(source)
		end}
	end
	vRP.openMenu(source,menudata)
end)