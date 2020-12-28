-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("dl_ac",src)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookac = "https://discordapp.com/api/webhooks/673475372297355264/gg-IyjsevtH3UANL6c7Z1VV9-jqdjGqXT5P1ENic2Y5rgkkpkDkA1lxRT6FoG-Qs6Mly"
local webhookban = "https://discordapp.com/api/webhooks/711723243819761674/daKczbBadSjNT8OPEoHmjmre7YpLahadxpbuOrs2YtSfWEi9lpneD2Kl0fj5mCFUmOXO"
local LogoServer = "https://cdn.discordapp.com/icons/569721737730588692/a_22a49ee6382741bace9b9787af6df225.gif?size=2048"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FORBIDDEN EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
local events = {
    "bank:deposit",
    "bank:withdraw",
    "cacador-vender",
    "esx:giveInventoryItem",
    "esx_jobs:caution",
    "esx_fueldelivery:pay",
    "esx_carthief:pay",
    "esx_society:getOnlinePlayers",
    "esx_vehicleshop:setVehicleOwned",
    "esx_carthief:pay",
    "esx_jobs:caution",
    "esx_fueldelivery:pay",
    "esx_carthief:pay",
    "esx_godirtyjob:pay",
    "esx_pizza:pay",
    "esx_ranger:pay",
    "esx_garbagejob:pay",
    "esx_truckerjob:pay",
    "AdminMenu:giveBank",
    "AdminMenu:giveCash",
    "esx_gopostaljob:pay",
    "esx_banksecurity:pay",
    "esx_slotmachine:sv:2",
    "vrp_slotmachine:server:2",
    "Banca:deposit",
    "esx:giveInventoryItem",
    "esx_billing:sendBill",
    "lscustoms:payGarage",
    "LegacyFuel:PayFuel",
    "blarglebus:finishRoute",
    "dmv:success",
    "departamento-vender",
    "reanimar:pagamento",
    "adminmenu:allowall"
}

