-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = Proxy.getInterface("vRP")
gcp = Tunnel.getInterface("gcphone")

local KeyToucheCloseEvent = {
	{ code = 172, event = 'ArrowUp' },
	{ code = 173, event = 'ArrowDown' },
	{ code = 174, event = 'ArrowLeft' },
	{ code = 175, event = 'ArrowRight' },
	{ code = 176, event = 'Enter' },
	{ code = 177, event = 'Backspace' }
}

local inCall = false
local menuIsOpen = false
local contacts = {}
local messages = {}
local myPhoneNumber = ''
local USE_RTC = false
local useMouse = false
local ignoreFocus = false
local lastFrameIsOpen = false
local PhoneInCall = {}
local currentPlaySound = false
local TokoVoipID = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(1,311) and gcp.checkCelular() and not IsEntityInWater(PlayerPedId()) then
			if menuIsOpen then
				PhonePlayOut()
				SendNUIMessage({ show = false })
				menuIsOpen = false
				TriggerEvent("status:celular",false)
				--TriggerEvent("gcphoneVoip",false)
			else
				PhonePlayIn()
				SendNUIMessage({ show = true })
				menuIsOpen = true
				TriggerEvent("status:celular",true)
				--TriggerEvent("gcphoneVoip",true)
				PlaySound(-1,"Hang_Up","Phone_SoundSet_Michael",0,0,1)
			end
		end
		if menuIsOpen then
			for _,value in ipairs(KeyToucheCloseEvent) do
				if IsControlJustPressed(1,value.code) then
					PlaySound(-1,"CLICK_BACK","WEB_NAVIGATION_SOUNDS_PHONE",0,0,1)
					SendNUIMessage({ keyUp = value.event })
				end
			end
			local nuiFocus = useMouse and not ignoreFocus
			SetNuiFocus(nuiFocus,nuiFocus)
			lastFrameIsOpen = true
			DisableControlAction(0,243,true)
		else
			if lastFrameIsOpen then
				PlaySound(-1,"CLICK_BACK","WEB_NAVIGATION_SOUNDS_PHONE",0,0,1)
				SetNuiFocus(false,false)
				lastFrameIsOpen = false
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if GetEntityHealth(PlayerPedId()) <= 101 or vRP.isHandcuffed() or not gcp.checkCelular2() or IsEntityInWater(PlayerPedId()) then
			menuIsOpen = false
			SendNUIMessage({ show = false })
			PhonePlayOut()
		end
	end
end)

RegisterNetEvent("gcphone:submitCaller")
AddEventHandler("gcphone:submitCaller",function(data)
    local message = data.message

    if message == nil then
        DisplayOnscreenKeyboard(1,"FMMC_MPM_NA","","","","","",200)
        while UpdateOnscreenKeyboard() == 0 do
            DisableAllControlActions(0)
            Citizen.Wait(10)
        end

        if GetOnscreenKeyboardResult() then
            message = GetOnscreenKeyboardResult()
        end

		if message ~= nil and message ~= "" then
			TriggerServerEvent("submitCaller",tostring(data.number),tostring(message))
        end
    end
end)

RegisterNetEvent("gcPhone:myPhoneNumber")
AddEventHandler("gcPhone:myPhoneNumber",function(_myPhoneNumber)
	myPhoneNumber = _myPhoneNumber
	SendNUIMessage({ event = 'updateMyPhoneNumber', myPhoneNumber = myPhoneNumber })
end)

RegisterNetEvent("gcPhone:contactList")
AddEventHandler("gcPhone:contactList",function(_contacts)
	SendNUIMessage({ event = 'updateContacts', contacts = _contacts })
	contacts = _contacts
end)

RegisterNetEvent("gcPhone:allMessage")
AddEventHandler("gcPhone:allMessage",function(allmessages)
	SendNUIMessage({ event = 'updateMessages', messages = allmessages })
	messages = allmessages
end)

RegisterNetEvent("gcPhone:receiveMessage")
AddEventHandler("gcPhone:receiveMessage",function(message)
	SendNUIMessage({ event = 'newMessage', message = message })
	if message.owner == 0 and gcp.checkCelular2() and not IsEntityInWater(PlayerPedId()) then
		TriggerEvent("vrp_sound:source",'message',1.0)
	end
end)

function addContact(display,num)
	TriggerServerEvent('gcPhone:addContact',display,num)
end

function deleteContact(num)
	TriggerServerEvent('gcPhone:deleteContact',num)
end

function sendMessage(num,message)
	TriggerServerEvent('gcPhone:sendMessage',num,message)
