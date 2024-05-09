/*global 

 adminRegField adminPwdField  adminLoginResult adminEndLogin adminLogIn adminSection
 countryChart scoreChart ctryAvChart ageAvChart ageChart lowLoginChart
 countries users tutors
 nameAField lastpAField lastmAField bdateAField pwdAField userAField regAResult endARegister
 ctryPanel userPanel tutorPanel
 ctryIdField ctryNameField ctryDelField ctryResult
 userIdField userNameField userPField userMField userCField userMailField userYField userGField userDelField userResult
 tutorIdField tutorNameField tutorPhoneField tutorPField tutorMField tutorMailField tutorDelField tutorResult

*/

function adminLogin() {
    const payLoad = JSON.stringify({
        nombreuser: adminRegField.value,
        pwd: adminPwdField.value
    });
    const xhr = new XMLHttpRequest();
    xhr.onload = () => {
        adminLoginResult.innerText = xhr.responseText;
        adminEndLogin.style.display = 'block';
        console.log(xhr.responseText);
        
        if (xhr.responseText == 'OK') {
            adminLogIn.style.display = 'none';
            adminSection.style.display = 'block';
        }
    };
    xhr.open('POST', '/loginAdmin');
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(payLoad);
}


function adminRegister() {
    
    const name = nameAField.value;
    const lastP = lastpAField.value;
    const lastM = lastmAField.value;
    const bdate = bdateAField.value;
    const user = userAField.value;
    const pwd = pwdAField.value;

    
    if (name && lastP && lastM && bdate && user && pwd) {
        const payLoad = JSON.stringify({
            name, lastP, lastM,
            bdate, user, pwd
        });
        const xhr = new XMLHttpRequest();
        xhr.onload = () => {
          regAResult.innerText = xhr.responseText;
          endARegister.style.display = 'block';
        };
        xhr.open('POST', '/registerAdmin');
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.send(payLoad);
        
    } else {
    alert("Por favor llena todos los campos antes de enviar la información");
  }
}


/*--------------------- Manipulación de datos --------------------------------*/

allCountries();
allUsers();
allTutors();


function changePage(n) {
  const params = new URLSearchParams(window.location.search);
  let page = parseInt(params.get('page') ?? 1);
  page += n;
  params.set('page', page);
  window.location.search = params;
}


function allCountries() {
  const xhr = new XMLHttpRequest();
  const url = 'http://3.219.153.3:8080/countryInfo';
  xhr.onload = () => {
    const result = JSON.parse(xhr.responseText);
    const table = countries;
    for (let i of result['table']) {
      let row = table.insertRow(-1);
      let cell1 = row.insertCell(0);
      let cell2 = row.insertCell(1);
      cell1.innerHTML = i['IDPais'];
      cell2.innerHTML = i['Nombre'];
    }
  };
  xhr.open('GET', url);
  xhr.send();  
}


function allUsers() {
  const params = new URLSearchParams(window.location.search);
  
  const xhr = new XMLHttpRequest();
  const url = 'http://3.219.153.3:8080/userInfo';
  xhr.onload = () => {
    const result = JSON.parse(xhr.responseText);
    const table = users;
    for (let i of result['table']) {
      let row = table.insertRow(-1);
      let cell1 = row.insertCell(0);
      let cell2 = row.insertCell(1);
      let cell3 = row.insertCell(2);
      let cell4 = row.insertCell(3);
      let cell5 = row.insertCell(4);
      let cell6 = row.insertCell(5);
      let cell7 = row.insertCell(6);
      let cell8 = row.insertCell(7);
      cell1.innerHTML = i['IDUsuario'];
      cell2.innerHTML = i['IDPais'];
      cell3.innerHTML = i['IDTutor'];
      cell4.innerHTML = i['Nombre'];
      cell5.innerHTML = i['ApellidoP'];
      cell6.innerHTML = i['ApellidoM'];
      cell7.innerHTML = i['FechaNacim'];
      cell8.innerHTML = i['GamerTag'];
    }
  };
  xhr.open('GET', url);
  xhr.send();   
}


