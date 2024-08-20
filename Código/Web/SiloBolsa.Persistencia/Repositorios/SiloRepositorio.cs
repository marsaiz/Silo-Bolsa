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

    internal List<Silo> ObtenerDato()
    {
        return _siloBolsaContexto.Silos.ToList();
    }

    public List<Silo> ListarId()
    {
        return _siloBolsaContexto.Silos.Include(d => d.IdSilo).ToList();
    }
}
