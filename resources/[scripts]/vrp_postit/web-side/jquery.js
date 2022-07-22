$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }
    display(false)

    window.addEventListener('message',function(event) {
        var item = event.data;

        if (item.type === "postit:init") {
            if (item.status == true) {
                display(true)
                $("#text").val("");
                $("#text").prop("disabled",false);
            } else {
                display(false)
            }
        }

        if (item.text) {
            $("#text").val(item.text);
            $("#text").prop("disabled",true);
        }
    })
    
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://vrp_postit/postit:exit',JSON.stringify({}));
            return
        }
        if (!$("#text").prop("disabled")){
            if (data.which == 13) {
                let inputValue = $("#text").val()

                if (inputValue.length >= 150) {
                    $.post("http://vrp_postit/postit:error",JSON.stringify({
                        error: "O máximo de letras no post-it é <b>150</b>."
                    }))
                    return
                } else if (inputValue.length <= 1) {
                    $.post("http://vrp_postit/postit:error",JSON.stringify({
                        error: "Você precisa digitar uma mensagem."
                    }))
                    return
                }
                
                $.post('http://vrp_postit/postit:send',JSON.stringify({
                    text: inputValue,
                }));
                return;
            }
        }
    };

    $("#close").click(function () {
        $.post('http://vrp_postit/postit:exit',JSON.stringify({}));
        return
    })
})