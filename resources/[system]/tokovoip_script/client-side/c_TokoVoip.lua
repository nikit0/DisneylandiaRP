-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
TokoVoip = {};
TokoVoip.__index = TokoVoip;
local lastTalkState = false

function TokoVoip.init(self,config)
	local self = setmetatable(config,TokoVoip);
	self.config = json.decode(json.encode(config));
	self.lastNetworkUpdate = 0;
	self.lastPlayerListUpdate = self.playerListRefreshRate;
	self.playerList = {};
	return (self);
end

function TokoVoip.loop(self)
	Citizen.CreateThread(function()
		while (true) do
			Citizen.Wait(self.refreshRate);
			self:processFunction();
			self:sendDataToTS3();

			self.lastNetworkUpdate = self.lastNetworkUpdate + self.refreshRate;
			self.lastPlayerListUpdate = self.lastPlayerListUpdate + self.refreshRate;
			if (self.lastNetworkUpdate >= self.networkRefreshRate) then
				self.lastNetworkUpdate = 0;
				self:updateTokoVoipInfo();
			end
			if (self.lastPlayerListUpdate >= self.playerListRefreshRate) then
				self.playerList = vRP.getPlayers();
				self.lastPlayerListUpdate = 0;
			end
		end
	end);
end

function TokoVoip.sendDataToTS3(self)
	self:updatePlugin("updateTokoVoip",self.plugin_data);
end

function TokoVoip.updateTokoVoipInfo(self,forceUpdate)
	local info = "";
	if (self.mode == 1) then
		info = "Cochichando";
	elseif (self.mode == 2) then
		info = "Normal";
	elseif (self.mode == 3) then
		info = "Gritando";
	end

	if (self.plugin_data.radioTalking) then
		info = info .. " No Radio ";
	end
	if (self.talking == 1 or self.plugin_data.radioTalking) then
		info = "<font class='talking'>" .. info .. "</font>";
	end
	if (self.plugin_data.radioChannel ~= -1 and self.myChannels[self.plugin_data.radioChannel]) then
		--if (string.match(self.myChannels[self.plugin_data.radioChannel].name, "Call")) then
			--info = info  .. "<br> [Phone] " .. self.myChannels[self.plugin_data.radioChannel].name;
		--else
			info = info  .. "<br> [Radio] " .. self.myChannels[self.plugin_data.radioChannel].name;
		--end
	end
	if (info == self.screenInfo and not forceUpdate) then return end
	self.screenInfo = info;
	self:updatePlugin("updateTokovoipInfo",""..info);
end

function TokoVoip.updatePlugin(self,event,payload)
	exports.tokovoip_script:doSendNuiMessage(event,payload);
end

function TokoVoip.updateConfig(self)
	local data = self.config;
	data.plugin_data = self.plugin_data;
	data.pluginVersion = self.pluginVersion;
	data.pluginStatus = self.pluginStatus;
	data.pluginUUID = self.pluginUUID;
	self:updatePlugin("updateConfig", data);
end

function TokoVoip.initialize(self)
	self:updateConfig();
	self:updatePlugin("initializeSocket", nil);
	Citizen.CreateThread(function()
		while (true) do
			if ((self.keySwitchChannelsSecondary and IsControlPressed(0,self.keySwitchChannelsSecondary)) or not self.keySwitchChannelsSecondary) and IsInputDisabled(0) then
				if (IsControlJustPressed(0,self.keySwitchChannels) and IsInputDisabled(0) and tablelength(self.myChannels) > 0) then
					local myChannels = {};
					local currentChannel = 0;
					local currentChannelID = 0;

					for channel, _ in pairs(self.myChannels) do
						if (channel == self.plugin_data.radioChannel) then
							currentChannel = #myChannels + 1;
							currentChannelID = channel;
						end
						myChannels[#myChannels + 1] = {channelID = channel};
					end
					if (currentChannel == #myChannels) then
						currentChannelID = myChannels[1].channelID;
					else
						currentChannelID = myChannels[currentChannel + 1].channelID;
					end
					self.plugin_data.radioChannel = currentChannelID;
					setPlayerData(self.serverId,"radio:channel",currentChannelID,true);
					self:updateTokoVoipInfo();
				end
			elseif (IsControlJustPressed(0,self.keyProximity)) and IsInputDisabled(0) then
				if (not self.mode) then
					self.mode = 1;
				end
				self.mode = self.mode + 1;
				if (self.mode > 3) then
					self.mode = 1;
				end
				setPlayerData(self.serverId,"voip:mode",self.mode,true);
				self:updateTokoVoipInfo();
			end
			if (IsControlPressed(0, self.radioKey) and self.plugin_data.radioChannel ~= -1) then
				self.plugin_data.radioTalking = true;
				self.plugin_data.localRadioClicks = true;
				if (self.plugin_data.radioChannel > self.config.radioClickMaxChannel) then
					self.plugin_data.localRadioClicks = false;
				end
				if (not getPlayerData(self.serverId, "radio:talking")) then
					setPlayerData(self.serverId, "radio:talking", true, true);
				end
				self:updateTokoVoipInfo();
				if (lastTalkState == false and self.myChannels[self.plugin_data.radioChannel]) then
					--if not string.match(self.myChannels[self.plugin_data.radioChannel].name, "Call") then
						vRP._CarregarObjeto("random@arrests","generic_radio_chatter","prop_cs_hand_radio",49,60309,0.09,0.03,0.02,-70.0,180.0,50.0)
						lastTalkState = true
					--end
				end
			else
				self.plugin_data.radioTalking = false;
				if (getPlayerData(self.serverId,"radio:talking")) then
					setPlayerData(self.serverId,"radio:talking",false,true);
				end
				self:updateTokoVoipInfo();
				if lastTalkState then
					vRP.DeletarObjeto("one")
					lastTalkState = false
				end
			end
			Citizen.Wait(4)
		end
	end);
end

function TokoVoip.disconnect(self)
	self:updatePlugin("disconnect");
end