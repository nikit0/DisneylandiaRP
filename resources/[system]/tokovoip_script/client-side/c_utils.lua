local playersData = {};

function setPlayerData(playerServerId, key, data, shared)
	if (not key or data == nil) then return end
	if (not playersData[playerServerId]) then
		playersData[playerServerId] = {};
	end
	playersData[playerServerId][key] = { data = data, shared = shared };
	if (shared) then
		TriggerServerEvent("Tokovoip:setPlayerData",playerServerId,key,data,shared);
	end
end
RegisterNetEvent("Tokovoip:setPlayerData");
AddEventHandler("Tokovoip:setPlayerData",setPlayerData);

function getPlayerData(playerServerId,key)
	if (not playersData[playerServerId] or playersData[playerServerId][key] == nil) then return false; end
	return playersData[playerServerId][key].data;
end

function refreshAllPlayerData(toEveryone)
	TriggerServerEvent("Tokovoip:refreshAllPlayerData",toEveryone);
end
RegisterNetEvent("onClientPlayerReady");
AddEventHandler("onClientPlayerReady",refreshAllPlayerData);

function doRefreshAllPlayerData(serverData)
	for playerServerId, playerData in pairs(serverData) do
		for key, data in pairs(playerData) do
			if (not playersData[playerServerId]) then
				playersData[playerServerId] = {};
			end
			playersData[playerServerId][key] = { data = data, shared = true };
		end
	end
	for playerServerId, playerData in pairs(playersData) do
		for key, data in pairs(playerData) do
			if (not serverData[playerServerId]) then
				playersData[playerServerId] = nil;
			elseif (serverData[playerServerId][key] == nil) then
				playersData[playerServerId][key] = nil;
			end
		end
	end
end
RegisterNetEvent("Tokovoip:doRefreshAllPlayerData");
AddEventHandler("Tokovoip:doRefreshAllPlayerData",doRefreshAllPlayerData);

function table.val_to_str (v)
	if ("string" == type(v)) then
		v = string.gsub(v, "\n", "\\n");
		if (string.match(string.gsub(v, "[^'\"]", ""), '^"+$')) then
			return ("'"..v.."'");
		end
		return ('"'..string.gsub(v, '"', '\\"')..'"');
	else
		return ("table" == type(v) and table.tostring(v) or tostring(v));
	end
end

function table.key_to_str (k)
	if ("string" == type(k) and string.match(k, "^[_%a][_%a%d]*$")) then
		return (k);
	else
		return ("["..table.val_to_str(k).."]");
	end
end

function table.tostring(tbl)
	local result, done = {}, {};
	for k, v in ipairs(tbl) do
		table.insert(result, table.val_to_str(v));
		done[k] = true;
	end
	for k, v in pairs(tbl) do
		if (not done[k]) then
			table.insert(result, table.key_to_str(k).."="..table.val_to_str(v));
		end
	end
	return ("{"..table.concat(result, ",").."}");
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function escape(str)
	return str:gsub( "%W", "");
end