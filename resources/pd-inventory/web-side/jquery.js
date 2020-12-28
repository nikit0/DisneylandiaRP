let secondary = 'drop'
let disabled = false
let disabledFunction = null
let slots = 50
let slots2 = 100
let inv = []
let secInv = []

$(() => {
    $('#count')
        .focus(function() {
            $(this).val('')
        })
        .blur(function() {
            if ($(this).val() == '') {
                $(this).val('1')
            }
        })

    $('#use').droppable({
        hoverClass: 'hoverControl',
        accept: '.item',
        drop: function(event, ui) {
            itemData = ui.draggable.data('item')

            if (itemData == undefined) return

            //console.log('use')
            disableInventory(500)
            $.post('http://pd-inventory/UseItem',
                JSON.stringify({
                    number: parseInt($('#count').val()),
                    data: itemData
                })
            )
        }
    })

    $('#send').droppable({
        hoverClass: 'hoverControl',
        accept: '.item',
        drop: function(event, ui) {
            itemData = ui.draggable.data('item')

            if (itemData == undefined) return

            //console.log('send')
            disableInventory(500)
            $.post('http://pd-inventory/SendItem',
                JSON.stringify({
                    number: parseInt($('#count').val()),
                    data: itemData
                })
            )
        }
    })

    document.onkeyup = data => {
        if (data.which == 27) {
            $.post('http://pd-inventory/NUIFocusOff')
        }
    }

    window.addEventListener('message', event => {
        if (event.data.action === 'display') {
            $('.ui').fadeIn()
            secondary = event.data.type
            //console.log(secondary)
        } else if (event.data.action === 'setItems') {
            inv = event.data.itemList
            setupInventory(inv)
            updateDrag()
        } else if (event.data.action === 'hide') {
            $('.ui').fadeOut()
            inv = []
            secInv = []
            $('#playerInventory').html('')
            $('#otherInventory').html('')
        } else if (event.data.action === 'setSecondItems') {
            secInv = event.data.itemSList
            setupSecondInventory(secInv)
            updateDrag()
        } else if (event.data.action === 'setText') {
            $('#ply-id strong').html(event.data.text)
            if (event.data.max != undefined){
                $('#ply-id span').html(event.data.weight.toFixed(1) + 'kg / ' + event.data.max.toFixed(1) + 'kg')
            }
        } else if (event.data.action === 'setIdentity') {
            $('#info-identity').html('<b>Nome:</b> '+event.data.name+' '+event.data.firstname+' #'+event.data.id+' <b>Idade:</b> '+event.data.age+' <b>RG:</b> '+event.data.reg+' <b>Cel:</b> '+event.data.phone+' <br><b>Carteira:</b> $'+event.data.cash+' <b>Banco:</b> $'+event.data.bank+' <b>Paypal:</b> $'+event.data.paypal+' <b>Multas:</b> $'+event.data.tax+' <br><b>Emprego:</b> '+event.data.job+' <br><b>VIP:</b> '+event.data.vipName+' <b>Tempo:</b> '+event.data.vipTime+ ' <br><b>Coins:</b> '+event.data.coins)
        } else if (event.data.action === 'setSecondText') {
            // //console.log(event.data.text)
            $('#second-id strong').html(event.data.text)
            // $('#second-id span').html(event.data.weight.toFixed(1))
            var str = event.data.text
            if ( str.substring(0, str.indexOf("-")) != "drop" ){
                if (event.data.max != undefined){
                    $('#second-id span').html(event.data.weight.toFixed(1) + 'kg / ' + event.data.max.toFixed(1) + 'kg')
                }
            }
        }
    })
})

