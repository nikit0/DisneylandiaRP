TokoVoipConfig = {
	refreshRate = 500,
	networkRefreshRate = 2000,
	playerListRefreshRate = 5000,
	minVersion = "1.2.4",
	distance = { 5,10,40, },
	headingType = 1,
	radioKey = 137,
	keySwitchChannels = 212,
	keySwitchChannelsSecondary = 118,
	keyProximity = 212,
	radioClickMaxChannel = 1000,
	plugin_data = {
		TSChannel = "CONECTADO DL RP",
		TSPassword = "8600015f78ef142d69d1dc0e6be2aeff75568c75",
		TSChannelWait = "AGUARDANDO",
		TSServer = "dlgames.com.br",
		TSChannelSupport = "",
		TSDownload = "",
		TSChannelWhitelist = { "Suporte 1","Suporte 2", },
		local_click_on = true,
		local_click_off = true,
		remote_click_on = false,
		remote_click_off = true,
		enableStereoAudio = false,
		localName = "",
		localNamePrefix = "["..GetPlayerServerId(PlayerId()).."]",
	}
}

AddEventHandler("onClientResourceStart", function(resource)
	if (resource == GetCurrentResourceName()) then
		Citizen.CreateThread(function()
			TokoVoipConfig.plugin_data.localName = escape("DLRP")
		end)
		TriggerEvent("initializeVoip")
	end
end)