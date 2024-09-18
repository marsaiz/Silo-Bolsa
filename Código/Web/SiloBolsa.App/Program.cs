using Microsoft.Extensions.DependencyInjection;
using SiloBolsa.App.Negocio;
using SiloBolsa.App.Pantallas;
using SiloBolsa.Persistencia.Repositorios;
using SiloBolsa.Core.Interfaces;
using Microsoft.Extensions.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using SiloBolsa.App.Pantallas;

class Program
{
    static void Main(string[] args)
    {
        // Crear el host genérico
        var host = Host.CreateDefaultBuilder(args)
            .ConfigureServices((context, services) =>
            {
                // Obtener la cadena de conexión desde appsettings.json
                var conexionString = context.Configuration.GetConnectionString("DefaultConnection");

                // Registrar SiloBolsaContexto con PostgreSQL
                services.AddDbContext<SiloBolsaContexto>(options =>
                    options.UseNpgsql(conexionString));

                // Registrar los repositorios e interfaces
                services.AddScoped<IAlertaRepositorio, AlertaRepositorio>();
                services.AddScoped<IGranoRepositorio, GranoRepositorio>();
                services.AddScoped<ILecturaRepositorio, LecturaRepositorio>();
                services.AddScoped<ISensoresRepositorio, SensoresRepositorio>();
                services.AddScoped<ISiloRepositorio, SiloRepositorio>();

                // Otras configuraciones adicionales si es necesario
                // Registrar todas las dependencias necesarias
                services.AddTransient<PantallaPrincipal>();
                services.AddTransient<PantallaAgregarSilo>();
                services.AddTransient<PantallaConsultarSilo>();
                services.AddTransient<PantallaConsultarAlerta>();
                services.AddTransient<PantallaAgregarAlerta>();

                // Aquí puedes agregar también tus repositorios, contextos de base de datos, etc.
            })
            .Build();

        // Iniciar la aplicación con PantallaPrincipal
        var pantallaPrincipal = host.Services.GetRequiredService<PantallaPrincipal>();
        pantallaPrincipal.MostrarPantallaPrincial();
    }
}


/* var host = Host.CreateDefaultBuilder(args)
    .ConfigureServices((SiloBolsaContexto, services) =>
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
 */
// Obtener la instancia de PantallaPrincipal
//var pantallaPrincipal = host.Services.GetRequiredService<PantallaPrincipal>();
//pantallaPrincipal.MostrarPantallaPrincial();
