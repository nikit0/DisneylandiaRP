-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local targetPed;
local useLocalPed = true;
local isRunning = false;
local scriptVersion = "1.3.4";
local animStates = {}
local displayingPluginScreen = false;
local HeadBone = 0x796e;
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
local function setPlayerTalkingState(player,playerServerId)
	if player ~= -1 then
		local talking = tonumber(getPlayerData(playerServerId,"voip:talking"));
		if (animStates[playerServerId] == 0 and talking == 1) then
			PlayFacialAnim(GetPlayerPed(player),"mic_chatter","mp_facial");
		elseif (animStates[playerServerId] == 1 and talking == 0) then
			PlayFacialAnim(GetPlayerPed(player),"mood_normal_1","facials@gen_male@base");
		end
		animStates[playerServerId] = talking;
	end
end

RegisterNUICallback("updatePluginData",function(data)
	local payload = data.payload;
	if (voip[payload.key] == payload.data) then return end
	voip[payload.key] = payload.data;
	setPlayerData(voip.serverId,"voip:"..payload.key,voip[payload.key],true);
	voip:updateConfig();
	voip:updateTokoVoipInfo(true);
end);

RegisterNUICallback("setPlayerTalking",function(data)
	voip.talking = tonumber(data.state);
	if (voip.talking == 1) then
		setPlayerData(voip.serverId,"voip:talking",1,true);
		PlayFacialAnim(GetPlayerPed(PlayerId()),"mic_chatter","mp_facial");
	else
		setPlayerData(voip.serverId,"voip:talking",0,true);
		PlayFacialAnim(PlayerPedId(),"mood_normal_1","facials@gen_male@base");
	end
end)

