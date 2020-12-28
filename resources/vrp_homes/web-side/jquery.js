let blockAction = false

$(document).ready(function(){
	let actionContainer = $("#actionmenu");

	$('#amount').focus(function() {
		$(this).val('');
	  }).blur(function() {
		if ($(this).val() == '') {
		  $(this).val('1');
		}
	  });

	window.addEventListener("message",function(event){
		let item = event.data;
		switch(item.action){
			case "showMenu":
				updateVault();
				actionContainer.fadeIn(500);
			break;

			case "hideMenu":
				actionContainer.fadeOut(500);
			break;

			case "updateVault":
				updateVault();
			break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://vrp_homes/chestClose");
		}
	};
});

const updateDrag = () => {
  
	$('.item').draggable({
	  helper: 'clone',
	  appendTo: 'body',
	  zIndex: 99999,
	  revert: 'invalid',
	  opacity: 0.5,
	  start: function(event, ui) {
		  $(this).children().children('img').hide();
		  itemData = $(this).data('item-key')
		  
		  if (itemData === undefined) return;
  
		  let $el = $(this);
		  $el.addClass("active");
	  },
	  stop: function() {
		  $(this).children().children('img').show();
  
		  let $el = $(this);
		  $el.removeClass("active");
	  }
	})
  
	$('.item2').draggable({
	  helper: 'clone',
	  appendTo: 'body',
	  zIndex: 99999,
	  revert: 'invalid',
	  opacity: 0.5,
	  start: function(event, ui) {
		  $(this).children().children('img').hide();
		  itemData = $(this).data('item-key')
  
		  if (itemData === undefined) return;
  
  
		  let $el = $(this);
		  $el.addClass("active");
	  },
	  stop: function() {
		  $(this).children().children('img').show();
  
		  let $el = $(this);
		  $el.removeClass("active");
	  }
	})
  
	$('.direita').droppable({
	  hoverClass: 'hoverControl',
	  accept: '.item',
	  drop: function(event, ui) {
		itemData = ui.draggable.data('item-key')
		  
		  if (itemData === undefined) return
		  
		  let amount = Number($("#amount").val());
		  if (amount > 0) {
			if (!blockAction) {
				blockAction = true;
				$.post("http://vrp_homes/storeItem",
				  JSON.stringify({ item: itemData,amount }),
				  data => {blockAction = false;
				  });
			  }
		  } else {
			if (!blockAction) {
				blockAction = true;
				$.post("http://vrp_homes/storeItem",
				  JSON.stringify({ item: itemData }),
				  data => {blockAction = false;
				  });
			  }
		  }
	  }
	})
  
	$('.esquerda').droppable({
	  hoverClass: 'hoverControl',
	  accept: '.item2',
	  drop: function(event, ui) {
		  itemData = ui.draggable.data('item-key')
		  
		  if (itemData === undefined) return
		  
		  let amount = Number($("#amount").val());
  
		  if (amount > 0) {
			if (!blockAction) {
				blockAction = true;
				$.post("http://vrp_homes/takeItem",
				  JSON.stringify({ item: itemData,amount }),
				  data => {blockAction = false;
				  });
			  }
		  } else {
			if (!blockAction) {
				blockAction = true;
				$.post("http://vrp_homes/takeItem",
				  JSON.stringify({ item: itemData }),
				  data => {blockAction = false;
				  });
			  }
		  }
	  }
	})
	
  }

const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}

const updateVault = () => {
	$.post("http://vrp_homes/requestVault",JSON.stringify({}),(data) => {
		const nameList = data.inventario.sort((a,b) => (a.name > b.name) ? 1: -1);
	    const nameList2 = data.inventario2.sort((a,b) => (a.name > b.name) ? 1: -1);
	    $('#inventory').html(`
	      <div class="peso"><span class="texto"><b>OCUPADO:</b>  ${(data.peso).toFixed(2)}    <s>|</s>    <b>DISPONÍVEL:</b>  ${(data.maxpeso-data.peso).toFixed(2)}    <s>|</s>    <b>TAMANHO:</b>  ${(data.maxpeso).toFixed(2)}</span></div>
	      <div class="peso2"><span class="texto2"><b>OCUPADO:</b>  ${(data.peso2).toFixed(2)}    <s>|</s>    <b>DISPONÍVEL:</b>  ${(data.maxpeso2-data.peso2).toFixed(2)}    <s>|</s>    <b>TAMANHO:</b>  ${(data.maxpeso2).toFixed(2)}</span></div>
	      <div class="esquerda">
	        ${nameList2.map((item) => (`
			  <div class="item" data-item-key="${item.key}">
			  	<div id="image"><img src="nui://vrp_inventory/web-side/images/${item.index}.png" width="118" height="110"></div>
	            <div id="peso">${(item.peso * item.amount).toFixed(2)}</div>
	            <div id="quantity">${formatarNumero(item.amount)}x</div>
	            <div id="itemname">${item.name}</div>
	          </div>
	        `)).join('')}
	      </div>

	      <div class="meio">
	        <input id="amount" class="qtd" maxlength="9" spellcheck="false" value="" placeholder="QUANTIDADE">
	      </div>

	      <div class="direita">
	        ${nameList.map((item) => (`
			  <div class="item2" data-item-key="${item.key}">
			  	<div id="image"><img src="nui://vrp_inventory/web-side/images/${item.index}.png" width="118" height="110"></div>
	            <div id="peso">${(item.peso * item.amount).toFixed(2)}</div>
	            <div id="quantity">${formatarNumero(item.amount)}x</div>
	            <div id="itemname">${item.name}</div>
	          </div>
	        `)).join('')}
	      </div>
		`);
		updateDrag()
  	});
}