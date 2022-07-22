-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
emP = {}
Tunnel.bindInterface("farm_ilegal",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local amount = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK AMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkAmount(farm)
	local source = source
	local user_id = vRP.getUserId(source)
	if amount[source] == nil then
		local item = cfg.FarmItems[farm]["item"].item
		local item2 = cfg.FarmItems[farm]["item"].item2
		local times = cfg.FarmItems[farm]["item"].times
		
		local random = math.random(cfg.FarmItems[farm]["item"].a1,cfg.FarmItems[farm]["item"].a2)
		if times > 1 then
			local random2 = math.random(cfg.FarmItems[farm]["item"].a3,cfg.FarmItems[farm]["item"].a4)
			if exports["pd-inventory"]:checkWeightAmount(user_id,item,parseInt(random)) and exports["pd-inventory"]:checkWeightAmount(user_id,"dinheirosujo",parseInt(random*random2)) then
				amount[source] = random2
				return true
			end
		else
			if exports["pd-inventory"]:checkWeightAmount(user_id,item,parseInt(random)) then
				amount[source] = random
				return true
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment(farm)
    local source = source
    local user_id = vRP.getUserId(source)
    local item = cfg.FarmItems[farm]["item"].item
    local item2 = cfg.FarmItems[farm]["item"].item2
    local times = cfg.FarmItems[farm]["item"].times

    local random = math.random(cfg.FarmItems[farm]["item"].a1,cfg.FarmItems[farm]["item"].a2)
	if times > 1 then
		local random2 = math.random(cfg.FarmItems[farm]["item"].a3,cfg.FarmItems[farm]["item"].a4)
        exports["pd-inventory"]:giveItem(user_id,item,parseInt(random),true)
        exports["pd-inventory"]:giveItem(user_id,item2,parseInt(random*random2),true) 
        amount[source] = nil
        return true
    else            
        exports["pd-inventory"]:giveItem(user_id,item,parseInt(random),true)
        amount[source] = nil
        return true
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkIntPermissions(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.searchReturn(source,user_id) then
			return vRP.hasPermission(user_id,perm)
		end
	end
end