using SiloBolsa.Persistencia.Repositorios;
using SiloBolsa.Servicios.Interfaces;
using Microsoft.Extensions.Options;
using Microsoft.EntityFrameworkCore;
using SiloBolsa.Servicios.Negocio;
using SiloBolsa.Servicios;

//El servicio de logging esta configurado automaticamente por el WebApplicationBuilder
// Trigger redeploy (no-op): 2025-11-14 19:58 UTC
// Trigger redeploy 2 (no-op): 2025-11-14 20:08 UTC
var builder = WebApplication.CreateBuilder(args);

builder.Logging.ClearProviders(); //Limpiar los providers por defecto si no los quieres
builder.Logging.AddConsole(); //Agregar logging en la consola
builder.Logging.AddDebug(); //Agregar logging para el debug(util en desarrollo)

builder.Logging.AddFilter("Microsoft", LogLevel.Warning)
                .AddFilter("System", LogLevel.Warning)
                .AddFilter("SiloBolsa", LogLevel.Information);

//Obtener la conexión desde variables de entorno o appsetings.json
// Railway inyecta las variables de entorno automáticamente
var conexionString = builder.Configuration.GetConnectionString("DefaultConnection");

// Si Railway provee DATABASE_URL (formato postgresql://), convertirla
var databaseUrl = Environment.GetEnvironmentVariable("DATABASE_URL");
if (!string.IsNullOrEmpty(databaseUrl))
{
    // Railway usa formato: postgresql://user:password@host:port/database
    var uri = new Uri(databaseUrl);
    conexionString = $"Host={uri.Host};Port={uri.Port};Database={uri.AbsolutePath.Trim('/')};User Id={uri.UserInfo.Split(':')[0]};Password={uri.UserInfo.Split(':')[1]};SSL Mode=Require;Trust Server Certificate=true";
}

Console.WriteLine($"🔌 Conectando a base de datos: {conexionString?.Split(';')[0]}");

//Registrar SiloBolsaContexto con Postresql
builder.Services.AddDbContext<SiloBolsaContexto>(Options =>
    Options.UseNpgsql(conexionString));

// Agregar EmailSettings a partir de appsettings.json
builder.Services.Configure<EmailSettings>(builder.Configuration.GetSection("EmailSettings"));

//Registrar el servicio de Email
builder.Services.AddScoped<IEmailServices, EmailServices>();
builder.Services.AddScoped<IEmailServicesSMTP, EmailServiceSMTP>();

// Add services to the container. cada Scope se crea cuando hay una llamada HTTP
builder.Services.AddScoped<IAlertaRepositorio, AlertaRepositorio>();
builder.Services.AddScoped<IGranoRepositorio, GranoRepositorio>();
builder.Services.AddScoped<ILecturaRepositorio, LecturaRepositorio>();
builder.Services.AddScoped<ICajaRepositorio, CajaRepositorio>();
builder.Services.AddScoped<ISiloRepositorio, SiloRepositorio>();
builder.Services.AddScoped<IAlertaServicio, AlertaServicio>();
builder.Services.AddScoped<ICajaServicio, CajaServicio>();
builder.Services.AddScoped<IGranoServicio, GranoServicio>();
builder.Services.AddScoped<ILecturaServicio, LecturaServicio>();
builder.Services.AddScoped<ISiloServicio, SiloServicio>();



builder.Services.AddControllers()
    .AddJsonOptions(options =>
{
    options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.Preserve;
});

//builder.Services.AddSingleton<LecturaRepositorio>(); //no se puede correr un Scoped y un Singleton
builder.Services.AddHostedService<AnalisisAlertasBackgroundService>();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddCors(p => p.AddPolicy("corsapp",
    builder => { builder.WithOrigins("*").AllowAnyMethod().AllowAnyHeader(); }));

var app = builder.Build();

// 🔧 Aplicar migraciones automáticamente al iniciar
// Esto aplica todas las migraciones pendientes a la base de datos
try
{
    using (var scope = app.Services.CreateScope())
    {
        var dbContext = scope.ServiceProvider.GetRequiredService<SiloBolsaContexto>();
        var logger = scope.ServiceProvider.GetRequiredService<ILogger<Program>>();
        
        logger.LogInformation("🔍 Verificando migraciones pendientes...");
        
        // Aplicar migraciones automáticamente
        dbContext.Database.Migrate();
        
        logger.LogInformation("✅ Migraciones aplicadas exitosamente!");
    }
}
catch (Exception ex)
{
    var logger = app.Services.GetRequiredService<ILogger<Program>>();
    logger.LogError(ex, "❌ Error al aplicar migraciones: {Message}", ex.Message);
    throw;
}

//Habilitar archivos estáticos (servir index.html, CSS, etc.)
app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = new Microsoft.Extensions.FileProviders.PhysicalFileProvider(
        System.IO.Path.Combine(System.IO.Directory.GetCurrentDirectory(), "paginaWeb")),
    RequestPath = ""
});

//Ruta por defecto que devolvera el archivo index.html
app.UseDefaultFiles();
app.UseStaticFiles();

// Servir explicitamente Flutter Web en /flutter desde wwwroot/flutter
var flutterWebRoot = System.IO.Path.Combine(System.IO.Directory.GetCurrentDirectory(), "wwwroot", "flutter");
if (System.IO.Directory.Exists(flutterWebRoot))
{
    var defaultFlutter = new DefaultFilesOptions
    {
        FileProvider = new Microsoft.Extensions.FileProviders.PhysicalFileProvider(flutterWebRoot),
        RequestPath = "/flutter"
    };
    // Asegurar que busque index.html por defecto
    defaultFlutter.DefaultFileNames.Clear();
    defaultFlutter.DefaultFileNames.Add("index.html");
    app.UseDefaultFiles(defaultFlutter);

    var contentTypes = new Microsoft.AspNetCore.StaticFiles.FileExtensionContentTypeProvider();
    if (!contentTypes.Mappings.ContainsKey(".wasm"))
    {
        contentTypes.Mappings.Add(".wasm", "application/wasm");
    }

    app.UseStaticFiles(new StaticFileOptions
    {
        FileProvider = new Microsoft.Extensions.FileProviders.PhysicalFileProvider(flutterWebRoot),
        RequestPath = "/flutter",
        ContentTypeProvider = contentTypes
    });
}

// Configure the HTTP request pipeline.
/* if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
} */

app.UseSwagger();
app.UseSwaggerUI();


app.UseCors("corsapp");
app.UseHttpsRedirection();
app.UseAuthorization();
app.UseStaticFiles(); // Asegúrate de que esta línea esté presente para servir archivos estáticos


app.MapControllers();


var summaries = new[]
{
    "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
};

app.MapGet("/weatherforecast", () =>
{
    var forecast = Enumerable.Range(1, 5).Select(index =>
        new WeatherForecast
        (
            DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            Random.Shared.Next(-20, 55),
            summaries[Random.Shared.Next(summaries.Length)]
        ))
        .ToArray();
    return forecast;
})
.WithName("GetWeatherForecast")
.WithOpenApi();

var port = Environment.GetEnvironmentVariable("PORT") ?? "8080";
app.Run($"http://0.0.0.0:{port}");
record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
{
    public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
}

// Deploy trigger: 2025-11-10 16:45 - Flutter threshold fixes
