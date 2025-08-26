// ========================================
// 💵 Función verificar status de la compra
// ========================================

document.addEventListener("turbo:load", () => {
  const statusBox = document.getElementById("stateBox");
  if (!statusBox) return;

  const statusUrl = statusBox.dataset.statusUrl;

  let interval = setInterval(checkStatus, 2000);

  function checkStatus() {
    fetch(statusUrl)
      .then(res => res.json())
      .then(data => {
        console.log("Estado recibido:", data); // <-- agrega esto
        if (data.status === "approved") {
          statusBox.className = "state success";
          document.getElementById("loader").style.display = "none";
          document.getElementById("success").style.display = "block";
          document.getElementById("cancel-btn").style.display = "none";
          clearInterval(interval);
        } else if (data.status === "declined") {
          statusBox.className = "state error";
          document.getElementById("loader").style.display = "none";
          document.getElementById("declined").style.display = "block";
          document.getElementById("cancel-btn").style.display = "none";
          clearInterval(interval);
        } else if (data.status === "cancelled") {
          statusBox.className = "state error"
          document.getElementById("loader").style.display = "none";
          document.getElementById("declined").style.display = "block";
          document.getElementById("cancel-btn").style.display = "none";
          clearInterval(interval);
        }
      });
  }

  const btn = document.getElementById("reintentar");
  let intervalShow = setInterval(() => {
    btn.style.display = "inline-block";
    clearInterval(intervalShow);
  }, 8000);
});

// ==============================
// 🎞️ Función para mover el slider
// ==============================
document.addEventListener("turbo:load", function () {
  const slider = document.getElementById("productosIndex");
  if (slider) {
    window.moverSlider = function (id, direccion) {
      const slider = document.getElementById(id);
      const carta = slider.querySelector(".carta");
      if (!carta) return;

      const cartaStyle = getComputedStyle(slider);
      const gap = parseInt(cartaStyle.gap || "20", 10);
      const cartaWidth = carta.offsetWidth + gap;

      const nuevoScroll = slider.scrollLeft + direccion * cartaWidth;
      slider.scrollTo({ left: nuevoScroll, behavior: "smooth" });
    };
  }
});

// ==========================================
// 🔐 LÓGICA DE LOGIN: validación de campos
// ==========================================

document.addEventListener("turbo:load", function () {
  const loginForm = document.querySelector("form[action='/users/sign_in']");
  if (!loginForm) return;

  const email = document.querySelector("#user_email");
  const password = document.querySelector("#user_password");
  const flashAlert = document.querySelector(".alert-danger");

  if ((email?.value.trim() === "" || password?.value.trim() === "") && flashAlert) {
    flashAlert.style.display = "none";
  }

  loginForm.addEventListener("submit", function (e) {
    const emailVacio = email?.value.trim() === "";
    const passwordVacio = password?.value.trim() === "";

    if (emailVacio || passwordVacio) {
      e.preventDefault();
      if (flashAlert) flashAlert.style.display = "none";
      alert("Por favor completa ambos campos antes de iniciar sesión.");
    }
  });
});

// ===============================================
// 🛒 LÓGICA DE CARRITO: evitar redirección en POST
// ===============================================

document.addEventListener("turbo:load", function () {
  const carritoForms = document.querySelectorAll(".form-agregar-carrito");
  if (carritoForms) {
    carritoForms.forEach(form => {
      form.addEventListener("submit", function (event) {
        event.preventDefault();

        const formData = new FormData(form);

        fetch(form.action, {
          method: "POST",
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
          },
          body: formData
        })
        .then(response => response.json())
        .then(data => {
          console.log("Producto agregado al carrito", data);

          const contador = document.getElementById("contador-carrito");
          if (contador && data.total_productos !== undefined) {
            contador.textContent = data.total_productos;
          }
        })
        .catch(error => {
          console.error("Error al agregar al carrito", error);
        });
      });
    });
  }
});


// ========================================================
// 🛒 LÓGICA CONTADOR CARRITO: Mostrar cuantos productos hay
// ========================================================

function agregarAlCarrito(producto_id) {
  const productoId = producto_id;
  if (!productoId) return;

  fetch('/agregar_al_carrito?producto_id=${productoId}', {
    method:  'POST',
    headers:{
      'X-CSRF-Token' : document.querySelector('[name ="csrf-token"]').content
    } 
  })

  .then(Response => response.json())
  .then(data => {
    if (data.status == ok){
      document.getElementById("contador-carrito").textContent = `🛒 Carrito (${data.total_productos})`;
    }
  });
}

// ==============================
// 🎞️ Función para el banner
// ==============================

document.addEventListener("turbo:load", function () {

  const track = document.getElementById('carouselTrack');
  const slide = document.querySelectorAll('.carousel-image');
  let index = 0;

  if (!track || slide.length === 0) return;

  function movecarousel () {
    index++;
    if (index >= slide.length){
      index = 0;
    }

    const offset = index * slide[0].clientWidth;
    track.style.transform = `translateX(-${offset}px)`;  
  }
  setInterval(movecarousel, 3500);

});

// =====================================================
// 💳 Fuciones para verificar parametros de las tarjetas
// =====================================================


