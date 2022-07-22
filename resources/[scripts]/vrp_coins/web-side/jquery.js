let buyingCar = undefined,
  buyingVip = undefined,
  totalMoedas = 0,
  type = undefined,
  newCoins = undefined;

const renderVips = () => {
  vips.map((vip, index) => {

    let html = `
            <div class="item" id="vip-${index}">
                <div style="width: 100%; padding: 20px 0;">
                    <i class="fas fa-gem fa-4x"></i>
                </div>

                <h3>${vip.label.toUpperCase()}</h3>

                <ul>
                    <li>Garagem adicionais: <b>${vip.benefits.garages}</b></li>
                    <li>Salário: <b>$${vip.benefits.salary}</b></li>
                    <li>Prioridade na fila: <b>${vip.benefits.queue}</b></li>
                    ${vip.benefits.extra1 === undefined ? '' : `<li>Extra 1: <b>${vip.benefits.extra1}</b></li>`}
                    ${vip.benefits.extra2 === undefined ? '' : `<li>Extra 2: <b>${vip.benefits.extra2}</b></li>`}
                    ${vip.benefits.extra3 === undefined ? '' : `<li>Extra 3: <b>${vip.benefits.extra3}</b></li>`}
                    ${vip.benefits.extra4 === undefined ? '' : `<li>Extra 4: <b>${vip.benefits.extra4}</b></li>`}
                    ${vip.benefits.extra5 === undefined ? '' : `<li>Extra 5: <b>${vip.benefits.extra5}</b></li>`}
                </ul>
                <button class="buy" data-type="vip" data-id="${index}" data-name="${vip.label.toUpperCase()}" data-value="${vip.price}">
                    <i class="fas fa-coins"></i> ${vip.price}
                </button>
            </div>`;

    $(".content_vips").append(html);
  });
};

const renderVehicles = () => {
  vehicles.map((vehicle, index) => {
    let html = `
            <div class="item" id="vehicle-${index}">
                <div style="width: 100%; padding: 20px 0;">
                    <i class="fas fa-car fa-4x"></i>
                </div>

                <h3>${vehicle.label.toUpperCase()}</h3>

                <img width="294.89" height="173.72" src="assets/${
                  vehicle.name
                }.png" class="car-banner"/>

                <button class="buy" data-type="vehicle" data-id="${
                  vehicle.name
                }" data-name="${vehicle.label.toUpperCase()}" data-value="${vehicle.price}">
                    <i class="fas fa-coins"></i> ${vehicle.price}
                </button>
            </div>`;

    $(".content_vehicles").append(html);
  });
};

const renderExtras = () => {
  extras.map((extra, index) => {
    const html = `<div class="item" id="extra-${index}">
    <div style="width: 100%; padding: 20px 0;">
        <i class="fas fa-box-open fa-4x"></i>
    </div>

    <h3>${extra.name.toUpperCase()}</h3>
    
    <button class="buy" data-type="${ extra.type}" data-id="${index}" data-name="${extra.name.toUpperCase()}" data-value="${extra.price}">
        <i class="fas fa-coins"></i> ${extra.price}
    </button>
</div>`;
    $(".content_extras").append(html);
  });
};

const handleBuy = () => {
  if (type === "vip") {
    $.post(
      "http://vrp_coins/buyVip",
      JSON.stringify({ type: buyingVip.type, time: buyingVip.time })
    );
  } else if (type === "vehicle") {
    $.post(
      "http://vrp_coins/buyVehicle",
      JSON.stringify({ name: buyingCar.name })
    );
  } else {
    $.post(
      "http://vrp_coins/buyItem",
      JSON.stringify({ item: buyingExtra.type })
    );
  }
};

const handleClose = () => {
  $.post("http://vrp_coins/shopClose", JSON.stringify({}));
};

const showVips = () => {
  $(".content_vips").show();
  $(".content_vehicles").hide();
  $(".content_extras").hide();
};

const showVehicles = () => {
  $(".content_vips").hide();
  $(".content_vehicles").show();
  $(".content_extras").hide();
};

const showExtras = () => {
  $(".content_vips").hide();
  $(".content_vehicles").hide();
  $(".content_extras").show();
};

$(document).ready(function () {
  renderVips();
  renderVehicles();
  renderExtras();


  window.addEventListener("message", function (event) {
    if (event.data.openMenu) {
      $("#totalMoedas").html(event.data.coins);
      $("body").show();
    } else {
      $("#totalMoedas").html(0);
      $("body").hide();
    }
  });

  $("#close").click(function () {
    handleClose();
  });

  $("#botaoSalvar").click(function () {
    handleBuy();
  });

  $(document).on("click", ".buy", function () {
    let name = $(this).data("name"),
      value = $(this).data("value"),
      id = $(this).data("id");

    type = $(this).data("type");

    if (type === "vehicle") {
      buyingCar = vehicles.find((vehicle) => vehicle.name === id);
    } else if (type === "vip") {
      buyingVip = vips.find((vip) => vip.label.toUpperCase() === name);
    } else {
      buyingExtra = extras.find((extra) => extra.name.toUpperCase() === name);
    }

    $(".message").html(
      "Você gostaria de adquirir o " + name + " por " + value + " coins?"
    );
    $(".alertbox").addClass("active");
  });
  $(document).on("click", ".btn-cancel", function () {
    $(".alertbox").removeClass("active");
    $(".alert-success").removeClass("active");
    $(".alert-danger").removeClass("active");
    buyingCa = undefined;
  });
  $(document).on("click", ".btn-success", function () {
    $(".alertbox").removeClass("active");
    $(".alert").removeClass("active");
    buyingCar = undefined;
    if (!$(".alert-success").hasClass("active")) {
      $(".alert-success").toggleClass("active");
      setTimeout(function () {
        $(".alert-success").removeClass("active");
      }, 2000);
    }
  });
});
