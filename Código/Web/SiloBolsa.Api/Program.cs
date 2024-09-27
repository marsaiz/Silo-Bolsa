using SiloBolsa.Persistencia.Repositorios;
using SiloBolsa.Servicios.Interfaces;
using Microsoft.Extensions.Options;
using Microsoft.EntityFrameworkCore;
using SiloBolsa.Servicios.Negocio;


var builder = WebApplication.CreateBuilder(args);

//Obtener la conexión desde appsetings.json
var conexionString =
builder.Configuration.GetConnectionString("DefaultConnection");

//Registrar SiloBolsaContexto con Postresql
builder.Services.AddDbContext<SiloBolsaContexto>(Options =>
    Options.UseNpgsql(conexionString));


// Add services to the container.
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


builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddCors(p => p.AddPolicy("corsapp",
    builder => { builder.WithOrigins("*").AllowAnyMethod().AllowAnyHeader(); }));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseCors("corsapp");
app.UseHttpsRedirection();
app.UseAuthorization();

app.MapControllers();


var summaries = new[]
{
    "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
};

app.MapGet("/weatherforecast", () =>
{
    var forecast =  Enumerable.Range(1, 5).Select(index =>
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

app.Run();

record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
{
    public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
}
