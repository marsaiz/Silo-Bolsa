using Microsoft.EntityFrameworkCore;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Persistencia.Repositorios;

public class SiloRepositorio
{

    private readonly SiloBolsaContexto _siloBolsaContexto;

    public SiloRepositorio()
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
    }
}
