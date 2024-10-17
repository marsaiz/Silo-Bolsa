using Microsoft.EntityFrameworkCore;
using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;


namespace SiloBolsa.Persistencia.Repositorios;

public class LecturaRepositorio : ILecturaRepositorio
{
    private readonly SiloBolsaContexto _siloBolsaContexto;

    public LecturaRepositorio(SiloBolsaContexto siloBolsaContexto)
    {
        _siloBolsaContexto = siloBolsaContexto;
    }

    public IEnumerable<Lectura> GetLecturas()
    {
        return _siloBolsaContexto.Lecturas.ToList();
    }

    public Lectura GetLecturaById(Guid id_lectura)
    {
        return _siloBolsaContexto.Lecturas.Find(id_lectura);
    }

    public void AddLectura(Lectura lectura)
    {
        _siloBolsaContexto.Lecturas.Add(lectura);
        _siloBolsaContexto.SaveChanges();
    }

    /* public void UpdateLectura(Lectura lectura)
    {
        _siloBolsaContexto.Lecturas.Update(lectura);
        _siloBolsaContexto.SaveChanges();
    }
 */    public void DeleteLectura(Guid id_lectura)
    {
        var lectura = _siloBolsaContexto.Lecturas.Find(id_lectura);
        if (lectura != null)
        {
            _siloBolsaContexto.Lecturas.Remove(lectura);
            _siloBolsaContexto.SaveChanges();
        }
    }
    public IEnumerable<Lectura> GetLecturasByIdSilo(Guid id_silo)
    {
        return _siloBolsaContexto.Lecturas
        .Include(l => l.Caja)
        .ThenInclude(c => c.Silo)
        .Where(l => l.Caja != null && l.Caja.Silo != null && l.Caja.Silo.IdSilo == id_silo)
        .ToList();
    }

    public void AnalizarCondicionesYGenerarAlertas(Guid id_silo)
    {
        var lecturas = GetLecturasByIdSilo(id_silo);
        var silo = _siloBolsaContexto.Silos.Include(s => s.GranoSilo).FirstOrDefault(s => s.IdSilo == id_silo);

        if (silo == null)
        {
            throw new Exception("Silo no encontrado");
        }

        var grano = silo.GranoSilo;//Obtener el grano a travez del silo

        foreach (var lectura in lecturas)
        {
            if (lectura.Temp > grano.TempMax || lectura.Temp < grano.TempMin ||
                lectura.Humedad > grano.HumedadMax || lectura.Humedad < grano.HumedadMin)
            {
                //crear una nueva alerta si las condiciones son extremas
                var alerta = new Alerta
                {
                    IdAlerta = Guid.NewGuid(),
                    FechaHoraAlerta = DateTime.Now,
                    Mensaje = $"Condiciones extremas en el silo {silo.Descripcion}",
                    IdSilo = silo.IdSilo,
                    Silo = silo
                };
                _siloBolsaContexto.Alertas.Add(alerta);
            }
        }
        _siloBolsaContexto.SaveChanges();
    }
}