end

function deleteMessage(msgId)
	TriggerServerEvent('gcPhone:deleteMessage',msgId)
	for k, v in ipairs(messages) do 
		if v.id == msgId then
			table.remove(messages,k)
			SendNUIMessage({ event = 'updateMessages', messages = messages })
			return
		end
	end
end

function deleteMessageContact(num)
	TriggerServerEvent('gcPhone:deleteMessageNumber',num)
end

function deleteAllMessage()
	TriggerServerEvent('gcPhone:deleteAllMessage')
end

function setReadMessageNumber(num)
	TriggerServerEvent('gcPhone:setReadMessageNumber',num)
	for k, v in ipairs(messages) do 
		if v.transmitter == num then
			v.isRead = 1
		end
	end
end

function requestAllMessages()
	TriggerServerEvent('gcPhone:requestAllMessages')
end

function requestAllContact()
	TriggerServerEvent('gcPhone:requestAllContact')
end

RegisterNetEvent("gcPhone:waitingCall")
AddEventHandler("gcPhone:waitingCall",function(infoCall,initiator)
    if not initiator and gcp.checkCelular2() then
        SendNUIMessage({ event = "waitingCall", infoCall = infoCall, initiator = initiator })
    end

    if initiator then
        inCall = true
        SendNUIMessage({ event = "waitingCall", infoCall = infoCall, initiator = initiator })
        PhonePlayCall()
    end
end)

RegisterNetEvent("gcPhone:acceptCall")
AddEventHandler("gcPhone:acceptCall",function(infoCall,initiator)
    -- exports.tokovoip_script:addPlayerToRadio(infoCall.id + 1200)
    -- TokoVoipID = infoCall.id + 1200

    inCall = true

    PhonePlayCall()
    SendNUIMessage({ event = "acceptCall", infoCall = infoCall, initiator = initiator })
end)

RegisterNetEvent("gcPhone:rejectCall")
AddEventHandler("gcPhone:rejectCall",function(infoCall)
    Citizen.InvokeNative(0xE036A705F989E049)
    -- exports.tokovoip_script:removePlayerFromRadio(TokoVoipID)
    -- TokoVoipID = nil

    if inCall then
        inCall = false
        PhonePlayText()
    end

    SendNUIMessage({ event = "rejectCall", infoCall = infoCall })
end)

RegisterNetEvent("gcPhone:historiqueCall")
AddEventHandler("gcPhone:historiqueCall",function(historique)
	SendNUIMessage({ event = 'historiqueCall', historique = historique })
end)

function startCall(phone_number,rtcOffer,extraData)
	TriggerServerEvent('gcPhone:startCall',phone_number,rtcOffer,extraData)
end

function acceptCall(infoCall,rtcAnswer)
	TriggerServerEvent('gcPhone:acceptCall',infoCall,rtcAnswer)
end

function rejectCall(infoCall)
	TriggerServerEvent('gcPhone:rejectCall',infoCall)
end

function ignoreCall(infoCall)
	TriggerServerEvent('gcPhone:ignoreCall',infoCall)
end

function requestHistoriqueCall() 
	TriggerServerEvent('gcPhone:getHistoriqueCall')
end

function appelsDeleteHistorique(num)
	TriggerServerEvent('gcPhone:appelsDeleteHistorique',num)
end

function appelsDeleteAllHistorique()
	TriggerServerEvent('gcPhone:appelsDeleteAllHistorique')
end

RegisterNUICallback('startCall',function(data,cb)
	startCall(data.numero,data.rtcOffer,data.extraData)
	cb()
end)

RegisterNUICallback('acceptCall',function(data,cb)
	acceptCall(data.infoCall,data.rtcAnswer)
	cb()
end)

RegisterNUICallback('rejectCall',function(data,cb)
	rejectCall(data.infoCall)
	cb()
end)

RegisterNUICallback('ignoreCall',function(data,cb)
	ignoreCall(data.infoCall)
	cb()
end)

RegisterNUICallback('notififyUseRTC',function(use,cb)
	USE_RTC = use
	if USE_RTC == true and inCall == true then
		inCall = false
	end
	cb()
end)

RegisterNUICallback('onCandidates',function(data,cb)
	TriggerServerEvent('gcPhone:candidates',data.id,data.candidates)
	cb()
end)

RegisterNetEvent("gcPhone:candidates")
AddEventHandler("gcPhone:candidates",function(candidates)
	SendNUIMessage({ event = 'candidatesAvailable', candidates = candidates })
end)

