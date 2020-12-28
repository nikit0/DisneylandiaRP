local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")

vRP = {}
Proxy.addInterface("vRP",vRP)

tvRP = {}
Tunnel.bindInterface("vRP",tvRP)
vRPclient = Tunnel.getInterface("vRP")

vRP.users = {}
vRP.rusers = {}
vRP.user_tables = {}
vRP.user_tmp_tables = {}
vRP.user_sources = {}

local db_drivers = {}
local db_driver
local cached_prepares = {}
local cached_queries = {}
local prepared_queries = {}
local db_initialized = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookjoins = "https://discordapp.com/api/webhooks/583495157211594765/RiVbj9ZiOSLap5SGYSEIn1cufk_F4jqDeOydiomSgPKGohlxnqxdKOxhNPpqg5jbF0r9"
local webhookcrashesexit = "https://discordapp.com/api/webhooks/670034550520283188/Xv4DG4-PG9EB9pQ6ofTevFCtR7Ed6SIMVH9Jk52McGTXEp6ndkSiKZUp23-Xw-pRwpGs"
local webhookpolicia = "https://discordapp.com/api/webhooks/624333914143457300/WHmIZeCcHy0m666zp2ednPaKfbbkjDCDMalb_-cIVMbkXeix94v6eD2JvMzkuqeuY44l"
local webhookparamedico = "https://discordapp.com/api/webhooks/624334236933029900/G3WuTyWoXktdG8xvbV5YZSlGcKob4QIGiCAfbqv4RDW1EA7YdpWXDMfEOLUl_OZLZNW2"
local webhookmecanico = "https://discordapp.com/api/webhooks/615738661924765725/jKOys6iSBFWSmt2nafrF2A1_OxAig6rZUkQFb6OT-9YMpmK96myAiLCZupNTrg88i2Yn"
local webhookjuiz = "https://discordapp.com/api/webhooks/629674264466948116/MjZaCqRolmZiH3ykzt_tLGD1BhLLeWKGGzTt6BurTL_dMlr6fOCsocXvkW5wy7wcD4-Q"
local webhookadvogado = "https://discordapp.com/api/webhooks/629674340539170836/9dfmg7ffkQ7TEHou4iP9dq1UHpFRdmPa9s3GYXMPlb-sEAdNLoxiy7Qi8VXyi1o7MSZh"
local webhookgarmasbug = "https://discordapp.com/api/webhooks/623413446515621891/6a76famEQU18K0I8P70hskBMS7n_LbF9cxus7-x2yvbmx70iCOBgrOpJONRoh3_lHD2Y"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BASE.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.registerDBDriver(name,on_init,on_prepare,on_query)
	if not db_drivers[name] then
		db_drivers[name] = { on_init,on_prepare,on_query }

		if name == "ghmattimysql" then
			db_driver = db_drivers[name]

			local ok = on_init("disneylandiarp")
			if ok then
				db_initialized = true
				for _,prepare in pairs(cached_prepares) do
					on_prepare(table.unpack(prepare,1,table.maxn(prepare)))
				end

				for _,query in pairs(cached_queries) do
					query[2](on_query(table.unpack(query[1],1,table.maxn(query[1]))))
				end

				cached_prepares = nil
				cached_queries = nil
			end
		end
	end
end