document.addEventListener("turbo:load", function() {
  const form = document.getElementById("payment-form");
  const payBtn = document.getElementById("pay-btn");

  if (!form ) return;

  const cardInput = form.querySelector("[name='payment[card_number]']");
  const expMonthInput = form.querySelector("[name='payment[exp_month]']");
  const expYearInput = form.querySelector("[name='payment[exp_year]']");
  const cvvInput = form.querySelector("[name='payment[cvv]']");
  const emailInput = form.querySelector("[name='payment[email]']");
  const holderInput = form.querySelector("[name='payment[card_holder]']");
  const termsCheck = document.getElementById("payment_accept_terms");
  const dataCheck = document.getElementById("payment_accept_data");

  const errorCard = document.getElementById("error-card");
  const errorMonth = document.getElementById("error-month");
  const errorYear = document.getElementById("error-year");
  const errorCvv = document.getElementById("error-cvv");
  const errorEmail = document.getElementById("error-email");
  const errorHolder = document.getElementById("error-holder");

  let interacted = {
    card: false,
    month: false,
    year: false,
    cvv: false,
    holder: false,
    email: false
  };

  // Algoritmo Luhn para validar tarjeta
  function luhnCheck(card) {
    let sum = 0;
    let shouldDouble = false;
    for (let i = card.length - 1; i >= 0; i--) {
      let digit = parseInt(card.charAt(i));
      if (shouldDouble) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      shouldDouble = !shouldDouble;
    }
    return sum % 10 === 0;
  }

  // Detecta tipo de tarjeta
  function cardType(card) {
    if (/^4/.test(card)) return "Visa";
    if (/^5[1-5]/.test(card)) return "MasterCard";
    if (/^3[47]/.test(card)) return "Amex";
    if (/^6(?:011|5)/.test(card)) return "Discover";
    return "Desconocida";
  }

  function validateField(input, isValid, errorElem, errorMsg, key) {
    input.classList.remove("input-error", "input-success");
    if (!interacted[key]) {
      errorElem.textContent = "";
      return;
    }
    if (isValid) {
      input.classList.add("input-success");
      errorElem.textContent = "";
    } else {
      input.classList.add("input-error");
      errorElem.textContent = errorMsg;
    }
  }

  function validateForm() {
    const cardValue = cardInput.value.replace(/\s+/g, "");
    const cardValidLength = /^\d{15,16}$/.test(cardValue);
    const cardValidLuhn = luhnCheck(cardValue);
    const type = cardType(cardValue);

    let cardValid = cardValidLength && cardValidLuhn && type !== "Desconocida";
    let cardErrorMsg = "";
    if (!cardValidLength) cardErrorMsg = "La tarjeta debe tener 15 o 16 dígitos";
    else if (!cardValidLuhn) cardErrorMsg = "Número de tarjeta no válido";
    else if (type === "Desconocida") cardErrorMsg = "Tipo de tarjeta no soportado";

    validateField(cardInput, cardValid, errorCard, cardErrorMsg, "card");

    // Fecha de expiración
    const monthValid = expMonthInput.value !== "";
    const yearValid = expYearInput.value !== "";
    let dateValid = false;
    let dateErrorMsg = "";
    if (monthValid && yearValid) {
      const expDate = new Date(expYearInput.value, expMonthInput.value - 1, 1);
      const now = new Date();
      expDate.setMonth(expDate.getMonth() + 1);
      dateValid = expDate > now;
      if (!dateValid) dateErrorMsg = "La tarjeta está vencida";
    }
    validateField(expMonthInput, monthValid, errorMonth, "Seleccione el mes de expiración", "month");
    validateField(expYearInput, yearValid, errorYear, "Seleccione el año de expiración", "year");
    if (monthValid && yearValid && !dateValid) {
      expMonthInput.classList.add("input-error");
      expYearInput.classList.add("input-error");
      errorMonth.textContent = dateErrorMsg;
      errorYear.textContent = dateErrorMsg;
    }

    // CVV según tipo de tarjeta
    let cvvPattern = type === "Amex" ? /^\d{4}$/ : /^\d{3}$/;
    let cvvValid = cvvPattern.test(cvvInput.value.trim());
    let cvvErrorMsg = type === "Amex" ? "CVV debe tener 4 dígitos" : "CVV debe tener 3 dígitos";
    validateField(cvvInput, cvvValid, errorCvv, cvvErrorMsg, "cvv");

    // Titular
    let holderValid = holderInput.value.trim().length > 2;
    validateField(holderInput, holderValid, errorHolder, "Ingrese el nombre del titular", "holder");

    // Email
    const emailValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailInput.value.trim());
    validateField(emailInput, emailValid, errorEmail, "Correo electrónico no válido", "email");

    // Terminos y condiciones 
    const termsAccepted = termsCheck.checked

    // Tratamientod de datos
    const dataAccepted = dataCheck.checked


    if (cardValid && monthValid && yearValid && dateValid && cvvValid && emailValid && holderValid && termsAccepted && dataAccepted) {
      payBtn.disabled = false;
    } else {
      payBtn.disabled = true;
    }
  }

  // Marca el campo como interactuado al cambiar
  cardInput.addEventListener("input", function() { interacted.card = true; validateForm(); });
  expMonthInput.addEventListener("change", function() { interacted.month = true; validateForm(); });
  expYearInput.addEventListener("change", function() { interacted.year = true; validateForm(); });
  cvvInput.addEventListener("input", function() { interacted.cvv = true; validateForm(); });
  emailInput.addEventListener("input", function() { interacted.email = true; validateForm(); });
  holderInput.addEventListener("input", function() { interacted.holder = true; validateForm(); });
  termsCheck.addEventListener("change", validateForm);
  dataCheck.addEventListener("change", validateForm);

  // Validación inicial solo para estilos, sin mostrar errores
  validateForm();
});