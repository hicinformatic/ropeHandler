let menuLoaded = false;
let optionActive = false;
let optionsEl = {};

function activeOption(option) {
    if (optionActive && optionsEl[optionActive]) {
        optionsEl[optionActive].classList.remove("selected");
    }
    if (option != "clean" && option != "close") {
        optionActive = option;
        optionsEl[option].classList.add("selected");
    } else {
        optionActive = false;
    }
}

function selectOption(option) {
    fetch(`https://ropehandler/selectOption`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', },
        body: JSON.stringify({ option }),
    }).then(() => {
        activeOption(option);
    });
}

// Fonction pour charger les traductions
function loadLanguage(lang) {
    var script = document.createElement('script');
    script.src = `./i18n/${lang}.js`;
    script.type = 'text/javascript';
    script.async = false; // Important pour bloquer l'exécution du script jusqu'à ce qu'il soit chargé
    script.defer = false; // Peut être ignoré si async = false
    document.body.appendChild(script);
}

function loadMenu(options) {
    var menu = document.getElementById("menu");
    options.forEach((option) => {
        console.log(option);
        if (option.name != "ui") {
            var button = document.createElement("button");
            button.innerHTML = option.lang
            button.onclick = () => selectOption(option.name);
            menu.appendChild(button);
            optionsEl[option.name] = button;
        }
    });
    menuLoaded = true;
}

// Gestion des événements envoyés par Lua
window.addEventListener("message", (event) => {
    const data = event.data;
    loadLanguage(data.lang);
    if (data.action === "openui") {
        if (!menuLoaded) {
            loadMenu(data.options);
        }
        console.log("active", data.active);
        if (data.active) {
            activeOption(data.active);
        }
        document.getElementById("menu").style.display = "block";
    } else if (data.action === "closeui") {
        document.getElementById("menu").style.display = "none";
    }
});
