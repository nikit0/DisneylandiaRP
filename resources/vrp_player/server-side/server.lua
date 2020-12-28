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
vCLIENT = Tunnel.getInterface("vrp_player")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local idgens = Tools.newIDGenerator()
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookgarmas = "https://discordapp.com/api/webhooks/584810865862246400/wgP4-Y9q3HULRFfOnJxIjNbMR3Es0c09xG80XyDUg-BxJU3uonCWq0K9AFnlpgM0M5kt"
local webhookgarmas250 = "https://discordapp.com/api/webhooks/623413446515621891/6a76famEQU18K0I8P70hskBMS7n_LbF9cxus7-x2yvbmx70iCOBgrOpJONRoh3_lHD2Y"
local webhookenviardinheiro = "https://discordapp.com/api/webhooks/584808947186139157/MFAXxTPWnyR11ChXMY_Qa9QITowhZa83RqkVo0cpx2030jut5eVxJsJRlg7D6cdrDo7H"
local webhookpaypal = "https://discordapp.com/api/webhooks/585220507226603549/St3qXdKWmgMPdAwEx1qFiG5zyQ3Rc6A9dLNcLVDiiggUWcLCs-GUwUQF9N5jgZRGIzsm"
local webhookgive = "https://discordapp.com/api/webhooks/585782631791198208/v9MouRfvkx6txaCXqC3JF3UEWFKQl-2ZjCyxTJRisBNaKBmYiQYYskzQwIh88rhIiFaO"

local webhookballas = "https://discordapp.com/api/webhooks/624424775606992917/sfBrbMA9CX7s78jYFLM6L6Mng1-Vgnsb4UpokKB1XdksksrcQLKLM6WrADPalzh4ZUaX"
local webhookfamilies = "https://discordapp.com/api/webhooks/624425166042038302/Ag5PoMI1mdQxpEYL3wZHTl0efyw_84Q4y4DIXDQ4z2xCuyazpKlSJdSaJgipfOtHfDLh"
local webhookvagos = "https://discordapp.com/api/webhooks/624425100174950410/PvOz6zoK9_MuHLEG8gkut-dXBfTOuHsBpweAyyF5aNmpZJiD6LKXRpQ7rox-FzIoIuQg"
local webhookmarabuntas = "https://discordapp.com/api/webhooks/685599248389242888/6lNpJwrVd4KZ77oZctgOWqPViRThFkCxFEznxTbkq4dnCVoMyuaggLP-VrMdJb1TND1C"

local webhookmafia = "https://discordapp.com/api/webhooks/662189146642841611/XJ16ZLyJkbQ9AnurNg37MNwYRi0pQS4buCgm7fhD6jH4OxRXf6_KPEdiUSlUpOUTHN7J"
local webhookserpentes = "https://discordapp.com/api/webhooks/624425597434593281/Isg7czCdloqz0KhNgl29BJ1R_mNpvygK41MKuMpPsDru5odaa3QgISQ2r-ihudJ1ghgV"

local webhookmotoclub = "https://discordapp.com/api/webhooks/624425525758132251/wOgH88ppQlsA5rxuAK57-C-k-2RqN2Dsp5lS23A3_LtQ_nLrd5SkX-YqN8kMeRJP49hk"
local webhookcosanostra = "https://discordadogpp.com/api/webhooks/624425669169774593/AAzifgAA1cpgq-MJfNTWZbSUpiGuKN7csEWzKpYYLXq03wfSXEAmBMhflcCMF2VzMHVi"

local webhookyakuza = "https://discordapp.com/api/webhooks/624425322724458506/IgZLnAxpV8LVcTLx3VY3Ab19rc38eL91f1oHHcdLSBLVc_nK6DjsqFQBdDy6snFitu6Z"
local webhookcorleone = "https://discordapp.com/api/webhooks/624425423115124737/yfGy2xb71GbKV0BteSlc9s2w_zXjhuyc2OuN3Z0LfYRsRqgLu2XBLLlgZdYJsqIkBVbU"

