// ------------------------------------------------------------
// ------------------------------------------------------------
// ---- Author: Dylan 'Itokoyamato' Thuillier              ----
// ----                                                    ----
// ---- Email: itokoyamato@hotmail.fr                      ----
// ----                                                    ----
// ---- Resource: tokovoip_script                          ----
// ----                                                    ----
// ---- File: script.js                                    ----
// ------------------------------------------------------------
// ------------------------------------------------------------

// --------------------------------------------------------------------------------
// --	Using websockets to send data to TS3Plugin via local network
// --------------------------------------------------------------------------------

function getTickCount() {
	let date = new Date();
	let tick = date.getTime();
	return (tick);
}

let websocket;
let connected = false;
let lastPing = 0;
let lastReconnect = 0;
let lastOk = 0;

let voip = {};

const OK = 0;
const NOT_CONNECTED = 1;
const PLUGIN_INITIALIZING = 2;
const WRONG_SERVER = 3;
const WRONG_CHANNEL = 4;
const INCORRECT_VERSION = 5;

function init() {
	// console.log('TokoVOIP: Nova Conexão');
	websocket = new WebSocket('ws://127.0.0.1:38204/tokovoip');

	websocket.onopen = () => {
		// console.log('TokoVOIP: Conexão Aberta');
		connected = true;
		lastPing = getTickCount();
	};

	websocket.onmessage = (evt) => {
		// Handle plugin status
		if (evt.data.includes('TokoVOIP status:')) {
			connected = true;
			lastPing = getTickCount();
			forcedInfo = false;
			const pluginStatus = evt.data.split(':')[1].replace(/\./g, '');
			updateScriptData('pluginStatus', parseInt(pluginStatus));
		}

		// Handle plugin version
		if (evt.data.includes('TokoVOIP version:')) {
			updateScriptData('pluginVersion', evt.data.split(':')[1]);
		}

		// Handle plugin UUID
		if (evt.data.includes('TokoVOIP UUID:')) {
			updateScriptData('pluginUUID', evt.data.split(':')[1]);
		}

		// Handle talking states
		if (evt.data == 'startedtalking') {
			$.post('http://tokovoip_script/setPlayerTalking', JSON.stringify({state: 1}));
		}
		if (evt.data == 'stoppedtalking') {
			$.post('http://tokovoip_script/setPlayerTalking', JSON.stringify({state: 0}));
		}
	};

	/*websocket.onerror = (evt) => {
		console.log('TokoVOIP: Erro - ' + evt.data);
	};*/

	websocket.onclose = () => {
		sendData('disconnect');

		let reason;
		if (event.code == 1000)
		    reason = 'Fechamento normal, significando que o objetivo para o qual a conexão foi estabelecida foi cumprido.';
		else if(event.code == 1001)
		    reason = 'Um ponto de extremidade está \'indo embora\', como um servidor inoperante ou um navegador que saiu da página.';
		else if(event.code == 1002)
		    reason = 'Um terminal está finalizando a conexão devido a um erro de protocolo';
		else if(event.code == 1003)
		    reason = 'Um terminal está encerrando a conexão porque recebeu um tipo de dados que não pode aceitar (por exemplo, um terminal que entende apenas dados de texto PODE enviar isso se receber uma mensagem binária).';
		else if(event.code == 1004)
		    reason = 'Reservado. O significado específico pode ser definido no futuro.';
		else if(event.code == 1005)
		    reason = 'Nenhum código de status estava realmente presente.';
		else if(event.code == 1006)
		   reason = 'A conexão foi fechada de forma anormal, por exemplo, sem enviar ou receber um quadro de controle Fechar';
		else if(event.code == 1007)
		    reason = 'Um terminal está finalizando a conexão porque recebeu dados em uma mensagem que não era consistente com o tipo da mensagem (por exemplo, dados não UTF-8 [http://tools.ietf.org/html/rfc3629] em um mensagem de texto).';
		else if(event.code == 1008)
		    reason = 'Um terminal está finalizando a conexão porque recebeu uma mensagem que \'viola sua política\'. Esse motivo é fornecido se não houver outro motivo sutível ou se houver necessidade de ocultar detalhes específicos sobre a política.';
		else if(event.code == 1009)
		   reason = 'Um terminal está finalizando a conexão porque recebeu uma mensagem muito grande para ser processada.';
		else if(event.code == 1010) // Note that this status code is not used by the server, because it can fail the WebSocket handshake instead.
		    reason = 'Um terminal (cliente) está encerrando a conexão porque esperava que o servidor negociasse uma ou mais extensões, mas o servidor não as retornou na mensagem de resposta do handshake do WebSocket. <br /> Especificamente, as extensões necessárias são: ' + event.reason;
		else if(event.code == 1011)
		    reason = 'Um servidor está encerrando a conexão porque encontrou uma condição inesperada que o impediu de atender à solicitação.';
		else if(event.code == 1015)
		    reason = 'A conexão foi fechada devido a uma falha na execução de um handshake TLS (por exemplo, o certificado do servidor não pode ser verificado).';
		else
			reason = 'Razão desconhecida';

		// console.log('TokoVOIP: Conexão Fechada - ' + reason);
		lastReconnect = getTickCount();
		connected = false;
		updateScriptData('pluginStatus', -1);
		init();
	};
}

function sendData(message) {
	if (websocket.readyState == websocket.OPEN) {
		websocket.send(message);
	}
}

