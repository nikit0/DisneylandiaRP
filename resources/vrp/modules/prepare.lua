-----------------------------------------------------------------------------------------------------------------------------------------
-- BASE.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/create_user","INSERT INTO vrp_users(whitelisted,banned) VALUES(false,false); SELECT LAST_INSERT_ID() AS id")
vRP.prepare("vRP/set_steam","UPDATE vrp_users SET steam = @steam WHERE id = @user_id")
vRP.prepare("vRP/add_identifier","INSERT INTO vrp_user_ids(identifier,user_id) VALUES(@identifier,@user_id)")
vRP.prepare("vRP/userid_byidentifier","SELECT user_id FROM vrp_user_ids WHERE identifier = @identifier")
vRP.prepare("vRP/set_userdata","REPLACE INTO vrp_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
vRP.prepare("vRP/get_userdata","SELECT dvalue FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key")
vRP.prepare("vRP/set_srvdata","REPLACE INTO vrp_srv_data(dkey,dvalue) VALUES(@key,@value)")
vRP.prepare("vRP/get_srvdata","SELECT dvalue FROM vrp_srv_data WHERE dkey = @key")
vRP.prepare("vRP/get_banned","SELECT banned FROM vrp_users WHERE id = @user_id")
vRP.prepare("vRP/set_banned","UPDATE vrp_users SET banned = @banned WHERE id = @user_id")
vRP.prepare("vRP/get_whitelisted","SELECT whitelisted FROM vrp_users WHERE id = @user_id")
vRP.prepare("vRP/set_whitelisted","UPDATE vrp_users SET whitelisted = @whitelisted WHERE id = @user_id")
vRP.prepare("vRP/add_banned","INSERT INTO vrp_users_banned(user_id,identifier,hacker) VALUES(@user_id,@identifier,@hacker) ON DUPLICATE KEY UPDATE user_id = @user_id, hacker = @hacker")
vRP.prepare("vRP/get_identifiers_by_userid","SELECT identifier FROM vrp_user_ids WHERE user_id = @user_id")
vRP.prepare("vRP/get_banned_identifiers","SELECT identifier FROM vrp_users_banned WHERE identifier = @identifier")
vRP.prepare("vRP/rem_banned_identifiers","DELETE from vrp_users_banned WHERE user_id = @user_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUEUE.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
--vRP.prepare("vRP/get_priority","SELECT * FROM vrp_priority")
vRP.prepare("vRP/get_priority","SELECT * FROM vrp_users")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("getUserGroups","SELECT groups FROM vrp_users WHERE id = @id")
vRP.prepare("updateUserGroups","UPDATE vrp_users SET groups = @groups WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTITY.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_user_identity","SELECT * FROM vrp_user_identities WHERE user_id = @user_id")
vRP.prepare("vRP/init_user_identity","INSERT IGNORE INTO vrp_user_identities(user_id,registration,phone,firstname,name,age) VALUES(@user_id,@registration,@phone,@firstname,@name,@age)")
vRP.prepare("vRP/update_user_identity","UPDATE vrp_user_identities SET firstname = @firstname, name = @name, age = @age, registration = @registration, phone = @phone WHERE user_id = @user_id")
vRP.prepare("vRP/get_userbyreg","SELECT user_id FROM vrp_user_identities WHERE registration = @registration")
vRP.prepare("vRP/get_userbyphone","SELECT user_id FROM vrp_user_identities WHERE phone = @phone")
vRP.prepare("vRP/update_registration","UPDATE vrp_user_identities SET registration = @registration WHERE user_id = @user_id")
vRP.prepare("vRP/update_user_first_spawn","UPDATE vrp_user_identities SET firstname = @firstname, name = @name, age = @age WHERE user_id = @user_id")
vRP.prepare("vRP/update_phone","UPDATE vrp_user_identities SET phone = @phone WHERE user_id = @user_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("get_vehicle_data","SELECT * FROM vrp_vehicles WHERE spawn = @spawn")
vRP.prepare("get_vehicle_hash","SELECT * FROM vrp_vehicles WHERE hash = @hash")
vRP.prepare("get_vehicles","SELECT * FROM vrp_vehicles")
vRP.prepare("set_stock","UPDATE vrp_vehicles SET stock = @stock WHERE spawn = @spawn")
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEY.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/money_init_user","INSERT IGNORE INTO vrp_user_moneys(user_id,wallet,bank,paypal) VALUES(@user_id,@wallet,@bank,@paypal)")
vRP.prepare("vRP/get_money","SELECT wallet,bank,paypal FROM vrp_user_moneys WHERE user_id = @user_id")
vRP.prepare("vRP/set_money","UPDATE vrp_user_moneys SET wallet = @wallet, bank = @bank, paypal = @paypal WHERE user_id = @user_id")
vRP.prepare("get_coins","SELECT coins FROM vrp_users WHERE id = @id")
vRP.prepare("set_coins","UPDATE vrp_users SET coins = @coins WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPLOSIVERACE.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("explosiverace/get_race_rank_by_user_id","SELECT * FROM vrp_race_ranks WHERE user_id = @user_id AND race_id = @race_id")
vRP.prepare("explosiverace/insert_race_rank_by_user_id","INSERT INTO vrp_race_ranks (race_id, user_id, final_time) VALUES (@race_id, @user_id, @final_time)")
vRP.prepare("explosiverace/update_race_rank_by_user_id","UPDATE vrp_race_ranks SET final_time = @final_time WHERE race_id = @race_id AND user_id = @user_id")
vRP.prepare("explosiverace/get_top_players","SELECT * FROM vrp_race_ranks WHERE race_id = @race_id ORDER BY final_time ASC LIMIT @limit")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/upd_rg_phone","UPDATE vrp_user_identities SET registration = @registration, phone = @phone WHERE user_id = @user_id")
vRP.prepare("vRP/upd_user_identity","UPDATE vrp_user_identities SET name = @name, firstname = @firstname, age = @age WHERE user_id = @user_id")
vRP.prepare("vRP/get_allvehicles","SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP.prepare("vRP/rem_allcars","DELETE FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP.prepare("vRP/rem_allhouses","DELETE FROM vrp_homes_permissions WHERE user_id = @user_id")
vRP.prepare("vRP/rem_user_dkey","DELETE FROM vrp_user_data WHERE dkey = @dkey AND user_id = @user_id")
vRP.prepare("vRP/rem_srv_data","DELETE FROM vrp_srv_data WHERE dkey LIKE @user_id")
vRP.prepare("vRP/add_priority","UPDATE vrp_users SET priority = @priority WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- COINS.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("getVipTime","SELECT vip_time FROM vrp_users WHERE id = @id")
vRP.prepare("updateVipTime","UPDATE vrp_users SET vip_time = @vip_time WHERE id = @id")
vRP.prepare("setRentalTime","UPDATE vrp_user_vehicles SET rental_time = @rental_time WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("getRentalTime","SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- EBAY.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("creative/get_ebaylist","SELECT id,user_id,item_id,quantidade,price,anony FROM vrp_ebay")
vRP.prepare("creative/get_ebaylist2","SELECT id,user_id,item_id,quantidade,price,anony FROM vrp_ebay WHERE id = @id")
vRP.prepare("creative/get_ebaylist3","SELECT id,user_id,item_id,quantidade,price,anony FROM vrp_ebay WHERE user_id = @user_id AND item_id = @item_id AND quantidade = @quantidade AND price = @price")
vRP.prepare("creative/rem_ebaylist","DELETE FROM vrp_ebay WHERE id = @id")
vRP.prepare("creative/add_ebayitem","INSERT IGNORE INTO vrp_ebay(user_id,item_id,quantidade,price,anony) VALUES(@user_id,@item_id,@quantidade,@price,@anony)")
vRP.prepare("creative/set_paypal","UPDATE vrp_users SET paypal = @paypal WHERE id = @user_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("creative/get_vehicle","SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP.prepare("creative/rem_vehicle","DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("creative/get_vehicles","SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("creative/set_update_vehicles","UPDATE vrp_user_vehicles SET engine = @engine, body = @body, fuel = @fuel WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("creative/set_detido","UPDATE vrp_user_vehicles SET detido = @detido, time = @time WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("creative/set_ipva","UPDATE vrp_user_vehicles SET ipva = @ipva WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("creative/move_vehicle","UPDATE vrp_user_vehicles SET user_id = @nuser_id WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("creative/add_vehicle","INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle,ipva) VALUES(@user_id,@vehicle,@ipva)")
vRP.prepare("creative/con_maxvehs","SELECT COUNT(vehicle) as qtd FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP.prepare("creative/rem_srv_data","DELETE FROM vrp_srv_data WHERE dkey = @dkey")
vRP.prepare("creative/get_users","SELECT * FROM vrp_users WHERE id = @user_id")
vRP.prepare("creative/set_estoque","UPDATE vrp_estoque SET quantidade = @quantidade WHERE vehicle = @vehicle")
vRP.prepare("creative/update_garages","UPDATE vrp_users SET garagem = garagem + 1 WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPDESK.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("disneylandia/showMyCases","SELECT * FROM vrp_helpdesk_ticket WHERE user_id = @user_id")
vRP.prepare("disneylandia/showSupportCases", "SELECT * FROM vrp_helpdesk_ticket WHERE status = 1")
vRP.prepare("disneylandia/getCase","SELECT * FROM vrp_helpdesk_ticket WHERE id = @id")
vRP.prepare("disneylandia/getCaseReplies","SELECT * FROM vrp_helpdesk_answers WHERE case_id = @id")
vRP.prepare("disneylandia/new_ticket","INSERT INTO vrp_helpdesk_ticket SET user_id = @user_id, title = @title, message = @message")
vRP.prepare("disneylandia/new_answers","INSERT INTO vrp_helpdesk_answers SET user_id = @user_id, message = @message, case_id = @case_id")
vRP.prepare("disneylandia/upd_ticket","UPDATE vrp_helpdesk_ticket SET status = 0 WHERE id = @case_id")
vRP.prepare("disneylandia/rem_ticket","DELETE FROM vrp_helpdesk_ticket WHERE id = @case_id")
vRP.prepare("disneylandia/rem_answers","DELETE FROM vrp_helpdesk_answers WHERE id = @case_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMES.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("homes/get_homeuser","SELECT * FROM vrp_homes_permissions WHERE user_id = @user_id AND home = @home")
vRP.prepare("homes/get_homeuserid","SELECT * FROM vrp_homes_permissions WHERE user_id = @user_id")
vRP.prepare("homes/get_homeuserowner","SELECT * FROM vrp_homes_permissions WHERE user_id = @user_id AND home = @home AND owner = 1")
vRP.prepare("homes/get_homeuseridowner","SELECT * FROM vrp_homes_permissions WHERE home = @home AND owner = 1")
vRP.prepare("homes/get_homepermissions","SELECT * FROM vrp_homes_permissions WHERE home = @home")
vRP.prepare("homes/add_permissions","INSERT IGNORE INTO vrp_homes_permissions(home,user_id) VALUES(@home,@user_id)")
vRP.prepare("homes/buy_permissions","INSERT IGNORE INTO vrp_homes_permissions(home,user_id,owner,tax,garage) VALUES(@home,@user_id,1,@tax,1)")
vRP.prepare("homes/count_homepermissions","SELECT COUNT(*) as qtd FROM vrp_homes_permissions WHERE home = @home")
vRP.prepare("homes/upd_permissions","UPDATE vrp_homes_permissions SET garage = 1 WHERE home = @home AND user_id = @user_id")
vRP.prepare("homes/rem_permissions","DELETE FROM vrp_homes_permissions WHERE home = @home AND user_id = @user_id")
vRP.prepare("homes/upd_taxhomes","UPDATE vrp_homes_permissions SET tax = @tax WHERE user_id = @user_id AND home = @home AND owner = 1")
vRP.prepare("homes/rem_allpermissions","DELETE FROM vrp_homes_permissions WHERE home = @home")
vRP.prepare("homes/get_allhomes","SELECT * FROM vrp_homes_permissions WHERE owner = @owner")
vRP.prepare("homes/get_allvehs","SELECT * FROM vrp_vehicles")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PETS.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("disneylandia/get_users","SELECT * FROM vrp_users WHERE id = @id")
vRP.prepare("disneylandia/update_pets","UPDATE vrp_users SET pets = NULL WHERE id = @id")
vRP.prepare("disneylandia/get_pets","UPDATE vrp_users SET pets = @pets WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PD-INVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("pd-getInv", "SELECT itemlist FROM vrp_user_inventory WHERE user_id = @user_id")
vRP.prepare("pd-updateInv", "UPDATE vrp_user_inventory SET itemlist = @itemlist WHERE user_id = @user_id")
vRP.prepare("pd-getMax", "SELECT max FROM vrp_user_inventory WHERE user_id = @user_id")
vRP.prepare("pd-giveMax", "UPDATE vrp_user_inventory SET max = @max WHERE user_id = @user_id")
vRP.prepare("pd-newInv","INSERT INTO vrp_user_inventory(user_id,itemlist,max) VALUES(@user_id,@itemlist,@max)")
vRP.prepare("pd-clearInv","UPDATE vrp_user_inventory SET itemlist = @itemlist WHERE user_id = @user_id")