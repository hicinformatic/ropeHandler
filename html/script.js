let menuLoaded = false;
let ropeActive = false;
let ropesEl = {};

function activeOption(option) {
    if (ropeActive && ropesEl[ropeActive]) {
        ropesEl[ropeActive].classList.remove("selected");
    }
    if (option != "clean" && option != "close") {
        ropeActive = option;
        ropesEl[option].classList.add("selected");
    } else {
        ropeActive = false;
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

function loadMenu(ropes, commands) {
    var menu = document.getElementById("menu");
    ropes.forEach((rope) => {
        var button = document.createElement("button");
        button.innerHTML = rope.lang;
        button.onclick = () => selectOption(rope.name);
        menu.appendChild(button);
        ropesEl[rope.name] = button;
    });
    var separator = document.createElement("hr");
    menu.appendChild(separator);
    commands.forEach((command) => {
        if(command.name != "ui") {
            var button = document.createElement("button");
            button.innerHTML = command.lang;
            button.onclick = () => selectOption(command.name);
            menu.appendChild(button);
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
            console.log(data.commands);
            loadMenu(data.ropes, data.commands);
        }
        if (data.active) {
            activeOption(data.active);
        }
        document.getElementById("menu").style.display = "block";
    } else if (data.action === "closeui") {
        document.getElementById("menu").style.display = "none";
    }
});