for i,eventName in ipairs(events) do
    RegisterNetEvent(eventName)
    AddEventHandler(eventName,function()
        src.AntiCheater("ServerEvents",eventName)
    end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION AC
-----------------------------------------------------------------------------------------------------------------------------------------
function src.AntiCheater(variable,reason)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local steam = GetPlayerName(source)
        local steamhex = ""
        local ip = ""
        local discord = ""
        local license = ""
        local fivem = ""
        local live = ""
        local xbl = ""

        for k,v in pairs(GetPlayerIdentifiers(source)) do
            if string.sub(v,1,string.len("steam:")) == "steam:" then
                steamhex = v
            elseif string.sub(v,1,string.len("ip:")) == "ip:" then
                ip = v
            elseif string.sub(v,1,string.len("discord:")) == "discord:" then
                discord = v
            elseif string.sub(v,1,string.len("license:")) == "license:" then
                license = v
            elseif string.sub(v,1,string.len("fivem:")) == "fivem:" then
                fivem = v          
            elseif string.sub(v,1,string.len("live:")) == "live:" then
                live = v
            elseif string.sub(v,1,string.len("xbl:")) == "xbl:" then
                xbl = v
            end
        end

        if variable == "ClientEvents" then
            TriggerClientEvent('screenshot:ac',source,"Client Events")
            SendWebhookMessage(webhookac,"```prolog\n[CLIENT EVENTS] \n[ID]: "..user_id.." \n[STEAM]: "..steam.." \n[STEAMHEX]: "..steamhex.." \n[IP]: "..ip.." \n[DISCORD]: "..discord.." \n[LICENSE]: "..license.." \n[FIVEM]: "..fivem.." \n[LIVE]: "..live.." \n[XBL]: "..xbl.." \n[EVENT]: "..reason.." \n[SERVER]: DL Games RP"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        elseif variable == "ServerEvents" then
            TriggerClientEvent('screenshot:ac',source,"Server Events")
            SendWebhookMessage(webhookac,"```prolog\n[SERVER EVENTS] \n[ID]: "..user_id.." \n[STEAM]: "..steam.." \n[STEAMHEX]: "..steamhex.." \n[IP]: "..ip.." \n[DISCORD]: "..discord.." \n[LICENSE]: "..license.." \n[FIVEM]: "..fivem.." \n[LIVE]: "..live.." \n[XBL]: "..xbl.." \n[EVENT]: "..reason.." \n[SERVER]: DL Games RP"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")    
        elseif variable == "Cam" then
            TriggerClientEvent('screenshot:ac',source,"Cam")
            SendWebhookMessage(webhookac,"```prolog\n[SPECTATE / SPAWN OBJECT]\n[ID]: "..user_id.." \n[STEAM]: "..steam.." \n[STEAMHEX]: "..steamhex.." \n[IP]: "..ip.." \n[DISCORD]: "..discord.." \n[LICENSE]: "..license.." \n[FIVEM]: "..fivem.." \n[LIVE]: "..live.." \n[XBL]: "..xbl.." \n[CAM]: "..reason.." \n[SERVER]: DL Games RP"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        elseif variable == "Modifier" then
            TriggerClientEvent('screenshot:ac',source,"Damage Modifier")
            SendWebhookMessage(webhookac,"```prolog\n[DAMAGE MODIFIER]\n[ID]: "..user_id.." \n[STEAM]: "..steam.." \n[STEAMHEX]: "..steamhex.." \n[IP]: "..ip.." \n[DISCORD]: "..discord.." \n[LICENSE]: "..license.." \n[FIVEM]: "..fivem.." \n[LIVE]: "..live.." \n[XBL]: "..xbl.." \n[DAMAGE]: "..reason.." \n[SERVER]: DL Games RP"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        end
        SendWebhookMessage(webhookban,"```prolog\n[ID]: "..user_id.." \n[MOTIVO]: Hacker \n[TEMPO]: 2099 "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        
        Citizen.Wait(10000)
        vRP.setBanned(parseInt(user_id),true,1)
        vRP.setWhitelisted(parseInt(user_id),false)
        local id = vRP.getUserSource(parseInt(user_id))
        if id then
            if variable == "ClientEvents" or variable == "ServerEvents" or variable == "Cam" or variable == "Modifier" then
                vRP.kick(id,"Você foi banido da cidade por uso de hack.")
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION AC MENU
-----------------------------------------------------------------------------------------------------------------------------------------
function src.AntiCheaterMenu(variable,reason)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local steam = GetPlayerName(source)
        local steamhex = ""
        local ip = ""
        local discord = ""
        local license = ""
        local fivem = ""
        local live = ""
        local xbl = ""

        for k,v in pairs(GetPlayerIdentifiers(source)) do
            if string.sub(v,1,string.len("steam:")) == "steam:" then
                steamhex = v
            elseif string.sub(v,1,string.len("ip:")) == "ip:" then
                ip = v
            elseif string.sub(v,1,string.len("discord:")) == "discord:" then
                discord = v
            elseif string.sub(v,1,string.len("license:")) == "license:" then
                license = v
            elseif string.sub(v,1,string.len("fivem:")) == "fivem:" then
                fivem = v          
            elseif string.sub(v,1,string.len("live:")) == "live:" then
                live = v
            elseif string.sub(v,1,string.len("xbl:")) == "xbl:" then
                xbl = v
            end
        end

        if variable == "Armour" then
            TriggerClientEvent('screenshot:ac',source,"Armour")
            SendWebhookMessage(webhookac,"```prolog\n[ARMOUR EVENTS] \n[ID]: "..user_id.." \n[STEAM]: "..steam.." \n[STEAMHEX]: "..steamhex.." \n[IP]: "..ip.." \n[DISCORD]: "..discord.." \n[LICENSE]: "..license.." \n[FIVEM]: "..fivem.."\n[LIVE]: "..live.." \n[XBL]: "..xbl.." \n[ARMOUR]: "..reason.." \n[SERVER]: DL Games RP"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        elseif variable == "Menu" then
            TriggerClientEvent('screenshot:ac',source,"Menu") 
            SendWebhookMessage(webhookac,"```prolog\n[MENU EVENTS] \n[ID]: "..user_id.." \n[STEAM]: "..steam.." \n[STEAMHEX]: "..steamhex.." \n[IP]: "..ip.." \n[DISCORD]: "..discord.." \n[LICENSE]: "..license.." \n[FIVEM]: "..fivem.." \n[LIVE]: "..live.." \n[XBL]: "..xbl.." \n[SERVER]: DL Games RP"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        elseif variable == "AntiCopy" then
            vRP.setBanned(parseInt(user_id),true,1)
            vRP.setWhitelisted(parseInt(user_id),false)
            SendWebhookMessage(webhookac,"```prolog\n[HTML ANTICOPY] \n[ID]: "..user_id.." \n[STEAM]: "..steam.." \n[STEAMHEX]: "..steamhex.." \n[IP]: "..ip.." \n[DISCORD]: "..discord.." \n[LICENSE]: "..license.." \n[FIVEM]: "..fivem.." \n[LIVE]: "..live.." \n[XBL]: "..xbl.." \n[SERVER]: DL Games RP"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
            SendWebhookMessage(webhookban,"```prolog\n[ID]: "..user_id.." \n[MOTIVO]: Hacker \n[TEMPO]: 2099 "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        end
 
        local id = vRP.getUserSource(parseInt(user_id))
        if id then
            if variable == "AntiCopy" then
                vRP.kick(id,"Você foi banido por tentar roubar o HTML da cidade.")
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SCREENSHOT
-----------------------------------------------------------------------------------------------------------------------------------------
function src.Screenshot(url,reason)
    local nName = GetPlayerName(source)
    local nUser = vRP.getUserId(source) or "SOLO"
    local uFields = {}
    if nName then
        table.insert(uFields,{ ["name"] = "Nome da Steam", ["value"] = nName, ["inline"] = true })
    end
    if nUser then
        table.insert(uFields,{ ["name"] = "User ID", ["value"] = nUser, ["inline"] = true })
    end
    table.insert(uFields,{ ["name"] = "Server ID", ["value"] = source, ["inline"] = true })
    table.insert(uFields,{ ["name"] = "Motivo", ["value"] = reason })
        Image = LogoServer
        if GetIDFromSource("steam", source) then
        table.insert(uFields,{ ["name"] = "Steam", ["value"] = "http://steamcommunity.com/profiles/"..tonumber(GetIDFromSource("steam",source),16) })
        table.insert(uFields,{ ["name"] = "Screenshot", ["value"] = "Printscreen Tirada da Tela do Jogador"})
        PerformHttpRequest("http://steamcommunity.com/profiles/"..tonumber(GetIDFromSource("steam",source),16) .."/?xml=1",
        function(Error,Content,Head)
            local SteamProfileSplitted = stringsplit(Content,"\n")
            for i,Line in ipairs(SteamProfileSplitted) do
                if Line:find("<avatarFull>") then
                    Image = Line:gsub("<avatarFull><!%[CDATA%[",""):gsub("]]></avatarFull>","")
                    local dsData = {
                        {
                            ["color"] = 16711680,
                            ["title"] = "Anti Cheat",
                            ["fields"] = uFields,
                            ["image"] = {
                                ["url"] = url
                            },
                            ["footer"] = {
                                ["text"] = "DLGames RP",
                                ["icon_url"] = LogoServer
                            }
                        }
                    }
                    PerformHttpRequest(webhookac,function(Error,Content,Head)end,"POST",json.encode({ username = GetPlayerName(source), avatar_url = Image, embeds = dsData }),{["Content-Type"] = "application/json"})
                    return 
                end
            end
        end)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPLOSION EVENT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler('explosionEvent',function(sender,ev)
	local OwnerNetID = ev["ownerNetId"]
	local ExplosionType = ev["explosionType"]
	if not ExplosionType == 7 or not ExplosionType == 9 then
        SendWebhookMessage(webhookac,"```prolog\n[EXPLOSION EVENTS] \n[ID]: "..vRP.getUserId(sender).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        SendWebhookMessage(webhookban,"```prolog\n[ID]: "..user_id.." \n[MOTIVO]: Hacker \n[TEMPO]: 2099 "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        TriggerClientEvent('screenshot:ac',source,"Explosion Event")
        CancelEvent() 
        local user_id = vRP.getUserId(sender)
        if user_id ~= 2 then
            vRP.setBanned(parseInt(user_id),true,1)
            vRP.setWhitelisted(parseInt(user_id),false)
            local id = vRP.getUserSource(parseInt(user_id))
            if id then  
                vRP.kick(id,"Você foi banido da cidade por uso de hack.")
            end
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET ID FROM SOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetIDFromSource(Type,ID)
	local IDs = GetPlayerIdentifiers(ID)
	for k,CurrentID in pairs(IDs) do
		local ID = stringsplit(CurrentID,":")
		if ID[1]:lower() == string.lower(Type) then
			return ID[2]:lower()
		end
	end
	return nil
end

function stringsplit(input, seperator)
	if seperator == nil then
		seperator = "%s"
	end

	local t = {}
	i = 1

	for str in string.gmatch(input,"([^"..seperator.."]+)") do
		t[i] = str
		i = i + 1
    end
    
	return t
end