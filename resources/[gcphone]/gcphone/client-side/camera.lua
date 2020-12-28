local frontCam = false
local phone = false

RegisterNetEvent('camera:open')
AddEventHandler('camera:open',function()
    CreateMobilePhone(4)
	CellCamActivate(true,true)
	phone = true
	TriggerEvent("startCamera")
end)

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838,activate)
end

Citizen.CreateThread(function()
	DestroyMobilePhone()
	while true do
		Citizen.Wait(1)		
		if IsControlJustPressed(1,177) and phone == true then
			DestroyMobilePhone()
			phone = false
			CellCamActivate(false,false)
			PhonePlayOut()
		end	
		if IsControlJustPressed(1,27) and phone == true then
			frontCam = not frontCam
			CellFrontCamActivate(frontCam)
		end		
	end
end)