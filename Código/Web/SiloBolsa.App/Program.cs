using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using SiloBolsa.App.Negocio;
using SiloBolsa.App.Pantallas;
using SiloBolsa.Persistencia.Repositorios;
using SiloBolsa.Core.Interfaces;

var host = Host.CreateDefaultBuilder(args)
    .ConfigureServices((context, services) =>
    {
        // Registrar los servicios
        services.AddScoped<AlertaServicio>();
        services.AddScoped<SiloServicio>();

        // Registrar los repositorios
        services.AddScoped<IAlertaRepositorio, AlertaRepositorio>();
        services.AddScoped<ISiloRepositorio, SiloRepositorio>();

        // Registrar las pantallas
        services.AddScoped<PantallaAgregarSilo>();
        services.AddScoped<PantallaConsultarSilo>();
        services.AddScoped<PantallaAgregarAlerta>();
        services.AddScoped<PantallaConsultarAlerta>();
        services.AddScoped<PantallaPrincipal>();
    })
    .Build();

// Obtener la instancia de PantallaPrincipal
var pantallaPrincipal = host.Services.GetRequiredService<PantallaPrincipal>();
pantallaPrincipal.MostrarPantallaPrincial();
