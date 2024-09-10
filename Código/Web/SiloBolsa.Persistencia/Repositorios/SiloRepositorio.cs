using Microsoft.EntityFrameworkCore;
using SiloBolsa.Persistencia.Modelos;

namespace SiloBolsa.Persistencia.Repositorios;

public class SiloRepositorio
{

    private readonly SiloBolsaContexto _siloBolsaContexto;

     public IEnumerable<Silo> GetSilos()
    {
        return _siloBolsaContexto.Silos.ToList();
    }

    public Silo GetSiloById(Guid id_silo)
    {
        return _siloBolsaContexto.Silos.Find(id_silo);
    }

    public void AddSilo(Silo silo)
    {
        _siloBolsaContexto.Silos.Add(silo);
        _siloBolsaContexto.SaveChanges();
    }

    public void UpdateSilo (Silo silo)
    {
        throw new NotImplementedException();
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

    /* public SiloRepositorio()
    {
        _siloBolsaContexto = SiloBolsaContexto.CrearInstancia();
    }

    public List<Silo> ObtenerDato()
    {
        return _siloBolsaContexto.Silos.ToList();
    }

    public List<Silo> ListarSilos()
    {
        //return _siloBolsaContexto.Silos.Include(a => ((Silo)a).IdSilo).ToList();
        return _siloBolsaContexto.Silos.ToList();
    }

    public List<Silo> ListarSilosPorNombre(string descripcion)
    {
        return _siloBolsaContexto.Silos.Where(d => d.Descripcion.ToLower().Contains(descripcion.ToLower())).ToList();
    }
    public void CrearSilo(Silo silo)
    {
        _siloBolsaContexto.Silos.Add(silo);
        _siloBolsaContexto.SaveChanges();
    } */
}
