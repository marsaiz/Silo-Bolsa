using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;
using System.Runtime.CompilerServices;
using Microsoft.Extensions.Logging;


namespace SiloBolsa.Servicios.Negocio;

public class LecturaServicio : ILecturaServicio
{

    // 1. Buscar el Grano para obenter Max y Min
    // 2. Grabar en Base de datos la lectura.
    // 3. Analizar los datos
    // 4- Enviar la alerta

    private ISiloRepositorio _siloRepositorio;
    private IAlertaRepositorio _alertaRepositorio;
    private ILecturaRepositorio _lecturaRepositorio;
    private ICajaRepositorio _cajaRepositorio;
    private readonly ILogger<AnalisisAlertasBackgroundService> _logger;

    public LecturaServicio(ISiloRepositorio siloRepositorio, IAlertaRepositorio alertaRepositorio, ILecturaRepositorio lecturaRepositorio, ICajaRepositorio cajaRepositorio, ILogger<AnalisisAlertasBackgroundService> logger)
    {
        _lecturaRepositorio = lecturaRepositorio;
        _cajaRepositorio = cajaRepositorio;
        _alertaRepositorio = alertaRepositorio;
        _siloRepositorio = siloRepositorio;
        _logger = logger ?? throw new ArgumentNullException(nameof(logger)); //Validación
    }
    public void AddLectura(LecturaDTO lecturaDTO)
    {
        Lectura lectura = new Lectura();
        lectura.IdLectura = Guid.NewGuid();
        lectura.FechaHoraLectura = lecturaDTO.FechaHoraLectura;
        lectura.Temp = lecturaDTO.Temp;
        lectura.Humedad = lecturaDTO.Humedad;
        lectura.DioxidoDeCarbono = lecturaDTO.DioxidoDeCarbono;
        lectura.IdCaja = lecturaDTO.IdCaja;

        _lecturaRepositorio.AddLectura(lectura);
    }

    public void DeleteLectura(Guid id_lectura)
    {
        _lecturaRepositorio.DeleteLectura(id_lectura);
    }

    public Lectura GetLecturaById(Guid id_lectura)
    {
        return _lecturaRepositorio.GetLecturaById(id_lectura);
    }

    public IEnumerable<Lectura> GetLecturasByIdSilo(Guid id_silo)
    {
        return _lecturaRepositorio.GetLecturasByIdSilo(id_silo);
    }

    public IEnumerable<Lectura> GetLecturas()
    {
        return _lecturaRepositorio.GetLecturas();
    }

    public void AnalizarCondicionesYGenerarAlertas(Guid id_silo)
    {
        var silo = _siloRepositorio.GetSiloById(id_silo);

        if (silo == null)
        {
            throw new Exception("Silo no encontrado");
        }

        var lecturas = GetLecturasByIdSilo(id_silo);

        if (lecturas == null || !lecturas.Any())
        {
            _logger.LogWarning($"No se encontraron lecturas para el silo {silo.Descripcion}.");
            return; //Salir si no hay lecturas
        }

        _logger.LogInformation($"Analizando lecturas para el silo {silo.Descripcion}.");
        _logger.LogInformation($"Lecturas: {lecturas.Count()} lecturas encontradas.");

        var grano = silo.GranoSilo;//Obtener el grano a travez del silo
        
        if (grano == null || string.IsNullOrWhiteSpace(grano.Descripcion))
        {
            _logger.LogError($"No se ha encontrado información sobre el grano en el silo: {silo.Descripcion}");
            throw new Exception($"No se ha encontrado información sobre el grano en el silo {silo.Descripcion}");
        }

        _logger.LogInformation($"Grano del silo: {grano?.Descripcion ?? "Sin asignar"}.");

        foreach (var lectura in lecturas)
        {
            if (lectura.Temp > grano.TempMax || lectura.Temp < grano.TempMin ||
                lectura.Humedad > grano.HumedadMax || lectura.Humedad < grano.HumedadMin)
            {
                //crear una nueva alerta si las condiciones son extremas
                var alerta = new Alerta
                {
                    IdAlerta = Guid.NewGuid(),
                    FechaHoraAlerta = DateTime.UtcNow,
                    Mensaje = $"Condiciones extremas en el silo {silo.Descripcion}",
                    IdSilo = silo.IdSilo,
                    Silo = silo
                };
                _alertaRepositorio.AddAlerta(alerta);
            }
        }
        _alertaRepositorio.SaveChanges();
    }
    /* public void UpdateLectura(LecturaDTO lecturaDTO)
    {
        var lecturaExistente = _lecturaRepositorio.GetLecturaById(lecturaDTO.IdLectura);

        if(lecturaExistente == null)
        {
            throw new Exception("La lectura no existe");
        }

        lecturaExistente.FechaHoraLectura = lecturaDTO.FechaHoraLectura;
        lecturaExistente.Temp = lecturaDTO.Temp;
        lecturaExistente.Humedad = lecturaDTO.Humedad;
        lecturaExistente.DioxidoDeCarbono = lecturaDTO.DioxidoDeCarbono;
        lecturaExistente.IdCaja = lecturaDTO.IdCaja;

        _lecturaRepositorio.UpdateLectura(lecturaExistente);
    } */
}