function vRP.format(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function vRP.prepare(name,query)
	prepared_queries[name] = true

	if db_initialized then
		db_driver[2](name,query)
	else
		table.insert(cached_prepares,{ name,query })
	end
end

function vRP.query(name,params,mode)
	if not mode then mode = "query" end

	if db_initialized then
		return db_driver[3](name,params or {},mode)
	else
		local r = async()
		table.insert(cached_queries,{{ name,params or {},mode },r })
		return r:wait()
	end
end

function vRP.execute(name,params)
	return vRP.query(name,params,"execute")
end

function vRP.getUserIdByIdentifiers(ids)
	if ids and #ids then
		for i=1,#ids do
			if (string.find(ids[i],"ip:") == nil) then
				local rows = vRP.query("vRP/userid_byidentifier",{ identifier = ids[i] })
				if #rows > 0 then
					return rows[1].user_id
				end
			end
		end

		local rows,affected = vRP.query("vRP/create_user",{})

		if #rows > 0 then
			local user_id = rows[1].id
			local steam
			for l,w in pairs(ids) do
				if string.find(w,"steam:") then
					steam = w
				end
				if (string.find(w,"ip:") == nil) then
					vRP.execute("vRP/add_identifier",{ user_id = user_id, identifier = w })
				end
			end
			vRP.execute("vRP/set_steam",{ user_id = user_id, steam = steam })
			return user_id
		end
	end
end

function vRP.getPlayerEndpoint(player)
	return GetPlayerEP(player) or "0.0.0.0"
end

function vRP.isBanned(user_id, cbr)
	local rows = vRP.query("vRP/get_banned",{ user_id = user_id })
	if #rows > 0 then
		return rows[1].banned
	else
		return false
	end
end

function dump(o)
	if type(o) == 'table' then
	   local s = '{ '
	   for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. dump(v) .. ','
	   end
	   return s .. '} '
	else
	   return tostring(o)
	end
 end

function vRP.isIdentifiersBanned(user_id)
	local identifiers = GetPlayerIdentifiers(user_id)
	--local s = ""
	local total = 0
	for k,v in pairs(identifiers) do
		--s = s.."'"..v.."',"
		local count = vRP.query("vRP/get_banned_identifiers", { identifier = v })
		total = total + #count
	end
	--local buffer = s:sub(1, #s - 1)
	return total > 0
end

function vRP.setBanned(user_id,banned,hack)
	local identifiers = vRP.query("vRP/get_identifiers_by_userid", { user_id = user_id })
	if banned == false then
		vRP.execute("vRP/rem_banned_identifiers", { user_id = user_id })
	else
		for k,v in pairs(identifiers) do
			for l,w in pairs(v) do
				if hack == 1 then
					vRP.execute("vRP/add_banned",{ user_id = user_id, identifier = w, hacker = 1 })
				else
					vRP.execute("vRP/add_banned",{ user_id = user_id, identifier = w, hacker = 0 })
				end
			end
		end
	end
	vRP.execute("vRP/set_banned",{ user_id = user_id, banned = banned })
end

function setBanned(user_id,banned,hack)
	source = source
	local identifiers = vRP.query("vRP/get_identifiers_by_userid", { user_id = user_id })
	if banned == false then
		vRP.execute("vRP/rem_banned_identifiers", { user_id = user_id })
	else
		for k,v in pairs(identifiers) do
			for l,w in pairs(v) do
				if hack == 1 then
					vRP.execute("vRP/add_banned",{ user_id = user_id, identifier = w, hacker = 1 })
				else
					vRP.execute("vRP/add_banned",{ user_id = user_id, identifier = w, hacker = 0 })
				end
			end
		end
	end
	vRP.execute("vRP/set_banned",{ user_id = user_id, banned = banned })
end
exports("setBanned",setBanned)

function vRP.isWhitelisted(user_id, cbr)
	local rows = vRP.query("vRP/get_whitelisted",{ user_id = user_id })
	if #rows > 0 then
		return rows[1].whitelisted
	else
		return false
	end
end

function vRP.setWhitelisted(user_id,whitelisted)
	vRP.execute("vRP/set_whitelisted",{ user_id = user_id, whitelisted = whitelisted })
end

function vRP.setUData(user_id,key,value)
	vRP.execute("vRP/set_userdata",{ user_id = user_id, key = key, value = value })
end

function vRP.getUData(user_id,key,cbr)
	local rows = vRP.query("vRP/get_userdata",{ user_id = user_id, key = key })
	if #rows > 0 then
		return rows[1].dvalue
	else
		return ""
	end
end

function vRP.setSData(key,value)
	vRP.execute("vRP/set_srvdata",{ key = key, value = value })
end

function vRP.getSData(key, cbr)
	local rows = vRP.query("vRP/get_srvdata",{ key = key })
	if #rows > 0 then
		return rows[1].dvalue
	else
		return ""
	end
end

function vRP.getUserDataTable(user_id)
	return vRP.user_tables[user_id]
end

function vRP.getUserTmpTable(user_id)
	return vRP.user_tmp_tables[user_id]
end

function vRP.getUserId(source)
	if source ~= nil then
		local ids = GetPlayerIdentifiers(source)
		if ids ~= nil and #ids > 0 then
			return vRP.users[ids[1]]
		end
	end
	return nil
end

function getUserId(source)
	if source ~= nil then
		local ids = GetPlayerIdentifiers(source)
		if ids ~= nil and #ids > 0 then
			return vRP.users[ids[1]]
		end
	end
	return nil
end
exports("getUserId",getUserId)

function vRP.getUsers()
	local users = {}
	for k,v in pairs(vRP.user_sources) do
		users[k] = v
	end
	return users
end

function vRP.getUserSource(user_id)
	return vRP.user_sources[user_id]
end

function getUserSource(user_id)
	return vRP.user_sources[user_id]
end
exports("getUserSource",getUserSource)

function vRP.kick(source,reason)
	DropPlayer(source,reason)
end

function kick(source,reason)
	DropPlayer(source,reason)
end
exports("kick",kick)

function vRP.dropPlayer(source,reason)
	local source = source
	local user_id = vRP.getUserId(source)
	local steam = GetPlayerName(source)
	local steamhex = GetPlayerIdentifier(source)
	local ip = GetPlayerEndpoint(source)
	local ping = GetPlayerPing(source)
	vRPclient._removePlayer(-1,source)
	if user_id then
		if user_id and source then
			TriggerEvent("vRP:playerLeave",user_id,source)
			local identity = vRP.getUserIdentity(user_id)
			SendWebhookMessage(webhookcrashesexit,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[STEAM]: "..steam.." \n[STEAMHEX]: "..steamhex.." \n[IP]: "..ip.." \n[PING]: "..ping.." \n[MOTIVO]: "..reason.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			if vRP.hasGroup(user_id,"Taxista") then
				vRP.removeUserGroup(user_id,"Taxista")
			elseif vRP.hasGroup(user_id,"Policia") or vRP.hasGroup(user_id,"AcaoPolicia") then
				vRP.addUserGroup(user_id,"PaisanaPolicia")
				SendWebhookMessage(webhookpolicia,"```prolog\n[POLICIAL]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			elseif vRP.hasGroup(user_id,"Paramedico") then
				vRP.addUserGroup(user_id,"PaisanaParamedico")
				SendWebhookMessage(webhookparamedico,"```prolog\n[PARAMEDICO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")	
			elseif vRP.hasGroup(user_id,"Mecanico") then
				vRP.addUserGroup(user_id,"PaisanaMecanico")
				SendWebhookMessage(webhookmecanico,"```prolog\n[MECANICO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			elseif vRP.hasGroup(user_id,"Juiz") then
				vRP.addUserGroup(user_id,"PaisanaJuiz")
				SendWebhookMessage(webhookjuiz,"```prolog\n[JUIZ]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			elseif vRP.hasGroup(user_id,"Advogado") then
				vRP.addUserGroup(user_id,"PaisanaAdvogado")
				SendWebhookMessage(webhookadvogado,"```prolog\n[ADVOGADO]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===========SAIU DE SERVICO==========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
		vRP.setUData(user_id,"vRP:datatable",json.encode(vRP.getUserDataTable(user_id)))
		vRP.users[vRP.rusers[user_id]] = nil
		vRP.rusers[user_id] = nil
		vRP.user_tables[user_id] = nil
		vRP.user_tmp_tables[user_id] = nil
		vRP.user_sources[user_id] = nil
	end
end

function task_save_datatables()
	SetTimeout(60000,task_save_datatables)
	TriggerEvent("vRP:save")
	for k,v in pairs(vRP.user_tables) do
		vRP.setUData(k,"vRP:datatable",json.encode(v))
	end
end

async(function()
	task_save_datatables()
end)

AddEventHandler("queue:playerConnecting",function(source,ids,name,setKickReason,deferrals)
	deferrals.defer()
	local source = source
	local ids = ids

	if ids ~= nil and #ids > 0 then
		deferrals.update("Carregando identidades.")
		local user_id = vRP.getUserIdByIdentifiers(ids)
		if user_id then
			deferrals.update("Carregando banimentos.")
			if not vRP.isBanned(user_id) and not vRP.isIdentifiersBanned(source) then
				deferrals.update("Carregando whitelist.")
				if vRP.isWhitelisted(user_id) then
					if vRP.rusers[user_id] == nil then
						deferrals.update("Carregando banco de dados.")
						local sdata = vRP.getUData(user_id,"vRP:datatable")

						vRP.users[ids[1]] = user_id
						vRP.rusers[user_id] = ids[1]
						vRP.user_tables[user_id] = {}
						vRP.user_tmp_tables[user_id] = {}
						vRP.user_sources[user_id] = source

						local data = json.decode(sdata)
						if type(data) == "table" then vRP.user_tables[user_id] = data end

						local tmpdata = vRP.getUserTmpTable(user_id)
						tmpdata.spawns = 0

						TriggerEvent("vRP:playerJoin",user_id,source,name)
						SendWebhookMessage(webhookjoins,"```prolog\n[ID]: "..user_id.." \n[IP]: "..GetPlayerEndpoint(source).." \n[========ENTROU NO SERVIDOR========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						--vRP.execute("vRP/add_player_online",{ user_id = user_id })
						deferrals.done()				
					else
						local tmpdata = vRP.getUserTmpTable(user_id)
						tmpdata.spawns = 0

						TriggerEvent("vRP:playerRejoin",user_id,source,name)
						deferrals.done()
					end
				else
					deferrals.done("Seu ID: "..user_id..", entre em nosso discord e faça a Whitelist automática através do BOT.")
					TriggerEvent("queue:playerConnectingRemoveQueues",ids)
				end
			else
				deferrals.done("Você foi banido da cidade.")
				TriggerEvent("queue:playerConnectingRemoveQueues",ids)
			end
		else
			deferrals.done("Ocorreu um problema de identificação.")
			TriggerEvent("queue:playerConnectingRemoveQueues",ids)
		end
	else
		deferrals.done("Ocorreu um problema de identidade.")
		TriggerEvent("queue:playerConnectingRemoveQueues",ids)
	end
end)

AddEventHandler("playerDropped",function(reason)
	local source = source
	vRP.dropPlayer(source,reason)
end)

RegisterServerEvent("vRPcli:playerSpawned")
AddEventHandler("vRPcli:playerSpawned",function()
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.user_sources[user_id] = source
		local tmp = vRP.getUserTmpTable(user_id)
		tmp.spawns = tmp.spawns+1
		local first_spawn = (tmp.spawns == 1)

		if first_spawn then
			for k,v in pairs(vRP.user_sources) do
				vRPclient._addPlayer(source,v)
			end
			vRPclient._addPlayer(-1,source)
			Tunnel.setDestDelay(source,0)
		end
		TriggerEvent("vRP:playerSpawn",user_id,source,first_spawn)
	end
end)

function vRP.getDayHours(seconds)
    local days = math.floor(seconds/86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds/3600)

    if days > 0 then
        return string.format("<b>%d Dias</b> e <b>%d Horas</b>",days,hours)
    else
        return string.format("<b>%d Horas</b>",hours)
    end
end

function vRP.getMinSecs(seconds)
    local days = math.floor(seconds/86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds/3600)
    seconds = seconds - hours * 3600
    local minutes = math.floor(seconds/60)
    seconds = seconds - minutes * 60

	if minutes > 0 then
		if minutes == 1 then
			return string.format("<b>%d Minuto</b> e <b>%d Segundos</b>",minutes,seconds)
		else
			return string.format("<b>%d Minutos</b> e <b>%d Segundos</b>",minutes,seconds)
		end
    else
        return string.format("<b>%d Segundos</b>",seconds)
    end
end