function allTutors() {
  const params = new URLSearchParams(window.location.search);
  
  const xhr = new XMLHttpRequest();
  const url = 'http://3.219.153.3:8080/tutorInfo';
  xhr.onload = () => {
    const result = JSON.parse(xhr.responseText);
    const table = tutors;
    for (let i of result['table']) {
      let row = table.insertRow(-1);      
      let cell1 = row.insertCell(0);
      let cell2 = row.insertCell(1);
      let cell3 = row.insertCell(2);
      let cell4 = row.insertCell(3);
      let cell5 = row.insertCell(4);
      let cell6 = row.insertCell(5);
      cell1.innerHTML = i['IDTutor'];
      cell2.innerHTML = i['Nombre'];
      cell3.innerHTML = i['ApellidoP'];
      cell4.innerHTML = i['ApellidoM'];
      cell5.innerHTML = i['Telefono'];
      cell6.innerHTML = i['Correo'];
    }
  };
  xhr.open('GET', url);
  xhr.send();   
}


function toggleP() {
  ctryPanel.style.display = "block";
  userPanel.style.display = "none";
  tutorPanel.style.display = "none";
}

function toggleU() {
  ctryPanel.style.display = "none";
  userPanel.style.display = "block";
  tutorPanel.style.display = "none";
}

function toggleT() {
  ctryPanel.style.display = "none";
  userPanel.style.display = "none";
  tutorPanel.style.display = "block";
}


// Actualizar País
function updateCtry() {
    
    const idPais = ctryIdField.value;
    const nombre = ctryNameField.value;

    
    if (idPais && nombre) {
        const payLoad = JSON.stringify({
            idPais, nombre
        });
        const xhr = new XMLHttpRequest();
        xhr.onload = () => {
          ctryResult.innerText = xhr.responseText;
        };
        xhr.open('PUT', '/updateCtry');
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.send(payLoad);
        
    } else {
    alert("Por favor llena todos los campos antes de enviar la información");
  }
}


// Actualizar Usuario
function updateUser() {
    
    const id = userIdField.value;
    const name = userNameField.value;
    const lastP = userPField.value;
    const lastM = userMField.value;
    const ctry = userCField.value;
    const email = userMailField.value;
    const bdate = userYField.value;
    const gamertag = userGField.value;

    
    if (id && name && lastP && lastM && ctry && email && bdate && gamertag) {
        const payLoad = JSON.stringify({
            id, name, lastP, lastM,
            ctry, email, bdate, gamertag
        });
        const xhr = new XMLHttpRequest();
        xhr.onload = () => {
          userResult.innerText = xhr.responseText;
        };
        xhr.open('PUT', '/updateUser');
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.send(payLoad);
        
    } else {
    alert("Por favor llena todos los campos antes de enviar la información");
  }
}


// Actualizar Tutor
function updateTutor() {
    
    const id = tutorIdField.value;
    const name = tutorNameField.value;
    const lastP = tutorPField.value;
    const lastM = tutorMField.value;
    const phone = tutorPhoneField.value;
    const email = tutorMailField.value;

    
    if (id && name && lastP && lastM && phone && email) {
        const payLoad = JSON.stringify({
            id, name, lastP, 
            lastM, phone, email
        });
        const xhr = new XMLHttpRequest();
        xhr.onload = () => {
          tutorResult.innerText = xhr.responseText;
        };
        xhr.open('PUT', '/updateTutor');
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.send(payLoad);
        
    } else {
    alert("Por favor llena todos los campos antes de enviar la información");
  }
}


// Borrar un país
function deleteCtry() {
    
    const name = ctryDelField.value;

    if (name) {
        const payLoad = JSON.stringify({
            name
        });
        const xhr = new XMLHttpRequest();
        xhr.onload = () => {
          ctryResult.innerText = xhr.responseText;
        };
        xhr.open('DELETE', '/deleteCtry');
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.send(payLoad);
        
    } else {
    alert("Por favor llena todos los campos antes de enviar la información");
  }
}


// Borrar un usuario
function deleteUser() {
    
    const gamerTag = userDelField.value;

    if (gamerTag) {
        const payLoad = JSON.stringify({
            gamerTag
        });
        const xhr = new XMLHttpRequest();
        xhr.onload = () => {
          userResult.innerText = xhr.responseText;
        };
        xhr.open('DELETE', '/deleteUser');
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.send(payLoad);
        
    } else {
    alert("Por favor llena todos los campos antes de enviar la información");
  }
}


