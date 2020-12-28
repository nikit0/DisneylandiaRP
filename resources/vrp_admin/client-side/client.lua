-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local showblip = false
local showsprite = false

RegisterNetEvent('blips:showBlips')
AddEventHandler('blips:showBlips',function()
	showblip = not showblip
	showsprite = not showsprite
	if showblip and showsprite then
		showblip = true
		showsprite = true
		TriggerEvent('chatMessage',"BLIPS",{255,70,50},"ON")
	else
		showblip = false
		showsprite = false
		TriggerEvent('chatMessage',"BLIPS",{255,70,50},"OFF")
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		for _,player in ipairs(GetActivePlayers()) do
			if GetPlayerPed(player) ~= PlayerPedId() then
				ped = GetPlayerPed(player)
				blip = GetBlipFromEntity(ped)
				-- HEAD DISPLAY STUFF --			
				-- Create head display (this is safe to be spammed)
				headId = Citizen.InvokeNative(0xBFEFE3321A3F5015,ped,GetPlayerName(player),false,false,"",false)
				wantedLvl = GetPlayerWantedLevel(player)
				if showsprite then
					Citizen.InvokeNative(0x63BB75ABEDC1F6A0,headId,0,true) -- Add player name sprite
					-- Wanted level display
					if wantedLvl then
						Citizen.InvokeNative(0x63BB75ABEDC1F6A0,headId,7,true) -- Add wanted sprite
						Citizen.InvokeNative(0xCF228E2AA03099C3,headId,wantedLvl) -- Set wanted number
					else
						Citizen.InvokeNative(0x63BB75ABEDC1F6A0,headId,7,false) -- Remove wanted sprite
					end
				else
					Citizen.InvokeNative(0x63BB75ABEDC1F6A0,headId,7,false) -- Remove wanted sprite
					Citizen.InvokeNative(0x63BB75ABEDC1F6A0,headId,9,false) -- Remove speaking sprite
					Citizen.InvokeNative(0x63BB75ABEDC1F6A0,headId,0,false) -- Remove player name sprite
				end
				if showblip then
					if not DoesBlipExist(blip) then -- Add blip and create head display on player	
						blip = AddBlipForEntity(ped)
						SetBlipSprite(blip,1)
						Citizen.InvokeNative(0x5FBCA48327B914DF,blip,true) -- Player Blip indicator
						HideNumberOnBlip(blip)
						SetBlipNameToPlayerName(blip,player)
						SetBlipCategory(blip,7)	
					else -- update blip
						veh = GetVehiclePedIsIn(ped,false)
						blipSprite = GetBlipSprite(blip)	
						if GetEntityHealth(ped) <= 101 then -- dead
							if blipSprite ~= 274 then	
								SetBlipSprite(blip,274)
								Citizen.InvokeNative(0x5FBCA48327B914DF,blip,false) -- Player Blip indicator
							end
						elseif veh then
							vehClass = GetVehicleClass(veh)
							vehModel = GetEntityModel(veh)							
							if vehClass == 15 then -- jet	
								if blipSprite ~= 422 then
									SetBlipSprite(blip,422)
									Citizen.InvokeNative(0x5FBCA48327B914DF,blip,false) -- Player Blip indicator
								end
							elseif vehClass == 16 then -- plane
								if vehModel == GetHashKey("besra") or vehModel == GetHashKey("hydra") or vehModel == GetHashKey("lazer") then -- jet
									if blipSprite ~= 424 then
										SetBlipSprite(blip,424)
										Citizen.InvokeNative(0x5FBCA48327B914DF,blip,false) -- Player Blip indicator
									end
								elseif blipSprite ~= 423 then
									SetBlipSprite(blip,423)
									Citizen.InvokeNative (0x5FBCA48327B914DF,blip,false) -- Player Blip indicator
								end
							elseif vehClass == 14 then -- boat
								if blipSprite ~= 427 then
									SetBlipSprite(blip,427)
									Citizen.InvokeNative(0x5FBCA48327B914DF,blip,false) -- Player Blip indicator
								end
							elseif vehModel == GetHashKey("insurgent") or vehModel == GetHashKey("insurgent2") or vehModel == GetHashKey("limo2") then -- insurgent (+ turreted limo cuz limo blip wont work)
								if blipSprite ~= 426 then
									SetBlipSprite(blip,426)
									Citizen.InvokeNative(0x5FBCA48327B914DF,blip,false) -- Player Blip indicator
								end
							elseif vehModel == GetHashKey("rhino") then -- tank
								if blipSprite ~= 421 then
									SetBlipSprite(blip,421)
									Citizen.InvokeNative(0x5FBCA48327B914DF,blip,false) -- Player Blip indicator
								end
							elseif blipSprite ~= 1 then -- default blip
								SetBlipSprite(blip,1)
								Citizen.InvokeNative(0x5FBCA48327B914DF,blip,true) -- Player Blip indicator
							end
							-- Show number in case of passangers
							passengers = GetVehicleNumberOfPassengers(veh)
							if passengers then
								if not IsVehicleSeatFree(veh,-1) then
									passengers = passengers + 1
								end
								ShowNumberOnBlip(blip,passengers)
							else
								HideNumberOnBlip(blip)
							end
						else
							-- Remove leftover number
							HideNumberOnBlip(blip)
							if blipSprite ~= 1 then -- default blip
								SetBlipSprite(blip,1)
								Citizen.InvokeNative(0x5FBCA48327B914DF,blip,true) -- Player Blip indicator
							end
						end
						SetBlipRotation(blip,math.ceil(GetEntityHeading(veh))) -- update rotation
						SetBlipNameToPlayerName(blip,player) -- update blip name
						SetBlipColour(blip,24)
						SetBlipScale(blip,0.7) -- set scale
						-- set player alpha
						if IsPauseMenuActive() then
							SetBlipAlpha(blip,255)
						else
							x1, y1 = table.unpack(GetEntityCoords(PlayerPedId(),true))
							x2, y2 = table.unpack(GetEntityCoords(GetPlayerPed(player),true))
							distance = (math.floor(math.abs(math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)))/-1))+900
							-- Probably a way easier way to do this but whatever im an idiot
							if distance < 0 then
								distance = 0
							elseif distance > 255 then
								distance = 255
							end
							SetBlipAlpha(blip,distance)
						end
						SetBlipNameToPlayerName(blip,player)
					end
				else
					RemoveBlip(blip)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEAR INVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('SetClearInventory')