function receivedClientCall(event) {
	const eventName = event.data.type;
	const payload = event.data.payload;

	// Start with a status OK by default, and change the status if issues are encountered
	voipStatus = OK;

	if (eventName == 'updateConfig') {
		updateConfig(payload);

	} else if (voip) {
		if (eventName == 'initializeSocket') {
			lastPing = getTickCount();
			lastReconnect = getTickCount();
			init();
	
		} else if (eventName == 'updateTokovoipInfo') {
			if (connected)
				updateTokovoipInfo(payload, 1);
	
		} else if (eventName == 'updateTokoVoip') {
			voip.plugin_data = payload;
			updatePlugin();
	
		} else if (eventName == 'disconnect') {
			sendData('disconnect');
			voipStatus = NOT_CONNECTED;
		}
	}

	checkPluginStatus();
	if (voipStatus != NOT_CONNECTED)
		checkPluginVersion();

	if (voipStatus != OK) {
		// Se não houver status Ok por mais de 5 segundos, a tela mostrará
		if (getTickCount() - lastOk > 5000) {
			displayPluginScreen(true);
		}
	} else {
		lastOk = getTickCount();
		displayPluginScreen(false);
	}

	updateTokovoipInfo();
}

function checkPluginStatus() {
	switch (parseInt(voip.pluginStatus)) {
		case -1:
			voipStatus = NOT_CONNECTED;
			break;
		case 0:
			voipStatus = PLUGIN_INITIALIZING;
			break;
		case 1:
			voipStatus = WRONG_SERVER;
			break;
		case 2:
			voipStatus = WRONG_CHANNEL;
			break;
		case 3:
			voipStatus = OK;
			break;
	}
	if (getTickCount() - lastPing > 5000)
		voipStatus = NOT_CONNECTED;
}

function checkPluginVersion() {
	if (isPluginVersionCorrect()) {
		document.getElementById('pluginVersion').innerHTML = `Versão do Plugin: <font color="green">${voip.pluginVersion}</font> (atualizado)`;
	} else {
		document.getElementById('pluginVersion').innerHTML = `Versão do Plugin: <font color="red">${voip.pluginVersion}</font> (Requerido: ${voip.minVersion})`;
		voipStatus = INCORRECT_VERSION;
	}
}

function isPluginVersionCorrect() {
	if (parseInt(voip.pluginVersion.replace(/\./g, '')) < parseInt(voip.minVersion.replace(/\./g, ''))) return false;
	return true;
}

function displayPluginScreen(toggle) {
	document.getElementById('pluginScreen').style.display = (toggle) ? 'block' : 'none';
}

function updateTokovoipInfo(msg) {
	document.getElementById('tokovoipInfo').style.fontSize = '12px';
	let screenMessage;

	switch (voipStatus) {
		case NOT_CONNECTED:
			msg = 'OFFLINE';
			color = 'red';
			break;
		case PLUGIN_INITIALIZING:
			msg = 'Inicializando';
			color = 'red';
			break;
		case WRONG_SERVER:
			msg = `Conectado em um servidor errado no TeamSpeak, por favor entre no server: <font color="#01b0f0">${voip.plugin_data.TSServer}</font>`;
			screenMessage = 'Servidor TeamSpeak Incorreto';
			color = 'red';
			break;
		case WRONG_CHANNEL:
			msg = `Conectado ao canal TeamSpeak errado, entre no canal: <font color="#01b0f0">${voip.plugin_data.TSChannelWait && voip.plugin_data.TSChannelWait !== '' && voip.plugin_data.TSChannelWait || voip.plugin_data.TSChannel}</font>`;
			screenMessage = 'Canal errado no TeamSpeak';
			color = 'red';
			break;
		case INCORRECT_VERSION:
			msg = 'Usando a versão incorreta do plug-in';
			screenMessage = 'Versão incorreta do plugin';
			color = 'red';
			break;
		case OK:
			color = '#01b0f0';
			break;
	}
		if (msg) {
			document.getElementById('tokovoipInfo').innerHTML = `<font color="${color}">[TokoVoip] ${msg}</font>`;
		}
	document.getElementById('pluginStatus').innerHTML = `Plugin status: <font color="${color}">${screenMessage || msg}</font>`;
}

function updateConfig(payload) {
	voip = payload;
	document.getElementById('TSServer').innerHTML = `Server no TeamSpeak : <font color="#01b0f0">${voip.plugin_data.TSServer}</font>`;
	document.getElementById('TSChannel').innerHTML = `Canal no TeamSpeak: <font color="#01b0f0">${(voip.plugin_data.TSChannelWait) ? voip.plugin_data.TSChannelWait : voip.plugin_data.TSChannel}</font>`;
	/*document.getElementById('TSDownload').innerHTML = voip.plugin_data.TSDownload;
	document.getElementById('TSChannelSupport').innerHTML = voip.plugin_data.TSChannelSupport;*/
}

function updatePlugin() {
	const timeout = getTickCount() - lastPing;
	const lastRetry = getTickCount() - lastReconnect;
	if (timeout >= 10000 && lastRetry >= 5000) {
		// console.log('TokoVOIP: Tempo Esgotado - ' + (timeout) + ' - ' + (lastRetry));
		lastReconnect = getTickCount();
		connected = false;
		updateScriptData('pluginStatus', -1);
		init();
	} else if (connected) {
		sendData(JSON.stringify(voip.plugin_data));
	}
}

function updateScriptData(key, data) {
	if (voip[key] === data) return;
	$.post(`http://tokovoip_script/updatePluginData`, JSON.stringify({
		payload: {
			key,
			data,
		}
	}));
}

window.addEventListener('message', receivedClientCall, false);
