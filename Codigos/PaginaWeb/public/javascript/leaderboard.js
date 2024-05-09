/*global leaderboard leaderboardChart*/

createLeaderboard();


function changePage(n) {
  const params = new URLSearchParams(window.location.search);
  let page = parseInt(params.get('page') ?? 1);
  page += n;
  params.set('page', page);
  window.location.search = params;
}


function createLeaderboard() {
  const params = new URLSearchParams(window.location.search);
  const page = params.get('page') ?? 1;
  
  const xhr = new XMLHttpRequest();
  const url = `http://3.219.153.3:8080/puntuaciones/${page}`;
  xhr.onload = () => {
    const labels = [];
    const data = [];
    const result = JSON.parse(xhr.responseText);
    const table = leaderboard;
    for (let i of result['table']) {
      let row = table.insertRow(-1);
      let cell1 = row.insertCell(0);
      let cell2 = row.insertCell(1);
      let cell3 = row.insertCell(2);
      let cell4 = row.insertCell(3);
      cell1.innerHTML = i['Place'];
      cell2.innerHTML = i['GamerTag'];
      cell3.innerHTML = i['Puntos'];
      cell4.innerHTML = i['Nombre'];
      // Construcción de la tabla
      labels.push(i['GamerTag']);
      data.push(i['Puntos']);
    }
    
    // Construcción de la tabla
    const ctx = leaderboardChart;
    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: 'Puntuaciones',
          data: data
        }]
      }
    });
  };
  xhr.open('GET', url);
  xhr.send();
}