const setupInventory = data => {
    $('#playerInventory').html('')
    $('#description').hide()

    for (let i = 1; i <= slots; i++) {
        $('#playerInventory').append(
            '<div class="slot" id="slot-' + i + '"><div class="item-name"></div></div>'
        )
    }

    const list = JSON.parse(data).sort((a,b) => (a.item > b.item) ? 1 : -1)
    $.each(list, (k, v) => {
        let icon = v.icon === undefined ? 'noicon.png' : v.icon
        let name = v.item
        let label = v.name
        let amount = formatNumber(v.amount)
        let weight = v.weight
        let descript = v.desc
        let slot = k+1

        // //console.log('[' + slot + '] Loaded ' + name + ' times ' + amount + '(' + weight + ') ')
        
        $('#slot-' + slot).html(
            "<div class='item' id='item-" +
                slot +
                "' style ='background-image: url(images/" +
                icon +
                ")'><div class='item-count'>" +
                amount +
                ' (' +
                weight.toFixed(1) +
                "kg)</div> <div class='item-name'>" +
                label +
                "</div> <div class='item-name-bg'></div></div>"
        )

        $('#item-' + slot).data('item', v)
        $('#item-' + slot).hover(
            () => {
                $('#description').hide()
                $('#name').html(label)

                if (descript != undefined) {
                    $('#desc').show()
                    $('#desc').html(descript)
                } else {
                    $('#desc').hide()
                }

                $('#weight').html('<strong>Peso</strong>: ' + weight.toFixed(1) + 'kg')
                $('#amount').html('<strong>Quantidade</strong>: ' + amount)
                $('#description').fadeIn(300)
            },
            () => {
                $('#description').hide()
            }
        )
    })
}

const setupSecondInventory = data => {
    $('#otherInventory').html('')
    $('#description').hide()

    for (let i = 1; i <= slots2; i++) {
        $('#otherInventory').append(
            '<div class="slotOther" id="slotOther-' + i + '"><div class="item-name"></div></div>'
        )
    }

    const list = JSON.parse(data).sort((a,b) => (a.item > b.item) ? 1 : -1)
    $.each(list, (k, v) => {
        let icon = v.icon === undefined ? 'noicon.png' : v.icon
        let name = v.item
        let label = v.name
        let amount = formatNumber(v.amount)
        let weight = v.weight
        let descript = v.desc
        let slot = k+1

        // //console.log('[' + slot + '] Loaded Secondary ' + name + ' times ' + amount + '(' + weight + ') ')

        $('#slotOther-' + slot).html(
            "<div class='itemOther' id='itemOther-" +
                slot +
                "' style ='background-image: url(images/" +
                icon +
                ")'><div class='item-count'>" +
                amount +
                ' (' +
                weight.toFixed(1) +
                "kg)</div> <div class='item-name'>" +
                label +
                "</div> <div class='item-name-bg'></div></div>"
        )
            
        $('#itemOther-' + slot).data('item', v)
        $('#itemOther-' + slot).hover(
            () => {
                $('#description').hide()
                $('#name').html(label)

                if (descript != undefined) {
                    $('#desc').show()
                    $('#desc').html(descript)
                } else {
                    $('#desc').hide()
                }
                
                $('#weight').html('<strong>Peso</strong>: ' + weight.toFixed(1) + 'kg')
                $('#amount').html('<strong>Quantidade</strong>: ' + amount)
                $('#description').fadeIn(300)
            },
            () => {
                $('#description').hide()
            }
        )
    })
}

