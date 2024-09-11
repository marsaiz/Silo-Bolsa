using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using SiloBolsa.App.Negocio;
using SiloBolsa.App.Pantallas;

var host = Host.CreateDefaultBuilder(args)
    .ConfigureServices((context, services) =>
    {
        // Registrar los servicios y dependencias
        services.AddScoped<AlertaServicio>();
        services.AddScoped<SiloServicio>();

        // Registrar pantallas con inyección de dependencias
        services.AddScoped<PantallaAgregarSilo>();
        services.AddScoped<PantallaConsultarSilo>();
        services.AddScoped<PantallaAgregarAlerta>();
        services.AddScoped<PantallaConsultarAlerta>();

        // Registrar la pantalla principal
        services.AddScoped<PantallaPrincipal>();
    })
    .Build();

// Obtener el servicio de PantallaPrincipal desde el contenedor de dependencias
var pantallaPrincipal = host.Services.GetRequiredService<PantallaPrincipal>();

// Ejecutar la aplicación
pantallaPrincipal.MostrarPantallaPrincial();