local function clientProcessing()
	local playerList = voip.playerList;
	local usersdata = {};
	local localHeading;
	local ped = PlayerPedId()

	if (voip.headingType == 1) then
		localHeading = math.rad(GetEntityHeading(ped));
	else
		localHeading = math.rad(GetGameplayCamRot().z%360);
	end

	local localPos;

	if useLocalPed then
		localPos = GetPedBoneCoords(ped,HeadBone);
	else
		localPos = GetPedBoneCoords(targetPed,HeadBone);
	end

	for k,v in pairs(playerList) do
		local player = GetPlayerFromServerId(k);
		local playerServerId = k;
		if (GetPlayerPed(player) and voip.serverId ~= playerServerId) then
			local playerPos = GetPedBoneCoords(GetPlayerPed(player),HeadBone);
			local dist = #(localPos - playerPos);

			if (not getPlayerData(playerServerId,"voip:mode")) then
				setPlayerData(playerServerId,"voip:mode", 1);
			end

			local mode = tonumber(getPlayerData(playerServerId,"voip:mode"));
			if (not mode or (mode ~= 1 and mode ~= 2 and mode ~= 3)) then mode = 1 end;
			local volume = -30 + (30 - dist / voip.distance[mode] * 30);
			if (volume >= 0) then
				volume = 0;
			end

			local angleToTarget = localHeading - math.atan(playerPos.y - localPos.y, playerPos.x - localPos.x);

			local tbl = { uuid = getPlayerData(playerServerId,"voip:pluginUUID"), volume = -30, muted = 1, radioEffect = false, posX = voip.plugin_data.enableStereoAudio and math.cos(angleToTarget) * dist or 0, posY = voip.plugin_data.enableStereoAudio and math.sin(angleToTarget) * dist or 0, posZ = voip.plugin_data.enableStereoAudio and playerPos.z or 0 };

			if GetEntityHealth(ped) > 101 then
                if (dist >= voip.distance[mode] or player == -1) then
					tbl.muted = 1;
				else
					tbl.volume = volume;
					tbl.muted = 0;
				end
            else
                tbl.muted = 1;
            end

			local remotePlayerUsingRadio = getPlayerData(playerServerId,"radio:talking");
			local remotePlayerChannel = getPlayerData(playerServerId,"radio:channel");

			for _, channel in pairs(voip.myChannels) do
				if (channel.subscribers[voip.serverId] and channel.subscribers[playerServerId] and voip.myChannels[remotePlayerChannel] and remotePlayerUsingRadio) then
					if (remotePlayerChannel <= voip.config.radioClickMaxChannel) then
						tbl.radioEffect = true;
					end
					tbl.volume = 0;
					tbl.muted = 0;
					tbl.posX = 0;
					tbl.posY = 0;
					tbl.posZ = voip.plugin_data.enableStereoAudio and localPos.z or 0;
				end
			end

			usersdata[#usersdata + 1] = tbl
			setPlayerTalkingState(player, playerServerId);
		end
	end
	voip.plugin_data.Users = usersdata;
	voip.plugin_data.posX = 0;
	voip.plugin_data.posY = 0;
	voip.plugin_data.posZ = voip.plugin_data.enableStereoAudio and localPos.z or 0;
end

RegisterNetEvent("initializeVoip");
AddEventHandler("initializeVoip",function()
	isRunning = true;
	voip = TokoVoip:init(TokoVoipConfig);
	voip.plugin_data.Users = {};
	voip.plugin_data.radioTalking = false;
	voip.plugin_data.radioChannel = -1;
	voip.plugin_data.localRadioClicks = false;
	voip.mode = 2;
	voip.talking = false;
	voip.pluginStatus = -1;
	voip.pluginVersion = "0";
	voip.serverId = GetPlayerServerId(PlayerId());
	voip.myChannels = {};

	setPlayerData(voip.serverId,"voip:mode",voip.mode,true);
	setPlayerData(voip.serverId,"voip:talking",voip.talking,true);
	setPlayerData(voip.serverId,"radio:channel",voip.plugin_data.radioChannel,true);
	setPlayerData(voip.serverId,"radio:talking",voip.plugin_data.radioTalking,true);
	setPlayerData(voip.serverId,"voip:pluginStatus",voip.pluginStatus,true);
	setPlayerData(voip.serverId,"voip:pluginVersion",voip.pluginVersion,true);
	refreshAllPlayerData();

	targetPed = PlayerPedId();
	voip.processFunction = clientProcessing;
	voip:initialize();
	voip:loop();

	RequestAnimDict("mp_facial");
	while not HasAnimDictLoaded("mp_facial") do
		RequestAnimDict("mp_facial");
		Citizen.Wait(10);
	end

	RequestAnimDict("facials@gen_male@base");
	while not HasAnimDictLoaded("facials@gen_male@base") do
		RequestAnimDict("facials@gen_male@base");
		Citizen.Wait(10);
	end
end)

function addPlayerToRadio(channel)
	TriggerServerEvent("TokoVoip:addPlayerToRadio",channel,voip.serverId);
end
RegisterNetEvent("TokoVoip:addPlayerToRadio");
AddEventHandler("TokoVoip:addPlayerToRadio",addPlayerToRadio);

function removePlayerFromRadio(channel)
	TriggerServerEvent("TokoVoip:removePlayerFromRadio",channel,voip.serverId);
end
RegisterNetEvent("TokoVoip:removePlayerFromRadio");
AddEventHandler("TokoVoip:removePlayerFromRadio",removePlayerFromRadio);

RegisterNetEvent("TokoVoip:onPlayerLeaveChannel");
AddEventHandler("TokoVoip:onPlayerLeaveChannel",function(channelId,playerServerId)
	if (playerServerId == voip.serverId and voip.myChannels[channelId]) then
		local previousChannel = voip.plugin_data.radioChannel;
		voip.myChannels[channelId] = nil;
		if (voip.plugin_data.radioChannel == channelId) then
			if (tablelength(voip.myChannels) > 0) then
				for channelId,_ in pairs(voip.myChannels) do
					voip.plugin_data.radioChannel = channelId;
					break;
				end
			else
				voip.plugin_data.radioChannel = -1;
			end
		end

		if (previousChannel ~= voip.plugin_data.radioChannel) then
			setPlayerData(voip.serverId,"radio:channel",voip.plugin_data.radioChannel,true);
		end
	elseif (voip.myChannels[channelId]) then
		voip.myChannels[channelId].subscribers[playerServerId] = nil;
	end
end)

RegisterNetEvent("TokoVoip:onPlayerJoinChannel");
AddEventHandler("TokoVoip:onPlayerJoinChannel",function(channelId,playerServerId,channelData)
	if (playerServerId == voip.serverId and channelData) then
		local previousChannel = voip.plugin_data.radioChannel;

		voip.plugin_data.radioChannel = channelData.id;
		voip.myChannels[channelData.id] = channelData;

		if (previousChannel ~= voip.plugin_data.radioChannel) then
			setPlayerData(voip.serverId,"radio:channel",voip.plugin_data.radioChannel,true);
		end
	elseif (voip.myChannels[channelId]) then
		voip.myChannels[channelId].subscribers[playerServerId] = playerServerId;
	end
end)

function isPlayerInChannel(channel)
	if (voip.myChannels[channel]) then
		return true;
	else
		return false;
	end
end

function displayPluginScreen(toggle)
	if (displayingPluginScreen ~= toggle) then
		SendNUIMessage({ type = "displayPluginScreen", data = toggle });
		displayingPluginScreen = toggle;
	end
end

AddEventHandler("updateVoipTargetPed",function(newTargetPed,useLocal)
	targetPed = newTargetPed
	useLocalPed = useLocal
end)