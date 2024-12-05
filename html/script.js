let menuLoaded = false;
let ropeActive = false;
let ropesEl = {};
let invInput;
let invData = false;
let commands = {};
let ropes = {};

function invincible() {

}

function activeOption(option) {
    if (ropeActive && ropesEl[ropeActive]) {
        ropesEl[ropeActive].classList.remove("selected");
    }
    if (option && option != "clean" && option != "close") {
        ropeActive = option;
        ropesEl[option].classList.add("selected");
    } else {
        ropeActive = false;
    }
}

function selectOption(option, skin, invincible) {
    let data = JSON.stringify((option in commands) ? { option } : { option, skin, invincible: invData });
    fetch(`https://ropehandler/selectOption`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', },
        body: data,
    }).then(() => {
        activeOption(skin ? option+"_skin" : option);
    });
}

function loadMenu(ropes, commands, invincibleLang, choiceOption, withSkin) {
    var menu = document.getElementById("menu");

    var h1 = document.createElement("h1");
    h1.innerHTML = choiceOption;
    menu.appendChild(h1);

    var separator = document.createElement("div");
    separator.classList.add("separator");
    menu.appendChild(separator);

    label = document.createElement("label");
    invInput = document.createElement("input");
    invInput.type = "checkbox";
    invInput.onchange = () => {
        invData = !invData;
        invInput.checked = invData;
    };
    invInput.checked = invData;
    label.appendChild(invInput);
    label.appendChild(document.createTextNode(invincibleLang));
    menu.appendChild(label);

    for (const [key, value] of Object.entries(ropes)) {
        var divbutton = document.createElement("div");
        divbutton.classList.add("divbutton");
        var button = document.createElement("button");
        button.innerHTML = value.lang;
        button.onclick = () => selectOption(key);
        divbutton.appendChild(button);
        divbutton.classList.add("rope");
        divbutton.classList.add(key);
        ropesEl[key] = button;
        if (value.skin) {
            var button = document.createElement("button");
            button.innerHTML = withSkin;
            button.onclick = () => selectOption(key, value.skin);
            divbutton.appendChild(button);
            ropesEl[key+"_skin"] = button;
        }
        menu.appendChild(divbutton);
    }

    separator = document.createElement("div");
    separator.classList.add("separator");
    menu.appendChild(separator);

    for (const [key, value] of Object.entries(commands)) {
        if(value.name != "ui") {
            var divbutton = document.createElement("div");
            divbutton.classList.add("divbutton");
            divbutton.classList.add("command");
            divbutton.classList.add(key);
            var button = document.createElement("button");
            button.innerHTML = value.lang;
            button.onclick = () => selectOption(value.name);
            divbutton.appendChild(button);
            menu.appendChild(divbutton);
        }
    }
    menuLoaded = true;
}

// Gestion des événements envoyés par Lua
window.addEventListener("message", (event) => {
    const data = event.data;
    commands = data.commands;
    ropes = data.ropes;
    if (data.action === "openui") {
        invincible(data.invincible);
        if (!menuLoaded)
            loadMenu(
                data.ropes,
                data.commands,
                data.invincibleLang,
                data.choiceOption,
                data.withSkin
            );
        activeOption(data.active);
        document.getElementById("menu").style.display = "block";
    } else if (data.action === "closeui") {
        document.getElementById("menu").style.display = "none";
    }
});
