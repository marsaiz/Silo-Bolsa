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
    //alert(`Consultando reportes de ${tipo}...`);

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

                //LLenar los datos para la tabla
                const tableData = items.map((entry, index) => ({
                    id: index +1,
                    fechaHora: new Date(entry.fechaHoraLectura).toLocaleString(),
                    temperatura: entry.temp,
                    humedad: entry.humedad,
                    co2: entry.dioxidoDeCarbono,
                }));

                //Crear o actualizar la tabla con tabulator
                new Tabulator("#tablaLecturas", {
                    data: tableData,
                    layout: "fitColumns",
                    columns: [
                        { title: "ID", field: "id", width: 50},
                        { title: "Fecha y Hora", field: "fechaHora", sorter: "datetime", aling: "enter",
                            sorterParams: {
                                format: "DD/MM/YYYY HH:mm:ss", //Ajusta el formato según la entrada de fecha
                                alignEmptyValues: "bottom"
                            }
                        },
                        { title: "Temperatura (Cº)", field: "temperatura", aling: "center"},
                        { title: "Humedad", field: "humedad", aling: "center"},
                        { title: "CO2 (ppm)", field: "co2", aling: "center"},
                    ],
                });
            } else {
                console.warn("No se pudieron cargar datos válidos para el gráfico.");
            }
        })
        .catch(error => console.error('Error al obtener los datos de la API:', error));
}

function cargarGranos() {
    const tablaGranos = document.getElementById("tablaGranos");

    //Verificar que la tabla este visible
    if (tablaGranos.style.display == "none"){
        //Muestra la tabla granos
        tablaGranos.style.display = "block";

    // Llama a la API para obtener datos de granos
    fetch('http://77.81.230.76:5096/api/granos')
        .then(response => response.json())
        .then(data => {
            console.log(data);

            const items = Array.isArray(data.$values) ? data.$values : [];
            
            // Mapea los datos a un formato adecuado para Tabulator
            const tableData = items.map((entry, index) => ({
                id: entry.id,
                descripcion: entry.descripcion,
                humedadMax: entry.humedadMax,
                humedadMin: entry.humedadMin,
                tempMax: entry.tempMax,
                tempMin: entry.tempMin,
                nivelDioxidoMax: entry.nivelDioxidoMax,
                nivelDioxidoMin: entry.nivelDioxidoMin,
            }));

            new Tabulator('#tablaGranos', {
                data: tableData,
                layout: "fitColumns",
                columns: [
                    { title: "ID Grano", field: "id" },
                    { title: "Descripción", field: "descripcion" },
                    { title: "Humedad Máxima", field: "humedadMax", align: "center" },
                    { title: "Humedad Mínima", field: "humedadMin", align: "center" },
                    { title: "Temperatura Máxima (°C)", field: "tempMax", align: "center" },
                    { title: "Temperatura Mínima (°C)", field: "tempMin", align: "center" },
                    { title: "CO2 Máximo (ppm)", field: "nivelDioxidoMax", align: "center" },
                    { title: "CO2 Mínimo (ppm)", field: "nivelDioxidoMin", align: "center" },
                ],
            });
        })
        .catch(error => console.error('Error al obtener los datos de granos:', error));
    } else {
        //Oculta la tabla si esta visible
        tablaGranos.style.display = "none";
    }
}

function cargarSilos() {
    const tablaSilos = document.getElementById("tablaSilos");

    if (tablaSilos.style.display == "none") {
        tablaSilos.style.display = "block";

        fetch('http://77.81.230.76:5096/api/silos')
            .then(response => response.json())
            .then(data => {
                console.log(data)
                const items = Array.isArray(data.$values) ? data.$values : [];

                const tableData = items.map((entry, index) => ({
                    id: entry.id,
                    latitud: entry.latitud,
                    longitud: entry.longitud,
                    capacidad: entry.capacidad,
                    tipoGrano: entry.tipoGrano,
                    descripcion: entry.descripcion,
                }));
            new Tabulator('#tablaSilos', {
                data: tableData,
                layout: "fitColumns",
                columns: [
                    { title: "ID Silo", field: "id" },
                    { title: "Latitud", field: "latitud" },
                    { title: "Longitud", field: "longitud" },
                    { title: "Capacidad", field: "capacidad" },
                    { title: "Tipo Grano", field: "tipoGrano" },
                    { title: "Descripción", field: "descripcion" },
                ],
            });
        })
        .catch(error => console.error('Error al obtener los datos de silos'));
   } else {
    tablaSilos.style.display = 'none';
   } 
}

// Llama a la función al cargar la página o al hacer clic en el menú
//cargarGranos();

function cargarAlertas() {
    const tablaAlertas = document.getElementById("tablaAlertas");

    if (tablaAlertas.style.display == "none") {
        tablaAlertas.style.display = "block";

        fetch('http://77.81.230.76:5096/api/alertas')
            .then(response => response.json())
            .then(data => {
                console.log(data)
                const items = Array.isArray(data.$values) ? data.$values : [];

                const tableData = items.map((entry, index) => ({
                    id: entry.idAlerta,
                    fechaHoraAlerta: entry.fechaHoraAlerta,
                    mensaje: entry.mensaje,
                    idSilo: entry.idSilo,
                    correoEnviado: entry.correoEnviado,
                }));
            new Tabulator('#tablaAlertas', {
                data: tableData,
                layout: "fitColumns",
                columns: [
                    { title: "ID Alerta", field: "idAlerta" },
                    { title: "Fecha y Hora de la Alerta", field: "fechaHoraAlerta" },
                    { title: "Mensaje", field: "mensaje" },
                    { title: "Id Silo", field: "idSilo" },
                    { title: "Correo Enviado", field: "correoEnviado" },
                ],
            });
        })
        .catch(error => console.error('Error al obtener los datos de silos'));
   } else {
    tablaAlertas.style.display = 'none';
   } 
}