RegisterNetEvent('gcphone:autoCall')
AddEventHandler('gcphone:autoCall',function(number,extraData)
	if number ~= nil then
		SendNUIMessage({ event = "autoStartCall", number = number, extraData = extraData })
	end
end)

RegisterNetEvent('gcphone:autoCallNumber')
AddEventHandler('gcphone:autoCallNumber',function(data)
	TriggerEvent('gcphone:autoCall',data.number)
end)

RegisterNetEvent('gcphone:autoAcceptCall')
AddEventHandler('gcphone:autoAcceptCall',function(infoCall)
	SendNUIMessage({ event = "autoAcceptCall", infoCall = infoCall })
end)

RegisterNUICallback('log',function(data,cb)
	cb()
end)

RegisterNUICallback('focus',function(data,cb)
	cb()
end)

RegisterNUICallback('blur',function(data,cb)
	cb()
end)

RegisterNUICallback('reponseText',function(data,cb)
	local limit = data.limit or 255
	local text = data.text or ''
  
	DisplayOnscreenKeyboard(1,"FMMC_MPM_NA","",text,"","","",limit)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0)
		Citizen.Wait(10)
	end
	if (GetOnscreenKeyboardResult()) then
		text = GetOnscreenKeyboardResult()
	end
	cb(json.encode({ text = text }))
end)

RegisterNUICallback('getMessages',function(data,cb)
	cb(json.encode(messages))
end)

RegisterNUICallback('sendMessage',function(data,cb)
	if data.message == '%pos%' then
		local myPos = GetEntityCoords(PlayerPedId())
		data.message = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
	end
	TriggerServerEvent('gcPhone:sendMessage', data.phoneNumber, data.message)
end)

RegisterNUICallback('deleteMessage',function(data,cb)
	deleteMessage(data.id)
	cb()
end)

RegisterNUICallback('deleteMessageNumber',function(data,cb)
	deleteMessageContact(data.number)
	cb()
end)

RegisterNUICallback('deleteAllMessage',function(data,cb)
	deleteAllMessage()
	cb()
end)

RegisterNUICallback('setReadMessageNumber',function(data,cb)
	setReadMessageNumber(data.number)
	cb()
end)

RegisterNUICallback('addContact',function(data,cb) 
	TriggerServerEvent('gcPhone:addContact',data.display,data.phoneNumber)
end)

RegisterNUICallback('updateContact',function(data,cb)
	TriggerServerEvent('gcPhone:updateContact',data.id,data.display,data.phoneNumber)
end)

RegisterNUICallback('deleteContact',function(data,cb)
	TriggerServerEvent('gcPhone:deleteContact',data.id)
end)

RegisterNUICallback('getContacts',function(data,cb)
	cb(json.encode(contacts))
end)

RegisterNUICallback('setGPS',function(data,cb)
	SetNewWaypoint(tonumber(data.x),tonumber(data.y))
	cb()
end)

RegisterNUICallback('callEvent',function(data,cb)
	local eventName = data.eventName or ''
	if string.match(eventName, 'gcphone') then
		if data.data ~= nil then 
			TriggerEvent(data.eventName, data.data)
		else
			TriggerEvent(data.eventName)
		end
	end
	cb()
end)

RegisterNUICallback('useMouse',function(um,cb)
	useMouse = um
end)

RegisterNUICallback('deleteALL',function(data,cb)
	TriggerServerEvent('gcPhone:deleteALL')
	cb()
end)

RegisterNUICallback('closePhone',function(data,cb)
	TriggerEvent("status:celular",false)
	--TriggerEvent("gcphoneVoip",false)
	menuIsOpen = false
	SendNUIMessage({ show = false })
	PhonePlayOut()
	cb()
end)

RegisterNUICallback('appelsDeleteHistorique',function(data,cb)
	appelsDeleteHistorique(data.numero)
	cb()
end)

RegisterNUICallback('appelsDeleteAllHistorique',function(data,cb)
	appelsDeleteAllHistorique(data.infoCall)
	cb()
end)

AddEventHandler('onClientResourceStart',function(res)
	if res == "gcphone" then
		TriggerServerEvent('gcPhone:allUpdate')
	end
end)

RegisterNUICallback('setIgnoreFocus',function(data,cb)
	ignoreFocus = data.ignoreFocus
	cb()
end)

RegisterNUICallback('takePhoto',function(data,cb)
	menuIsOpen = false
	SendNUIMessage({ show = false })
	TriggerEvent('camera:open')
	cb()
end)