// Borrar un tutor
function deleteTutor() {
    
    const email = tutorDelField.value;

    if (email) {
        const payLoad = JSON.stringify({
            email
        });
        const xhr = new XMLHttpRequest();
        xhr.onload = () => {
          tutorResult.innerText = xhr.responseText;
        };
        xhr.open('DELETE', '/deleteTutor');
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.send(payLoad);
        
    } else {
    alert("Por favor llena todos los campos antes de enviar la información");
  }
}


/*------------------------ Gráficas generales --------------------------------*/

usersCountry();
scoreAverage();
ageAverage();
ctryLeaderboard();
scoreAge();
ctryLogin();


function usersCountry() {
  const xhr = new XMLHttpRequest();
  const url = 'http://3.219.153.3:8080/countryUser';
  xhr.onload = () => {
    const labels = [];
    const data = [];
    const result = JSON.parse(xhr.responseText);
    for (let i of result['table']) {
        labels.push(i['Nombre']);
        data.push(i['TotalUsuarios']);
    }
    
    const ctx = countryChart;
    new Chart(ctx, {
      type: 'pie',
      data: {
        labels: labels,
        datasets: [{
          label: "Usuarios por país",
          data: data
        }]
      }
    });
  };
    xhr.open('GET', url);
    xhr.send();
}


function scoreAverage() {
  const xhr = new XMLHttpRequest();
  const url = 'http://3.219.153.3:8080/scoreAverage';
  xhr.onload = () => {
    const labels = [];
    const data = [];
    const result = JSON.parse(xhr.responseText);
    for (let i of result['table']) {
        labels.push(i['IDNivel']);
        data.push(i['Puntaje']);
    }
    
    const ctx = scoreChart;
    new Chart(ctx, {
      type: 'polarArea',
      data: {
        labels: labels,
        datasets: [{
          label: "Puntuación promedio por nivel",
          data: data
        }]
      }
    });
  };
    xhr.open('GET', url);
    xhr.send();
}


function ageAverage() {
  const xhr = new XMLHttpRequest();
  const url = 'http://3.219.153.3:8080/ageAverage';
  xhr.onload = () => {
    const labels = [];
    const data = [];
    const result = JSON.parse(xhr.responseText);
    for (let i of result['table']) {
        labels.push(i['PromEdades']);
        data.push(i['PromEdades']);
    }
    
    const ctx = ageChart;
    new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: labels,
        datasets: [{
          label: "Edad promedio",
          data: data
        }]
      }
    });
  };
    xhr.open('GET', url);
    xhr.send();
}


function ctryLeaderboard() {
  const xhr = new XMLHttpRequest();
  const url = 'http://3.219.153.3:8080/ctryLeaderboard';
  xhr.onload = () => {
    const labels = [];
    const data = [];
    const result = JSON.parse(xhr.responseText);
    for (let i of result['table']) {
        labels.push(i['Nombre']);
        data.push(i['Puntos']);
    }
    
    const ctx = ctryAvChart;
    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: "Puntuación promedio por país",
          data: data
        }]
      }
    });
  };
    xhr.open('GET', url);
    xhr.send();
}


function scoreAge() {
  const xhr = new XMLHttpRequest();
  const url = 'http://3.219.153.3:8080/scoreAge';
  xhr.onload = () => {
    const labels = [];
    const data = [];
    const result = JSON.parse(xhr.responseText);
    for (let i of result['table']) {
        labels.push(i['Edad']);
        data.push(i['Puntos']);
    }
    
    const ctx = ageAvChart;
    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: "Puntuación promedio por edades",
          data: data
        }]
      }
    });
  };
    xhr.open('GET', url);
    xhr.send();
}


function ctryLogin() {
  const xhr = new XMLHttpRequest();
  const url = 'http://3.219.153.3:8080/ctryLogin';
  xhr.onload = () => {
    const labels = [];
    const data = [];
    const result = JSON.parse(xhr.responseText);
    for (let i of result['table']) {
        labels.push(i['Jugador']);
        data.push(i['Visitas']);
    }
    
    const ctx = lowLoginChart;
    new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: labels,
        datasets: [{
          label: "Jugadores con menos Logins",
          data: data
        }]
      }
    });
  };
    xhr.open('GET', url);
    xhr.send();
}