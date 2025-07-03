using Microsoft.Extensions.Hosting;
using System;
using System.Threading;
using System.Threading.Tasks;
using SiloBolsa.Servicios.Negocio; // Asegúrate de usar el espacio de nombres correcto
using SiloBolsa.Core.Modelos;  // Donde estén tus modelos de Silo, Lectura, etc.
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using SiloBolsa.Servicios.Interfaces;

namespace SiloBolsa.Servicios;

public class AnalisisAlertasBackgroundService : BackgroundService
{
    //private readonly LecturaServicio _lecturaServicio;
    //private readonly SiloServicio _siloServicio;
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly ILogger<AnalisisAlertasBackgroundService> _logger;
    private readonly TimeSpan _intervalo;

    //El constructor inyecta el SiloServicio y el logger para registrar eventos
    public AnalisisAlertasBackgroundService(ILogger<AnalisisAlertasBackgroundService> logger, IServiceScopeFactory scopeFactory)
    {
        //_lecturaServicio = lecturaServicio;
        ///_siloServicio = siloServicio;
        _scopeFactory = scopeFactory;
        _logger = logger;
        _intervalo = TimeSpan.FromMinutes(30); // Aquí se define el intervalo de ejecución (ejemplo cada 10 minutos)
    }

    //El método ExecuteAsync ejecuta el código en segundo plano
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        //Mientras la aplicacón este en ejecución, ese bucle se repetirá
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                _logger.LogInformation("Iniciando analisis de condiciones para todos los Silos");

                //obtener todos los silos y analizar sus lecturas para deterinar si se deben generar alertas
                //var silos = _scopeFactory.GetSilos();
                using (var scope = _scopeFactory.CreateScope())
                {
                    var siloServicio = scope.ServiceProvider.GetRequiredService<ISiloServicio>();
                    var lecturaServicio = scope.ServiceProvider.GetRequiredService<ILecturaServicio>();

                    var silos = siloServicio.GetSilos();

                    foreach (var silo in silos)
                    {
                        lecturaServicio.AnalizarCondicionesYGenerarAlertas(silo.IdSilo);
                    }
                }
                _logger.LogInformation("Análisis completado.");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error durante el analisis de condindiones.");
            }
            //Esperar el intervalo antes de ejecutar nuevamente
            await Task.Delay(_intervalo, stoppingToken);
        }
    }
}