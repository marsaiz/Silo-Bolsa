using Microsoft.EntityFrameworkCore;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Persistencia.Repositorios;

public class SensoresRepositorio
{

    private readonly SiloBolsaContexto _siloBolsaContexto;

    public SensoresRepositorio()
    {
        _siloBolsaContexto = SiloBolsaContexto.CrearInstancia();
    }

    internal List<Sensores> ObtenerDatos()
    {
        return _siloBolsaContexto.Sensores.ToList();
    }

    public List<Sensores> ListarId()
    {
        return _siloBolsaContexto.Sensores.Include(d => d.IdCaja).ToList();
    }
}
