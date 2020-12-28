$(window).load(function() {
  $("#preloader").fadeOut(200);
});

var tips = ['Cuidado ao ultrapassar sinais vermelhos.', 'Não pergunte sobre coisas ilegais a qualquer pessoa. Tome cuidado.', 'Não ande com muito dinheiro em mãos.', 'Em caso de bugs, utilize o /help.', 'Não utilize informações obtidas privilegiadas no Discord para se beneficiar na cidade, Sujeito a ban.', 'Leia as regras no nosso Discord e respeite os outros cidadãos.'];
setInterval(function() {
  var r = Math.floor(Math.random() * tips.length);
  $(".tip-text").fadeOut(200, function() {
    $(".tip-text").html(tips[r]);
    $(this).fadeIn(200);
  });
  
}, 10000);