# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "imask", to: "https://ga.jspm.io/npm:imask@7.1.3/esm/index.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "flowbite", to: "https://ga.jspm.io/npm:flowbite@2.2.0/lib/esm/index.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"
