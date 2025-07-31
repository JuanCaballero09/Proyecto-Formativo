document.addEventListener("turbo:load", function () {
  // === Colores del sistema (desde CSS variables) ===
  const colores = getComputedStyle(document.documentElement);
  const base = colores.getPropertyValue("--base").trim();
  const claro = colores.getPropertyValue("--base-claro").trim();
  const oscuro = colores.getPropertyValue("--base-oscuro").trim();

  // === Productos por grupo ===
  new Chart(document.getElementById("chartBarras"), {
    type: "bar",
    data: {
      labels: window.ProductByGroup.labels,
      datasets: [{
        label: "Productos",
        data: window.ProductByGroup.data,
        backgroundColor: base
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: { beginAtZero: true }
      },
      plugins: {
        legend: {
          labels: {
            color: oscuro,
            boxWidth: 12,
            padding: 10
          }
        }
      },
      layout: {
        padding: {
          top: 10,
          bottom: 10
        }
      }
    }
  });

  // === Crecimiento en línea ===
  new Chart(document.getElementById("chartLineas"), {
    type: "line",
    data: {
      labels: window.salesGrowth.labels,
      datasets: [{
        label: "Crecimiento",
        data: window.salesGrowth.data,
        fill: true,
        backgroundColor: claro,
        borderColor: base,
        tension: 0.3,
        pointRadius: 4,
        pointHoverRadius: 6
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          labels: {
            color: oscuro,
            padding: 10
          }
        }
      },
      layout: {
        padding: {
          top: 10,
          bottom: 10
        }
      }
    }
  });

  // === Distribución (Doughnut) ===
  new Chart(document.getElementById("chartTorta"), {
    type: "doughnut",
    data: {
      labels: window.ProductByGroup.labels,
      datasets: [{
        label: "Distribución",
        data: window.ProductByGroup.data,
        backgroundColor: [base, claro, oscuro],
        borderColor: "#fff",
        borderWidth: 2
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: "bottom",
          labels: {
            color: oscuro,
            padding: 10
          }
        }
      },
      layout: {
        padding: {
          top: 10,
          bottom: 10
        }
      }
    }
  });
});
