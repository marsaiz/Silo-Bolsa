using SiloBolsa.Core.Modelos;
using SiloBolsa.Persistencia.Repositorios;

namespace SiloBolsa.Core.Negocio;

public class SensoresServicio
{
    private readonly SensoresRepositorio _sensoresServicio;

    public SensoresServicio()
    {
        _sensoresServicio = new SensoresRepositorio();
    }

    public List<Sensores> ObtenerDatos()
    {
        return _sensoresServicio.ListarId();
    }
}
