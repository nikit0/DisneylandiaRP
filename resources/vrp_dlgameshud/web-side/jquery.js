$(document).ready(function(){
	window.addEventListener("message",function(event){
		if (event.data.active == true){
			$("#backgroundbar").html("<div id=\"vida\"><div id=\"vida2\" style=\"width: "+event.data.vida+"%;\"></div></div><div id=\"colete\"><div id=\"colete2\" style=\"width: "+event.data.colete+"%;\"></div></div>").show();
			if (event.data.car == true){
				$("#voiceoutcar").html("").hide();
				$("#topbarra").html("<span style=\"float: left; margin-left: 10px;\">"+event.data.mes+", "+event.data.dia+event.data.vdia+" "+event.data.hora+":"+event.data.minuto+"</span>"+event.data.mph+" MPH <span style=\"float: left; margin-left: 20px; color: rgba(255,100,100,0.7);\">"+event.data.compass+"</span> <span class=\"color"+event.data.belt+"\" style=\"float: right; margin-right: 10px;\">Seatbelt</span>").show();
				$("#gasolina").html("<div id=\"gasolina2\" style=\"height: "+event.data.gasolina+"%; max-height: 192px;\"></div><b>E</b><s>F</s><line></line><line2></line2><line3></line3>").show();
				$("#rpm").html("<line1></line1><line2></line2><line3></line3><line4></line4><line5></line5><line6></line6><line7></line7><line8></line8><line9></line9><line11>1</line11><line22>2</line22><line33>3</line33><line44>4</line44><line55>5</line55><line66>6</line66><line77>7</line77><line88>8</line88><line99>9</line99><div id=\"rpm2\" style=\"margin-bottom: "+event.data.rpm+"%;\"></div>").show();
				$("#street").html(event.data.street).show();
				/*if (event.data.voice == 1){
					$("#voicecar").html("<b>Range:</b> Normal").show();
				} else if (event.data.voice == 2){
					$("#voicecar").html("<b>Range:</b> Whispering").show();
				} else if (event.data.voice == 3){
					$("#voicecar").html("<b>Range:</b> Shouting").show();
				}*/
			} else {
				$("#topbarra").html("").hide();
				$("#gasolina").html("").hide();
				$("#rpm").html("").hide();
				$("#voicecar").html("").hide();
				$("#street").html("").hide();
				if (event.data.voice == 1){
					$("#voiceoutcar").html(""+event.data.mes+", "+event.data.dia+event.data.vdia+" "+event.data.hora+":"+event.data.minuto).show();
				} /*else if (event.data.voice == 2){
					$("#voiceoutcar").html("<b>Range:</b> Whispering <s>|</s> "+event.data.mes+", "+event.data.dia+event.data.vdia+" "+event.data.hora+":"+event.data.minuto).show();
				} else if (event.data.voice == 3){
					$("#voiceoutcar").html("<b>Range:</b> Shouting <s>|</s> "+event.data.mes+", "+event.data.dia+event.data.vdia+" "+event.data.hora+":"+event.data.minuto).show();
				}*/
			}
		} else {
			$("#backgroundbar").html("").hide();
			$("#voiceoutcar").html("").hide();
			$("#topbarra").html("").hide();
			$("#gasolina").html("").hide();
			$("#rpm").html("").hide();
			$("#voicecar").html("").hide();
			$("#street").html("").hide();
		}
	})
});