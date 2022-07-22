-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local aWeapons = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
local weapons = {
	-- FRONT
	{ hash = "WEAPON_SMG", bone = 24818, x = 0.0, y = 0.20, z = 0.02, xR = 175.0, yR = 140.0, zR = 0.5, model = "w_sb_smg" },
	{ hash = "WEAPON_COMBATPDW", bone = 24818, x = 0.0, y = 0.20, z = 0.02, xR = 175.0, yR = 140.0, zR = 0.5, model = "w_sb_pdw" },
	{ hash = "WEAPON_CARBINERIFLE", bone = 24818, x = 0.0, y = 0.20, z = 0.02, xR = 175.0, yR = 140.0, zR = 0.5, model = "w_ar_carbinerifle" },
	{ hash = "WEAPON_COMPACTRIFLE", bone = 24818, x = 0.0, y = 0.20, z = 0.02, xR = 175.0, yR = 140.0, zR = 0.5, model = "w_ar_assaultrifle_smg" },
	-- BACK
	{ hash = "WEAPON_MUSKET", bone = 24818, x = 0.16, y = -0.15, z = -0.03, xR = 185.0, yR = 140.0, zR = 0.5, model = "w_ar_musket" },
	{ hash = "WEAPON_PUMPSHOTGUN_MK2", bone = 24818, x = 0.16, y = -0.15, z = -0.03, xR = 185.0, yR = 140.0, zR = 0.5, model = "w_sg_pumpshotgunmk2" },
	{ hash = "WEAPON_ASSAULTRIFLE", bone = 24818, x = 0.16, y = -0.15, z = -0.03, xR = 185.0, yR = 140.0, zR = 0.5, model = "w_ar_assaultrifle" },
	{ hash = "WEAPON_CARBINERIFLE_MK2", bone = 24818, x = 0.16, y = -0.15, z = -0.03, xR = 185.0, yR = 140.0, zR = 0.5, model = "w_ar_carbineriflemk2" },
	-- PISTOL
	{ hash = "WEAPON_PISTOL", bone = 24816, x = -0.11, y = -0.01, z = -0.21, xR = 80.0, yR = 180.0, zR = 15.0, model = "w_pi_pistol" },
	{ hash = "WEAPON_COMBATPISTOL", bone = 24816, x = -0.11, y = -0.01, z = -0.21, xR = 80.0, yR = 180.0, zR = 15.0, model = "w_pi_combatpistol" },
	{ hash = "WEAPON_REVOLVER_MK2", bone = 24816, x = -0.11, y = -0.01, z = -0.21, xR = 80.0, yR = 180.0, zR = 15.0, model = "w_pi_revolvermk2" },
	{ hash = "WEAPON_STUNGUN", bone = 24816, x = 0.0, y = 0.18, z = 0.02, xR = 185.0, yR = 140.0, zR = 0.5, model = "w_pi_stungun" },
	{ hash = "WEAPON_PISTOL_MK2", bone = 24816, x = -0.11, y = -0.01, z = -0.21, xR = 80.0, yR = 180.0, zR = 15.0, model = "w_pi_pistolmk2" },
	{ hash = "WEAPON_MACHINEPISTOL", bone = 24816, x = -0.11, y = -0.01, z = -0.21, xR = 80.0, yR = 180.0, zR = 15.0, model = "w_sb_compactsmg" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCIONS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local ped = PlayerPedId()

		for k, v in pairs(weapons) do
			if not aWeapons[v.model] then
				if HasPedGotWeapon(ped, GetHashKey(v.hash), false) then
					RequestModel(v.model)
					while not HasModelLoaded(v.model) do
						RequestModel(v.model)
						Wait(10)
					end

					aWeapons[v.model] = { hash = GetHashKey(v.hash), handle = CreateObject(GetHashKey(v.model), 1.0, 1.0, 1.0, true, true, false) }
					AttachEntityToEntity(aWeapons[v.model].handle, ped, GetPedBoneIndex(ped, v.bone), v.x, v.y, v.z, v.xR, v.yR, v.zR, false, false, false, false, 2, true)
					SetEntityAsMissionEntity(aWeapons[v.model].handle, true, true)
					SetEntityAsNoLongerNeeded(aWeapons[v.model].handle)
				end
			end
		end

		for k, v in pairs(aWeapons) do
			if GetSelectedPedWeapon(ped) == v.hash or not HasPedGotWeapon(ped, v.hash, false) then
				if DoesEntityExist(v.handle) then
					SetEntityAsMissionEntity(v.handle, false, false)
					DeleteObject(v.handle)
					aWeapons[k] = nil
				end
			end
		end

		Wait(400)
	end
end)
