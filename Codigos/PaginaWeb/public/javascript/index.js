// SMALL SCREEN NAVBAR
function toggleFunction() {
    var x = document.getElementById("smallNavbar");
    if (x.className.indexOf("w3-show") == -1) {
        x.className += " w3-show";
    } else {
        x.className = x.className.replace(" w3-show", "");
    }
}

// SMALL NAVBAR OPEN
function w3_open() {
    var fafa = document.getElementById("myNavbar");
    fafa.style.display = "none";
    var x = document.getElementById("smallNavbar");
    x.style.width = "100%";
    x.style.fontSize = "40px";
    x.style.paddingTop = "10%";
    x.style.display = "block";
}

// SMALL NAVBAR CLOSE
function w3_close() {
    var fafa = document.getElementById("myNavbar");
    fafa.style.display = "block";
    document.getElementById("smallNavbar").style.display = "none";
}

// NAVBAR STYLE ON SCROLL
window.onscroll = function() {myFunction()};
function myFunction() {
    var navbar = document.getElementById("myNavbar");
    if (document.body.scrollTop > 15 || document.documentElement.scrollTop > 15) {
      navbar.className = "w3-bar" + " w3-card" + " w3-black";
    } else {
      navbar.className = navbar.className.replace(" w3-card w3-black", "");
    }
}

function toGame() {
    window.location.href = "http://3.219.153.3:8080/web/game.html";
}

/* global nameTField lastTField emailField phoneField 

   lastTField2 lastEField2
   
   nameEField lastEField bdateField 
   gamertagField pwdField ctryField
   
   gamertagRegField pwdRegField
   
   endLogin loginResult
   endRegister regResult 
*/

function sendInfo() {
    
    const nameT = nameTField.value;
    const lastT1 = lastTField.value;
    const lastT2 = lastTField2.value;
    const email = emailField.value;
    const phone = phoneField.value;
    const nameE = nameEField.value;
    const lastE1 = lastEField.value;
    const lastE2 = lastEField2.value;
    const bdate = bdateField.value;
    const gamertag = gamertagField.value;
    const pwd = pwdField.value;
    const ctry = ctryField.value;
    
    
    if (nameT && lastT1 && lastT2 && email && phone && nameE && lastE1 && lastE2 && bdate && gamertag && pwd && ctry) {
        const payLoad = JSON.stringify({
            nameT, lastT1, lastT2, email, phone, nameE,
            lastE1, lastE2, bdate, gamertag, pwd, ctry
        });
        const xhr = new XMLHttpRequest();
        xhr.onload = () => {
          regResult.innerText = xhr.responseText;
          endRegister.style.display = 'block';
          if (xhr.responseText == 'OK') {
            toGame();
          }    
        };
        xhr.open('POST', '/userinfo');
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.send(payLoad);
        
    } else {
    alert("Por favor llena todos los campos antes de enviar la información");
  }
}


function login() {
    const payLoad = JSON.stringify({
        gamertag: gamertagRegField.value,
        pwd: pwdRegField.value
    });
    const xhr = new XMLHttpRequest();
    xhr.onload = () => {
        loginResult.innerText = xhr.responseText;
        endLogin.style.display = 'block';
    };
    xhr.open('POST', '/login');
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(payLoad);
}