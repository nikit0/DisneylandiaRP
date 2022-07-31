-----------------------------------------------------------------------------------------------------------------------------------------
-- BASE
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/create_user", "INSERT INTO vrp_users(whitelisted,banned) VALUES(false,false)")
vRP.prepare("vRP/set_license", "UPDATE vrp_users SET license = @license WHERE id = @user_id")
vRP.prepare("vRP/get_license", "SELECT license FROM vrp_users WHERE id = @id")
vRP.prepare("vRP/add_identifier", "INSERT INTO vrp_user_ids(identifier,user_id) VALUES(@identifier,@user_id)")
vRP.prepare("vRP/userid_byidentifier", "SELECT user_id FROM vrp_user_ids WHERE identifier = @identifier")
vRP.prepare("vRP/set_userdata", "REPLACE INTO vrp_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
vRP.prepare("vRP/get_userdata", "SELECT dvalue FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key")
vRP.prepare("vRP/set_srvdata", "REPLACE INTO vrp_srv_data(dkey,dvalue) VALUES(@key,@value)")
vRP.prepare("vRP/get_srvdata", "SELECT dvalue FROM vrp_srv_data WHERE dkey = @key")
vRP.prepare("vRP/get_banned", "SELECT banned FROM vrp_users WHERE id = @user_id")
vRP.prepare("vRP/set_banned", "UPDATE vrp_users SET banned = @banned WHERE id = @user_id")
vRP.prepare("vRP/get_whitelisted", "SELECT whitelisted FROM vrp_users WHERE id = @user_id")
vRP.prepare("vRP/set_whitelisted", "UPDATE vrp_users SET whitelisted = @whitelisted WHERE id = @user_id")
vRP.prepare("vRP/get_user_groups", "SELECT groups FROM vrp_users WHERE id = @id")
vRP.prepare("vRP/update_user_groups", "UPDATE vrp_users SET groups = @groups WHERE id = @id")
vRP.prepare("vRP/get_priority", "SELECT * FROM vrp_users")
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_user_identity", "SELECT * FROM vrp_user_identities WHERE user_id = @user_id")
vRP.prepare("vRP/init_user_identity", "INSERT IGNORE INTO vrp_user_identities(user_id,registration,phone,firstname,name,age) VALUES(@user_id,@registration,@phone,@firstname,@name,@age)")
vRP.prepare("vRP/update_user_identity", "UPDATE vrp_user_identities SET firstname = @firstname, name = @name, age = @age, registration = @registration, phone = @phone WHERE user_id = @user_id")
vRP.prepare("vRP/get_userbyreg", "SELECT user_id FROM vrp_user_identities WHERE registration = @registration")
vRP.prepare("vRP/get_userbyphone", "SELECT user_id FROM vrp_user_identities WHERE phone = @phone")
vRP.prepare("vRP/update_registration", "UPDATE vrp_user_identities SET registration = @registration WHERE user_id = @user_id")
vRP.prepare("vRP/update_user_first_spawn", "UPDATE vrp_user_identities SET firstname = @firstname, name = @name, age = @age WHERE user_id = @user_id")
vRP.prepare("vRP/update_phone", "UPDATE vrp_user_identities SET phone = @phone WHERE user_id = @user_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_vehicle_data", "SELECT * FROM vrp_vehicles WHERE spawn = @spawn")
vRP.prepare("vRP/get_vehicle_hash", "SELECT * FROM vrp_vehicles WHERE hash = @hash")
vRP.prepare("vRP/get_all_vehicles", "SELECT * FROM vrp_vehicles")
vRP.prepare("vRP/set_stock", "UPDATE vrp_vehicles SET stock = @stock WHERE spawn = @spawn")
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEY
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/money_init_user", "INSERT IGNORE INTO vrp_user_moneys(user_id,wallet,bank,paypal) VALUES(@user_id,@wallet,@bank,@paypal)")
vRP.prepare("vRP/get_money", "SELECT wallet,bank,paypal FROM vrp_user_moneys WHERE user_id = @user_id")
vRP.prepare("vRP/set_money", "UPDATE vrp_user_moneys SET wallet = @wallet, bank = @bank, paypal = @paypal WHERE user_id = @user_id")
vRP.prepare("vRP/get_coins", "SELECT coins FROM vrp_users WHERE id = @id")
vRP.prepare("vRP/set_coins", "UPDATE vrp_users SET coins = @coins WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/upd_rg_phone", "UPDATE vrp_user_identities SET registration = @registration, phone = @phone WHERE user_id = @user_id")
vRP.prepare("vRP/upd_user_identity", "UPDATE vrp_user_identities SET name = @name, firstname = @firstname, age = @age WHERE user_id = @user_id")
vRP.prepare("vRP/get_allvehicles", "SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP.prepare("vRP/rem_allcars", "DELETE FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP.prepare("vRP/rem_allhouses", "DELETE FROM vrp_homes_permissions WHERE user_id = @user_id")
vRP.prepare("vRP/rem_user_dkey", "DELETE FROM vrp_user_data WHERE dkey = @dkey AND user_id = @user_id")
vRP.prepare("vRP/rem_srv_data", "DELETE FROM vrp_srv_data WHERE dkey LIKE @user_id")
vRP.prepare("vRP/add_priority", "UPDATE vrp_users SET priority = @priority WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- COINS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_vip_time", "SELECT vip_time FROM vrp_users WHERE id = @id")
vRP.prepare("vRP/update_vip_time", "UPDATE vrp_users SET vip_time = @vip_time WHERE id = @id")
vRP.prepare("vRP/get_rental_time", "SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP.prepare("vRP/set_rental_time", "UPDATE vrp_user_vehicles SET rental_time = @rental_time WHERE user_id = @user_id AND vehicle = @vehicle")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_vehicle", "SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP.prepare("vRP/rem_vehicle", "DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vRP/get_vehicles", "SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vRP/update_vehicles", "UPDATE vrp_user_vehicles SET engine = @engine, body = @body, fuel = @fuel WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vRP/set_detido", "UPDATE vrp_user_vehicles SET detido = @detido, time = @time WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vRP/set_ipva", "UPDATE vrp_user_vehicles SET ipva = @ipva WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vRP/move_vehicle", "UPDATE vrp_user_vehicles SET user_id = @nuser_id WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vRP/add_vehicle", "INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle,ipva) VALUES(@user_id,@vehicle,@ipva)")
vRP.prepare("vRP/con_maxvehs", "SELECT COUNT(vehicle) as qtd FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP.prepare("vRP/rem_veh_srv_data", "DELETE FROM vrp_srv_data WHERE dkey = @dkey")
vRP.prepare("vRP/get_users", "SELECT * FROM vrp_users WHERE id = @user_id")
vRP.prepare("vRP/update_garages", "UPDATE vrp_users SET garagem = garagem + 1 WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOMES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_homeuser", "SELECT * FROM vrp_homes_permissions WHERE user_id = @user_id AND home = @home")
vRP.prepare("vRP/get_homeuserid", "SELECT * FROM vrp_homes_permissions WHERE user_id = @user_id")
vRP.prepare("vRP/get_homeuserowner", "SELECT * FROM vrp_homes_permissions WHERE user_id = @user_id AND home = @home AND owner = 1")
vRP.prepare("vRP/get_homeuseridowner", "SELECT * FROM vrp_homes_permissions WHERE home = @home AND owner = 1")
vRP.prepare("vRP/get_homepermissions", "SELECT * FROM vrp_homes_permissions WHERE home = @home")
vRP.prepare("vRP/add_permissions", "INSERT IGNORE INTO vrp_homes_permissions(home,user_id) VALUES(@home,@user_id)")
vRP.prepare("vRP/buy_permissions", "INSERT IGNORE INTO vrp_homes_permissions(home,user_id,owner,tax,garage) VALUES(@home,@user_id,1,@tax,1)")
vRP.prepare("vRP/count_homepermissions", "SELECT COUNT(*) as qtd FROM vrp_homes_permissions WHERE home = @home")
vRP.prepare("vRP/upd_permissions", "UPDATE vrp_homes_permissions SET garage = 1 WHERE home = @home AND user_id = @user_id")
vRP.prepare("vRP/rem_permissions", "DELETE FROM vrp_homes_permissions WHERE home = @home AND user_id = @user_id")
vRP.prepare("vRP/upd_taxhomes", "UPDATE vrp_homes_permissions SET tax = @tax WHERE user_id = @user_id AND home = @home AND owner = 1")
vRP.prepare("vRP/rem_allpermissions", "DELETE FROM vrp_homes_permissions WHERE home = @home")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PETS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_pet_users", "SELECT * FROM vrp_users WHERE id = @id")
vRP.prepare("vRP/update_pets", "UPDATE vrp_users SET pets = NULL WHERE id = @id")
vRP.prepare("vRP/get_pets", "UPDATE vrp_users SET pets = @pets WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_inv", "SELECT itemlist FROM vrp_user_inventory WHERE user_id = @user_id")
vRP.prepare("vRP/update_inv", "UPDATE vrp_user_inventory SET itemlist = @itemlist WHERE user_id = @user_id")
vRP.prepare("vRP/get_max_inv", "SELECT max FROM vrp_user_inventory WHERE user_id = @user_id")
vRP.prepare("vRP/give_max_inv", "UPDATE vrp_user_inventory SET max = @max WHERE user_id = @user_id")
vRP.prepare("vRP/new_inv", "INSERT INTO vrp_user_inventory(user_id,itemlist,max) VALUES(@user_id,@itemlist,@max)")
vRP.prepare("vRP/clear_inv", "UPDATE vrp_user_inventory SET itemlist = @itemlist WHERE user_id = @user_id")