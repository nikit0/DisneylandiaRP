-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
local vipItems = {
	["vipgold15"] = true,
	["vipgold30"] = true,
	["vipplatinum15"] = true,
	["vipplatinum30"] = true,
	["vipaparencia"] = true,
	["vipplaca"] = true,
	["vipgaragem"] = true,
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD BANDAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
local bandagem = {}
CreateThread(function()
	while true do
		Wait(1000)
		for k, v in pairs(bandagem) do
			if v > 0 then
				bandagem[k] = v - 1
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD USE ITEMS
-----------------------------------------------------------------------------------------------------------------------------------------
local timers = {}
CreateThread(function()
	while true do
		for k, v in pairs(timers) do
			if parseInt(v) > 0 then
				timers[k] = parseInt(v) - 1
			end
			Wait(10)
		end
		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCEL EVENT ITEMS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_inventory:Cancel")
AddEventHandler("vrp_inventory:Cancel", function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if parseInt(timers[user_id]) > 0 then
			timers[user_id] = nil
			actived[user_id] = nil
			TriggerClientEvent("progress", source, 1000)

			SetTimeout(1000, function()
				vRPclient._DeletarObjeto(source)
				vGARAGE.updateHotwired(source, false)
				TriggerClientEvent('cancelando', source, false)
			end)
		else
			vRPclient._DeletarObjeto(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USE ITEMS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("b03461cc:pd-inventory:useItem")
AddEventHandler("b03461cc:pd-inventory:useItem", function(item, amount)
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
		if getItemAmount(user_id, item) >= amount then
			if itemlist[item].isWeapon then
				local weapons = {}
				weapons["WEAPON_" .. string.upper(item)] = { ammo = 0 }
				vRPclient._giveWeapons(source, weapons)
				consumeItem(user_id, item, 1, true, "Usou")
			end

			if itemlist[item].isAmmo then
				local uweapons = vRPclient.getWeapons(source)
				local weaponuse = "WEAPON_" .. string.upper(string.gsub(item, "ammo_", ""))
				if uweapons[weaponuse] then
					if consumeItem(user_id, item, amount, true, "Recarregou ") then
						local weapons = {}
						weapons[weaponuse] = { ammo = parseInt(amount) }
						vRPclient._giveWeapons(source, weapons, false)
					end
				end
			end

			if itemlist[item].isWeaponisAmmo then
				local weapons = {}
				weapons["WEAPON_" .. string.upper(item)] = { ammo = 1 }
				weapons["GADGET_" .. string.upper(item)] = { ammo = 1 }
				vRPclient._giveWeapons(source, weapons)
				consumeItem(user_id, item, 1, true, "Usou")
			end

			if item == "bandagem" then
				if vRPclient.getHealth(source) > 101 and vRPclient.getHealth(source) < 250 then
					if bandagem[user_id] == 0 or not bandagem[user_id] then
						if vDIAGNOSTIC.getBleeding(source) >= 4 then
							TriggerClientEvent("Notify", source, "importante", "Você está com um sangramento alto e não pode utilizar a <b>Bandagem</b>, chame um paramédico ou vá até o <b>Hospital</b> mais próximo para receber atendimento.", 8000)
							return
						end

						if consumeItem(user_id, item, 1, true, "Usou") then
							timers[user_id] = 20
							actived[user_id] = true

							TriggerClientEvent('cancelando', source, true)
							TriggerClientEvent("progress", source, 20000, "bandagem")
							vRPclient._CarregarObjeto(source, "amb@world_human_clipboard@male@idle_a", "idle_c", "v_ret_ta_firstaid", 49, 60309)
							repeat
								if timers[user_id] <= 0 then
									timers[user_id] = nil
									actived[user_id] = nil
									bandagem[user_id] = 3600
									TriggerClientEvent('cancelando', source, false)
									TriggerClientEvent('bandagem', source)
									TriggerClientEvent("Notify", source, "sucesso", "<b>Bandagem</b> utilizada com sucesso.", 5000)
									vRPclient._DeletarObjeto(source)
									Wait(10000)
									TriggerClientEvent("resetBleeding", source)
								end
								Wait(10)
							until not timers[user_id]
						end
					else
						TriggerClientEvent("Notify", source, "importante", "Aguarde <b>" .. vRP.getMinSecs(parseInt(bandagem[user_id])) .. "</b> para usar a bandagem.", 5000)
					end
				else
					TriggerClientEvent("Notify", source, "aviso", "Você não pode utilizar de vida cheia ou nocauteado.", 8000)
				end
			end

			if item == "dorflex" or item == "cicatricure" or item == "dipirona" or item == "paracetamol" or item == "clozapina" or item == "amoxilina" or item == "omeprazol" or item == "riopan" or item == "fluoxetina" or item == "luftal" or item == "buscofem" or item == "allegra" or item == "novalgina" or item == "rivotril" or item == "cataflan" or item == "anticoncepcional" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 5
					actived[user_id] = true
					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 5000, "remedio")
					vRPclient._CarregarObjeto(source, "mp_player_intdrink", "loop_bottle", "ng_proc_drug01a002", 49, 60309)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							TriggerClientEvent('cancelando', source, false)
							vRPclient._DeletarObjeto(source)
							TriggerClientEvent("Notify", source, "sucesso", "<b>Remédio</b> utilizado com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "camisinha" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 10
					actived[user_id] = true

					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 10000, "camisinha")
					vRPclient._playAnim(source, true, { "misscarsteal2peeing", "peeing_intro" }, false)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							TriggerClientEvent('cancelando', source, false)
							TriggerClientEvent("Notify", source, "sucesso", "<b>Camisinha</b> utilizada com sucesso.", 5000)
							vRPclient._StopAnim(source, false)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "xerelto" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 20
					actived[user_id] = true

					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 20000, "xerelto")
					vRPclient._CarregarObjeto(source, "mp_player_intdrink", "loop_bottle", "ng_proc_drug01a002", 49, 60309)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							TriggerClientEvent('cancelando', source, false)
							TriggerClientEvent("resetBleeding", source)
							vRPclient._DeletarObjeto(source)
							TriggerClientEvent("Notify", source, "sucesso", "<b>Xerelto</b> utilizado com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "coumadin" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 20
					actived[user_id] = true

					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 20000, "coumadin")
					vRPclient._CarregarObjeto(source, "mp_player_intdrink", "loop_bottle", "ng_proc_drug01a002", 49, 60309)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							TriggerClientEvent('cancelando', source, false)
							TriggerClientEvent("resetBleeding", source)
							vRPclient._DeletarObjeto(source)
							TriggerClientEvent("Notify", source, "sucesso", "<b>Coumadin</b> utilizado com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "anesthesia" then
				if vRP.hasPermission(user_id, "paramedico.permissao") then
					local nplayer = vRPclient.getNearestPlayer(source, 2)
					if nplayer then
						if vRPclient.getHealth(nplayer) > 101 then
							TriggerClientEvent("anesthesia", nplayer)
							TriggerClientEvent("Notify", source, "sucesso", "Anestesia no paciente aplicada com sucesso.", 10000)
						end
					end
				end
			end

			if item == "bodybag" then
				if not vRPclient.isInVehicle(source) then
					if vRP.hasPermission(user_id, "paramedico.permissao") then
						local value = vRP.getUData(parseInt(user_id), "vRP:ParamedicPromotion")
						local pp = json.decode(value) or 0
						if pp >= 4 then
							local nplayer = vRPclient.getNearestPlayer(source, 2)
							if nplayer then
								if vRPclient.getHealth(nplayer) <= 101 then
									TriggerClientEvent('personDeath', nplayer)
									TriggerClientEvent("Notify", source, "sucesso", "Paciente foi a óbito.")
								else
									TriggerClientEvent("Notify", source, "importante", "A pessoa precisa estar em coma para prosseguir.", 8000)
								end
							end
						end
					end
				end
			end

			if item == "medkit" then
				if not vRPclient.isInVehicle(source) then
					if vRP.hasPermission(user_id, "paramedico.permissao") then
						local nplayer = vRPclient.getNearestPlayer(source, 2)
						if nplayer then
							if vRPclient.getHealth(nplayer) > 101 then
								vRPclient.DeleteCam(nplayer)
								TriggerClientEvent("tratamento", nplayer)
								TriggerClientEvent("resetBleeding", nplayer)
								TriggerClientEvent("resetDiagnostic", nplayer)
								TriggerClientEvent("Notify", source, "sucesso", "Tratamento no paciente iniciado com sucesso.", 10000)
							end
						end
					end
				end
			end

			if item == "defibrillator" then
				if not vRPclient.isInVehicle(source) then
					local identity = vRP.getUserIdentity(user_id)
					if vRP.hasPermission(user_id, "paramedico.permissao") then
						local nplayer = vRPclient.getNearestPlayer(source, 2)
						if nplayer then
							if vRPclient.getHealth(nplayer) <= 101 then
								timers[user_id] = 30
								actived[user_id] = true
								TriggerClientEvent('resetTimer', nplayer)
								TriggerClientEvent('cancelando', source, true)
								TriggerClientEvent("progress", source, 30000, "reanimando")
								vRPclient._playAnim(source, false, { "mini@cpr@char_a@cpr_str", "cpr_pumpchest" }, true)
								repeat
									if timers[user_id] <= 0 then
										timers[user_id] = nil
										actived[user_id] = nil
										TriggerClientEvent("resetBleeding", nplayer)
										TriggerClientEvent('cancelando', source, false)
										vRPclient.killGod(nplayer)
										vRPclient._stopAnim(source, false)

										vRP.giveMoney(user_id, 500)
										TriggerClientEvent("Notify", source, "sucesso", "Primeiros socorros realizado com sucesso.")
										TriggerClientEvent("Notify", source, "importante", "Você recebeu <b>$500 dólares</b> de bonificação.")
									end
									Wait(10)
								until not timers[user_id]
							else
								TriggerClientEvent("Notify", source, "importante", "A pessoa precisa estar em coma para prosseguir.", 8000)
							end
						end
					else
						if vRP.hasPermission(user_id, "policia.permissao") then
							local value = vRP.getUData(parseInt(user_id), "vRP:PolicePromotion")
							local pp = json.decode(value) or 0
							if pp >= 3 then
								local nplayer = vRPclient.getNearestPlayer(source, 2)
								if nplayer then
									if vRPclient.getHealth(nplayer) <= 101 then
										timers[user_id] = 30
										actived[user_id] = true
										TriggerClientEvent('resetTimer', nplayer)
										TriggerClientEvent('cancelando', source, true)
										TriggerClientEvent("progress", source, 30000, "reanimando")
										vRPclient._playAnim(source, false, { "mini@cpr@char_a@cpr_str", "cpr_pumpchest" }, true)
										repeat
											if timers[user_id] <= 0 then
												timers[user_id] = nil
												actived[user_id] = nil
												TriggerClientEvent("resetBleeding", nplayer)
												TriggerClientEvent('cancelando', source, false)
												vRPclient.killGod(nplayer)
												vRPclient._stopAnim(source, false)
												TriggerClientEvent("Notify", source, "sucesso", "Primeiros socorros realizado com sucesso.")
											end
											Wait(10)
										until not timers[user_id]
									else
										TriggerClientEvent("Notify", source, "importante", "A pessoa precisa estar em coma para prosseguir.", 8000)
									end
								end
							end
						end
					end
				end
			end

			if item == "firstaid" then
				if not vRPclient.isInVehicle(source) then
					local nplayer = vRPclient.getNearestPlayer(source, 2)
					if nplayer then
						if vRPclient.getHealth(nplayer) <= 101 then
							if vRP.hasPermission(user_id, "paramedico.permissao") then
								timers[user_id] = 15
								actived[user_id] = true
								TriggerClientEvent('resetTimer', nplayer)
								TriggerClientEvent('cancelando', source, true)
								TriggerClientEvent("progress", source, 15000, "firstaid")
								vRPclient._playAnim(source, false, { "mini@cpr@char_a@cpr_str", "cpr_pumpchest" }, true)
								repeat
									if timers[user_id] <= 0 then
										timers[user_id] = nil
										actived[user_id] = nil
										TriggerClientEvent('cancelando', source, false)
										vRPclient._stopAnim(source, false)
									end
									Wait(10)
								until not timers[user_id]
							else
								if consumeItem(user_id, item, 1, true, "Usou") then
									timers[user_id] = 15
									actived[user_id] = true

									TriggerClientEvent('resetTimer', nplayer)
									TriggerClientEvent('cancelando', source, true)
									TriggerClientEvent("progress", source, 15000, "firstaid")
									vRPclient._playAnim(source, false, { "mini@cpr@char_a@cpr_str", "cpr_pumpchest" }, true)
									repeat
										if timers[user_id] <= 0 then
											timers[user_id] = nil
											actived[user_id] = nil
											TriggerClientEvent('cancelando', source, false)
											vRPclient._stopAnim(source, false)
										end
										Wait(10)
									until not timers[user_id]
								end
							end
						end
					end
				end
			end

			if item == "adrenaline" then
				if vRPclient.checkDistance(source, 2435.12, 4966.3, 42.35, 10) then
					local nplayer = vRPclient.getNearestPlayer(source, 2)
					if nplayer then
						if vRPclient.getHealth(nplayer) <= 101 then
							if getItemAmount(user_id, "adrenaline") >= 3 then
								if consumeItem(user_id, item, 3, true) then
									timers[user_id] = 15
									actived[user_id] = true

									TriggerClientEvent('cancelando', source, true)
									TriggerClientEvent("progress", source, 15000, "reanimando")
									vRPclient._playAnim(source, false, { "mini@cpr@char_a@cpr_str", "cpr_pumpchest" }, true)
									repeat
										if timers[user_id] <= 0 then
											timers[user_id] = nil
											actived[user_id] = nil
											vRPclient.killGod(nplayer)
											vRPclient.setHealth(nplayer, 150)
											TriggerClientEvent("resetBleeding", nplayer)
											TriggerClientEvent("resetDiagnostic", nplayer)
											TriggerClientEvent('cancelando', source, false)
											vRPclient._stopAnim(source, false)
										end
										Wait(10)
									until not timers[user_id]
								end
							end
						else
							TriggerClientEvent("Notify", source, "importante", "A pessoa precisa estar em coma para prosseguir.", 8000)
						end
					end
				end
			end

			if item == "mochila" then
				local max = vRP.query("pd-getMax", { user_id = user_id })[1].max
				--print(max)
				if max < 90 then
					if consumeItem(user_id, item, 1, true, "Usou") then
						if max == 6 then
							vrpServer.giveMax(user_id, 30)
						else
							vrpServer.giveMax(user_id, max + 30)
						end
						TriggerClientEvent("Notify", source, "sucesso", "<b>Mochila</b> utilizada com sucesso.", 8000)
					end
				else
					TriggerClientEvent("Notify", source, "negado", "Maximo de <b>90 Kgs</b>.", 8000)
				end
			end

			if item == "oxigenio" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 3
					actived[user_id] = true

					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 3000, "Roupa de mergulho")
					vRPclient._playAnim(source, true, { "oddjobs@basejump@ig_15", "puton_parachute" }, false)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							TriggerClientEvent('cancelando', source, false)
							vRPclient.stopAnim(source, true)
							local model = vRPclient.getModelPlayer(source)
							if model == "mp_m_freemode_01" then
								TriggerClientEvent("updateRoupas", source, { 122, 0, -1, 0, -1, 0, 31, 0, 94, 0, 123, 0, 67, 0, 243, 0, -1, 0, -1, 0, -1, 0, 26, 0, -1, 0, -1, 0, -1, 0 })
							elseif model == "mp_f_freemode_01" then
								TriggerClientEvent("updateRoupas", source, { 122, 0, -1, 0, -1, 0, 18, 0, 97, 0, 153, 0, 70, 0, 251, 0, -1, 0, -1, 0, -1, 0, 28, 0, -1, 0, -1, 0, -1, 0 })
							end
							TriggerClientEvent("Notify", source, "sucesso", "Roupa de <b>Mergulho</b> colocada com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "skate" then
				if getItemAmount(user_id, item) >= 1 then
					TriggerClientEvent("skate", source)
				end
			end

			if item == "fireworks" then
				if not vRPclient.isInVehicle(source) then
					if not vCLIENT.returnfireWorks(source) then
						if consumeItem(user_id, item, 1, true, "Usou") then
							TriggerClientEvent("b03461cc:pd-inventory:fireworks", source)
						end
					end
				end
			end

			if item == "cerveja" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 30
					actived[user_id] = true

					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 30000, "bebendo")
					vRPclient._CarregarObjeto(source, "amb@world_human_drinking@beer@male@idle_a", "idle_a", "prop_amb_beer_bottle", 49, 28422)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							vRPclient.playScreenEffect(source, "RaceTurbo", 180)
							vRPclient.playScreenEffect(source, "DrugsTrevorClownsFight", 180)
							TriggerClientEvent('cancelando', source, false)
							vRPclient._DeletarObjeto(source)
							TriggerClientEvent("Notify", source, "sucesso", "<b>Cerveja</b> utilizada com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "tequila" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 30
					actived[user_id] = true

					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 30000, "bebendo")
					vRPclient._CarregarObjeto(source, "amb@world_human_drinking@beer@male@idle_a", "idle_a", "prop_amb_beer_bottle", 49, 28422)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							vRPclient.playScreenEffect(source, "RaceTurbo", 180)
							vRPclient.playScreenEffect(source, "DrugsTrevorClownsFight", 180)
							TriggerClientEvent('cancelando', source, false)
							vRPclient._DeletarObjeto(source)
							TriggerClientEvent("Notify", source, "sucesso", "<b>Tequila</b> utilizada com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "vodka" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 30
					actived[user_id] = true

					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 30000, "bebendo")
					vRPclient._CarregarObjeto(source, "amb@world_human_drinking@beer@male@idle_a", "idle_a", "prop_amb_beer_bottle", 49, 28422)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							vRPclient.playScreenEffect(source, "RaceTurbo", 180)
							vRPclient.playScreenEffect(source, "DrugsTrevorClownsFight", 180)
							TriggerClientEvent('cancelando', source, false)
							vRPclient._DeletarObjeto(source)
							TriggerClientEvent("Notify", source, "sucesso", "<b>Vodka</b> utilizada com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "whisky" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 30
					actived[user_id] = true

					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 30000, "bebendo")
					vRPclient._CarregarObjeto(source, "amb@world_human_drinking@beer@male@idle_a", "idle_a", "p_whiskey_notop", 49, 28422)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							vRPclient.playScreenEffect(source, "RaceTurbo", 180)
							vRPclient.playScreenEffect(source, "DrugsTrevorClownsFight", 180)
							TriggerClientEvent('cancelando', source, false)
							vRPclient._DeletarObjeto(source)
							TriggerClientEvent("Notify", source, "sucesso", "<b>Whisky</b> utilizada com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "conhaque" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 30
					actived[user_id] = true

					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 30000, "bebendo")
					vRPclient._CarregarObjeto(source, "amb@world_human_drinking@beer@male@idle_a", "idle_a", "prop_amb_beer_bottle", 49, 28422)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							vRPclient.playScreenEffect(source, "RaceTurbo", 180)
							vRPclient.playScreenEffect(source, "DrugsTrevorClownsFight", 180)
							TriggerClientEvent('cancelando', source, false)
							vRPclient._DeletarObjeto(source)
							TriggerClientEvent("Notify", source, "sucesso", "<b>Conhaque</b> utilizada com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "absinto" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 30
					actived[user_id] = true

					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 30000, "bebendo")
					vRPclient._CarregarObjeto(source, "amb@world_human_drinking@beer@male@idle_a", "idle_a", "prop_amb_beer_bottle", 49, 28422)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							vRPclient.playScreenEffect(source, "RaceTurbo", 180)
							vRPclient.playScreenEffect(source, "DrugsTrevorClownsFight", 180)
							TriggerClientEvent('cancelando', source, false)
							vRPclient._DeletarObjeto(source)
							TriggerClientEvent("Notify", source, "sucesso", "<b>Absinto</b> utilizada com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "identidade" then
				local nplayer = vRPclient.getNearestPlayer(source, 2)
				if nplayer then
					local identity = vRP.getUserIdentity(user_id)
					if identity then
						TriggerClientEvent("Identity2", nplayer, identity.name, identity.firstname, identity.user_id, identity.registration)
					end
				end
			end

			if item == "maconha" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					actived[user_id] = true

					TriggerClientEvent('bong', source)
					SetTimeout(9000, function()
						actived[user_id] = nil
						TriggerClientEvent("Notify", source, "sucesso", "<b>Maconha</b> utilizada com sucesso.", 8000)
					end)
				end
			end

			if item == "cocaina" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 10
					actived[user_id] = true

					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 10000, "cheirando")
					vRPclient._playAnim(source, true, { "mp_player_int_uppersmoke", "mp_player_int_smoke" }, true)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							TriggerClientEvent('cancelando', source, false)
							vRPclient._stopAnim(source, false)
							vRPclient.playScreenEffect(source, "RaceTurbo", 120)
							vRPclient.playScreenEffect(source, "DrugsTrevorClownsFight", 120)
							TriggerClientEvent("Notify", source, "sucesso", "<b>Cocaína</b> utilizada com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "metanfetamina" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 10
					actived[user_id] = true

					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 10000, "fumando")
					vRPclient._playAnim(source, true, { "mp_player_int_uppersmoke", "mp_player_int_smoke" }, true)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							TriggerClientEvent('cancelando', source, false)
							vRPclient._stopAnim(source, false)
							vRPclient.playScreenEffect(source, "RaceTurbo", 120)
							vRPclient.playScreenEffect(source, "DrugsTrevorClownsFight", 120)
							TriggerClientEvent("Notify", source, "sucesso", "<b>Metanfetamina</b> utilizada com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "lsd" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 10
					actived[user_id] = true

					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 10000, "tomando")
					vRPclient._playAnim(source, true, { "mp_player_int_uppersmoke", "mp_player_int_smoke" }, true)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							TriggerClientEvent('cancelando', source, false)
							vRPclient._stopAnim(source, false)
							vRPclient.playScreenEffect(source, "RaceTurbo", 120)
							vRPclient.playScreenEffect(source, "DrugsTrevorClownsFight", 120)
							TriggerClientEvent("Notify", source, "sucesso", "<b>LSD</b> utilizado com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "capuz" then
				if getItemAmount(user_id, "capuz") >= 1 then
					local nplayer = vRPclient.getNearestPlayer(source, 2)
					if nplayer then
						vRPclient.setCapuz(nplayer)
						vRP.closeMenu(nplayer)
						TriggerClientEvent("Notify", source, "sucesso", "Capuz utilizado com sucesso.", 8000)
					end
				end
			end

			if item == "energetico" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 10
					actived[user_id] = true

					TriggerClientEvent('cancelando', source, true)
					TriggerClientEvent("progress", source, 10000, "bebendo")
					vRPclient._CarregarObjeto(source, "amb@world_human_drinking@beer@male@idle_a", "idle_a", "prop_energy_drink", 49, 28422)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							TriggerClientEvent('energeticos', source, true)
							TriggerClientEvent('cancelando', source, false)
							vRPclient._DeletarObjeto(source)
							TriggerClientEvent("Notify", source, "sucesso", "<b>Energético</b> utilizado com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
					SetTimeout(20000, function()
						TriggerClientEvent('energeticos', source, false)
						TriggerClientEvent("Notify", source, "aviso", "O efeito do energético passou e o coração voltou a bater normalmente.", 8000)
					end)
				end
			end

			if item == "lockpick" then
				local vehicle, vnetid, placa, vname, lock, banned, trunk, model, street = vRPclient.vehList(source, 7)
				local policia = vRP.getUsersByPermission("policia.permissao")
				if vehicle then
					if vRP.hasPermission(user_id, "policia.permissao") then
						TriggerEvent("setPlateEveryone", placa)
						vGARAGE.vehicleClientLock(-1, vnetid, lock)
						TriggerClientEvent("vrp_sound:source", source, 'lock', 0.5)
						return
					end

					if vRPclient.isInVehicle(source) then
						timers[user_id] = 30
						actived[user_id] = true
						vGARAGE.startAnimHotwired(source)
						TriggerClientEvent('cancelando', source, true)
						TriggerClientEvent("progress", source, 30000, "roubando")

						repeat
							if timers[user_id] <= 0 then
								timers[user_id] = nil
								actived[user_id] = nil
								vGARAGE.stopAnimHotwired(source, vehicle)
								TriggerClientEvent('cancelando', source, false)
								if math.random(100) >= 20 then
									TriggerEvent("setPlateEveryone", placa)
									TriggerClientEvent("vrp_sound:source", source, 'lock', 0.5)
								else
									consumeItem(user_id, item, 1, true, "Usou")
									TriggerClientEvent("Notify", source, "aviso", "Sua <b>Lockpick</b> quebrou tentando roubar o veículo.", 8000)
								end
								local x, y, z = vRPclient.getPosition(source)
								local policia = vRP.getUsersByPermission("policia.permissao")
								for k, v in pairs(policia) do
									local player = vRP.getUserSource(parseInt(v))
									if player then
										async(function()
											TriggerClientEvent("NotifyPush", player, { code = 31, title = "Crime em andamento", x = x, y = y, z = z, badge = "Roubo de veículo", veh = vRP.vehicleName(vname) .. " - " .. placa })
										end)
									end
								end
							end
							Wait(10)
						until not timers[user_id]
					else
						if #policia < 3 then
							TriggerClientEvent("Notify", source, "aviso", "Número insuficiente de policiais no momento para iniciar o roubo.")
							return true
						end

						if consumeItem(user_id, item, 1, true, "Usou") then
							timers[user_id] = 30
							actived[user_id] = true
							TriggerClientEvent('cancelando', source, true)
							TriggerClientEvent("progress", source, 30000, "roubando")
							vRPclient._playAnim(source, false, { "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" }, true)

							repeat
								if timers[user_id] <= 0 then
									timers[user_id] = nil
									actived[user_id] = nil
									vRPclient._stopAnim(source, false)
									TriggerClientEvent('cancelando', source, false)

									if math.random(100) >= 50 then
										TriggerEvent("setPlateEveryone", placa)
										TriggerClientEvent("vrp_sound:source", source, 'lock', 0.5)
									else
										local x, y, z = vRPclient.getPosition(source)
										local policia = vRP.getUsersByPermission("policia.permissao")
										for k, v in pairs(policia) do
											local player = vRP.getUserSource(parseInt(v))
											if player then
												async(function()
													TriggerClientEvent("NotifyPush", player, { code = 31, title = "Crime em andamento", x = x, y = y, z = z, badge = "Roubo de veículo", veh = vRP.vehicleName(vname) .. " - " .. placa })
												end)
											end
										end
									end
								end
								Wait(10)
							until not timers[user_id]
						end
					end
				end
			end

			if item == "masterpick" then
				local vehicle, vnetid, placa, vname, lock, banned, trunk, model, street = vRPclient.vehList(source, 7)
				local policia = vRP.getUsersByPermission("policia.permissao")
				if vehicle then
					if vRP.hasPermission(user_id, "policia.permissao") then
						TriggerEvent("setPlateEveryone", placa)
						vGARAGE.vehicleClientLock(-1, vnetid, lock)
						TriggerClientEvent("vrp_sound:source", source, 'lock', 0.5)
						return
					end
					if #policia < 5 then
						TriggerClientEvent("Notify", source, "aviso", "Número insuficiente de policiais no momento para iniciar o roubo.")
						return true
					end
					if consumeItem(user_id, item, 1, true, "Usou") then
						timers[user_id] = 60
						actived[user_id] = true

						TriggerClientEvent('cancelando', source, true)
						TriggerClientEvent("progress", source, 60000, "roubando")
						vRPclient._playAnim(source, false, { "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" }, true)
						repeat
							if timers[user_id] <= 0 then
								timers[user_id] = nil
								actived[user_id] = nil
								TriggerClientEvent('cancelando', source, false)
								vRPclient._stopAnim(source, false)
								TriggerEvent("setPlateEveryone", placa)
								vGARAGE.vehicleClientLock(-1, vnetid, lock)
								TriggerClientEvent("vrp_sound:source", source, 'lock', 0.5)
								local x, y, z = vRPclient.getPosition(source)
								local policia = vRP.getUsersByPermission("policia.permissao")
								for k, v in pairs(policia) do
									local player = vRP.getUserSource(parseInt(v))
									if player then
										async(function()
											TriggerClientEvent("NotifyPush", player, { code = 31, title = "Crime em andamento", x = x, y = y, z = z, badge = "Roubo de veículo", veh = vRP.vehicleName(vname) .. " - " .. placa })
										end)
									end
								end
							end
							Wait(10)
						until not timers[user_id]
					end
				end
			end

			if item == "eventkey" then
				local identity = vRP.getUserIdentity(user_id)
				local vehicle, vnetid, placa, vname, lock, banned, trunk, model, street = vRPclient.vehList(source, 7)
				if vehicle then
					if consumeItem(user_id, item, 1, true, "Usou") then
						timers[user_id] = 10
						actived[user_id] = true

						TriggerClientEvent('cancelando', source, true)
						TriggerClientEvent("progress", source, 10000, "abrindo")
						vRPclient._playSound(source, "Timer_10s", "DLC_HALLOWEEN_FVJ_Sounds")
						vRPclient._playAnim(source, false, { "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" }, true)
						repeat
							if timers[user_id] <= 0 then
								timers[user_id] = nil
								actived[user_id] = nil
								TriggerClientEvent('cancelando', source, false)
								vRPclient._stopAnim(source, false)
								if math.random(100) >= 90 then
									TriggerEvent("setPlateEveryone", placa)
									vGARAGE.vehicleClientLock(-1, vnetid, lock)
									TriggerClientEvent("vrp_sound:source", source, 'lock', 0.5)
									TriggerClientEvent("Notify", source, "sucesso", "Parabéns, você conseguiu.", 8000)
									TriggerClientEvent('chatMessage', -1, "VENCEDOR", { 19, 197, 43 }, "O jogador ^1" .. identity.name .. " " .. identity.firstname .. "^0 abriu o carro ^1" .. vRP.vehicleName(vname))
								else
									TriggerClientEvent("Notify", source, "negado", "Infelizmente não foi desta vez.", 8000)
								end
							end
							Wait(10)
						until not timers[user_id]
					end
				end
			end

			if item == "militec" then
				if not vRPclient.isInVehicle(source) then
					local vehicle, vnetid = vRPclient.vehList(source, 3.5)
					if vehicle then
						if vRP.hasPermission(user_id, "mecanico.permissao") then
							timers[user_id] = 30
							actived[user_id] = true
							TriggerClientEvent('cancelando', source, true)
							TriggerClientEvent("progress", source, 30000, "reparando motor")
							vGARAGE.vehicleClientHood(-1, vnetid, false)
							vRPclient._playAnim(source, false, { "mini@repair", "fixing_a_player" }, true)
							repeat
								if timers[user_id] <= 0 then
									timers[user_id] = nil
									actived[user_id] = nil
									TriggerClientEvent('cancelando', source, false)
									vRPclient._stopAnim(source, false)
									TriggerClientEvent('repararmotor', source, vehicle)
								end
								Wait(10)
							until not timers[user_id]
							vGARAGE.vehicleClientHood(-1, vnetid, true)
						else
							if consumeItem(user_id, item, 1, true, "Usou") then
								timers[user_id] = 30
								actived[user_id] = true
								TriggerClientEvent('cancelando', source, true)
								TriggerClientEvent("progress", source, 30000, "reparando motor")
								vGARAGE.vehicleClientHood(-1, vnetid, false)
								vRPclient._playAnim(source, false, { "mini@repair", "fixing_a_player" }, true)
								repeat
									if timers[user_id] <= 0 then
										timers[user_id] = nil
										actived[user_id] = nil
										TriggerClientEvent('cancelando', source, false)
										vRPclient._stopAnim(source, false)
										TriggerClientEvent('repararmotor', source, vehicle)
									end
									Wait(10)
								until not timers[user_id]
								vGARAGE.vehicleClientHood(-1, vnetid, true)
							end
						end
					end
				end
			end

			if item == "repairkit" then
				if not vRPclient.isInVehicle(source) then
					local vehicle, vnetid = vRPclient.vehList(source, 3.5)
					if vehicle then
						if vRP.hasPermission(user_id, "mecanico.permissao") then
							timers[user_id] = 30
							actived[user_id] = true
							TriggerClientEvent('cancelando', source, true)
							TriggerClientEvent("progress", source, 30000, "reparando veículo")
							vGARAGE.vehicleClientHood(-1, vnetid, false)
							vRPclient._playAnim(source, false, { "mini@repair", "fixing_a_player" }, true)
							repeat
								if timers[user_id] <= 0 then
									timers[user_id] = nil
									actived[user_id] = nil
									TriggerClientEvent('cancelando', source, false)
									vRPclient._stopAnim(source, false)
									TriggerClientEvent('reparar', source)
								end
								Wait(10)
							until not timers[user_id]
							vGARAGE.vehicleClientHood(-1, vnetid, true)
						else
							if consumeItem(user_id, item, 1, true, "Usou") then
								timers[user_id] = 30
								actived[user_id] = true
								TriggerClientEvent('cancelando', source, true)
								TriggerClientEvent("progress", source, 30000, "reparando veículo")
								vGARAGE.vehicleClientHood(-1, vnetid, false)
								vRPclient._playAnim(source, false, { "mini@repair", "fixing_a_player" }, true)
								repeat
									if timers[user_id] <= 0 then
										timers[user_id] = nil
										actived[user_id] = nil
										TriggerClientEvent('cancelando', source, false)
										vRPclient._stopAnim(source, false)
										TriggerClientEvent('reparar', source)
									end
									Wait(10)
								until not timers[user_id]
								vGARAGE.vehicleClientHood(-1, vnetid, true)
							end
						end
					end
				end
			end

			if item == "pneus" then
				if not vRPclient.isInVehicle(source) then
					local vehicle = vRPclient.getNearestVehicle(source, 3)
					if vehicle then
						if vRP.hasPermission(user_id, "mecanico.permissao") then
							timers[user_id] = 20
							actived[user_id] = true
							TriggerClientEvent('cancelando', source, true)
							TriggerClientEvent("progress", source, 20000, "reparando pneus")
							vRPclient._playAnim(source, false, { "amb@medic@standing@tendtodead@base", "base" }, true)
							vRPclient._CarregarObjeto(source, "", "", "prop_wheel_tyre", 49, 60309, -0.05, 0.2, 0.0, 0.0, 0.0, 50.0)
							repeat
								if timers[user_id] <= 0 then
									timers[user_id] = nil
									actived[user_id] = nil
									TriggerClientEvent('cancelando', source, false)
									vRPclient._DeletarObjeto(source)
									vRPclient._stopAnim(source, false)
									TriggerClientEvent('repararpneus', source, vehicle)
								end
								Wait(10)
							until not timers[user_id]
						else
							if consumeItem(user_id, item, 1, true, "Usou") then
								timers[user_id] = 20
								actived[user_id] = true
								TriggerClientEvent('cancelando', source, true)
								TriggerClientEvent("progress", source, 20000, "reparando pneus")
								vRPclient._playAnim(source, false, { "amb@medic@standing@tendtodead@base", "base" }, true)
								vRPclient._CarregarObjeto(source, "", "", "prop_wheel_tyre", 49, 60309, -0.05, 0.2, 0.0, 0.0, 0.0, 50.0)
								repeat
									if timers[user_id] <= 0 then
										timers[user_id] = nil
										actived[user_id] = nil
										TriggerClientEvent('cancelando', source, false)
										vRPclient._DeletarObjeto(source)
										vRPclient._stopAnim(source, false)
										TriggerClientEvent('repararpneus', source, vehicle)
									end
									Wait(10)
								until not timers[user_id]
							end
						end
					end
				end
			end

			if item == "notebook" then
				if vRPclient.isInVehicle(source) then
					local vehicle, vnetid, placa, vname, lock, banned = vRPclient.vehList(source, 7)
					if vehicle and placa then
						actived[user_id] = true
						vGARAGE.freezeVehicleNotebook(source, vehicle)
						TriggerClientEvent('cancelando', source, true)
						TriggerClientEvent("progress", source, 59500, "removendo rastreador")
						SetTimeout(60000, function()
							actived[user_id] = nil
							TriggerClientEvent('cancelando', source, false)
							local placa_user_id = vRP.getUserByRegistration(placa)
							if placa_user_id then
								local player = vRP.getUserSource(placa_user_id)
								if player then
									vGARAGE.removeGpsVehicle(player, vname)
								end
							end
						end)
					end
				end
			end

			if item == "placa" then
				if vRPclient.GetVehicleSeat(source) then
					local placa = vRP.generateRegistrationNumber()
					if consumeItem(user_id, item, 1, true, "Usou") then
						timers[user_id] = 60
						actived[user_id] = true
						TriggerClientEvent('cancelando', source, true)
						TriggerClientEvent("vehicleanchor", source, true)
						TriggerClientEvent("progress", source, 60000, "clonando")
						repeat
							if timers[user_id] <= 0 then
								timers[user_id] = nil
								actived[user_id] = nil
								TriggerClientEvent('cancelando', source, false)
								TriggerClientEvent("cloneplates", source, placa)
								TriggerEvent("setPlateEveryone", placa)
								TriggerClientEvent("Notify", source, "sucesso", "Veículo clonado com sucesso.", 8000)
							end
							Wait(10)
						until not timers[user_id]
						TriggerClientEvent("vehicleanchor", source, false)
					end
				end
			end

			if item == "colete" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					timers[user_id] = 3
					actived[user_id] = true
					vRPclient._playAnim(source, true, { "oddjobs@basejump@ig_15", "puton_parachute" }, false)
					TriggerClientEvent("progress", source, 3000)
					repeat
						if timers[user_id] <= 0 then
							timers[user_id] = nil
							actived[user_id] = nil
							vRPclient.setArmour(source, 100)
							TriggerClientEvent("setColeteUser", source)
							TriggerClientEvent("Notify", source, "sucesso", "<b>Colete</b> colocado com sucesso.", 8000)
						end
						Wait(10)
					until not timers[user_id]
				end
			end

			if item == "radio" then
				TriggerClientEvent("openRadio", source)
			end

			if item == "binoculos" then
				TriggerClientEvent("binoculos", source, true)
				vRPclient.CarregarObjeto(source, "amb@world_human_binoculars@male@enter", "enter", "prop_binoc_01", 50, 28422)
			end

			if item == "postit" then
				TriggerClientEvent("postit:init", source)
				vRPclient.CarregarObjeto(source, "amb@medic@standing@timeofdeath@base", "base", "prop_notepad_01", 49, 60309)
			end

			if item == "chip" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					vRP.execute("vRP/update_phone", { user_id = user_id, phone = vRP.generatePhoneNumber() })
				end
			end

			if item == "vipgold15" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					local time = string.sub(item, 8)
					local vip_time = os.time() + time * 24 * 60 * 60
					vRP.execute("updateVipTime", { id = user_id, vip_time = vip_time })
					vRP.addUserGroup(parseInt(user_id), "Gold")
					vRP.execute("vRP/add_priority", { id = user_id, priority = 50 })

					TriggerClientEvent("Notify", source, "sucesso", "<b>VIP Gold 15 dias</b>, utilizado com sucesso.", 8000)
				end
			end

			if item == "vipgold30" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					local time = string.sub(item, 8)
					local vip_time = os.time() + time * 24 * 60 * 60
					vRP.execute("updateVipTime", { id = user_id, vip_time = vip_time })
					vRP.addUserGroup(parseInt(user_id), "Gold")
					vRP.execute("vRP/add_priority", { id = user_id, priority = 50 })

					TriggerClientEvent("Notify", source, "sucesso", "<b>VIP Gold 30 dias</b>, utilizado com sucesso.", 8000)
				end
			end

			if item == "vipplatinum15" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					local time = string.sub(item, 12)
					local vip_time = os.time() + time * 24 * 60 * 60
					vRP.execute("updateVipTime", { id = user_id, vip_time = vip_time })
					vRP.addUserGroup(parseInt(user_id), "Platinum")
					vRP.execute("vRP/add_priority", { id = user_id, priority = 90 })


					TriggerClientEvent("Notify", source, "sucesso", "<b>VIP Platinum 15 dias</b>, utilizado com sucesso.", 8000)
				end
			end

			if item == "vipplatinum30" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					local time = string.sub(item, 12)
					local vip_time = os.time() + time * 24 * 60 * 60
					vRP.execute("updateVipTime", { id = user_id, vip_time = vip_time })
					vRP.addUserGroup(parseInt(user_id), "Platinum")
					vRP.execute("vRP/add_priority", { id = user_id, priority = 90 })

					TriggerClientEvent("Notify", source, "sucesso", "<b>VIP Platinum 30 dias</b>, utilizado com sucesso.", 8000)
				end
			end

			if item == "vipaparencia" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					vRP.setUData(user_id, "vRP:spawnController", json.encode(0))

					TriggerClientEvent("Notify", source, "sucesso", "<b>Aparência resetada</b> com sucesso.", 8000)
				end
			end

			if item == "vipgaragem" then
				if consumeItem(user_id, item, 1, true, "Usou") then
					vRP.execute("creative/update_garages", { id = user_id })

					TriggerClientEvent("Notify", source, "sucesso", "<b>Adicionado +1 Garagem</b> com sucesso.", 8000)
				end
			end

			if item == "vipplaca" then
				local descricao = vRP.prompt(source, "Mudança de placa (8 Caractér):", "")
				local descricao2 = sanitizeString(descricao, "abcdefghijklmnopqrstuvwxyz0123456789", true)
				if descricao2 == "" or vRP.getUserByRegistration(descricao2) ~= nil or string.len(descricao2) ~= 8 then
					return
				end

				vRP.execute("vRP/update_registration", { user_id = user_id, registration = string.upper(descricao2) })

				consumeItem(user_id, item, 1, true, "Usou")
				TriggerClientEvent("Notify", source, "sucesso", "<b>Placa Modificada</b> com sucesso, favor relogar.", 8000)
			end
		end
	end
end)