AddEventHandler('SetClearInventory',function(index)
	TriggerServerEvent("clearInventory",index)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET PLATE TEXT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('setPlateText')
AddEventHandler('setPlateText',function(plateText)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	if vehicle then
        SetVehicleNumberPlateText(vehicle,plateText)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncarea")
AddEventHandler("syncarea",function(x,y,z)
    ClearAreaOfVehicles(x,y,z,150.0,false,false,false,false,false)
    ClearAreaOfEverything(x,y,z,150.0,false,false,false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS CORRIDAS
-----------------------------------------------------------------------------------------------------------------------------------------
--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		if IsControlJustPressed(0,121) and IsInputDisabled(0) then
			TriggerServerEvent("cds:corridas",coords)
		end
	end
end)]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- APAGAO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("cloud:setApagao")
AddEventHandler("cloud:setApagao", function(cond)
    local status = false
    if cond == 1 then
        status = true
    end
    SetBlackout(status)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RAIOS
-----------------------------------------------------------------------------------------------------------------------------------------
local lightsCounter = 0
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if lightsCounter > 0 then
      lightsCounter = lightsCounter - 1
      CreateLightningThunder()
      Citizen.Wait(2000)
    end
  end
end)

RegisterNetEvent("cloud:raios")
AddEventHandler("cloud:raios", function(vezes)
    lightsCounter = lightsCounter + vezes
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TROCAR SEXO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skinmenu")
AddEventHandler("skinmenu",function(mhash)
    while not HasModelLoaded(mhash) do
        RequestModel(mhash)
        Citizen.Wait(10)
    end

    if HasModelLoaded(mhash) then
        SetPlayerModel(PlayerId(),mhash)
        SetModelAsNoLongerNeeded(mhash)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCDELETEOBJ
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncdeleteobj")
AddEventHandler("syncdeleteobj",function(index)
    if NetworkDoesNetworkIdExist(index) then
        local v = NetToEnt(index)
        if DoesEntityExist(v) then
            SetEntityAsMissionEntity(v,false,false)
            DeleteEntity(v)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEADING
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterCommand("h",function(source,args)
	TriggerEvent('chatMessage',"HEADING",{255,70,50},GetEntityHeading(PlayerPedId()))
end)]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNAR VEICULO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('spawnarveiculo')
AddEventHandler('spawnarveiculo',function(name)
	local mhash = GetHashKey(name)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mhash) then
		local ped = PlayerPedId()
		local nveh = CreateVehicle(mhash,GetEntityCoords(ped),GetEntityHeading(ped),true,false)

		NetworkRegisterEntityAsNetworked(nveh)
		while not NetworkGetEntityIsNetworked(nveh) do
			NetworkRegisterEntityAsNetworked(nveh)
			Citizen.Wait(1)
		end

		SetVehicleOnGroundProperly(nveh)
		SetVehicleAsNoLongerNeeded(nveh)
		SetVehicleIsStolen(nveh,false)
		SetPedIntoVehicle(ped,nveh,-1)
		SetVehicleNeedsToBeHotwired(nveh,false)
		SetEntityInvincible(nveh,false)
		SetVehicleNumberPlateText(nveh,vRP.getRegistrationNumber())
		Citizen.InvokeNative(0xAD738C3085FE7E11,nveh,true,true)
		SetVehicleHasBeenOwnedByPlayer(nveh,true)
		SetVehRadioStation(nveh,"OFF")
		SetModelAsNoLongerNeeded(mhash)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTAR PARA O LOCAL MARCADO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('tptoway')
AddEventHandler('tptoway',function()
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)
	if IsPedInAnyVehicle(ped) then
		ped = veh
    end

	local waypointBlip = GetFirstBlipInfoId(8)
	local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09,waypointBlip,Citizen.ResultAsVector()))

	local ground
	local groundFound = false
	local groundCheckHeights = { 0.0,50.0,100.0,150.0,200.0,250.0,300.0,350.0,400.0,450.0,500.0,550.0,600.0,650.0,700.0,750.0,800.0,850.0,900.0,950.0,1000.0,1050.0,1100.0 }

	for i,height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(ped,x,y,height,0,0,1)

		RequestCollisionAtCoord(x,y,z)
		while not HasCollisionLoadedAroundEntity(ped) do
			RequestCollisionAtCoord(x,y,z)
			Citizen.Wait(1)
		end
		Citizen.Wait(20)

		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if ground then
			z = z + 1.0
			groundFound = true
			break;
		end
	end

	if not groundFound then
		z = 1200
		GiveDelayedWeaponToPed(ped,0xFBAB5776,1,0)
	end

	RequestCollisionAtCoord(x,y,z)
	while not HasCollisionLoadedAroundEntity(ped) do
		RequestCollisionAtCoord(x,y,z)
		Citizen.Wait(1)
	end

	SetEntityCoordsNoOffset(ped,x,y,z,0,0,1)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETAR NPCS MORTOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('delnpcs')
AddEventHandler('delnpcs',function()
	local handle,ped = FindFirstPed()
	local finished = false
	repeat
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(ped),true)
		if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and distance < 3 then
			Citizen.InvokeNative(0xAD738C3085FE7E11,ped,true,true)
			TriggerServerEvent("trydeleteped",PedToNet(ped))
			finished = true
		end
		finished,ped = FindNextPed(handle)
	until not finished
	EndFindPed(handle)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('DOG-GOD')
AddEventHandler('DOG-GOD',function()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	if vehicle then
        SetVehicleNumberPlateText(vehicle,"DOG-GOD")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vehtuning")
AddEventHandler("vehtuning",function()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped)
	if IsEntityAVehicle(vehicle) then
		SetVehicleModKit(vehicle,0)
		SetVehicleWheelType(vehicle,0)
		SetVehicleMod(vehicle,0,GetNumVehicleMods(vehicle,0)-1,false)
		SetVehicleMod(vehicle,1,GetNumVehicleMods(vehicle,1)-1,false)
		SetVehicleMod(vehicle,2,GetNumVehicleMods(vehicle,2)-1,false)
		SetVehicleMod(vehicle,3,GetNumVehicleMods(vehicle,3)-1,false)
		SetVehicleMod(vehicle,4,GetNumVehicleMods(vehicle,4)-1,false)
		SetVehicleMod(vehicle,5,GetNumVehicleMods(vehicle,5)-1,false)
		SetVehicleMod(vehicle,6,GetNumVehicleMods(vehicle,6)-1,false)
		SetVehicleMod(vehicle,7,GetNumVehicleMods(vehicle,7)-1,false)
		SetVehicleMod(vehicle,8,GetNumVehicleMods(vehicle,8)-1,false)
		SetVehicleMod(vehicle,9,GetNumVehicleMods(vehicle,9)-1,false)
		SetVehicleMod(vehicle,10,GetNumVehicleMods(vehicle,10)-1,false)
		SetVehicleMod(vehicle,11,GetNumVehicleMods(vehicle,11)-1,false)
		SetVehicleMod(vehicle,12,GetNumVehicleMods(vehicle,12)-1,false)
		SetVehicleMod(vehicle,13,GetNumVehicleMods(vehicle,13)-1,false)
		SetVehicleMod(vehicle,14,16,false)
		SetVehicleMod(vehicle,15,GetNumVehicleMods(vehicle,15)-1,false)
		SetVehicleMod(vehicle,16,GetNumVehicleMods(vehicle,16)-1,false)
		ToggleVehicleMod(vehicle,17,true)
		ToggleVehicleMod(vehicle,18,true)
		ToggleVehicleMod(vehicle,19,true)
		ToggleVehicleMod(vehicle,20,true)
		ToggleVehicleMod(vehicle,21,true)
		ToggleVehicleMod(vehicle,22,true)
		--SetVehicleMod(vehicle,23,91,false)
		--SetVehicleMod(vehicle,24,91,false)
		SetVehicleMod(vehicle,25,GetNumVehicleMods(vehicle,25)-1,false)
		SetVehicleMod(vehicle,27,GetNumVehicleMods(vehicle,27)-1,false)
		SetVehicleMod(vehicle,28,GetNumVehicleMods(vehicle,28)-1,false)
		SetVehicleMod(vehicle,30,GetNumVehicleMods(vehicle,30)-1,false)
		SetVehicleMod(vehicle,33,GetNumVehicleMods(vehicle,33)-1,false)
		SetVehicleMod(vehicle,34,GetNumVehicleMods(vehicle,34)-1,false)
		SetVehicleMod(vehicle,35,GetNumVehicleMods(vehicle,35)-1,false)
		SetVehicleMod(vehicle,38,GetNumVehicleMods(vehicle,38)-1,true)
		SetVehicleTyreSmokeColor(vehicle,0,0,0)
        SetVehicleWindowTint(vehicle,1)
        SetVehicleTyresCanBurst(vehicle,false)
        --SetVehicleNumberPlateText(vehicle,"DISNEYRP")
        SetVehicleNumberPlateTextIndex(vehicle,5)
        SetVehicleModColor_1(vehicle,255,255,255)
        SetVehicleModColor_2(vehicle,255,255,255)
        SetVehicleColours(vehicle,0,0)
        SetVehicleExtraColours(vehicle,0,0)
	end
end)
------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
------------------------------------------------------------------------------------------------------------------------------
local dickheaddebug = false
local inFreeze = false
RegisterNetEvent("ToggleDebug")
AddEventHandler("ToggleDebug",function()
	dickheaddebug = not dickheaddebug
    if dickheaddebug then
        TriggerEvent('chatMessage',"DEBUG",{255,0,0},"ON")
    else
        TriggerEvent('chatMessage',"DEBUG",{255,0,0},"OFF")
    end
end)

function GetVehicle()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords,pos,true)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
           	FreezeEntityPosition(ped, inFreeze)
	    	if IsEntityTouchingEntity(playerped,ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1,"~g~VEHICLE: ~w~"..ped.." ~g~HASH: ~w~"..GetEntityModel(ped).." ~r~IN CONTACT",350)
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1,"~g~VEHICLE: ~w~"..ped.." ~g~HASH: ~w~"..GetEntityModel(ped).."",350)
	    	end
        end
        success, ped = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return rped
