function vRP.getMoney(user_id)
	local tmp = vRP.getUserTmpTable(user_id)
	if tmp then
		return tmp.wallet or 0
	else
		return 0
	end
end

function vRP.setMoney(user_id,value)
	local tmp = vRP.getUserTmpTable(user_id)
	if tmp then
		tmp.wallet = value
	end
end

function vRP.giveMoney(user_id,amount,notify)
	if amount >= 0 then
		local money = vRP.getMoney(user_id)
		vRP.setMoney(user_id,money+amount)
		if notify then
			TriggerClientEvent("ItemNotify",vRP.getUserSource(user_id),"Dólares","dinheiro.png","Recebeu $"..vRP.format(parseInt(amount)))
		end
	end
end

function vRP.getBankMoney(user_id)
	local tmp = vRP.getUserTmpTable(user_id)
	if tmp then
		return tmp.bank or 0
	else
		return 0
	end
end

function vRP.setBankMoney(user_id,value)
	local tmp = vRP.getUserTmpTable(user_id)
	if tmp then
		tmp.bank = value
	end
end

function vRP.giveBankMoney(user_id,amount,notify)
	if amount >= 0 then
		local money = vRP.getBankMoney(user_id)
		vRP.setBankMoney(user_id,money+amount)
		if notify then
			TriggerClientEvent("ItemNotify",vRP.getUserSource(user_id),"Dólares","dinheiro.png","Recebeu $"..vRP.format(parseInt(amount)))
		end
	end
end

function vRP.getPaypalMoney(user_id)
	local tmp = vRP.getUserTmpTable(user_id)
	if tmp then
		return tmp.paypal or 0
	else
		return 0
	end
end

function vRP.setPaypalMoney(user_id,value)
	local tmp = vRP.getUserTmpTable(user_id)
	if tmp then
		tmp.paypal = value
	end
end

function vRP.paypalWithdraw(user_id,amount)
	local money = vRP.getPaypalMoney(user_id)
	if amount >= 0 and money >= amount then
		vRP.setPaypalMoney(user_id,money-amount)
		return true
	else
		return false
	end
end

function vRP.tryWithdraw(user_id,amount)
	local money = vRP.getBankMoney(user_id)
	if amount >= 0 and money >= amount then
		vRP.setBankMoney(user_id,money-amount)
		vRP.giveMoney(user_id,amount)
		return true
	else
		return false
	end
end

function vRP.tryDeposit(user_id,amount)
	if amount >= 0 and vRP.tryPayment(user_id,amount) then
		vRP.giveBankMoney(user_id,amount)
		return true
	else
		return false
	end
end

function vRP.getJobPayment(name,amount,legal)
	if legal then
		return parseInt(amount) * 0.50
	else
		return parseInt(amount) * 0.70
	end
end

function vRP.tryPayment(user_id,amount,notify)
	if amount >= 0 then
		local money = vRP.getMoney(user_id)
		if amount >= 0 and money >= amount then
			vRP.setMoney(user_id,money-amount)
			if notify then
				TriggerClientEvent("ItemNotify",vRP.getUserSource(user_id),"Dólares","dinheiro.png","Pagou $"..vRP.format(parseInt(amount)))
			end
			return true
		else
			return false
		end
	end
	return false
end

function vRP.tryFullPayment(user_id,amount)
	if amount >= 0 then
		local money = vRP.getMoney(user_id)
		if money >= amount then
			return vRP.tryPayment(user_id,amount,true)
		else
			if vRP.tryWithdraw(user_id,amount-money) then
				return vRP.tryPayment(user_id,amount,true)
			end
		end
	end
	return false
end

function vRP.getCoins(user_id)
	local rows = vRP.query("get_coins",{ id = parseInt(user_id) })
	local tmpcoins = 0
	for k,v in pairs(rows) do
		for z,x in pairs(v) do
			tmpcoins = x
		end
	end
	return tmpcoins
end

function vRP.withdrawCoins(user_id,amount)
	local coins = vRP.getCoins(user_id)
	vRP.execute("set_coins",{ id = parseInt(user_id), coins = coins-amount })
end

function vRP.giveCoins(user_id,amount)
	local coins = vRP.getCoins(user_id)
	if coins >= 0 then
		vRP.execute("set_coins",{ id = parseInt(user_id), coins = coins+amount })
	end
end

AddEventHandler("vRP:playerJoin",function(user_id,source,name)
	vRP.execute("vRP/money_init_user",{ user_id = user_id, wallet = 1000, bank = 2000, paypal = 0 })
	local tmp = vRP.getUserTmpTable(user_id)
	if tmp then
		local rows = vRP.query("vRP/get_money",{ user_id = user_id })
		if #rows > 0 then
			tmp.wallet = rows[1].wallet
			tmp.bank = rows[1].bank
			tmp.paypal = rows[1].paypal
		end
	end
end)

RegisterCommand('savedb',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local tmp = vRP.getUserTmpTable(user_id)
		if tmp and tmp.wallet and tmp.bank and tmp.paypal then
			vRP.execute("vRP/set_money",{ user_id = user_id, wallet = tmp.wallet, bank = tmp.bank, paypal = tmp.paypal })
		end
		TriggerClientEvent("save:database",source)
		TriggerClientEvent("Notify",source,"importante","Você salvou todo o conteúdo temporário de sua database.")
	end
end)

AddEventHandler("vRP:playerLeave",function(user_id,source)
	local tmp = vRP.getUserTmpTable(user_id)
	if tmp and tmp.wallet and tmp.bank and tmp.paypal then
		vRP.execute("vRP/set_money",{ user_id = user_id, wallet = tmp.wallet, bank = tmp.bank, paypal = tmp.paypal })
	end
end)

AddEventHandler("vRP:save",function()
	for k,v in pairs(vRP.user_tmp_tables) do
		if v.wallet and v.bank and v.paypal then
			vRP.execute("vRP/set_money",{ user_id = k, wallet = v.wallet, bank = v.bank, paypal = v.paypal })
		end
	end
end)