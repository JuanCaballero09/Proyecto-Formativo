pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/turbo", to: "turbo.js" # opcional, puede eliminarse si no usas directo esto
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # si lo necesitas
pin "script", to: "script.js"
pin "chart", to: "chart.js"
pin "bootstrap", to: "bootstrap.bundle.min.js"