end

function GetObject()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstObject()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords,pos,true)
        if distance < 10.0 then
            distanceFrom = distance
            rped = ped
            FreezeEntityPosition(ped,inFreeze)
	    	if IsEntityTouchingEntity(playerped,ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1,"~g~OBJECT: ~w~"..ped.." ~g~HASH: ~w~"..GetEntityModel(ped).." ~r~IN CONTACT",350)
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1,"~g~OBJECT: ~w~"..ped.." ~g~HASH: ~w~"..GetEntityModel(ped).."",350)
	    	end
        end
        success, ped = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    return rped
end

function getNPC()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords,pos,true)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped

	    	if IsEntityTouchingEntity(playerped,ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"],"~g~PED: ~w~"..ped.." ~g~HASH: ~w~"..GetEntityModel(ped).." ~g~RELATIONSHIP HASH: ~w~"..GetPedRelationshipGroupHash(ped).." ~r~IN CONTACT",350)
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"],"~g~PED: ~w~"..ped.." ~g~HASH: ~w~"..GetEntityModel(ped).." ~g~RELATIONSHIP HASH: ~w~"..GetPedRelationshipGroupHash(ped),350)
	    	end

            FreezeEntityPosition(ped,inFreeze)
        end
        success,ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == PlayerPedId() then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end

Citizen.CreateThread(function()
    while true do  
		Citizen.Wait(1)
		local ped = PlayerPedId()
        if dickheaddebug then
            local pos = GetEntityCoords(ped)

            local forPos = GetOffsetFromEntityInWorldCoords(ped,0,1.0,0.0)
            local backPos = GetOffsetFromEntityInWorldCoords(ped,0,-1.0,0.0)
            local LPos = GetOffsetFromEntityInWorldCoords(ped,1.0,0.0,0.0)
            local RPos = GetOffsetFromEntityInWorldCoords(ped,-1.0,0.0,0.0) 

            local forPos2 = GetOffsetFromEntityInWorldCoords(ped,0,2.0,0.0)
            local backPos2 = GetOffsetFromEntityInWorldCoords(ped,0,-2.0,0.0)
            local LPos2 = GetOffsetFromEntityInWorldCoords(ped,2.0,0.0,0.0)
            local RPos2 = GetOffsetFromEntityInWorldCoords(ped,-2.0,0.0,0.0)    

            local x, y, z = table.unpack(GetEntityCoords(ped,true))
            local currentStreetHash,intersectStreetHash = GetStreetNameAtCoord(x,y,z,currentStreetHash,intersectStreetHash)
            currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

            drawTxtS(0.8, 0.50, 0.4,0.4,0.30, "~g~HEADING: ~r~"..GetEntityHeading(ped))
            drawTxtS(0.8, 0.52, 0.4,0.4,0.30, "~g~COORDS: ~r~"..pos)
            drawTxtS(0.8, 0.54, 0.4,0.4,0.30, "~g~ATTACHED ENT: ~r~"..GetEntityAttachedTo(ped))
            drawTxtS(0.8, 0.56, 0.4,0.4,0.30, "~g~HEALTH: ~r~"..GetEntityHealth(ped))
            drawTxtS(0.8, 0.58, 0.4,0.4,0.30, "~g~H a G: ~r~"..GetEntityHeightAboveGround(ped))
            drawTxtS(0.8, 0.60, 0.4,0.4,0.30, "~g~HASH: ~r~"..GetEntityModel(ped))
            drawTxtS(0.8, 0.62, 0.4,0.4,0.30, "~g~SPEED: ~r~"..GetEntitySpeed(ped))
            drawTxtS(0.8, 0.64, 0.4,0.4,0.30, "~g~FRAME TIME: ~r~"..GetFrameTime())
            drawTxtS(0.8, 0.66, 0.4,0.4,0.30, "~g~STREET: ~r~"..currentStreetName)
             
            DrawLine(pos,forPos,255,0,0,115)
            DrawLine(pos,backPos,255,0,0,115)

            DrawLine(pos,LPos,255,255,0,115)
            DrawLine(pos,RPos,255,255,0,115)

            DrawLine(forPos,forPos2,255,0,255,115)
            DrawLine(backPos,backPos2,255,0,255,115)

            DrawLine(LPos,LPos2,255,255,255,115)
            DrawLine(RPos,RPos2,255,255,255,115)

            local nearped = getNPC()
            local veh = GetVehicle()
            local nearobj = GetObject()
            if IsControlJustReleased(0,38) and IsInputDisabled(0) then
                if inFreeze then
                    inFreeze = false
                    TriggerEvent("Notify","negado","Freeze disabled.")
                else
                    inFreeze = true             
                    TriggerEvent("Notify","sucesso","Freeze enabled.")
                end
            end
        else
            Citizen.Wait(5000)
        end
    end
end)

function drawTxtS(x,y,width,height,scale,text)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.25,0.25)
    SetTextDropShadow(0,0,0,0,255)
    SetTextEdge(1,0,0,0,255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x-width/2,y-height/3)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z,text,size)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/size
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end