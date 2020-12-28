-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local sanitizes = module("cfg/sanitizes")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_homes",src)
vCLIENT = Tunnel.getInterface("vrp_homes")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookbaucasas = "https://discordapp.com/api/webhooks/595667589837881346/Eg6b-cri7HI2NkrhJ2v0DiTK-veTcSyMXWlf9eBU-jjymJokJEvajEvn4Tjerzq_hYJy"
local webhookpoliciainvade = "https://discordapp.com/api/webhooks/644154494791319568/IYmmdU4_Pv6Ov4aSrHLMkk5A0nKxsPybwNRCsG7pt7jD2cNQwYha_RoKhVQ1SjyThIeR"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMESINFO
-----------------------------------------------------------------------------------------------------------------------------------------
local homes = {
-----------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------FORTHILLS-----------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	["FH01"] = { 1000000,2,1000 },
	["FH02"] = { 1000000,2,1000 },
	["FH03"] = { 1000000,2,1000 },
	["FH04"] = { 1000000,2,1000 },
	["FH05"] = { 1000000,2,1000 },
	["FH06"] = { 1000000,2,1000 },
	["FH07"] = { 1000000,2,1000 },
	["FH08"] = { 1000000,2,1000 },
	["FH09"] = { 1000000,2,1000 },
	["FH10"] = { 1000000,2,1000 },
	["FH11"] = { 1000000,2,1000 },
	["FH12"] = { 1000000,2,1000 },
	["FH13"] = { 1000000,2,1000 },
	["FH14"] = { 1000000,2,1000 },
	["FH15"] = { 1000000,2,1000 },
	["FH16"] = { 1000000,2,1000 },
	["FH17"] = { 1000000,2,1000 },
	["FH18"] = { 1000000,2,1000 },
	["FH19"] = { 1000000,2,1000 },
	["FH20"] = { 1000000,2,1000 },
	["FH21"] = { 1000000,2,1000 },
	["FH22"] = { 1000000,2,1000 },
	["FH23"] = { 1000000,2,1000 },
	["FH24"] = { 1000000,2,1000 },
	["FH25"] = { 1000000,2,1000 },
	["FH26"] = { 1000000,2,1000 },
	["FH27"] = { 1000000,2,1000 },
	["FH28"] = { 1000000,2,1000 },
	["FH29"] = { 1000000,2,1000 },
	["FH30"] = { 1000000,2,1000 },
	["FH31"] = { 1000000,2,1000 },
	["FH32"] = { 1000000,2,1000 },
	["FH33"] = { 1000000,2,1000 },
	["FH34"] = { 1000000,2,1000 },
	["FH35"] = { 1000000,2,1000 },
	["FH36"] = { 1000000,2,1000 },
	["FH37"] = { 1000000,2,1000 },
	["FH38"] = { 1000000,2,1000 },
	["FH39"] = { 1000000,2,1000 },
	["FH40"] = { 1000000,2,1000 },
	["FH41"] = { 1000000,2,1000 },
	["FH42"] = { 1000000,2,1000 },
	["FH43"] = { 1000000,2,1000 },
	["FH44"] = { 1000000,2,1000 },
	["FH45"] = { 1000000,2,1000 },
	["FH46"] = { 1000000,2,1000 },
	["FH47"] = { 1000000,2,1000 },
	["FH48"] = { 1000000,2,1000 },
	["FH49"] = { 1000000,2,1000 },
	["FH50"] = { 1000000,2,1000 },
	["FH51"] = { 1000000,2,1000 },
	["FH52"] = { 1000000,2,1000 },
	["FH53"] = { 1000000,2,1000 },
	["FH54"] = { 1000000,2,1000 },
	["FH55"] = { 1000000,2,1000 },
	["FH56"] = { 1000000,2,1000 },
	["FH57"] = { 1000000,2,1000 },
	["FH58"] = { 1000000,2,1000 },
	["FH59"] = { 1000000,2,1000 },
	["FH60"] = { 1000000,2,1000 },
	["FH61"] = { 1000000,2,1000 },
	["FH62"] = { 1000000,2,1000 },
	["FH63"] = { 1000000,2,1000 },
	["FH64"] = { 1000000,2,1000 },
	["FH65"] = { 1000000,2,1000 },
	["FH66"] = { 1000000,2,1000 },
	["FH67"] = { 1000000,2,1000 },
	["FH68"] = { 1000000,2,1000 },
	["FH69"] = { 1000000,2,1000 },
	["FH70"] = { 1000000,2,1000 },
	["FH71"] = { 1000000,2,1000 },
	["FH72"] = { 1000000,2,1000 },
	["FH73"] = { 1000000,2,1000 },
	["FH74"] = { 1000000,2,1000 },
	["FH75"] = { 1000000,2,1000 },
	["FH76"] = { 1000000,2,1000 },
	["FH77"] = { 1000000,2,1000 },
	["FH78"] = { 1000000,2,1000 },
	["FH79"] = { 1000000,2,1000 },
	["FH80"] = { 1000000,2,1000 },
	["FH81"] = { 1000000,2,1000 },
	["FH82"] = { 1000000,2,1000 },
	["FH83"] = { 1000000,2,1000 },
	["FH84"] = { 1000000,2,1000 },
	["FH85"] = { 1000000,2,1000 },
	["FH86"] = { 1000000,2,1000 },
	["FH87"] = { 1000000,2,1000 },
	["FH88"] = { 1000000,2,1000 },
	["FH89"] = { 1000000,2,1000 },
	["FH90"] = { 1000000,2,1000 },
	["FH91"] = { 1000000,2,1000 },
	["FH92"] = { 1000000,2,1000 },
	["FH93"] = { 1000000,2,1000 },
	["FH94"] = { 1000000,2,1000 },
	["FH95"] = { 1000000,2,1000 },
	["FH96"] = { 1000000,2,1000 },
	["FH97"] = { 1000000,2,1000 },
	["FH98"] = { 1000000,2,1000 },
	["FH99"] = { 1000000,2,1000 },
	["FH100"] = { 1000000,2,1000 },
-----------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------LUXURY--------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	["LX01"] = { 1000000,2,1000 },
	["LX02"] = { 1000000,2,1000 },
	["LX03"] = { 1000000,2,1000 },
	["LX04"] = { 1000000,2,1000 },
	["LX05"] = { 1000000,2,1000 },
	["LX06"] = { 1000000,2,1000 },
	["LX07"] = { 1000000,2,1000 },
	["LX08"] = { 1000000,2,1000 },
	["LX09"] = { 1000000,2,1000 },
	["LX10"] = { 1000000,2,1000 },
	["LX11"] = { 1000000,2,1000 },
	["LX12"] = { 1000000,2,1000 },
	["LX13"] = { 1000000,2,1000 },
	["LX14"] = { 1000000,2,1000 },
	["LX15"] = { 1000000,2,1000 },
	["LX16"] = { 1000000,2,1000 },
	["LX17"] = { 1000000,2,1000 },
	["LX18"] = { 1000000,2,1000 },
	["LX19"] = { 1000000,2,1000 },
	["LX20"] = { 1000000,2,1000 },
	["LX21"] = { 1000000,2,1000 },
	["LX22"] = { 1000000,2,1000 },
	["LX23"] = { 1000000,2,1000 },
	["LX24"] = { 1000000,2,1000 },
	["LX25"] = { 1000000,2,1000 },
	["LX26"] = { 1000000,2,1000 },
	["LX27"] = { 1000000,2,1000 },
	["LX28"] = { 1000000,2,1000 },
	["LX29"] = { 1000000,2,1000 },
	["LX30"] = { 1000000,2,1000 },
	["LX31"] = { 1000000,2,1000 },
	["LX32"] = { 1000000,2,1000 },
	["LX33"] = { 1000000,2,1000 },
	["LX34"] = { 1000000,2,1000 },
	["LX35"] = { 1000000,2,1000 },
	["LX36"] = { 1000000,2,1000 },
	["LX37"] = { 1000000,2,1000 },
	["LX38"] = { 1000000,2,1000 },
	["LX39"] = { 1000000,2,1000 },
	["LX40"] = { 1000000,2,1000 },
	["LX41"] = { 1000000,2,1000 },
	["LX42"] = { 1000000,2,1000 },
	["LX43"] = { 1000000,2,1000 },
	["LX44"] = { 1000000,2,1000 },
	["LX45"] = { 1000000,2,1000 },
	["LX46"] = { 1000000,2,1000 },
	["LX47"] = { 1000000,2,1000 },
	["LX48"] = { 1000000,2,1000 },
	["LX49"] = { 1000000,2,1000 },
	["LX50"] = { 1000000,2,1000 },
	["LX51"] = { 1000000,2,1000 },
	["LX52"] = { 1000000,2,1000 },
	["LX53"] = { 1000000,2,1500 },
	["LX54"] = { 1000000,2,1000 },
	["LX55"] = { 1000000,2,1000 },
	["LX56"] = { 1000000,2,1000 },
	["LX57"] = { 1000000,2,1000 },
	["LX58"] = { 1000000,2,1000 },
	["LX59"] = { 1000000,2,1000 },
	["LX60"] = { 1000000,2,1000 },
	["LX61"] = { 1000000,2,1000 },
	["LX62"] = { 1000000,2,1000 },
	["LX63"] = { 1000000,2,1000 },
	["LX64"] = { 1000000,2,1000 },
	["LX65"] = { 1000000,2,1000 },
	["LX66"] = { 1000000,2,1000 },
	["LX67"] = { 1000000,2,1000 },
	["LX68"] = { 1000000,2,1000 },
	["LX69"] = { 1000000,2,1000 },
	["LX70"] = { 1000000,2,1000 },	
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------SAMIR-------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	["LS01"] = { 350000,2,400 },
	["LS02"] = { 350000,2,400 },
	["LS03"] = { 350000,2,400 },
	["LS04"] = { 350000,2,400 },
	["LS05"] = { 350000,2,400 },
	["LS06"] = { 350000,2,400 },
	["LS07"] = { 350000,2,400 },
	["LS08"] = { 350000,2,400 },
	["LS09"] = { 350000,2,400 },
	["LS10"] = { 350000,2,400 },
	["LS11"] = { 350000,2,400 },
	["LS12"] = { 350000,2,400 },
	["LS13"] = { 350000,2,400 },
	["LS14"] = { 350000,2,400 },
	["LS15"] = { 350000,2,400 },
	["LS16"] = { 350000,2,400 },
	["LS17"] = { 350000,2,400 },
	["LS18"] = { 350000,2,400 },
	["LS19"] = { 350000,2,400 },
	["LS20"] = { 350000,2,400 },
	["LS21"] = { 350000,2,400 },
	["LS22"] = { 350000,2,400 },
	["LS23"] = { 350000,2,400 },
	["LS24"] = { 350000,2,400 },
	["LS25"] = { 350000,2,400 },
	["LS26"] = { 350000,2,400 },
	["LS27"] = { 350000,2,400 },
	["LS28"] = { 350000,2,400 },
	["LS29"] = { 350000,2,400 },
	["LS30"] = { 350000,2,400 },
	["LS31"] = { 350000,2,400 },
	["LS32"] = { 350000,2,400 },
	["LS33"] = { 350000,2,400 },
	["LS34"] = { 350000,2,400 },
	["LS35"] = { 350000,2,400 },
	["LS36"] = { 350000,2,400 },
	["LS37"] = { 350000,2,400 },
	["LS38"] = { 350000,2,400 },
	["LS39"] = { 350000,2,400 },
	["LS40"] = { 350000,2,400 },
	["LS41"] = { 350000,2,400 },
	["LS42"] = { 350000,2,400 },
	["LS43"] = { 350000,2,400 },
	["LS44"] = { 350000,2,400 },
	["LS45"] = { 350000,2,400 },
	["LS46"] = { 350000,2,400 },
	["LS47"] = { 350000,2,400 },
	["LS48"] = { 350000,2,400 },
	["LS49"] = { 350000,2,400 },
	["LS50"] = { 350000,2,400 },
	["LS51"] = { 350000,2,400 },
	["LS52"] = { 350000,2,400 },
	["LS53"] = { 350000,2,400 },
	["LS54"] = { 350000,2,400 },
	["LS55"] = { 350000,2,400 },
	["LS56"] = { 350000,2,400 },
	["LS57"] = { 350000,2,400 },
	["LS58"] = { 350000,2,400 },
	["LS59"] = { 350000,2,400 },
	["LS60"] = { 350000,2,400 },
	["LS61"] = { 350000,2,400 },
	["LS62"] = { 350000,2,400 },
	["LS63"] = { 350000,2,400 },
	["LS64"] = { 350000,2,400 },
	["LS65"] = { 350000,2,400 },
	["LS66"] = { 350000,2,400 },
	["LS67"] = { 350000,2,400 },
	["LS68"] = { 350000,2,400 },
	["LS69"] = { 350000,2,400 },
	["LS70"] = { 350000,2,400 },
	["LS71"] = { 350000,2,400 },
	["LS72"] = { 350000,2,400 },
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------BOLLINI------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	["BL01"] = { 100000,2,200 },
	["BL02"] = { 100000,2,200 },
	["BL03"] = { 100000,2,200 },
	["BL04"] = { 100000,2,200 },
	["BL05"] = { 100000,2,200 },
	["BL06"] = { 100000,2,200 },
	["BL07"] = { 100000,2,200 },
	["BL08"] = { 100000,2,200 },
	["BL09"] = { 100000,2,200 },
	["BL10"] = { 100000,2,200 },
	["BL11"] = { 100000,2,200 },
	["BL12"] = { 100000,2,200 },
	["BL13"] = { 100000,2,200 },
	["BL14"] = { 100000,2,200 },
	["BL15"] = { 100000,2,200 },
	["BL16"] = { 100000,2,200 },
	["BL17"] = { 100000,2,200 },
	["BL18"] = { 100000,2,200 },
	["BL19"] = { 100000,2,200 },
	["BL20"] = { 100000,2,200 },
	["BL21"] = { 100000,2,200 },
	["BL22"] = { 100000,2,200 },
	["BL23"] = { 100000,2,200 },
	["BL24"] = { 100000,2,200 },
	["BL25"] = { 100000,2,200 },
	["BL26"] = { 100000,2,200 },
	["BL27"] = { 100000,2,200 },
	["BL28"] = { 100000,2,200 },
	["BL29"] = { 100000,2,200 },
	["BL30"] = { 100000,2,200 },
	["BL31"] = { 100000,2,200 },
	["BL32"] = { 100000,2,200 },
-----------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------LOSVAGOS------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	["LV01"] = { 150000,2,250 },
	["LV02"] = { 150000,2,250 },
	["LV03"] = { 150000,2,250 },
	["LV04"] = { 150000,2,250 },
	["LV05"] = { 150000,2,250 },
	["LV06"] = { 150000,2,250 },
	["LV07"] = { 150000,2,250 },
	["LV08"] = { 150000,2,250 },
	["LV09"] = { 150000,2,250 },
	["LV10"] = { 150000,2,250 },
	["LV11"] = { 150000,2,250 },
	["LV12"] = { 150000,2,250 },
	["LV13"] = { 150000,2,250 },
	["LV14"] = { 150000,2,250 },
	["LV15"] = { 150000,2,250 },
	["LV16"] = { 150000,2,250 },
	["LV17"] = { 150000,2,250 },
	["LV18"] = { 150000,2,250 },
	["LV19"] = { 150000,2,250 },
	["LV20"] = { 150000,2,250 },
	["LV21"] = { 150000,2,250 },
	["LV22"] = { 150000,2,250 },
	["LV23"] = { 150000,2,250 },
	["LV24"] = { 150000,2,250 },
	["LV25"] = { 150000,2,250 },
	["LV26"] = { 150000,2,250 },
	["LV27"] = { 150000,2,250 },
	["LV28"] = { 150000,2,250 },
	["LV29"] = { 150000,2,250 },
	["LV30"] = { 150000,2,250 },
	["LV31"] = { 150000,2,250 },
	["LV32"] = { 150000,2,250 },
	["LV33"] = { 150000,2,250 },
	["LV34"] = { 150000,2,250 },
	["LV35"] = { 150000,2,250 },
-----------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------KRONDORS------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	["KR01"] = { 100000,2,200 },
	["KR02"] = { 100000,2,200 },
	["KR03"] = { 100000,2,200 },
	["KR04"] = { 100000,2,200 },
	["KR05"] = { 100000,2,200 },
	["KR06"] = { 100000,2,200 },
	["KR07"] = { 100000,2,200 },
	["KR08"] = { 100000,2,200 },
	["KR09"] = { 100000,2,200 },
	["KR10"] = { 100000,2,200 },
	["KR11"] = { 100000,2,200 },
	["KR12"] = { 100000,2,200 },
	["KR13"] = { 100000,2,200 },
	["KR14"] = { 100000,2,200 },
	["KR15"] = { 100000,2,200 },
	["KR16"] = { 100000,2,200 },
	["KR17"] = { 100000,2,200 },
	["KR18"] = { 100000,2,200 },
	["KR19"] = { 100000,2,200 },
	["KR20"] = { 100000,2,200 },
	["KR21"] = { 100000,2,200 },
	["KR22"] = { 100000,2,200 },
	["KR23"] = { 100000,2,200 },
	["KR24"] = { 100000,2,200 },
	["KR25"] = { 100000,2,200 },
	["KR26"] = { 100000,2,200 },
	["KR27"] = { 100000,2,200 },
	["KR28"] = { 100000,2,200 },
	["KR29"] = { 100000,2,200 },
	["KR30"] = { 100000,2,200 },
	["KR31"] = { 100000,2,200 },
	["KR32"] = { 100000,2,200 },
	["KR33"] = { 100000,2,200 },
	["KR34"] = { 100000,2,200 },
	["KR35"] = { 100000,2,200 },
	["KR36"] = { 100000,2,200 },
	["KR37"] = { 100000,2,200 },
	["KR38"] = { 100000,2,200 },
	["KR39"] = { 100000,2,200 },
	["KR40"] = { 100000,2,200 },
	["KR41"] = { 100000,2,200 },
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------GROOVEMOTEL--------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	["GR01"] = { 100000,2,200 },
	["GR02"] = { 100000,2,200 },
	["GR03"] = { 100000,2,200 },
	["GR04"] = { 100000,2,200 },
	["GR05"] = { 100000,2,200 },
	["GR06"] = { 100000,2,200 },
	["GR07"] = { 100000,2,200 },
	["GR08"] = { 100000,2,200 },
	["GR09"] = { 100000,2,200 },
	["GR10"] = { 100000,2,200 },
	["GR11"] = { 100000,2,200 },
	["GR12"] = { 100000,2,200 },
	["GR13"] = { 100000,2,200 },
	["GR14"] = { 100000,2,200 },
	["GR15"] = { 100000,2,200 },
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------ALLSUELLMOTEL------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	["AS01"] = { 100000,2,200 },
	["AS02"] = { 100000,2,200 },
	["AS03"] = { 100000,2,200 },
	["AS04"] = { 100000,2,200 },
	["AS05"] = { 100000,2,200 },
	["AS06"] = { 100000,2,200 },
	["AS07"] = { 100000,2,200 },
	["AS08"] = { 100000,2,200 },
	["AS09"] = { 100000,2,200 },
	["AS10"] = { 100000,2,200 },
	["AS12"] = { 100000,2,200 },
	["AS13"] = { 100000,2,200 },
	["AS14"] = { 100000,2,200 },
	["AS15"] = { 100000,2,200 },
	["AS16"] = { 100000,2,200 },
	["AS17"] = { 100000,2,200 },
	["AS18"] = { 100000,2,200 },
	["AS19"] = { 100000,2,200 },
	["AS20"] = { 100000,2,200 },
	["AS21"] = { 100000,2,200 },
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------PINKCAGEMOTEL-----------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	["PC01"] = { 70000,2,150 },
	["PC02"] = { 70000,2,150 },
	["PC03"] = { 70000,2,150 },
	["PC04"] = { 70000,2,150 },
	["PC05"] = { 70000,2,150 },
	["PC06"] = { 70000,2,150 },
	["PC07"] = { 70000,2,150 },
	["PC08"] = { 70000,2,150 },
	["PC09"] = { 70000,2,150 },
	["PC10"] = { 70000,2,150 },
	["PC11"] = { 70000,2,150 },
	["PC12"] = { 70000,2,150 },
	["PC13"] = { 70000,2,150 },
	["PC14"] = { 70000,2,150 },
	["PC15"] = { 70000,2,150 },
	["PC16"] = { 70000,2,150 },
	["PC17"] = { 70000,2,150 },
	["PC18"] = { 70000,2,150 },
	["PC19"] = { 70000,2,150 },
	["PC20"] = { 70000,2,150 },
	["PC21"] = { 70000,2,150 },
	["PC22"] = { 70000,2,150 },
	["PC23"] = { 70000,2,150 },
	["PC24"] = { 70000,2,150 },
	["PC25"] = { 70000,2,150 },
	["PC26"] = { 70000,2,150 },
	["PC27"] = { 70000,2,150 },
	["PC28"] = { 70000,2,150 },
	["PC29"] = { 70000,2,150 },
	["PC30"] = { 70000,2,150 },
	["PC31"] = { 70000,2,150 },
	["PC32"] = { 70000,2,150 },
	["PC33"] = { 70000,2,150 },
	["PC34"] = { 70000,2,150 },
	["PC35"] = { 70000,2,150 },
	["PC36"] = { 70000,2,150 },
	["PC37"] = { 70000,2,150 },
	["PC38"] = { 70000,2,150 },
-----------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------PALETOMOTEL------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	["PL01"] = { 70000,2,150 },
	["PL02"] = { 70000,2,150 },
	["PL03"] = { 70000,2,150 },
	["PL04"] = { 70000,2,150 },
	["PL05"] = { 70000,2,150 },
	["PL06"] = { 70000,2,150 },
	["PL07"] = { 70000,2,150 },
	["PL08"] = { 70000,2,150 },
	["PL09"] = { 70000,2,150 },
	["PL11"] = { 70000,2,150 },
	["PL12"] = { 70000,2,150 },
	["PL13"] = { 70000,2,150 },
	["PL14"] = { 70000,2,150 },
	["PL15"] = { 70000,2,150 },
	["PL16"] = { 70000,2,150 },
	["PL17"] = { 70000,2,150 },
	["PL18"] = { 70000,2,150 },
	["PL19"] = { 70000,2,150 },
	["PL20"] = { 70000,2,150 },
	["PL21"] = { 70000,2,150 },
	["PL22"] = { 70000,2,150 },
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------PALETOBAY-------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	["PB01"] = { 150000,2,250 },
	["PB02"] = { 150000,2,250 },
	["PB03"] = { 150000,2,250 },
	["PB04"] = { 150000,2,250 },
	["PB05"] = { 150000,2,250 },
	["PB06"] = { 150000,2,250 },
	["PB07"] = { 150000,2,250 },
	["PB08"] = { 150000,2,250 },
	["PB09"] = { 150000,2,250 },
	["PB10"] = { 150000,2,250 },
	["PB11"] = { 150000,2,250 },
	["PB12"] = { 150000,2,250 },
	["PB13"] = { 150000,2,250 },
	["PB14"] = { 150000,2,250 },
	["PB15"] = { 150000,2,250 },
	["PB16"] = { 150000,2,250 },
	["PB17"] = { 150000,2,250 },
	["PB18"] = { 150000,2,250 },
	["PB19"] = { 150000,2,250 },
	["PB20"] = { 150000,2,250 },
	["PB21"] = { 150000,2,250 },
	["PB22"] = { 150000,2,250 },
	["PB23"] = { 150000,2,250 },
	["PB24"] = { 150000,2,250 },
	["PB25"] = { 150000,2,250 },
	["PB26"] = { 150000,2,250 },
	["PB27"] = { 150000,2,250 },
	["PB28"] = { 150000,2,250 },
	["PB29"] = { 150000,2,250 },
	["PB30"] = { 150000,2,250 },
	["PB31"] = { 150000,2,250 },
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------MANSAO------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	["MS01"] = { 1000000,2,1500 },
	["MS02"] = { 1000000,2,1500 },
	["MS03"] = { 1000000,10,1500 },
	["MS04"] = { 1000000,5,1500 },
	["MS05"] = { 1000000,2,1500 },
	["MS06"] = { 1000000,2,1500 },
	["MS07"] = { 1000000,2,1500 },
	["MS08"] = { 1000000,2,1500 },
	["MS09"] = { 1000000,2,1500 },
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------SANDYSHORE------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	["SS01"] = { 350000,2,400 },
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------TREVORHOUSE-----------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
	["TR01"] = { 300000,2,200 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
local blipHomes = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPHOMES
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		blipHomes = {}
		for k,v in pairs(homes) do
			local checkHomes = vRP.query("homes/get_homeuseridowner",{ home = tostring(k) })
			if checkHomes[1] == nil then
				table.insert(blipHomes,{ name = tostring(k) })
				Citizen.Wait(10)
			end
		end
		Citizen.Wait(30*60000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('homes',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if args[1] == "add" and homes[tostring(args[2])] then
			local myHomes = vRP.query("homes/get_homeuserowner",{ user_id = parseInt(user_id), home = tostring(args[2]) })
			if myHomes[1] then
				local totalResidents = vRP.query("homes/count_homepermissions",{ home = tostring(args[2]) })
				if parseInt(totalResidents[1].qtd) >= parseInt(homes[tostring(args[2])][2]) then
					TriggerClientEvent("Notify",source,"negado","A residência "..tostring(args[2]).." atingiu o máximo de moradores.",10000)
					return
				end

				vRP.execute("homes/add_permissions",{ home = tostring(args[2]), user_id = parseInt(args[3]) })
				local identity = vRP.getUserIdentity(parseInt(args[3]))
				local nplayer = vRP.getUserSource(parseInt(args[3]))
				if identity and nplayer then
					TriggerClientEvent("Notify",source,"sucesso","Você entregou uma chave da residência <b>"..tostring(args[2]).."</b> para <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
					TriggerClientEvent("Notify",nplayer,"importante","Você recebeu as chaves da residência <b>"..tostring(args[2]).."</b>.",10000)
				end
			end
		elseif args[1] == "rem" and homes[tostring(args[2])] then
			local myHomes = vRP.query("homes/get_homeuserowner",{ user_id = parseInt(user_id), home = tostring(args[2]) })
			if myHomes[1] then
				local userHomes = vRP.query("homes/get_homeuser",{ user_id = parseInt(args[3]), home = tostring(args[2]) })
				if userHomes[1] then
					vRP.execute("homes/rem_permissions",{ home = tostring(args[2]), user_id = parseInt(args[3]) })
					local identity = vRP.getUserIdentity(parseInt(args[3]))
					local nplayer = vRP.getUserSource(parseInt(args[3]))
					if identity and nplayer then
						TriggerClientEvent("Notify",source,"importante","Você pegou a chave da residência <b>"..tostring(args[2]).."</b> de <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
						TriggerClientEvent("Notify",nplayer,"negado","As trancas da residência <b>"..tostring(args[2]).."</b> foram trocadas e você perdeu o acesso.",10000)
					end
				end
			end
		elseif args[1] == "garage" and homes[tostring(args[2])] then
			local myHomes = vRP.query("homes/get_homeuserowner",{ user_id = parseInt(user_id), home = tostring(args[2]) })
			if myHomes[1] then
				local userHomes = vRP.query("homes/get_homeuser",{ user_id = parseInt(args[3]), home = tostring(args[2]) })
				if userHomes[1] then
					if vRP.tryFullPayment(user_id,50000) then
						vRP.execute("homes/upd_permissions",{ home = tostring(args[2]), user_id = parseInt(args[3]) })
						local identity = vRP.getUserIdentity(parseInt(args[3]))
						local nplayer = vRP.getUserSource(parseInt(args[3]))
						if identity and nplayer then
							TriggerClientEvent("Notify",source,"sucesso","Você entregou o controle da garagem para <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
							TriggerClientEvent("Notify",nplayer,"importante","Você recebeu o controle da <b>Garagem</b>.",10000)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
					end
				end
			end
		elseif args[1] == "list" then
			vCLIENT.setBlipsHomes(source,blipHomes)
		elseif args[1] == "check" and homes[tostring(args[2])] then
			local myHomes = vRP.query("homes/get_homeuserowner",{ user_id = parseInt(user_id), home = tostring(args[2]) })
			if myHomes[1] then
				local userHomes = vRP.query("homes/get_homepermissions",{ home = tostring(args[2]) })
				if parseInt(#userHomes) > 1 then
					local permissoes = ""
					for k,v in pairs(userHomes) do
						if v.user_id ~= user_id then
							local identity = vRP.getUserIdentity(v.user_id)
							permissoes = permissoes.."<b>Nome:</b> "..identity.name.." "..identity.firstname.." - <b>Passaporte:</b> "..v.user_id
							if k ~= #userHomes then
								permissoes = permissoes.."<br>"
							end
						end
						Citizen.Wait(10)
					end
					TriggerClientEvent("Notify",source,"importante","Cópia das chaves da residência <b>"..tostring(args[2]).."</b>: <br>"..permissoes,20000)
				else
					TriggerClientEvent("Notify",source,"negado","Nenhuma cópia de chave encontrada.",20000)
				end
			end
		elseif args[1] == "transfer" and homes[tostring(args[2])] then
			if vRP.hasPermission(user_id,"platina.permissao") and (string.find(args[2],"FH") or string.find(args[2],"LX") or string.find(args[2],"MS") or string.find(args[2],"SS")) then
				TriggerClientEvent("Notify",source,"negado","<b>"..args[2].."</b> não pode ser transferida por ser uma residência <b>VIP</b>.",10000)
				return
			end
			local myHomes = vRP.query("homes/get_homeuserowner",{ user_id = parseInt(user_id), home = tostring(args[2]) })
			if myHomes[1] then
				local identity = vRP.getUserIdentity(parseInt(args[3]))
				local nplayer = vRP.getUserSource(parseInt(args[3]))
				if identity and nplayer then
					local ok = vRP.request(source,"Deseja transferir a residência <b>"..tostring(args[2]).."</b> para <b>"..identity.name.." "..identity.firstname.."</b> ?",30)
					if ok then
						vRP.execute("homes/rem_allpermissions",{ home = tostring(args[2]) })
						vRP.execute("homes/buy_permissions",{ home = tostring(args[2]), user_id = parseInt(args[3]), tax = parseInt(myHomes[1].tax) })
						TriggerClientEvent("Notify",source,"importante","Você transferiu a residência <b>"..tostring(args[2]).."</b> para <b>"..identity.name.." "..identity.firstname.."</b>.",10000)
						TriggerClientEvent("Notify",nplayer,"importante","Você recebeu a transferência da residência <b>"..tostring(args[2]).."</b>.",10000)
					end
				end
			end
		elseif args[1] == "tax" and homes[tostring(args[2])] then
			local ownerHomes = vRP.query("homes/get_homeuseridowner",{ home = tostring(args[2]) })
			if ownerHomes[1] then
				if vRP.tryFullPayment(user_id,parseInt(homes[tostring(args[2])][1]*0.1)) then
					vRP.execute("homes/rem_permissions",{ home = tostring(args[2]), user_id = parseInt(ownerHomes[1].user_id) })
					vRP.execute("homes/buy_permissions",{ home = tostring(args[2]), user_id = parseInt(ownerHomes[1].user_id), tax = parseInt(os.time()) })
					TriggerClientEvent("Notify",source,"sucesso","Pagamento de <b>$"..vRP.format(parseInt(homes[tostring(args[2])][1]*0.1)).." dólares</b> efetuado com sucesso.",10000)
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
				end
			end
		elseif args[1] == "sell" and homes[tostring(args[2])] then
			if vRP.hasPermission(user_id,"platina.permissao") and (string.find(args[2],"FH") or string.find(args[2],"LX") or string.find(args[2],"MS") or string.find(args[2],"SS")) then
				TriggerClientEvent("Notify",source,"negado","<b>"..args[2].."</b> não pode ser vendida por ser uma residência <b>VIP</b>.",10000)
				return
			end
			local myHomes = vRP.query("homes/get_homeuserowner",{ user_id = parseInt(user_id), home = tostring(args[2]) })
			if myHomes[1] then
				local ok = vRP.request(source,"Deseja vender a residência <b>"..tostring(args[2]).."</b> por <b>$"..vRP.format(parseInt(homes[tostring(args[2])][1]*0.5)).." dólares</b> ?",30)
				if ok then
					local chest = vRP.getSData("chest:"..tostring(args[2]))
					local chest2 = json.decode(chest) or {}
					if chest2 then
						vRP.execute("creative/rem_srv_data",{ dkey = "chest:"..tostring(args[2]) })
					end

					local outfit = vRP.getSData("outfit:"..tostring(args[2]))
					local outfit2 = json.decode(outfit) or {}
					if outfit2 then
						vRP.execute("creative/rem_srv_data",{ dkey = "outfit:"..tostring(args[2]) })
					end
					vRP.execute("homes/rem_allpermissions",{ home = tostring(args[2]) })

					vRP.giveBankMoney(user_id,parseInt(homes[tostring(args[2])][1]*0.5))
					TriggerClientEvent("Notify",source,"sucesso","Você vendeu a residência <b>"..tostring(args[2]).."</b> por <b>$"..vRP.format(parseInt(homes[tostring(args[2])][1]*0.5)).." dólares</b>.",10000)
				end
			end
		else
			local myHomes = vRP.query("homes/get_homeuserid",{ user_id = parseInt(user_id) })
			if parseInt(#myHomes) >= 1 then
				for k,v in pairs(myHomes) do
					local ownerHomes = vRP.query("homes/get_homeuseridowner",{ home = tostring(v.home) })
					if ownerHomes[1] then
						if vRP.hasPermission(user_id,"platina.permissao") and (string.find(v.home,"FH") or string.find(v.home,"LX") or string.find(v.home,"MS") or string.find(v.home,"SS")) then
							TriggerClientEvent("Notify",source,"importante","<b>Residência:</b> "..v.home.."<br><b>Property Tax:</b> Quitado",20000)
							vRP.execute("homes/upd_taxhomes",{ tax = parseInt(os.time()), user_id = parseInt(ownerHomes[1].user_id), home = tostring(v.home), owner = 1 })
						else
							if parseInt(os.time()) >= parseInt(ownerHomes[1].tax+24*15*60*60) then
								TriggerClientEvent("Notify",source,"negado","<b>Residência:</b> "..v.home.."<br><b>Property Tax:</b> Atrasado",20000)
							else
								TriggerClientEvent("Notify",source,"importante","<b>Residência:</b> "..v.home.."<br>Taxa em: "..vRP.getDayHours(parseInt(86400*15-(os.time()-ownerHomes[1].tax))).."<br>Valor: <b>$"..vRP.format(parseInt(homes[tostring(v.home)][1]*0.1)).." dólares</b>",20000)
							end
						end
						Citizen.Wait(10)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local myHomes = vRP.query("homes/get_homeuserid",{ user_id = parseInt(user_id) })
		if parseInt(#myHomes) >= 1 then
			for k,v in pairs(myHomes) do
				vCLIENT.setBlipsOwner(source,v.home)
				Citizen.Wait(10)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEDOWNTIME
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		for k,v in pairs(actived) do
			if v > 0 then
				actived[k] = v - 2
				if v == 0 then
					actived[k] = nil
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local answered = {}
function src.checkPermissions(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			if not vRP.searchReturn(source,user_id) then
				local homeResult = vRP.query("homes/get_homepermissions",{ home = tostring(homeName) })
				if parseInt(#homeResult) >= 1 then
					local myResult = vRP.query("homes/get_homeuser",{ user_id = parseInt(user_id), home = tostring(homeName) })
					local resultOwner = vRP.query("homes/get_homeuseridowner",{ home = tostring(homeName) })
					if myResult[1] then

						if vRP.hasPermission(user_id,"platina.permissao") and (string.find(homeName,"FH") or string.find(homeName,"LX") or string.find(homeName,"MS") or string.find(homeName,"SS")) then
							vRP.execute("homes/upd_taxhomes",{ tax = parseInt(os.time()), user_id = parseInt(resultOwner[1].user_id), home = tostring(homeName), owner = 1 })
							return true
						end

						if parseInt(os.time()) >= parseInt(resultOwner[1].tax+24*18*60*60) and not (vRP.hasPermission(user_id,"platina.permissao") and (string.find(homeName,"FH") or string.find(homeName,"LX") or string.find(homeName,"MS") or string.find(homeName,"SS"))) then

							local chest = vRP.getSData("chest:"..tostring(homeName))
							local chest2 = json.decode(chest) or {}
							if chest2 then
								vRP.execute("creative/rem_srv_data",{ dkey = "chest:"..tostring(homeName) })
							end

							local outfit = vRP.getSData("outfit:"..tostring(homeName))
							local outfit2 = json.decode(outfit) or {}
							if outfit2 then
								vRP.execute("creative/rem_srv_data",{ dkey = "outfit:"..tostring(homeName) })
							end

							vRP.execute("homes/rem_allpermissions",{ home = tostring(homeName) })
							TriggerClientEvent("Notify",source,"aviso","A <b>Property Tax</b> venceu por <b>3 dias</b> e a casa foi vendida.",10000)
							return false
						elseif parseInt(os.time()) <= parseInt(resultOwner[1].tax+24*15*60*60) then
							return true
						else
							TriggerClientEvent("Notify",source,"aviso","A <b>Property Tax</b> da residência está atrasada.",10000)
							return false
						end
					else
						if parseInt(os.time()) >= parseInt(resultOwner[1].tax+24*18*60*60) and not (vRP.hasPermission(user_id,"platina.permissao") and (string.find(homeName,"FH") or string.find(homeName,"LX") or string.find(homeName,"MS") or string.find(homeName,"SS"))) then

							local chest = vRP.getSData("chest:"..tostring(homeName))
							local chest2 = json.decode(chest) or {}
							if chest2 then
								vRP.execute("creative/rem_srv_data",{ dkey = "chest:"..tostring(homeName) })
							end

							local outfit = vRP.getSData("outfit:"..tostring(homeName))
							local outfit2 = json.decode(outfit) or {}
							if outfit2 then
								vRP.execute("creative/rem_srv_data",{ dkey = "outfit:"..tostring(homeName) })
							end

							vRP.execute("homes/rem_allpermissions",{ home = tostring(homeName) })
							return false
						end

						if parseInt(os.time()) >= parseInt(resultOwner[1].tax+24*15*60*60) and not (vRP.hasPermission(user_id,"platina.permissao") and (string.find(homeName,"FH") or string.find(homeName,"LX") or string.find(homeName,"MS") or string.find(homeName,"SS"))) then
							TriggerClientEvent("Notify",source,"aviso","A <b>Property Tax</b> da residência está atrasada.",10000)
							return false
						end

						answered[user_id] = nil
						for k,v in pairs(homeResult) do
							local player = vRP.getUserSource(parseInt(v.user_id))
							if player then
								if not answered[user_id] then
									TriggerClientEvent("vrp_sound:source",player,'doorbell',0.2)
									TriggerClientEvent("vrp_sound:source",source,'doorbell',0.2)
									vRPclient._playAnim(source,true,{"timetable@jimmy@doorknock@","knockdoor_idle"},false)
									TriggerClientEvent("Notify",player,"importante","<b>"..identity.name.." "..identity.firstname.."</b> tocou o interfone da residência <b>"..tostring(homeName).."</b>.<br>Deseja permitir a entrada do mesmo ?",10000)
									local ok = vRP.request(player,"Permitir acesso a residência ?",30)
									if ok then
										answered[user_id] = true
										return true
									end
								end
							end
							Citizen.Wait(10)
						end
					end
				else
					local ok = vRP.request(source,"Deseja efetuar a compra da residência <b>"..tostring(homeName).."</b> por <b>$"..vRP.format(parseInt(homes[tostring(homeName)][1])).."</b> ?",30)
					if ok then
						if vRP.tryFullPayment(user_id,parseInt(homes[tostring(homeName)][1])) then
							vRP.execute("homes/buy_permissions",{ home = tostring(homeName), user_id = parseInt(user_id), tax = parseInt(os.time()) })
							TriggerClientEvent("Notify",source,"sucesso","A residência <b>"..tostring(homeName).."</b> foi comprada com sucesso.",10000)
						else
							TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
						end
					end
					return false
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINTPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkIntPermissions(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.searchReturn(source,user_id) then
			local myResult = vRP.query("homes/get_homeuser",{ user_id = parseInt(user_id), home = tostring(homeName) })
			if myResult[1] or vRP.hasPermission(user_id,"policia.permissao") then
				return true
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTFIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('outfit',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local homeName = vCLIENT.getHomeStatistics(source)
		local myResult = vRP.query("homes/get_homeuser",{ user_id = parseInt(user_id), home = tostring(homeName) })
		if myResult[1] then
			local data = vRP.getSData("outfit:"..tostring(homeName))
			local result = json.decode(data) or {}
			if result then
				if args[1] == "save" and args[2] then
					local custom = vRPclient.getCustomPlayer(source)
					if custom then
						local outname = sanitizeString(rawCommand:sub(13),sanitizes.homename[1],sanitizes.homename[2])
						if result[outname] == nil and string.len(outname) > 0 then
							result[outname] = custom
							vRP.setSData("outfit:"..tostring(homeName),json.encode(result))
							TriggerClientEvent("Notify",source,"sucesso","Outfit <b>"..outname.."</b> adicionado com sucesso.",10000)
						else
							TriggerClientEvent("Notify",source,"aviso","Nome escolhido já existe na lista de <b>Outfits</b>.",10000)
						end
					end
				elseif args[1] == "rem" and args[2] then
					local outname = sanitizeString(rawCommand:sub(12),sanitizes.homename[1],sanitizes.homename[2])
					if result[outname] ~= nil and string.len(outname) > 0 then
						result[outname] = nil
						vRP.setSData("outfit:"..tostring(homeName),json.encode(result))
						TriggerClientEvent("Notify",source,"sucesso","Outfit <b>"..outname.."</b> removido com sucesso.",10000)
					else
						TriggerClientEvent("Notify",source,"negado","Nome escolhido não encontrado na lista de <b>Outfits</b>.",10000)
					end
				elseif args[1] == "apply" and args[2] then
					local outname = sanitizeString(rawCommand:sub(14),sanitizes.homename[1],sanitizes.homename[2])
					if result[outname] ~= nil and string.len(outname) > 0 then
						TriggerClientEvent("updateRoupas",source,result[outname])
						TriggerClientEvent("Notify",source,"sucesso","Outfit <b>"..outname.."</b> aplicado com sucesso.",10000)
					else
						TriggerClientEvent("Notify",source,"negado","Nome escolhido não encontrado na lista de <b>Outfits</b>.",10000)
					end
				else
					for k,v in pairs(result) do
						TriggerClientEvent("Notify",source,"importante","<b>Outfit:</b> "..k,20000)
						Citizen.Wait(10)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.openChest(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local hsinventory = {}
		local myinventory = {}
		local data = vRP.getSData("chest:"..tostring(homeName))
		local result = json.decode(data) or {}
		if result then
			for k,v in pairs(result) do
				table.insert(hsinventory,{ amount = parseInt(v.amount), name = exports["pd-inventory"]:getItemName(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
			end

			local inv = vRP.getInventory(parseInt(user_id))
			for k,v in pairs(inv) do
				table.insert(myinventory,{ amount = parseInt(v.amount), name = exports["pd-inventory"]:getItemName(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
			end
		end
		return hsinventory,myinventory,vRP.getInventoryWeight(user_id),vRP.getInventoryMaxWeight(user_id),vRP.computeItemsWeight(result),parseInt(homes[tostring(homeName)][3])
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
local vipItems = {
	["vipgold15"] = true,
	["vipgold30"] = true,
	["vipplatinum15"] = true,
	["vipplatinum30"] = true,
	["vipaparencia"] = true,
	["vipplaca"] = true,
	["vipgaragem"] = true,
}

function src.storeItem(homeName,itemName,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if user_id and actived[parseInt(user_id)] == 0 or not actived[parseInt(user_id)] then

			if vipItems[itemName] then
				TriggerClientEvent("Notify",source,"importante","Não pode guardar este item.",8000)
				return
			end

			local data = vRP.getSData("chest:"..tostring(homeName))
			local items = json.decode(data) or {}
			if items then
				if parseInt(amount) > 0 then
					local new_weight = vRP.computeItemsWeight(items)+vRP.getItemWeight(itemName)*parseInt(amount)
					if new_weight <= parseInt(homes[tostring(homeName)][3]) then
						if vRP.tryGetInventoryItem(parseInt(user_id),itemName,parseInt(amount)) then
							if items[itemName] ~= nil then
								items[itemName].amount = parseInt(items[itemName].amount) + parseInt(amount)
							else
								items[itemName] = { amount = parseInt(amount) }
							end
							vRP.setSData("chest:"..tostring(homeName),json.encode(items))
							TriggerClientEvent('Creative:UpdateVault',source,'updateVault')

							SendWebhookMessage(webhookbaucasas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.format(parseInt(amount)).." "..exports["pd-inventory"]:getItemName(itemName).." \n[BAU]: "..(tostring(homeName)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
							actived[parseInt(user_id)] = 2
						end
					else
						TriggerClientEvent("Notify",source,"negado","<b>Vault</b> cheio.",8000)
					end
				else
					local inv = vRP.getInventory(parseInt(user_id))
					for k,v in pairs(inv) do
						if itemName == k then
							local new_weight = vRP.computeItemsWeight(items)+vRP.getItemWeight(itemName)*parseInt(v.amount)
							if new_weight <= parseInt(homes[tostring(homeName)][3]) then
								if vRP.tryGetInventoryItem(parseInt(user_id),itemName,parseInt(v.amount)) then
									if items[itemName] ~= nil then
										items[itemName].amount = parseInt(items[itemName].amount) + parseInt(v.amount)
									else
										items[itemName] = { amount = parseInt(v.amount) }
									end
									vRP.setSData("chest:"..tostring(homeName),json.encode(items))
									TriggerClientEvent('Creative:UpdateVault',source,'updateVault')

									SendWebhookMessage(webhookbaucasas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.format(parseInt(v.amount)).." "..exports["pd-inventory"]:getItemName(itemName).." \n[BAU]: "..(tostring(homeName)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									actived[parseInt(user_id)] = 2
								end
							else
								TriggerClientEvent("Notify",source,"negado","<b>Vault</b> cheio.",8000)
							end
						end
					end
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function src.takeItem(homeName,itemName,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if user_id and actived[parseInt(user_id)] == 0 or not actived[parseInt(user_id)] then
			local data = vRP.getSData("chest:"..tostring(homeName))
			local items = json.decode(data) or {}
			if items then
				if parseInt(amount) > 0 then
					if items[itemName] ~= nil and parseInt(items[itemName].amount) >= parseInt(amount) then
						if vRP.getInventoryWeight(parseInt(user_id))+vRP.getItemWeight(itemName)*parseInt(amount) <= vRP.getInventoryMaxWeight(parseInt(user_id)) then
							SendWebhookMessage(webhookbaucasas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.format(parseInt(amount)).." "..exports["pd-inventory"]:getItemName(itemName).." \n[BAU]: "..(tostring(homeName)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
							
							vRP.giveInventoryItem(parseInt(user_id),itemName,parseInt(amount))
							items[itemName].amount = parseInt(items[itemName].amount) - parseInt(amount)
							if parseInt(items[itemName].amount) <= 0 then
								items[itemName] = nil
							end
							vRP.setSData("chest:"..tostring(homeName),json.encode(items))
							TriggerClientEvent('Creative:UpdateVault',source,'updateVault')

							actived[parseInt(user_id)] = 2
						else
							TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
						end
					end
				else
					if items[itemName] ~= nil and parseInt(items[itemName].amount) >= parseInt(amount) then
						if vRP.getInventoryWeight(parseInt(user_id))+vRP.getItemWeight(itemName)*parseInt(items[itemName].amount) <= vRP.getInventoryMaxWeight(parseInt(user_id)) then
							SendWebhookMessage(webhookbaucasas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.format(parseInt(items[itemName].amount)).." "..exports["pd-inventory"]:getItemName(itemName).." \n[BAU]: "..(tostring(homeName)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
							
							vRP.giveInventoryItem(parseInt(user_id),itemName,parseInt(items[itemName].amount))
							items[itemName] = nil
							vRP.setSData("chest:"..tostring(homeName),json.encode(items))
							TriggerClientEvent('Creative:UpdateVault',source,'updateVault')

							actived[parseInt(user_id)] = 2
						else
							TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
						end
					end
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPolice(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			TriggerClientEvent("Notify",source,"importante","Você invadiu a casa <b>"..homeName.."</b>.")
			SendWebhookMessage(webhookpoliciainvade,"```prolog\n[POLICIAL]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[===============INVADIU==============] \n[CASA]: "..homeName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			return true
		end
		return false
	end
end