/* globals Chart:false, feather:false */

'use strict';

// Inicializa Feather Icons
feather.replace({ 'aria-hidden': 'true' });

const ctx = document.getElementById('myChart').getContext('2d');
const myChart = new Chart(ctx, {
  type: 'line', // Cambia el tipo si es necesario
  data: {
    labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
    datasets: [{
      label: '# of Votes',
      data: [12, 19, 3, 5, 2, 3],
      backgroundColor: 'rgba(255, 99, 132, 0.2)',
      borderColor: 'rgba(255, 99, 132, 1)',
      borderWidth: 1
    }]
  },
  options: {
    scales: {
      y: {
        beginAtZero: true
      }
    }
  }
});


// Definición de la función consultar
function consultar(tipo) {
    // Llama a la API para obtener datos según el tipo
    let apiUrl = 'http://77.81.230.76:5096/api/lecturas';
    let label = '';
    
    switch (tipo) {
        case 'temperatura':
            label = 'Temperatura (ºC)';
            break;
        case 'humedad':
            label = 'Humedad (%)';
            break;
        case 'co2':
            label = 'Niveles de CO2 (ppm)';
            break;
        default:
            console.warn('Tipo de reporte desconocido:', tipo);
            return; // Salir si el tipo no es válido
    }

    // Mostrar mensaje al usuario
    alert(`Consultando reportes de ${tipo}...`);

    // Llama a la API para obtener datos
    fetch(apiUrl)
        .then(response => response.json())
        .then(data => {
            console.log(data);

            const items = Array.isArray(data.$values) ? data.$values : [];

            // Procesar los datos de la API
            const labels = items.map(entry => new Date(entry.fechaHoraLectura).toLocaleString()); // Obtener fechas
            const values = items.map(entry => {
                let value;
                switch (tipo) {
                    case 'temperatura':
                        value = parseFloat(entry.temp); // Obtener temperaturas
                        break;
                    case 'humedad':
                        value = parseFloat(entry.humedad); // Obtener humedad
                        break;
                    case 'co2':
                        value = parseFloat(entry.dioxidoDeCarbono); // Obtener niveles de CO2
                        break;
                }
                if (isNaN(value)) {
                    console.warn(`Valor inválido para ${tipo}:`, entry);
                    return 0;
                }
                return value;
            });

            console.log("Fechas:", labels);
            console.log(`${label}:`, values);

            if (labels.length > 0 && values.length > 0) {
                // Actualizar el gráfico con los datos de la API
                myChart.data.labels = labels;
                myChart.data.datasets[0].label = label; // Establecer el label correcto
                myChart.data.datasets[0].data = values;
                myChart.update();
            } else {
                console.warn("No se pudieron cargar datos válidos para el gráfico.");
            }
        })
        .catch(error => console.error('Error al obtener los datos de la API:', error));
}
