// ==============================
// 🎞️ Función para mover el slider
// ==============================
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
});


// ========================================================
// 🛒 LÓGICA CONTADOR CARRITO: Mostrar cuantos productos hay
// ========================================================

function agregarAlCarrito(producto_id) {
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

const track = document.getElementById('carouselTrack');
const slide = document.querySelectorAll('.carousel-image');
let index = 0;

function movecarousel () {
  index++;
  if (index >= slide.length){
    index = 0;
  }

  const offset = index * slide[0].clientWidth;
  track.style.transform = `translateX(-${offset}px)`;  
}
setInterval(movecarousel, 3500);




