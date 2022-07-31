local groups = {
	["Admin"] = {
		_config = {
			title = "Admin",
			gtype = "adm"
		},
		"admin.permissao"
	},
	["Suporte"] = {
		_config = {
			title = "Suporte",
			gtype = "adm"
		},
		"suporte.permissao"
	},
	["Disneynews"] = {
		_config = {
			title = "Disneynews",
			gtype = "job2"
		},
		"disneynews.permissao"
	},
	["Juiz"] = {
		_config = {
			title = "Juiz",
			gtype = "job"
		},
		"juiz.permissao",
		"portadp.permissao",
		"sem.permissao"
	},
	["PaisanaJuiz"] = {
		_config = {
			title = "PaisanaJuiz",
			gtype = "job"
		},
		"paisanajuiz.permissao",
		"sem.permissao"
	},
	["Advogado"] = {
		_config = {
			title = "Advogado",
			gtype = "job"
		},
		"advogado.permissao",
		"sem.permissao"
	},
	["PaisanaAdvogado"] = {
		_config = {
			title = "PaisanaAdvogado",
			gtype = "job"
		},
		"paisanaadvogado.permissao",
		"sem.permissao"
	},
	["Policia"] = {
		_config = {
			title = "Policia",
			gtype = "job"
		},
		"policia.permissao",
		"polpar.permissao",
		"portadp.permissao",
		"sem.permissao"
	},
	["PaisanaPolicia"] = {
		_config = {
			title = "PaisanaPolicia",
			gtype = "job"
		},
		"paisanapolicia.permissao",
		"sem.permissao"
	},
	["AcaoPolicia"] = {
		_config = {
			title = "AcaoPolicia",
			gtype = "job"
		},
		"acaopolicia.permissao",
		"portadp.permissao",
		"mochila.permissao",
		"sem.permissao"
	},
	["Paramedico"] = {
		_config = {
			title = "Paramedico",
			gtype = "job"
		},
		"paramedico.permissao",
		"polpar.permissao",
		"sem.permissao"
	},
	["PaisanaParamedico"] = {
		_config = {
			title = "PaisanaParamedico",
			gtype = "job"
		},
		"paisanaparamedico.permissao",
		"sem.permissao"
	},
	["Mecanico"] = {
		_config = {
			title = "Mecanico",
			gtype = "job"
		},
		"mecanico.permissao"
	},
	["PaisanaMecanico"] = {
		_config = {
			title = "PaisanaMecanico",
			gtype = "job"
		},
		"paisanamecanico.permissao"
	},
	["Taxista"] = {
		_config = {
			title = "Taxista",
			gtype = "job4"
		},
		"taxista.permissao"
	},
	--[[["PaisanaTaxista"] = {
		_config = {
			title = "PaisanaTaxista",
			gtype = "job"
		},
		"paisanataxista.permissao"
	},]]
	["Gold"] = {
		_config = {
			title = "Gold",
			gtype = "vip"
		},
		"ouro.permissao",
		"mochila.permissao"
	},
	["Platinum"] = {
		_config = {
			title = "Platinum",
			gtype = "vip"
		},
		"platina.permissao",
		"mochila.permissao"
	},
	["Diamond"] = {
		_config = {
			title = "Diamond",
			gtype = "vip"
		},
		"diamond.permissao",
		"mochila.permissao"
	},
	["Roxos"] = {
		_config = {
			title = "Roxos",
			gtype = "job"
		},
		"PurplePermission",
		"TrafficPermission"
	},
	["Amarelos"] = {
		_config = {
			title = "Amarelos",
			gtype = "job"
		},
		"YellowPermission",
		"TrafficPermission"
	},
	["Vermelhos"] = {
		_config = {
			title = "Vermelhos",
			gtype = "job"
		},
		"RedPermission",
		"TrafficPermission"
	},
	["Mafia"] = {
		_config = {
			title = "Mafia",
			gtype = "job"
		},
		"mafia.permissao"
	},
	["Serpentes"] = {
		_config = {
			title = "Serpentes",
			gtype = "job"
		},
		"serpentes.permissao"
	},
	["Motoclub"] = {
		_config = {
			title = "Motoclub",
			gtype = "job"
		},
		"motoclub.permissao"
	},
	["Yakuza"] = {
		_config = {
			title = "Yakuza",
			gtype = "job"
		},
		"yakuza.permissao"
	},
	["Concessionaria"] = {
		_config = {
			title = "Concessionaria",
			gtype = "job"
		},
		"conce.permissao"
	},
	["Fedex"] = {
		_config = {
			title = "Fedex",
			gtype = "job2"
		},
		"fedex.permissao"
	},
	["Desempregado"] = {
		_config = {
			title = "Desempregado",
			gtype = "job"
		},
		"desempregado.permissao"
	}
}

