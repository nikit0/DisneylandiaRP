RegisterNetEvent("ItemNotify")
AddEventHandler("ItemNotify",function(item, icon, status)
	SendNUIMessage({ item = item, icon = icon, status = status })
end)