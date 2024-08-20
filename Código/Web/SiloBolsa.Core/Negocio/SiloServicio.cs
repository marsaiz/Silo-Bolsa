using SiloBolsa.Core.Modelos;
using SiloBolsa.Persistencia.Repositorios;


namespace SiloBolsa.Core.Negocio;

public class SiloServicio
{
    private readonly SiloRepositorio _siloServicio;

    public SiloServicio()
    {
        _siloServicio = new SiloRepositorio();
    }

    public List<Silo> ObtenerDato()
    {
        return _siloServicio.ListarId();
    }
}