local users = {
	[1] = { "Admin" }
}

function vRP.getGroupTitle(group) -- ok
	local g = groups[group]
	if g and g._config and g._config.title then
		return g._config.title
	end
	return group
end

function vRP.getUserGroups(user_id) -- ok
	local groups = json.decode(vRP.query("vRP/get_user_groups", { id = user_id })[1].groups)
	return groups
end

function vRP.removeUserGroup(user_id, group)
	local user_groups = vRP.getUserGroups(user_id)
	local groupdef = groups[group]
	local gtype

	if groupdef then
		if groupdef._config and groupdef._config.gtype ~= nil then
			gtype = groupdef._config.gtype
		end

		for k, _ in pairs(user_groups) do
			if k == group then
				user_groups[group] = nil
				vRP.execute("vRP/update_user_groups", { groups = json.encode(user_groups), id = user_id })

				TriggerEvent("vRP:playerLeaveGroup", user_id, group, gtype)
			end
		end

	end
end

function vRP.addUserGroup(user_id, group)
	if not vRP.hasGroup(user_id, group) then
		local user_groups = vRP.getUserGroups(user_id)
		local ngroup = groups[group]
		local gtype
		if ngroup then
			-- Remover do mesmo GTYPE
			if ngroup._config and ngroup._config.gtype ~= nil then
				local _user_groups = {}
				for k, v in pairs(user_groups) do
					_user_groups[k] = v
				end

				for k, v in pairs(_user_groups) do
					local kgroup = groups[k]
					if kgroup and kgroup._config and ngroup._config and kgroup._config.gtype == ngroup._config.gtype then
						user_groups[k] = nil
						vRP.removeUserGroup(user_id, k)
					end
				end

				gtype = ngroup._config.gtype

				user_groups[group] = true
				vRP.execute("vRP/update_user_groups", { groups = json.encode(user_groups), id = user_id })

				TriggerEvent("vRP:playerJoinGroup", user_id, group, gtype)
			end
		end
	end
end

function vRP.getUserGroupByType(user_id, gtype) -- ok
	local user_groups = vRP.getUserGroups(user_id)
	for k, v in pairs(user_groups) do
		local kgroup = groups[k]
		if kgroup then
			if kgroup._config and kgroup._config.gtype and kgroup._config.gtype == gtype then
				return kgroup._config.title
			end
		end
	end
	return ""
end

function vRP.getUsersByPermission(perm) -- ok
	local users = {}
	for k, v in pairs(vRP.rusers) do
		if vRP.hasPermission(tonumber(k), perm) then
			table.insert(users, tonumber(k))
		end
	end
	return users
end

function vRP.hasGroup(user_id, group) -- ok
	local user_groups = vRP.getUserGroups(user_id)
	return (user_groups[group] ~= nil)
end

function vRP.hasPermission(user_id, perm) -- ok
	local user_groups = vRP.getUserGroups(user_id)

	for k, _ in pairs(user_groups) do
		if k then
			if groups[k] then
				for l, w in pairs(groups[k]) do
					if l ~= "_config" and w == perm then
						return true
					end
				end
			end
		end
	end
	return false
end

function vRP.hasPermissions(user_id, perms) -- ok
	for k, v in pairs(perms) do
		if not vRP.hasPermission(user_id, v) then
			return false
		end
	end
	return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
	if first_spawn then
		local user = users[user_id]
		if user then
			for k, v in pairs(user) do
				vRP.addUserGroup(user_id, v)
			end
		end

		if vRP.getUserGroupByType(user_id, "job") == "" then
			vRP.addUserGroup(user_id, "Desempregado")
		end
	end
end)
