local cfg = {}

cfg.groups = {
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
}

cfg.users = {
	[1] = { "Admin" },
	[2] = { "Admin" }
}

cfg.selectors = {}

return cfg