const updateDrag = () => {
    $('.item').draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        revert: 'invalid',
        opacity: 0.5,
        start: function(event, ui) {
            if (disabled) {
                return false
            }

            $(this).css('background-image', 'none')
            itemData = $(this).data('item')
            if (itemData === undefined) return
        },
        stop: function() {
            itemData = $(this).data('item')

            if (itemData !== undefined && itemData.name !== undefined) {
                $(this).css('background-image', 'url(images/' + itemData.icon)
                $('#use').removeClass('disabled')
                $('#send').removeClass('disabled')
            }
        }
    })

    $('.itemOther').draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        revert: 'invalid',
        opacity: 0.5,
        start: function(event, ui) {
            if (disabled) {
                return false
            }

            $(this).css('background-image', 'none')
            itemData = $(this).data('item')
            if (itemData === undefined) return
        },
        stop: function() {
            itemData = $(this).data('item')

            if (itemData !== undefined && itemData.name !== undefined) {
                $(this).css('background-image', 'url(images/' + itemData.icon)
                $('#use').removeClass('disabled')
                $('#send').removeClass('disabled')
            }
        }
    })

    $('.slot').droppable({
        accept: '.itemOther',
        drop: function(event, ui) {
            itemData = ui.draggable.data('item')
            actInv = JSON.parse(inv)
            actInv2 = JSON.parse(secInv)

            if (itemData === undefined) return

            if (secondary === 'drop') {
                //console.log('drop')
                disableInventory(500)
                $.post(
                    'http://pd-inventory/PickupItem',
                    JSON.stringify({
                        number: parseInt($('#count').val()),
                        data: itemData
                    })
                )
            } else if (secondary === 'shop') {
                //console.log('buy')
                disableInventory(500)
                $.post(
                    'http://pd-inventory/BuyItem',
                    JSON.stringify({
                        number: parseInt($('#count').val()),
                        data: itemData,
                    })
                )
            } else if (secondary === 'trafic') {
                //console.log('craft')
                disableInventory(500)
                $.post(
                    'http://pd-inventory/TraficItem',
                    JSON.stringify({
                        number: parseInt($('#count').val()),
                        data: itemData,
                    })
                )
            } else if (secondary === 'trunk') {
                //console.log('takeTrunk')
                disableInventory(500)
                $.post(
                    'http://pd-inventory/TakeFromTrunk',
                    JSON.stringify({
                        number: parseInt($('#count').val()),
                        data: itemData,
                    })
                )
            } else if (secondary === 'chest') {
                //console.log('takeChest')
                disableInventory(500)
                $.post(
                    'http://pd-inventory/TakeFromChest',
                    JSON.stringify({
                        number: parseInt($('#count').val()),
                        data: itemData,
                    })
                )
            } else if (secondary === 'vault') {
                //console.log('takeVault')
                disableInventory(500)
                $.post(
                    'http://pd-inventory/TakeFromVault',
                    JSON.stringify({
                        number: parseInt($('#count').val()),
                        data: itemData,
                    })
                )
            }
        }
    })

    $('.slotOther').droppable({
        accept: '.item',
        drop: function(event, ui) {
            itemData = ui.draggable.data('item')
            actInv = JSON.parse(inv)
            actInv2 = JSON.parse(secInv)

            if (itemData === undefined) return

            if (secondary === 'drop') {
                //console.log('drop')
                disableInventory(500)
                $.post(
                    'http://pd-inventory/DropItem',
                    JSON.stringify({
                        number: parseInt($('#count').val()),
                        data: itemData
                    })
                )
            } else if (secondary === 'sell') {
                //console.log('sell')
                disableInventory(500)
                $.post(
                    'http://pd-inventory/SellItem',
                    JSON.stringify({
                        number: parseInt($('#count').val()),
                        data: itemData,
                    })
                )
            } else if (secondary === 'craft') {
                //console.log('craft')
                disableInventory(500)
                $.post(
                    'http://pd-inventory/CraftItem',
                    JSON.stringify({
                        number: parseInt($('#count').val()),
                        data: itemData,
                    })
                )
            } else if (secondary === 'trunk') {
                //console.log('putTrunk')
                disableInventory(500)
                $.post(
                'http://pd-inventory/PutIntoTrunk',
                    JSON.stringify({
                        number: parseInt($('#count').val()),
                        data: itemData
                    })
                )
            } else if (secondary === 'chest') {
                //console.log('putChest')
                disableInventory(500)
                $.post(
                'http://pd-inventory/PutIntoChest',
                    JSON.stringify({
                        number: parseInt($('#count').val()),
                        data: itemData
                    })
                )
            } else if (secondary === 'vault') {
                //console.log('putVault')
                disableInventory(500)
                $.post(
                'http://pd-inventory/PutIntoVault',
                    JSON.stringify({
                        number: parseInt($('#count').val()),
                        data: itemData
                    })
                )
            }
        }
    })
}

const formatNumber = n => {
    var n = n.toString();
    var r = "";
    var x = 0;

    for (var i = n.length; i > 0; i--) {
        r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? "." : "");
        x = x == 2 ? 0 : x + 1;
    }

    return r
        .split("")
        .reverse()
        .join("");
};

function Interval(time) {
    var timer = false
    this.start = function() {
        if (this.isRunning()) {
            clearInterval(timer)
            timer = false
        }

        timer = setInterval(function() {
            disabled = false
        }, time)
    }
    this.stop = function() {
        clearInterval(timer)
        timer = false
    }
    this.isRunning = function() {
        return timer !== false
    }
}

const disableInventory = ms => {
    disabled = true

    if (disabledFunction === null) {
        disabledFunction = new Interval(ms)
        disabledFunction.start()
    } else {
        if (disabledFunction.isRunning()) {
            disabledFunction.stop()
        }

        disabledFunction.start()
    }
}