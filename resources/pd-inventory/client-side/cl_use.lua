-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENT FIREWORK
-----------------------------------------------------------------------------------------------------------------------------------------
local fireWorks = nil
local fireWorksCreate = false
RegisterNetEvent("b03461cc:pd-inventory:fireworks")
AddEventHandler("b03461cc:pd-inventory:fireworks",function()
    local ped = PlayerPedId()
    local times = 20

    if fireWorksCreate then
        return
    end
    fireWorksCreate = true
    
    vRP._playAnim(false,{"anim@mp_fireworks","place_firework_3_box"},false)
    Citizen.Wait(2000)
    
	local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.5,0.0)
	fireWorks = CreateObject(GetHashKey("ind_prop_firework_03"),coords.x,coords.y,coords.z,true,false,false)
	PlaceObjectOnGroundProperly(fireWorks)
    FreezeEntityPosition(fireWorks,true)

	Citizen.Wait(8000)
    repeat
        vRP.PtfxThis("scr_indep_fireworks")
	    StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst",GetEntityCoords(fireWorks),0.0,0.0,0.0,1.0,false,false,false,false)
	    times = times - 1
	    Citizen.Wait(2000)
    until times == 0
    
    DeleteEntity(fireWorks)
    fireWorksCreate = false
	fireWorks = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURN FIREWORK
-----------------------------------------------------------------------------------------------------------------------------------------
function vrpClient.returnfireWorks()
    return fireWorksCreate
end