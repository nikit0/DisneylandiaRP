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
Tunnel.bindInterface("vrp_diagnostic",src)
vSERVER = Tunnel.getInterface("vrp_diagnostic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DAMAGED
-----------------------------------------------------------------------------------------------------------------------------------------
local damaged = {}
local bleeding = 0
local bleedtype = "Superficial"
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETDIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
function src.getDiagnostic()
	return damaged
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETBLEEDING
-----------------------------------------------------------------------------------------------------------------------------------------
function src.getBleeding()
	return bleeding
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESSEDDIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 115 then
			local hit,bone = GetPedLastDamageBone(ped)
			if hit and not damaged[bone] and bone ~= 0 then
				damaged[bone] = true
				bleeding = bleeding + 1
			end
		end
		Citizen.Wait(500)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BONES
-----------------------------------------------------------------------------------------------------------------------------------------
local bones = {
	[11816] = "Pélvis",
	[58271] = "Coxa Esquerda",
	[63931] = "Panturrilha Esquerda",
	[14201] = "Pé Esquerdo",
	[2108] = "Dedo do Pé Esquerdo",
	[65245] = "Pé Esquerdo",
	[57717] = "Pé Esquerdo",
	[46078] = "Joelho Esquerdo",
	[51826] = "Coxa Direita",
	[36864] = "Panturrilha Direita",
	[52301] = "Pé Direito",
	[20781] = "Dedo do Pé Direito",
	[35502] = "Pé Direito",
	[24806] = "Pé Direito",
	[16335] = "Joelho Direito",
	[23639] = "Coxa Direita",
	[6442] = "Coxa Direita",
	[57597] = "Espinha Cervical",
	[23553] = "Espinha Toráxica",
	[24816] = "Espinha Lombar",
	[24817] = "Espinha Sacral",
	[24818] = "Espinha Cocciana",
	[64729] = "Escápula Esquerda",
	[45509] = "Braço Esquerdo",
	[61163] = "Antebraço Esquerdo",
	[18905] = "Mão Esquerda",
	[18905] = "Mão Esquerda",
	[26610] = "Dedo Esquerdo",
	[4089] = "Dedo Esquerdo",
	[4090] = "Dedo Esquerdo",
	[26611] = "Dedo Esquerdo",
	[4169] = "Dedo Esquerdo",
	[4170] = "Dedo Esquerdo",
	[26612] = "Dedo Esquerdo",
	[4185] = "Dedo Esquerdo",
	[4186] = "Dedo Esquerdo",
	[26613] = "Dedo Esquerdo",
	[4137] = "Dedo Esquerdo",
	[4138] = "Dedo Esquerdo",
	[26614] = "Dedo Esquerdo",
	[4153] = "Dedo Esquerdo",
	[4154] = "Dedo Esquerdo",
	[60309] = "Mão Esquerda",
	[36029] = "Mão Esquerda",
	[61007] = "Antebraço Esquerdo",
	[5232] = "Antebraço Esquerdo",
	[22711] = "Cotovelo Esquerdo",
	[10706] = "Escápula Direita",
	[40269] = "Braço Direito",
	[28252] = "Antebraço Direito",
	[57005] = "Mão Direita",
	[58866] = "Dedo Direito",
	[64016] = "Dedo Direito",
	[64017] = "Dedo Direito",
	[58867] = "Dedo Direito",
	[64096] = "Dedo Direito",
	[64097] = "Dedo Direito",
	[58868] = "Dedo Direito",
	[64112] = "Dedo Direito",
	[64113] = "Dedo Direito",
	[58869] = "Dedo Direito",
	[64064] = "Dedo Direito",
	[64065] = "Dedo Direito",
	[58870] = "Dedo Direito",
	[64080] = "Dedo Direito",
	[64081] = "Dedo Direito",
	[28422] = "Mão Direita",
	[6286] = "Mão Direita",
	[43810] = "Antebraço Direito",
	[37119] = "Antebraço Direito",
	[2992] = "Cotovelo Direito",
	[39317] = "Pescoço",
	[31086] = "Cabeça",
	[12844] = "Cabeça",
	[65068] = "Rosto"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESSEDBLEEDING
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()

		if GetEntityHealth(ped) > 101 then
			local diagnostic = src.getDiagnostic()
			if diagnostic then
				local danos = ""
				for k,v in pairs(diagnostic) do
					danos = danos.."<b>"..bones[k].."</b>, "
				end
				if bleeding == 1 then
					bleedtype = danos
				elseif bleeding == 2 then
					bleedtype = danos
				elseif bleeding == 3 then
					bleedtype = danos
				elseif bleeding == 4 then
					bleedtype = danos
					SetEntityHealth(ped,GetEntityHealth(ped)-1)
				elseif bleeding >= 5 then
					bleedtype = danos
					SetEntityHealth(ped,GetEntityHealth(ped)-2)
				elseif bleeding >= 6 then
					bleedtype = danos
					SetEntityHealth(ped,GetEntityHealth(ped)-3)
				elseif bleeding >= 7 then
					bleedtype = danos
					SetEntityHealth(ped,GetEntityHealth(ped)-4)
				elseif bleeding >= 8 then
					bleedtype = danos
					SetEntityHealth(ped,GetEntityHealth(ped)-5)
				end

				if bleeding >= 4 and GetEntityHealth(ped) > 101 then
					SetFlash(0,0,500,100,500)
				end

				if bleeding >= 1 and GetEntityHealth(ped) > 101 then
					TriggerEvent("Notify","negado","Ferimento <b>"..bleedtype.."</b> encontrado.",3000)
				end	
			end
		end

		Citizen.Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETDIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetDiagnostic")
AddEventHandler("resetDiagnostic",function()
	damaged = {}
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETDIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetBleeding")
AddEventHandler("resetBleeding",function()
	bleeding = 0
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETWARFARINA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("resetWarfarina")
AddEventHandler("resetWarfarina",function()
	repeat
		Citizen.Wait(10000)
		bleeding = bleeding - 1
	until bleeding <= 0
		TriggerEvent("Notify","importante","Sangramento paralisado.",8000)
end)