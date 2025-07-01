using Microsoft.EntityFrameworkCore;
using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Persistencia.Repositorios;

public class SiloRepositorio : ISiloRepositorio
{

    private readonly SiloBolsaContexto _siloBolsaContexto;

    public SiloRepositorio(SiloBolsaContexto siloBolsaContexto)
    {
        _siloBolsaContexto = siloBolsaContexto ?? throw new ArgumentNullException(nameof(siloBolsaContexto));
    }

    public IEnumerable<Silo> GetSilos()
    {
        return _siloBolsaContexto.Silos.ToList();
    }

    public Silo GetSiloById(Guid id_silo)
    {
        return _siloBolsaContexto.Silos
            .Include(s => s.GranoSilo)
            .FirstOrDefault(s => s.IdSilo == id_silo);
    }

    public void AddSilo(Silo silo)
    {
        _siloBolsaContexto.Silos.Add(silo);
        _siloBolsaContexto.SaveChanges();
    }

    public void UpdateSilo (Silo silo)
    {
        _siloBolsaContexto.Silos.Update(silo);
        _siloBolsaContexto.SaveChanges();
    }
    public void DeleteSilo(Guid id_silo)
    {
        var silo = _siloBolsaContexto.Silos.Find(id_silo);
        if (silo != null)
        {
            _siloBolsaContexto.Silos.Remove(silo);
            _siloBolsaContexto.SaveChanges();
        }
    }
}