local webhookjobrotation = "https://discordapp.com/api/webhooks/695381361908777070/8AgqT2sU3e_pgsrS7ahoJxp3aoR9A8Cwykzi_e7oRsBB5uMVihizfuzi6rSIMSOARpwF"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMLIST
-----------------------------------------------------------------------------------------------------------------------------------------
-- local itemlist = {
-- 	["ferramenta"] = { index = "ferramenta", nome = "Ferramenta" },
-- 	["skate"] = { index = "skate", nome = "Skate" },
-- 	["encomenda"] = { index = "encomenda", nome = "Encomenda" },
-- 	["sacodelixo"] = { index = "sacodelixo", nome = "Saco de Lixo" },
-- 	["garrafavazia"] = { index = "garrafavazia", nome = "Garrafa Vazia" },
-- 	["garrafadeleite"] = { index = "garrafadeleite", nome = "Garrafa de Leite" },
-- 	["tora"] = { index = "tora", nome = "Tora de Madeira" },
-- 	["alianca"] = { index = "alianca", nome = "Aliança" },
-- 	["bandagem"] = { index = "bandagem", nome = "Bandagem" },
-- 	["firstaid"] = { index = "firstaid", nome = "First Aid" },
-- 	["medkit"] = { index = "medkit", nome = "Med Kit" },
-- 	["defibrillator"] = { index = "defibrillator", nome = "Defibrillator" },
-- 	["bodybag"] = { index = "bodybag", nome = "Body Bag" },
-- 	["adrenaline"] = { index = "adrenaline", nome = "Adrenaline" },
-- 	["anesthesia"] = { index = "anesthesia", nome = "Anesthesia" },
-- 	["dorflex"] = { index = "dorflex", nome = "Dorflex" },
-- 	["cicatricure"] = { index = "cicatricure", nome = "Cicatricure" },
-- 	["dipirona"] = { index = "dipirona", nome = "Dipirona" },
-- 	["paracetamol"] = { index = "paracetamol", nome = "Paracetamol" },
-- 	["clozapina"] = { index = "clozapina", nome = "Clozapina" },
-- 	["amoxilina"] = { index = "amoxilina", nome = "Amoxilina" },
-- 	["omeprazol"] = { index = "pmeprazol", nome = "Omeprazol" },
-- 	["riopan"] = { index = "riopan", nome = "Riopan" },
-- 	["fluoxetina"] = { index = "fluoxetina", nome = "Fluoxetina" },
-- 	["luftal"] = { index = "luftal", nome = "Luftal" },
-- 	["buscofem"] = { index = "buscofem", nome = "Buscofem" },
-- 	["allegra"] = { index = "allegra", nome = "Allegra" },
-- 	["novalgina"] = { index = "novalgina", nome = "Novalgina" },
-- 	["rivotril"] = { index = "rivotril", nome = "Rivotril" },
-- 	["cataflan"] = { index = "cataflan", nome = "Cataflan" },
-- 	["camisinha"] = { index = "camisinha", nome = "Camisinha" },
-- 	["anticoncepcional"] = { index = "anticoncepcional", nome = "Anticoncepcional" },
-- 	["cerveja"] = { index = "cerveja", nome = "Cerveja" },
-- 	["tequila"] = { index = "tequila", nome = "Tequila" },
-- 	["vodka"] = { index = "vodka", nome = "Vodka" },
-- 	["whisky"] = { index = "whisky", nome = "Whisky" },
-- 	["conhaque"] = { index = "conhaque", nome = "Conhaque" },
-- 	["absinto"] = { index = "absinto", nome = "Absinto" },
-- 	["dinheirosujo"] = { index = "dinheirosujo", nome = "Dinheiro Sujo" },
-- 	["repairkit"] = { index = "repairkit", nome = "Kit de Reparos" },
-- 	["pneus"] = { index = "pneus", nome = "Pneus" },
-- 	["algemas"] = { index = "algemas", nome = "Algemas" },
-- 	["cordas"] = { index = "cordas", nome = "Cordas" },
-- 	["capuz"] = { index = "capuz", nome = "Capuz" },
-- 	["lockpick"] = { index = "lockpick", nome = "Lockpick" },
-- 	["masterpick"] = { index = "masterpick", nome = "Masterpick" },
-- 	["eventkey"] = { index = "eventkey", nome = "Eventkey" },
-- 	["militec"] = { index = "militec", nome = "Militec-1" },
-- 	["racao"] = { index = "racao", nome = "Ração" },
-- 	["ticket"] = { index = "ticket", nome = "Ticket" },
-- 	["carnedecormorao"] = { index = "carnedecormorao", nome = "Carne de Cormorão" },
-- 	["carnedecorvo"] = { index = "carnedecorvo", nome = "Carne de Corvo" },
-- 	["carnedeaguia"] = { index = "carnedeaguia", nome = "Carne de Águia" },
-- 	["carnedecervo"] = { index = "carnedecervo", nome = "Carne de Cervo" },
-- 	["carnedecoelho"] = { index = "carnedecoelho", nome = "Carne de Coelho" },
-- 	["carnedecoyote"] = { index = "carnedecoyote", nome = "Carne de Coyote" },
-- 	["carnedelobo"] = { index = "carnedelobo", nome = "Carne de Lobo" },
-- 	["carnedepuma"] = { index = "carnedepuma", nome = "Carne de Puma" },
-- 	["carnedejavali"] = { index = "carnedejavali", nome = "Carne de Javali" },
-- 	["turtlemeat"] = { index = "turtlemeat", nome = "Turtle Meat" },
-- 	["graos"] = { index = "graos", nome = "Graos" },
-- 	["graosimpuros"] = { index = "graosimpuros", nome = "Graos Impuros" },
-- 	["isca"] = { index = "isca", nome = "Isca" },
-- 	["dourado"] = { index = "dourado", nome = "Dourado" },
-- 	["corvina"] = { index = "corvina", nome = "Corvina" },
-- 	["salmao"] = { index = "salmao", nome = "Salmão" },
-- 	["pacu"] = { index = "pacu", nome = "Pacu" },
-- 	["pintado"] = { index = "pintado", nome = "Pintado" },
-- 	["pirarucu"] = { index = "pirarucu", nome = "Pirarucu" },
-- 	["tilapia"] = { index = "tilapia", nome = "Tilápia" },
-- 	["tucunare"] = { index = "tucunare", nome = "Tucunaré" },
-- 	["lambari"] = { index = "lambari", nome = "Lambari" },
-- 	["energetico"] = { index = "energetico", nome = "Energético" },
-- 	["mochila"] = { index = "mochila", nome = "Mochila" },
-- 	["maconha"] = { index = "maconha", nome = "Maconha" },
-- 	["adubo"] = { index = "adubo", nome = "Adubo" },
-- 	["fertilizante"] = { index = "fertilizante", nome = "Fertilizante" },
-- 	["capsula"] = { index = "capsula", nome = "Cápsula" },
-- 	["polvora"] = { index = "polvora", nome = "Pólvora" },
-- 	["orgao"] = { index = "orgao", nome = "Órgão" },
-- 	["etiqueta"] = { index = "etiqueta", nome = "Etiqueta" },
-- 	["pendrive"] = { index = "pendrive", nome = "Pendrive" },
-- 	["notebook"] = { index = "notebook", nome = "Notebook" },
-- 	["placa"] = { index = "placa", nome = "Placa" },
-- 	["relogioroubado"] = { index = "relogioroubado", nome = "Relógio Roubado" },
-- 	["pulseiraroubada"] = { index = "pulseiraroubada", nome = "Pulseira Roubada" },
-- 	["anelroubado"] = { index = "anelroubado", nome = "Anel Roubado" },
-- 	["colarroubado"] = { index = "colarroubado", nome = "Colar Roubado" },
-- 	["brincoroubado"] = { index = "brincoroubado", nome = "Brinco Roubado" },
-- 	["carteiraroubada"] = {  index = "carteiraroubada", nome = "Carteira Roubada"  },
-- 	["tabletroubado"] = {  index = "tabletroubado", nome = "Tablet Roubado"  },
-- 	["sapatosroubado"] = {  index = "sapatosroubado", nome = "Sapatos Roubado"  },
-- 	["carregadorroubado"] = { index = "carregadorroubado", nome = "Carregador Roubado" },
-- 	["vibradorroubado"] = { index = "vibradorroubado", nome = "Vibrador Roubado" },
-- 	["perfumeroubado"] = { index = "perfumeroubado", nome = "Perfume Roubado" },
-- 	["maquiagemroubada"] = { index = "maquiagemroubada", nome = "Maquiagem Roubada" },
-- 	["folhadecoca"] = { index = "folhadecoca", nome = "Folha de Coca" },
-- 	["pastadecoca"] = { index = "pastadecoca", nome = "Pasta de Coca" },
-- 	["cocaina"] = { index = "cocaina", nome = "Cocaína" },
-- 	["fungo"] = { index = "fungo", nome = "Fungo" },
-- 	["dietilamina"] = { index = "dietilamina", nome = "Dietilamina" },
-- 	["lsd"] = { index = "lsd", nome = "LSD" },
-- 	["acidobateria"] = { index = "acidobateria", nome = "Ácido de Bateria" },
-- 	["anfetamina"] = { index = "anfetamina", nome = "Anfetamina" },
-- 	["metanfetamina"] = { index = "metanfetamina", nome = "Metanfetamina" },
-- 	["armacaodearma"] = { index = "armacaodearma", nome = "Armação de Arma" },
-- 	["pecadearma"] = { index = "pecadearma", nome = "Peça de Arma" },
-- 	["logsinvasao"] = { index = "logsinvasao", nome = "L. Inv. Banco" },
-- 	["keysinvasao"] = { index = "keysinvasao", nome = "K. Inv. Banco" },
-- 	["pendriveinformacoes"] = { index = "pendriveinformacoes", nome = "P. Info." },
-- 	["acessodeepweb"] = { index = "acessodeepweb", nome = "P. DeepWeb" },
-- 	["diamante"] = { index = "diamante", nome = "Min. Diamante" },
-- 	["ouro"] = { index = "ouro", nome = "Min. Ouro" },
-- 	["bronze"] = { index = "bronze", nome = "Min. Bronze" },
-- 	["ferro"] = { index = "ferro", nome = "Min. Ferro" },
-- 	["rubi"] = { index = "rubi", nome = "Min. Rubi" },
-- 	["esmeralda"] = { index = "esmeralda", nome = "Min. Esmeralda" },
-- 	["safira"] = { index = "safira", nome = "Min. Safira" },
-- 	["topazio"] = { index = "topazio", nome = "Min. Topazio" },
-- 	["ametista"] = { index = "ametista", nome = "Min. Ametista" },
-- 	["diamante2"] = { index = "diamante2", nome = "Diamante" },
-- 	["ouro2"] = { index = "ouro2", nome = "Ouro" },
-- 	["bronze2"] = { index = "bronze2", nome = "Bronze" },
-- 	["ferro2"] = { index = "ferro2", nome = "Ferro" },
-- 	["rubi2"] = { index = "rubi2", nome = "Rubi" },
-- 	["esmeralda2"] = { index = "esmeralda2", nome = "Esmeralda" },
-- 	["safira2"] = { index = "safira2", nome = "Safira" },
-- 	["topazio2"] = { index = "topazio2", nome = "Topazio" },
-- 	["ametista2"] = { index = "ametista2", nome = "Ametista" },
-- 	["ingresso"] = { index = "ingresso", nome = "Ingresso Eventos" },
-- 	["radio"] = { index = "radio", nome = "Radio" },
-- 	["celular"] = { index = "celular", nome = "Celular" },
-- 	["serra"] = { index = "serra", nome = "Serra" },
-- 	["furadeira"] = { index = "furadeira", nome = "Furadeira" },
-- 	["roupas"] = { index = "roupas", nome = "Roupas" },
-- 	["oxigenio"] = { index = "oxigenio", nome = "Oxigênio" },
-- 	["postit"] = { index = "postit", nome = "Postit" },
-- 	["xerelto"] = { index = "xerelto", nome = "Xerelto" },
-- 	["coumadin"] = { index = "coumadin", nome = "Coumadin" },
-- 	["keycard"] = { index = "keycard", nome = "Keycard" },
-- 	["bluestone"] = { index = "bluestone", nome = "Bluestone" },
-- 	["greenstone"] = { index = "greenstone", nome = "Greenstone" },
-- 	["purplestone"] = { index = "purplestone", nome = "Purplestone" },
-- 	["redstone"] = { index = "redstone", nome = "Redstone" },
-- 	["yellowstone"] = { index = "yellowstone", nome = "Yellowstone" },
-- 	["vipgold15"] = { index = "vipgold15", nome = "Vip Gold 15 Dias" },
-- 	["vipgold30"] = { index = "vipgold30", nome = "Vip Gold 30 Dias" },
-- 	["vipplatinum15"] = { index = "vipplatinum15", nome = "Vip Platinum 15 Dias" },
-- 	["vipplatinum30"] = { index = "vipplatinum30", nome = "Vip Platinum 30 Dias" },
-- 	["vipaparencia"] = { index = "vipaparencia", nome = "Vip Aparencia" },
-- 	["vipplaca"] = { index = "vipplaca", nome = "Vip Placa" },
-- 	["vipgaragem"] = { index = "vipgaragem", nome = "Vip Garagem" },
-- 	["wbody|WEAPON_DAGGER"] = { index = "adaga", nome = "Adaga" },
-- 	["wbody|WEAPON_BAT"] = { index = "beisebol", nome = "Taco de Beisebol" },
-- 	["wbody|WEAPON_BOTTLE"] = { index = "garrafa", nome = "Garrafa" },
-- 	["wbody|WEAPON_CROWBAR"] = { index = "cabra", nome = "Pé de Cabra" },
-- 	["wbody|WEAPON_FLASHLIGHT"] = { index = "lanterna", nome = "Lanterna" },
-- 	["wbody|WEAPON_GOLFCLUB"] = { index = "golf", nome = "Taco de Golf" },
-- 	["wbody|WEAPON_HAMMER"] = { index = "martelo", nome = "Martelo" },
-- 	["wbody|WEAPON_HATCHET"] = { index = "machado", nome = "Machado" },
-- 	["wbody|WEAPON_KNUCKLE"] = { index = "ingles", nome = "Soco-Inglês" },
-- 	["wbody|WEAPON_KNIFE"] = { index = "faca", nome = "Faca" },
-- 	["wbody|WEAPON_MACHETE"] = { index = "machete", nome = "Machete" },
-- 	["wbody|WEAPON_SWITCHBLADE"] = { index = "canivete", nome = "Canivete" },
-- 	["wbody|WEAPON_NIGHTSTICK"] = { index = "cassetete", nome = "Cassetete" },
-- 	["wbody|WEAPON_WRENCH"] = { index = "grifo", nome = "Chave de Grifo" },
-- 	["wbody|WEAPON_BATTLEAXE"] = { index = "batalha", nome = "Machado de Batalha" },
-- 	["wbody|WEAPON_POOLCUE"] = { index = "sinuca", nome = "Taco de Sinuca" },
-- 	["wbody|WEAPON_STONE_HATCHET"] = { index = "pedra", nome = "Machado de Pedra" },
-- 	["wbody|WEAPON_PISTOL"] = { index = "m1911", nome = "M1911" },
-- 	["wbody|WEAPON_PISTOL_MK2"] = { index = "fiveseven", nome = "FN Five Seven" },
-- 	["wbody|WEAPON_COMBATPISTOL"] = { index = "glock", nome = "Glock 19" },
-- 	["wbody|WEAPON_STUNGUN"] = { index = "taser", nome = "Taser" },
-- 	["wbody|WEAPON_SNSPISTOL"] = { index = "hkp7m10", nome = "HK P7M10" },
-- 	["wbody|WEAPON_VINTAGEPISTOL"] = { index = "m1922", nome = "M1922" },
-- 	["wbody|WEAPON_REVOLVER"] = { index = "magnum44", nome = "Magnum 44" },
-- 	["wbody|WEAPON_REVOLVER_MK2"] = { index = "magnum357", nome = "Magnum 357" },
-- 	["wbody|WEAPON_MUSKET"] = { index = "winchester22", nome = "Winchester 22" },
-- 	["wbody|WEAPON_FLARE"] = { index = "sinalizador", nome = "Sinalizador" },
-- 	["wbody|GADGET_PARACHUTE"] = { index = "paraquedas", nome = "Paraquedas" },
-- 	["wbody|WEAPON_FIREEXTINGUISHER"] = { index = "extintor", nome = "Extintor" },
-- 	["wbody|WEAPON_MICROSMG"] = { index = "uzi", nome = "Uzi" },
-- 	["wbody|WEAPON_SMG"] = { index = "mp5", nome = "MP5" },
-- 	["wbody|WEAPON_ASSAULTSMG"] = { index = "mtar21", nome = "MTAR-21" },
-- 	["wbody|WEAPON_COMBATPDW"] = { index = "sigsauer", nome = "Sig Sauer MPX" },
-- 	["wbody|WEAPON_PUMPSHOTGUN_MK2"] = { index = "remington", nome = "Remington 870" },
-- 	["wbody|WEAPON_CARBINERIFLE"] = { index = "m4a1", nome = "M4A1" },
-- 	["wbody|WEAPON_ASSAULTRIFLE"] = { index = "ak103", nome = "AK-103" },
-- 	["wbody|WEAPON_GUSENBERG"] = { index = "thompson", nome = "Thompson" },
-- 	["wbody|WEAPON_MACHINEPISTOL"] = { index = "tec9", nome = "Tec-9" },
-- 	["wbody|WEAPON_CARBINERIFLE_MK2"] = { index = "mpx", nome = "MPX" },
-- 	["wbody|WEAPON_COMPACTRIFLE"] = { index = "aks", nome = "AKS-74U" },
-- 	["wbody|WEAPON_PETROLCAN"] = { index = "gasolina", nome = "Galão de Gasolina" },
-- 	["wammo|WEAPON_PISTOL"] = { index = "m-m1911", nome = "M.M1911" },
-- 	["wammo|WEAPON_PISTOL_MK2"] = { index = "m-fiveseven", nome = "M.Five Seven" },
-- 	["wammo|WEAPON_COMBATPISTOL"] = { index = "m-glock", nome = "M.Glock 19" },
-- 	["wammo|WEAPON_STUNGUN"] = { index = "m-taser", nome = "M.Taser" },
-- 	["wammo|WEAPON_SNSPISTOL"] = { index = "m-hkp7m10", nome = "M.HK P7M10" },
-- 	["wammo|WEAPON_VINTAGEPISTOL"] = { index = "m-m1922", nome = "M.M1922" },
-- 	["wammo|WEAPON_REVOLVER"] = { index = "m-magnum44", nome = "M.Magnum 44" },
-- 	["wammo|WEAPON_REVOLVER_MK2"] = { index = "m-magnum357", nome = "M.Magnum 357" },
-- 	["wammo|WEAPON_MUSKET"] = { index = "m-winchester22", nome = "M.Winchester 22" },
-- 	["wammo|WEAPON_FLARE"] = { index = "m-sinalizador", nome = "M.Sinalizador" },
-- 	["wammo|GADGET_PARACHUTE"] = { index = "m-paraquedas", nome = "M.Paraquedas" },
-- 	["wammo|WEAPON_FIREEXTINGUISHER"] = { index = "m-extintor", nome = "M.Extintor" },
-- 	["wammo|WEAPON_MICROSMG"] = { index = "m-uzi", nome = "M.Uzi" },
-- 	["wammo|WEAPON_SMG"] = { index = "m-mp5", nome = "M.MP5" },
-- 	["wammo|WEAPON_ASSAULTSMG"] = { index = "m-mtar21", nome = "M.MTAR-21" },
-- 	["wammo|WEAPON_COMBATPDW"] = { index = "m-sigsauer", nome = "M.Sig Sauer MPX" },
-- 	["wammo|WEAPON_PUMPSHOTGUN"] = { index = "m-shotgun", nome = "M.Shotgun" },
-- 	["wammo|WEAPON_PUMPSHOTGUN_MK2"] = { index = "m-remington", nome = "M.Remington 870" },
-- 	["wammo|WEAPON_CARBINERIFLE"] = { index = "m-m4a1", nome = "M.M4A1" },
-- 	["wammo|WEAPON_ASSAULTRIFLE"] = { index = "m-ak103", nome = "M.AK-103" },
-- 	["wammo|WEAPON_MACHINEPISTOL"] = { index = "m-tec9", nome = "M.Tec-9" },
-- 	["wammo|WEAPON_CARBINERIFLE_MK2"] = { index = "m-mpx", nome = "M.MPX" },
-- 	["wammo|WEAPON_COMPACTRIFLE"] = { index = "m-aks", nome = "M.AKS-74U" },
-- 	["wammo|WEAPON_GUSENBERG"] = { index = "m-thompson", nome = "M.Thompson" },
-- 	["wammo|WEAPON_PETROLCAN"] = { index = "combustivel", nome = "Combustível" }
-- }
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- /item
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand('item',function(source,args,rawCommand)
-- 	local user_id = vRP.getUserId(source)
-- 	local identity = vRP.getUserIdentity(user_id)
-- 	if vRP.hasPermission(user_id,"admin.permissao") then
-- 		if args[1] and args[2] and itemlist[args[1]] ~= nil then
-- 			vRP.giveInventoryItem(user_id,args[1],parseInt(args[2]))
-- 			SendWebhookMessage(webhookgive,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[PEGOU]: "..vRP.format(parseInt(args[2])).." "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /o
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("o",function(source,args,rawCommand)
    vCLIENT.insertObjects(source,tostring(args[1]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /job
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("job",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local juizes = vRP.getUsersByPermission("juiz.permissao")
	local juizes_nomes = ""

	local advogados = vRP.getUsersByPermission("advogado.permissao")
	local advogados_nomes = ""

	local mecanicos = vRP.getUsersByPermission("mecanico.permissao")
	local mecanicos_nomes = ""
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"juiz.permissao") then
		for k,v in pairs(juizes) do
			local identity = vRP.getUserIdentity(parseInt(v))
 			juizes_nomes = juizes_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
		end
		TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..#juizes.." Juizes</b> em serviço.<br> "..juizes_nomes)
	end

	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"advogado.permissao") then
		for k,v in pairs(advogados) do
			local identity = vRP.getUserIdentity(parseInt(v))
 			advogados_nomes = advogados_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
		end
		TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..#advogados.." Advogados</b> em serviço.<br> "..advogados_nomes)
	end

	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mecanico.permissao") then
		for k,v in pairs(mecanicos) do
			local identity = vRP.getUserIdentity(parseInt(v))
 			mecanicos_nomes = mecanicos_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
		end
		TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..#mecanicos.." Mecânicos</b> em serviço.<br> "..mecanicos_nomes)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /illegal
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("illegal",function(source,args,rawCommand)
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
	if vRP.hasPermission(user_id,"admin.permissao") then
		for k,v in pairs(roxos) do
			local identity = vRP.getUserIdentity(parseInt(v))
			roxos_nomes = roxos_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
		end
		TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..#roxos.." Roxos</b> em serviço.<br> "..roxos_nomes)

		for k,v in pairs(amarelos) do
			local identity = vRP.getUserIdentity(parseInt(v))
			amarelos_nomes = amarelos_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
		end
		TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..#amarelos.." Amarelos</b> em serviço.<br> "..amarelos_nomes)

		for k,v in pairs(vermelhos) do
			local identity = vRP.getUserIdentity(parseInt(v))
			vermelhos_nomes = vermelhos_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
		end
		TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..#vermelhos.." Vermelhos</b> em serviço.<br> "..vermelhos_nomes)

		for k,v in pairs(mafia) do
			local identity = vRP.getUserIdentity(parseInt(v))
			mafia_nomes = mafia_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
		end
		TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..#mafia.." Serpentes</b> em serviço.<br> "..mafia_nomes)

		for k,v in pairs(serpentes) do
			local identity = vRP.getUserIdentity(parseInt(v))
 			serpentes_nomes = serpentes_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
		end
		TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..#serpentes.." Serpentes</b> em serviço.<br> "..serpentes_nomes)

		for k,v in pairs(motoclub) do
			local identity = vRP.getUserIdentity(parseInt(v))
 			motoclub_nomes = motoclub_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
		end
		TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..#motoclub.." Motoclub</b> em serviço.<br> "..motoclub_nomes)

		for k,v in pairs(yakuza) do
			local identity = vRP.getUserIdentity(parseInt(v))
 			yakuza_nomes = yakuza_nomes.." "..v..": <b>"..identity.name.." "..identity.firstname.."</b><br>"
		end
		TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..#yakuza.." Yakuza</b> em serviço.<br> "..yakuza_nomes)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /informante
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("informante",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local policiais = vRP.getUsersByPermission("policia.permissao")
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if vRPclient.checkDistance(source,-69.88,-1230.79,28.95,1.5) then 
		if exports["pd-inventory"]:consumeItem(user_id,"dinheirosujo",5000,true)then
			TriggerClientEvent("Notify",source,"sucesso","Você pagou <b>$5.000 dólares sujos</b>, pelas informações dos policiais.")
			TriggerClientEvent("Notify",source,"importante","Atualmente <b>"..#policiais.." Policiais</b> em serviço.<br>")
		else
			TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /invasao
-----------------------------------------------------------------------------------------------------------------------------------------
local guetos = {}
RegisterCommand("invasao",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local uplayer = vRP.getUserSource(user_id)
	local x,y,z = vRPclient.getPosition(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if vRP.hasPermission(user_id,"PurplePermission") or vRP.hasPermission(user_id,"marabuntas.permissao") or vRP.hasPermission(user_id,"RedPermission") or vRP.hasPermission(user_id,"YellowPermission") then
		local policia = vRP.getUsersByPermission("policia.permissao")
		for l,w in pairs(policia) do
			local player = vRP.getUserSource(parseInt(w))
			if player and player ~= uplayer then
				async(function()
					local id = idgens:gen()
					if vRP.hasPermission(user_id,"PurplePermission") then
						guetos[id] = vRPclient.addBlip(player,x,y,z,437,27,"Localização da invasão",0.8,false)
						TriggerClientEvent("Notify",player,"negado","Localização da invasão entre gangues recebida de <b>Ballas</b>.")
					elseif vRP.hasPermission(user_id,"YellowPermission") then
						guetos[id] = vRPclient.addBlip(player,x,y,z,437,46,"Localização da invasão",0.8,false)
						TriggerClientEvent("Notify",player,"negado","Localização da invasão entre gangues recebida de <b>Vagos</b>.")
					elseif vRP.hasPermission(user_id,"RedPermission") then
						guetos[id] = vRPclient.addBlip(player,x,y,z,437,25,"Localização da invasão",0.8,false)
						TriggerClientEvent("Notify",player,"negado","Localização da invasão entre gangues recebida de <b>Families</b>.")
					elseif vRP.hasPermission(user_id,"marabuntas.permissao") then
						guetos[id] = vRPclient.addBlip(player,x,y,z,437,38,"Localização da invasão",0.8,false)
						TriggerClientEvent("Notify",player,"negado","Localização da invasão entre gangues recebida de <b>Marabuntas</b>.")
					end
					vRPclient._playSound(player,"5s_To_Event_Start_Countdown","GTAO_FM_Events_Soundset")
					vRPclient._playSound(source,"5s_To_Event_Start_Countdown","GTAO_FM_Events_Soundset")
					SetTimeout(60000,function() vRPclient.removeBlip(player,guetos[id]) idgens:free(id) end)
				end)
			end
		end
		TriggerClientEvent("Notify",source,"sucesso","Localização enviada com sucesso.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /id
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('id',function(source,rawCommand)    
    local user_id = vRP.getUserId(source)
    local nplayer = vRPclient.getNearestPlayer(source,2)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id then
        local identity = vRP.getUserIdentity(nuser_id)
        vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 8%; right: 2.5%; position: absolute; border: 1px solid rgba(255,255,255,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #d1257d; }","<div class=\"local\"><b>Passaporte:</b> ( "..vRP.format(identity.user_id).." )</div>")
       	if not vRP.hasPermission(user_id,"admin.permissao") and not vRP.hasPermission(user_id,"suporte.permissao") then
            TriggerClientEvent("Notify",nplayer,"importante","Seu passaporte está sendo <b>Verificado</b>.")
        end
        vRP.request(source,"Você deseja fechar o registro geral ?",1000)
        vRPclient.removeDiv(source,"completerg")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /debug
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('debug',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isInVehicle(source) or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if user_id and vRPclient.getHealth(source) >= 300 then	
		local data = vRP.getUserDataTable(user_id)
		local x,y,z = vRPclient.getPosition(source)
		if data then
			vRPclient._setCustomization(source,data.customization)
			--TriggerClientEvent("syncarea",-1,x,y,z,2)
		end
	end
	TriggerClientEvent("debug:nui",source)
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
AddEventHandler("vrp_player:salaryPayment",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(salarios) do
			if vRP.hasPermission(user_id,v.permissao) then
				local maxpayment = 7500
				if v.permissao == "policia.permissao" then
					local amount = v.payment
					local promotion = vRP.getUData(parseInt(user_id),"vRP:PolicePromotion")
					local bonus = 500
					if parseInt(promotion) ~= 0 or parseInt(promotion) ~= nil then
						for x = 1, parseInt(promotion) do
							amount = amount + bonus
						end
					end
					if amount >= maxpayment then
						amount = maxpayment
					end
					vRP.giveBankMoney(user_id,parseInt(amount),true)
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
					--TriggerClientEvent("Notify",source,"importante","Obrigado por colaborar com a cidade, seu salario de <b>$"..vRP.format(parseInt(amount)).." dólares</b> foi depositado.")
				elseif v.permissao == "paramedico.permissao" then
					local amount = v.payment
					local promotion = vRP.getUData(parseInt(user_id),"vRP:ParamedicPromotion")
					local bonus = 500
					if parseInt(promotion) ~= 0 or parseInt(promotion) ~= nil then
						for x = 1, parseInt(promotion) do
							amount = amount + bonus
						end
					end
					if amount >= maxpayment then
						amount = maxpayment
					end
					vRP.giveBankMoney(user_id,parseInt(amount),true)
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
					--TriggerClientEvent("Notify",source,"importante","Obrigado por colaborar com a cidade, seu salario de <b>$"..vRP.format(parseInt(amount)).." dólares</b> foi depositado.")
				end
				if v.permissao ~= "policia.permissao" and v.permissao ~= "paramedico.permissao" then
					vRP.giveBankMoney(user_id,parseInt(v.payment),true)
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
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
AddEventHandler("kickAFK",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if not vRP.hasPermission(user_id,"admin.permissao") then
        DropPlayer(source,"Voce foi desconectado por ficar ausente.")
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
RegisterCommand('party',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"disneynews.permissao") then
        local identity = vRP.getUserIdentity(user_id)
        local mensagem = vRP.prompt(source,"Mensagem:","")
        if mensagem == "" then
            return
        end
        vRPclient.setDiv(-1,"party","@keyframes blinking { 0%{ background-color: #ff3d50; opacity: 0.8; } 25%{ background-color: #d22d99; opacity: 0.8; } 50%{ background-color: #55d66b; opacity: 0.8; } 75%{ background-color: #22e5e0; opacity: 0.8; } 100%{ background-color: #222291; opacity: 0.8; }  } .div_party { font-size: 11px; font-family: arial; color: rgba(255,255,255,1); padding: 20px; bottom: 30%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; animation: blinking 1s infinite; } bold { font-size: 16px; }","<bold>"..mensagem.."</bold><br><br>Mensagem enviada por: "..identity.name.." "..identity.firstname)
        SetTimeout(25000,function()
            vRPclient.removeDiv(-1,"party")
        end)
    else
        if vRP.request(source,"Deseja pagar <b>$10.000 dólares</b> para anunciar sua festa ?",30) then
			local identity = vRP.getUserIdentity(user_id)
			local mensagem = vRP.prompt(source,"Mensagem:","")
			if mensagem == "" then
				return
			end
			vRP.tryFullPayment(user_id,10000)
			TriggerClientEvent("Notify",source,"sucesso","Você pagou <b>$10.000 dólares</b> pelo anuncio de sua festa.")
			vRPclient.setDiv(-1,"party","@keyframes blinking { 0%{ background-color: #ff3d50; opacity: 0.8; } 25%{ background-color: #d22d99; opacity: 0.8; } 50%{ background-color: #55d66b; opacity: 0.8; } 75%{ background-color: #22e5e0; opacity: 0.8; } 100%{ background-color: #222291; opacity: 0.8; }  } .div_party { font-size: 11px; font-family: arial; color: rgba(255,255,255,1); padding: 20px; bottom: 30%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; animation: blinking 1s infinite; } bold { font-size: 16px; }","<bold>"..mensagem.."</bold><br><br>Mensagem enviada por: "..identity.name.." "..identity.firstname)
			SetTimeout(25000,function()
				vRPclient.removeDiv(-1,"party")
			end)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /sequestro
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('sequestro',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,5)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isInVehicle(source) or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if nplayer then
		if vRPclient.isHandcuffed(nplayer) then
			if not vRPclient.getNoCarro(source) then
				local vehicle = vRPclient.getNearestVehicle(source,7)
				if vehicle then
					if vRPclient.getCarroClass(source,vehicle) then
						vRPclient.setMalas(nplayer)
					end
				end
			elseif vRPclient.isMalas(nplayer) then
				vRPclient.setMalas(nplayer)
			end
		else
			TriggerClientEvent("Notify",source,"aviso","A pessoa precisa estar algemada para colocar ou retirar do Porta-Malas.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /enviar
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('enviar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	local nuser_id = vRP.getUserId(nplayer)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if nuser_id and parseInt(args[1]) > 0 then
		if vRP.tryPayment(user_id,parseInt(args[1]),true) then
			vRP.giveMoney(nuser_id,parseInt(args[1]),true)
			vRPclient._playAnim(source,true,{"mp_common","givetake1_a"},false)
			vRPclient._playAnim(nplayer,true,{"mp_common","givetake1_a"},false)

			local identity = vRP.getUserIdentity(user_id)
			local identitynu = vRP.getUserIdentity(nuser_id)
			SendWebhookMessage(webhookenviardinheiro,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU]: $"..vRP.format(parseInt(args[1])).." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		else
			TriggerClientEvent("Notify",source,"negado","Não tem a quantia que deseja enviar.",8000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /garmas
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('garmas',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if user_id then
		if vRP.request(source,"Deseja guardar todo o seu armamento ?",30) then
			local weapons = vRPclient.replaceWeapons(source,{})
			local ammo
			for k,v in pairs(weapons) do
				exports["pd-inventory"]:giveItem(user_id, string.sub(string.lower(k),8), 1, true)
				if v.ammo > 0 then
					ammo = "ammo_"..string.sub(string.lower(k),8)
					exports["pd-inventory"]:giveItem(user_id, ammo, v.ammo, true, "Recebeu", true)
				end
				SendWebhookMessage(webhookgarmas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..k.." \n[QUANTIDADE]: "..v.ammo.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				if v.ammo == 250 and not vRP.hasPermission(user_id,"policia.permissao") then 
					SendWebhookMessage(webhookgarmas250,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.."\n[GUARDOU]: "..k.." \n[QUANTIDADE]: "..v.ammo.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				end
			end
			TriggerClientEvent("Notify",source,"sucesso","Guardou seu armamento na mochila.")
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

RegisterCommand('roubar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isInVehicle(source) or vRPclient.isHandcuffed(source) then--or -- vRP.searchReturn(source,user_id) then
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
					TriggerClientEvent('cancelando',source,true,true)
					vRPclient._playAnim(source,false,{"amb@medic@standing@tendtodead@idle_a","idle_a"},true)
					TriggerClientEvent("progress",source,15000,"roubando")
					SetTimeout(15000,function()
						local weapons = vRPclient.replaceWeapons(nplayer,{})
						local ammo
						for k,v in pairs(weapons) do
							exports["pd-inventory"]:giveItem(nuser_id, string.sub(string.lower(k),8), 1, true)
							if v.ammo > 0 then
								ammo = "ammo_"..string.sub(string.lower(k),8)
								exports["pd-inventory"]:giveItem(nuser_id, ammo, v.ammo, true)
							end
						end
						local query = vRP.query("pd-getInv", { user_id = nuser_id })
						local ndata = json.decode(query[1].itemlist)
						if ndata ~= nil then
							for k,v in pairs(ndata) do
								if not policeitems[k]then
									if exports["pd-inventory"]:checkWeightAmount(user_id, k, v.amount) then
										exports["pd-inventory"]:consumeItem(nuser_id, k, v.amount, true) 
										exports["pd-inventory"]:giveItem(user_id, k, v.amount, true)
									end
								end
							end
						end
						local nmoney = vRP.getMoney(nuser_id)
						if vRP.tryPayment(nuser_id,nmoney) then
							vRP.giveMoney(user_id,nmoney)
						end
						vRP.searchTimer(user_id,parseInt(120))
						vRPclient.stopAnim(source,false)
						TriggerClientEvent('cancelando',source,false,false)
						TriggerClientEvent("Notify",source,"sucesso","Roubo concluido com sucesso.")
					end)
				else
					if vRP.request(nplayer,"Você está sendo roubado, deseja passar tudo ?",30) then
						TriggerClientEvent('cancelando',source,true,true)
						vRPclient._playAnim(source,false,{"oddjobs@shop_robbery@rob_till","loop"},true)
						vRPclient._playAnim(nplayer,false,{"random@mugging3","handsup_standing_base"},true)
						TriggerClientEvent("progress",source,15000,"roubando")
						SetTimeout(15000,function()
							local weapons = vRPclient.replaceWeapons(nplayer,{})
							local ammo
							for k,v in pairs(weapons) do
								exports["pd-inventory"]:giveItem(nuser_id, string.sub(string.lower(k),8), 1, true)
								if v.ammo > 0 then
									ammo = "ammo_"..string.sub(string.lower(k),8)
									exports["pd-inventory"]:giveItem(nuser_id, ammo, v.ammo, true)
								end
							end
							local query = vRP.query("pd-getInv", { user_id = nuser_id })
							local ndata = json.decode(query[1].itemlist)
							if ndata ~= nil then
								for k,v in pairs(ndata) do
									if not policeitems[k]then
										if exports["pd-inventory"]:checkWeightAmount(user_id, k, v.amount) then
											exports["pd-inventory"]:consumeItem(nuser_id, k, v.amount, true) 
											exports["pd-inventory"]:giveItem(user_id, k, v.amount, true)
										end
									end
								end
							end
							local nmoney = vRP.getMoney(nuser_id)
							if vRP.tryPayment(nuser_id,nmoney) then
								vRP.giveMoney(user_id,nmoney)
							end
							vRP.searchTimer(user_id,parseInt(120))
							vRPclient.stopAnim(source,false)
							vRPclient.stopAnim(nplayer,false)
							TriggerClientEvent('cancelando',source,false)
							TriggerClientEvent('cancelando',nplayer,false)
							TriggerClientEvent("Notify",source,"sucesso","Roubo concluido com sucesso.")
						end)
					else
						TriggerClientEvent("Notify",source,"importante","A pessoa está resistindo ao roubo.")
					end
				end
			--else
				--TriggerClientEvent("Notify",source,"importante","A pessoa está resistindo ao roubo.")
			--end
		else
			TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUBMITCALLER
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
RegisterServerEvent("submitCaller")
AddEventHandler("submitCaller",function(number,message)
	local source = source
	local answered = false
	local user_id = vRP.getUserId(source)
	local uplayer = vRP.getUserSource(user_id)
	if user_id then
		local x,y,z = vRPclient.getPosition(source)
		local players = {}
		vRPclient._DeletarObjeto(source)
		if number == "policia" then
			players = vRP.getUsersByPermission("policia.permissao")
		elseif number == "paramedico" then
			players = vRP.getUsersByPermission("paramedico.permissao")
			if #players == 0 then
				TriggerClientEvent("Notify",source,"importante", "Atualmente não há <b>Paramédicos</b> em serviço.")
				return true
			end
		elseif number == "mecanico" then
			players = vRP.getUsersByPermission("mecanico.permissao")
			if #players == 0 then
				TriggerClientEvent("Notify",source,"importante", "Atualmente não há <b>Mecânicos</b> em serviço.")
				return true
			end
		elseif number == "taxista" then
			players = vRP.getUsersByPermission("taxista.permissao")
			if #players == 0 then
				TriggerClientEvent("Notify",source,"importante", "Atualmente não há <b>Taxistas</b> em serviço.")
				return true
			end
		elseif number == "juiz" then
			players = vRP.getUsersByPermission("juiz.permissao")	
			if #players == 0 then
				TriggerClientEvent("Notify",source,"importante", "Atualmente não há <b>Juizes</b> em serviço.")
				return true
			end
		elseif number == "advogado" then
			players = vRP.getUsersByPermission("advogado.permissao")
			if #players == 0 then
				TriggerClientEvent("Notify",source,"importante", "Atualmente não há <b>Advogados</b> em serviço.")
				return true
			end
		elseif number == "css" then
			players = vRP.getUsersByPermission("conce.permissao")
			if #players == 0 then
				TriggerClientEvent("Notify",source,"importante", "Atualmente não há <b>Vendedores</b> em serviço.")
				return true
			end
		elseif number == "taxiaereo" then
			players = vRP.getUsersByPermission("fedex.permissao")
			if #players == 0 then
				TriggerClientEvent("Notify",source,"importante", "Atualmente não há <b>Pilotos</b> em serviço.")
				return true
			end
		end
		local identitys = vRP.getUserIdentity(user_id)
		TriggerClientEvent("Notify",source,"sucesso","Chamado enviado com sucesso.")
		vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
		for l,w in pairs(players) do
			local player = vRP.getUserSource(parseInt(w))
			local nuser_id = vRP.getUserId(player)
			if player and player ~= uplayer then
				async(function()
					vRPclient.playSound(player,"Out_Of_Area","DLC_Lowrider_Relay_Race_Sounds")
					TriggerClientEvent('chatMessage',player,"CHAMADO",{19,197,43},"Enviado por ^1"..identitys.name.." "..identitys.firstname.."^0, "..message)
					local ok = vRP.request(player,"Aceitar o chamado de <b>"..identitys.name.." "..identitys.firstname.."</b> ?",30)
					if ok then
						if not answered then
							answered = true
							local identity = vRP.getUserIdentity(nuser_id)
							TriggerClientEvent("Notify",source,"importante","Chamado atendido por <b>"..identity.name.." "..identity.firstname.."</b>, aguarde no local.")
							vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
							vRPclient._setGPS(player,x,y)
						else
							TriggerClientEvent("Notify",player,"importante","Chamado ja foi atendido por outra pessoa.")
							vRPclient.playSound(player,"CHECKPOINT_MISSED","HUD_MINI_GAME_SOUNDSET")
						end
					end
					local id = idgens:gen()
					blips[id] = vRPclient.addBlip(player,x,y,z,358,71,"Chamado",0.6,false)
					SetTimeout(300000,function() vRPclient.removeBlip(player,blips[id]) idgens:free(id) end)
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYTOW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trytow")
AddEventHandler("trytow",function(nveh,rveh)
	TriggerClientEvent("synctow",-1,nveh,rveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trytrunk")
AddEventHandler("trytrunk",function(nveh)
	TriggerClientEvent("synctrunk",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trywins")
AddEventHandler("trywins",function(nveh)
	TriggerClientEvent("syncwins",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryhood")
AddEventHandler("tryhood",function(nveh)
	TriggerClientEvent("synchood",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydoors")
AddEventHandler("trydoors",function(nveh,door)
	TriggerClientEvent("syncdoors",-1,nveh,door)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /mec
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mec',function(source,args,rawCommand)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"mecanico.permissao") then
			if user_id then
				TriggerClientEvent('chatMessage',-1,"DL SportRace - ^1"..identity.name.." "..identity.firstname,{255,128,0},rawCommand:sub(4))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /mr
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mr',function(source,args,rawCommand)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"mecanico.permissao") then
			local mecanico = vRP.getUsersByPermission("mecanico.permissao")
			for l,w in pairs(mecanico) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,identity.name.." "..identity.firstname,{255,191,128},rawCommand:sub(3))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /dn
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dn',function(source,args,rawCommand)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"disneynews.permissao") then
			local disneynews = vRP.getUsersByPermission("disneynews.permissao")
			for l,w in pairs(disneynews) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,identity.name.." "..identity.firstname,{255,102,102},rawCommand:sub(3))
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
AddEventHandler('ChatMe',function(text)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if user_id then
		local players = vRPclient.getNearestPlayers(source,10)
		TriggerClientEvent('DisplayMe',source,text,source)
		for k,v in pairs(players) do
			TriggerClientEvent('DisplayMe',k,text,source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /roll
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('ChatRoll')
AddEventHandler('ChatRoll',function(text)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if user_id then
		local players = vRPclient.getNearestPlayers(source,10)
		TriggerClientEvent('DisplayRoll',source,text,source)
		for k,v in pairs(players) do
			TriggerClientEvent('DisplayRoll',k,text,source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /card
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('card',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) then
		return
	end
	if user_id then
		local cd = math.random(1,13)
		local naipe = math.random(1,4)
		local players = vRPclient.getNearestPlayers(source,10)
		TriggerClientEvent('CartasMe',source,source,identity.name,cd,naipe)
		for k,v in pairs(players) do
			TriggerClientEvent('CartasMe',k,source,identity.name,cd,naipe)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /mascara
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mascara',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id,"roupas") >= 1 then
			TriggerClientEvent("setmascara",source,args[1],args[2])
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui <b>Roupas Secundárias</b> na mochila.") 
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
RegisterCommand('colete',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if user_id then
		if not args[1] and not args[2] then
			if vRPclient.getArmour(source) >= 90 then
				vRPclient._playAnim(source,true,{"clothingshirt","try_shirt_positive_d"},false)
				Citizen.Wait(2500)
				vRPclient.setArmour(source,0)
				exports["pd-inventory"]:giveItem(user_id,"colete",1,true,"Guardou",true)
				TriggerClientEvent("removeColeteUser",source)
			end
		else
			if vRPclient.getArmour(source) >= 1 then
				TriggerClientEvent("setColeteUser",source,args[1],args[2])
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
RegisterCommand('maos',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id,"roupas") >= 1 then
			TriggerClientEvent("setmaos",source,args[1],args[2])
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui <b>Roupas Secundárias</b> na mochila.") 
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /maose
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('maose',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id,"roupas") >= 1 then
			TriggerClientEvent("setmaose",source,args[1],args[2])
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui <b>Roupas Secundárias</b> na mochila.") 
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /maosd
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('maosd',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id,"roupas") >= 1 then
			TriggerClientEvent("setmaosd",source,args[1],args[2])
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui <b>Roupas Secundárias</b> na mochila.") 
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
RegisterCommand('acessorios',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id,"roupas") >= 1 then
			TriggerClientEvent("setacessorios",source,args[1],args[2])
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui <b>Roupas Secundárias</b> na mochila.") 
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
RegisterCommand('chapeu',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id,"roupas") >= 1 and args[1] ~= 39 then
			TriggerClientEvent("setchapeu",source,args[1],args[2])
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui <b>Roupas Secundárias</b> na mochila.") 
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /oculos
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('oculos',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if user_id then
		if exports["pd-inventory"]:getItemAmount(user_id,"roupas") >= 1 then
			TriggerClientEvent("setoculos",source,args[1],args[2])
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui <b>Roupas Secundárias</b> na mochila.") 
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /roupas
-----------------------------------------------------------------------------------------------------------------------------------------
local roupas = {
	["mecanico"] = {
		["male"] = { -1,0,-1,0,109,0,19,0,59,9,89,0,25,0,0,0,-1,0,-1,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 },
		["female"] = { -1,0,-1,0,-1,0,44,0,61,9,54,0,66,3,73,0,-1,0,-1,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 }
	},
	["piloto"] = {
		["male"] = { -1,0,-1,0,10,2,11,0,13,0,15,0,10,0,13,0,0,0,-1,0,113,1,5,0,-1,-1,-1,-1,-1,-1 },
		["female"] = { -1,0,-1,0,22,0,3,0,6,0,38,0,29,0,57,0,-1,0,-1,0,112,1,11,3,-1,-1,-1,-1,-1,-1 }
	},
	["paciente"] = {
		["male"] = { 0,0,0,0,0,0,15,0,61,0,15,0,16,0,104,0,0,0,0,0,-1,-1,0,0,-1,-1,-1,-1,-1,-1 },
		["female"] = { 0,0,0,0,0,0,15,0,57,0,7,0,5,0,105,0,0,0,0,0,-1,-1,15,0,-1,-1,-1,-1,-1,-1 }
	},
	["pelado"] = {
		["male"] = { 121,1,0,0,0,0,15,0,72,0,85,0,34,0,15,0,0,0,0,0,-1,-1,0,0,-1,-1,-1,-1,-1,-1 },
		["female"] = { 0,0,0,0,0,0,15,0,21,0,7,0,35,0,82,0,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 }
	},
}

RegisterCommand("roupas",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local tempo = json.decode(vRP.getUData(parseInt(user_id),"vRP:prisao")) or 0
	if vRPclient.getHealth(source) <= 101 or vRPclient.getArmour(source) >= 1 or vRPclient.isInVehicle(source) or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if parseInt(tempo) >= 1 then
		TriggerClientEvent("Notify",source,"negado","Você não pode trocar de roupas, enquanto está <b>Preso</b>.",8000)
		return
	end
	if args[1] then
		if args[1] == "save" then
			local custom = vRPclient.getCustomPlayer(source)
			if custom then
				vRP.setUData(parseInt(user_id),"vRP:defaultVisual",json.encode(custom))
				TriggerClientEvent("Notify",source,"sucesso","Roupas salvo com sucesso.",8000)
			end
		elseif roupas[tostring(args[1])] then
			TriggerClientEvent("progress",source,4000,"")
			TriggerClientEvent('cancelando',source,true,true)
			vRPclient._playAnim(source,false,{"clothingshoes","try_shoes_positive_d"},false)
			SetTimeout(4000,function()
				local model = vRPclient.getModelPlayer(source)
				if model == "mp_m_freemode_01" then
					TriggerClientEvent("updateRoupas",source,roupas[tostring(args[1])]["male"])
				elseif model == "mp_f_freemode_01" then
					TriggerClientEvent("updateRoupas",source,roupas[tostring(args[1])]["female"])
				end
				vRPclient.stopAnim(source,false)
				TriggerClientEvent('cancelando',source,false,false)
			end)
		end
	else
		TriggerClientEvent("progress",source,4000,"")
		TriggerClientEvent('cancelando',source,true,true)
		vRPclient._playAnim(source,false,{"clothingshoes","try_shoes_positive_d"},false)
		SetTimeout(4000,function()
			local consulta = vRP.getUData(parseInt(user_id),"vRP:defaultVisual")
			local resultado = json.decode(consulta) or {}
			if resultado then
				TriggerClientEvent("updateRoupas",source,resultado)
			end
			vRPclient.stopAnim(source,false)
			TriggerClientEvent('cancelando',source,false,false)
		end)
	end
end)

RegisterCommand("roupas2",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isInVehicle(source) or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			if args[1] then
				if roupas[tostring(args[1])] then
					local model = vRPclient.getModelPlayer(nplayer)
					if model == "mp_m_freemode_01" then
						TriggerClientEvent("updateRoupas",nplayer,roupas[tostring(args[1])]["male"])
					elseif model == "mp_f_freemode_01" then
						TriggerClientEvent("updateRoupas",nplayer,roupas[tostring(args[1])]["female"])
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /paypal
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('paypal',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if args[1] == "sacar" and parseInt(args[2]) > 0 then
			if vRP.getPaypalMoney(user_id) >= parseInt(args[2]) then
				vRP.giveBankMoney(user_id,parseInt(args[2]))
				vRP.paypalWithdraw(user_id,parseInt(args[2]))
				TriggerClientEvent("Notify",source,"sucesso","Efetuou o saque de <b>$"..vRP.format(parseInt(args[2])).." dólares</b> da sua conta paypal.",8000)
			else
				TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente em sua conta do paypal.",8000)
			end
		elseif args[1] == "trans" and parseInt(args[2]) > 0 and parseInt(args[3]) > 0 then
			local player = vRP.getUserSource(parseInt(args[2]))
			if player == nil then
				TriggerClientEvent("Notify",source,"aviso","Passaporte <b>"..vRP.format(parseInt(args[2])).."</b> indisponível no momento.",8000)
				return
			end
			if vRP.request(source,"Deseja transferir <b>$"..vRP.format(parseInt(args[3])).." dólares</b> para o passaporte: <b>"..vRP.format(parseInt(args[2])).."</b> ?",30) then
				local banco = vRP.getBankMoney(user_id)
				local paypal = vRP.getPaypalMoney(parseInt(args[2]))
				local identity = vRP.getUserIdentity(parseInt(args[2]))
				local identity2 = vRP.getUserIdentity(user_id)
				if banco >= parseInt(args[3]) then
					vRP.setBankMoney(user_id,parseInt(banco-args[3]))
					vRP.setPaypalMoney(parseInt(args[2]),parseInt(paypal+args[3]))
					TriggerClientEvent("Notify",source,"sucesso","Enviou <b>$"..vRP.format(parseInt(args[3])).." dólares</b> ao passaporte <b>"..vRP.format(parseInt(args[2])).." "..identity.name.." "..identity.firstname.."</b>.",8000)
					SendWebhookMessage(webhookpaypal,"```prolog\n[ID]: "..user_id.." "..identity2.name.." "..identity2.firstname.." \n[ENVIOU]: $"..vRP.format(parseInt(args[3])).." \n[PARA O ID]: "..parseInt(args[2]).." "..identity.name.." "..identity.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
					local nplayer = vRP.getUserSource(parseInt(args[2]))
					if nplayer then
						TriggerClientEvent("Notify",nplayer,"importante","Passaporte: <b>"..user_id.." "..identity2.name.." "..identity2.firstname.."</b> transferiu <b>$"..vRP.format(parseInt(args[3])).." dólares</b> para sua conta do paypal.",8000)
					end
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",8000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /add
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('add',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if vRP.hasPermission(user_id,"PurplePermission") then
		if args[1] then
			SendWebhookMessage(webhookballas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: Ballas "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.addUserGroup(parseInt(args[1]),"Roxos")
		end
	elseif vRP.hasPermission(user_id,"RedPermission") then
		if args[1] then
			SendWebhookMessage(webhookfamilies,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: Families "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.addUserGroup(parseInt(args[1]),"Vermelhos")
		end
	elseif vRP.hasPermission(user_id,"YellowPermission") then
		if args[1] then
			SendWebhookMessage(webhookvagos,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: Vagos "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.addUserGroup(parseInt(args[1]),"Amarelos")
		end	
	elseif vRP.hasPermission(user_id,"marabuntas.permissao") then
		if args[1] then
			SendWebhookMessage(webhookmarabuntas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: Marabuntas "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.addUserGroup(parseInt(args[1]),"Marabuntas")
		end
	elseif vRP.hasPermission(user_id,"mafia.permissao") then
		if args[1] then
			SendWebhookMessage(webhookmafia,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: Mafia "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.addUserGroup(parseInt(args[1]),"Mafia")
		end
	elseif vRP.hasPermission(user_id,"motoclub.permissao") then
		if args[1] then
			SendWebhookMessage(webhookmotoclub,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: Motoclub "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.addUserGroup(parseInt(args[1]),"Motoclub")
		end	
	elseif vRP.hasPermission(user_id,"yakuza.permissao") then
		if args[1] then
			SendWebhookMessage(webhookyakuza,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: Yakuza "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.addUserGroup(parseInt(args[1]),"Yakuza")
		end	
	elseif vRP.hasPermission(user_id,"corleone.permissao") then
		if args[1] then
			SendWebhookMessage(webhookcorleone,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: Corleone "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.addUserGroup(parseInt(args[1]),"Corleone")
		end	
	elseif vRP.hasPermission(user_id,"cosanostra.permissao") then
		if args[1] then
			SendWebhookMessage(webhookcosanostra,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: Cosanostra "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.addUserGroup(parseInt(args[1]),"Cosanostra")
		end	
	elseif vRP.hasPermission(user_id,"serpentes.permissao") then
		if args[1] then
			SendWebhookMessage(webhookserpentes,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: Serpentes "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.addUserGroup(parseInt(args[1]),"Serpentes")
		end			
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /remove
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('remove',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRPclient.getHealth(source) <= 101 or vRPclient.isHandcuffed(source) or vRP.searchReturn(source,user_id) then
		return
	end
	if vRP.hasPermission(user_id,"PurplePermission") then
		if args[1] then
			SendWebhookMessage(webhookballas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[GRUPO]: Ballas "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.removeUserGroup(parseInt(args[1]),"Roxos")
		end
	elseif vRP.hasPermission(user_id,"RedPermission") then
		if args[1] then
			SendWebhookMessage(webhookfamilies,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[GRUPO]: Families "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.removeUserGroup(parseInt(args[1]),"Vermelhos")
		end
	elseif vRP.hasPermission(user_id,"YellowPermission") then
		if args[1] then
			SendWebhookMessage(webhookvagos,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[GRUPO]: Vagos "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.removeUserGroup(parseInt(args[1]),"Amarelos")
		end	
	elseif vRP.hasPermission(user_id,"marabuntas.permissao") then
		if args[1] then
			SendWebhookMessage(webhookmarabuntas,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[GRUPO]: Marabuntas "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.removeUserGroup(parseInt(args[1]),"Marabuntas")
		end
	elseif vRP.hasPermission(user_id,"mafia.permissao") then
		if args[1] then
			SendWebhookMessage(webhookmafia,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[GRUPO]: Mafia "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.removeUserGroup(parseInt(args[1]),"Mafia")
		end
	elseif vRP.hasPermission(user_id,"motoclub.permissao") then
		if args[1] then
			SendWebhookMessage(webhookmotoclub,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[GRUPO]: Motoclub "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.removeUserGroup(parseInt(args[1]),"Motoclub")
		end	
	elseif vRP.hasPermission(user_id,"yakuza.permissao") then
		if args[1] then
			SendWebhookMessage(webhookyakuza,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[GRUPO]: Yakuza "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.removeUserGroup(parseInt(args[1]),"Yakuza")
		end	
	elseif vRP.hasPermission(user_id,"corleone.permissao") then
		if args[1] then
			SendWebhookMessage(webhookcorleone,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[GRUPO]: Corleone "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.removeUserGroup(parseInt(args[1]),"Corleone")
		end	
	elseif vRP.hasPermission(user_id,"cosanostra.permissao") then
		if args[1] then
			SendWebhookMessage(webhookcosanostra,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[GRUPO]: Cosanostra "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.removeUserGroup(parseInt(args[1]),"Cosanostra")
		end	
	elseif vRP.hasPermission(user_id,"serpentes.permissao") then
		if args[1] then
			SendWebhookMessage(webhookserpentes,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[GRUPO]: Serpentes "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRP.removeUserGroup(parseInt(args[1]),"Serpentes")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JOB ROTATION
-----------------------------------------------------------------------------------------------------------------------------------------
--[[function checkJobRotation()
	local timer = vRP.query("vRP/get_job_rotation")
	return parseInt(os.time()) >= parseInt(timer[1].timer+24*1*60*60)
end

function setJobRotation()
	local jobs = {"Carteiro","Leiteiro","Lenhador","Lixeiro","Tartaruga","Assassino","Caminhao","Colheita","Contrabandista","Cacador","Minerador","Taxista","Pescador","Motorista","Drogas"}
	local job = math.random(#jobs)
	if checkJobRotation() then
		vRP.execute("vRP/set_job_rotation",{ job = jobs[job], timer = parseInt(os.time()) })
		SendWebhookMessage(webhookjobrotation,"Nosso sistema de empregos foi modificado, toda vez que um emprego for anunciado aqui ele será buffado em 20%! \nEmprego buffado: ||"..jobs[job]..".|| @everyone")
	end
end

Citizen.CreateThread(function()
	SetTimeout(30000,function()
		setJobRotation()
	end)
end)]]