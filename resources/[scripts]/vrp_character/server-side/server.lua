local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local userlogin = {}
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
	if first_spawn then
		local data = vRP.getUData(user_id, "vRP:spawnController")
		local sdata = json.decode(data) or 0
		if sdata then
			Wait(1000)
			processSpawnController(source, sdata, user_id)
		end
	end
end)

function processSpawnController(source, statusSent, user_id)
	if statusSent == 2 then
		if not userlogin[user_id] then
			userlogin[user_id] = true
			doSpawnPlayer(source, user_id, false)
		else
			doSpawnPlayer(source, user_id, true)
		end
	elseif statusSent == 1 or statusSent == 0 then
		userlogin[user_id] = true
		TriggerClientEvent("vrp-character:characterCreate", source)
	end
end

RegisterServerEvent("vrp-character:finishedCharacter")
AddEventHandler("vrp-character:finishedCharacter", function(characterNome, characterSobrenome, characterAge, currentCharacterMode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.setUData(user_id, "currentCharacterMode", json.encode(currentCharacterMode))
		vRP.setUData(user_id, "vRP:spawnController", json.encode(2))
		doSpawnPlayer(source, user_id, true)
		forceUpdateName(user_id, characterNome, characterSobrenome, characterAge)
	end
end)

function forceUpdateName(user_id, characterNome, characterSobrenome, characterAge)
	local user_id = user_id
	local characterNome = characterNome
	local characterSobrenome = characterSobrenome
	local characterAge = characterAge

	vRP.execute("vRP/update_user_first_spawn", { user_id = user_id, firstname = characterSobrenome, name = characterNome, age = characterAge })
	if characterNome == "Individuo" then
		return
	end

	SetTimeout(10000, function()
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			if identity.name == "Individuo" then
				forceUpdateName(user_id, characterNome, characterSobrenome, characterAge)
			end
		else
			forceUpdateName(user_id, characterNome, characterSobrenome, characterAge)
		end
	end)
end

function doSpawnPlayer(source, user_id, firstspawn)
	TriggerClientEvent("vrp-character:normalSpawn", source, firstspawn)
	TriggerEvent("vrp-barbershop:init", user_id)
	SetTimeout(120000, function()
		TriggerClientEvent("checkcam", source, true)
	end)
end
