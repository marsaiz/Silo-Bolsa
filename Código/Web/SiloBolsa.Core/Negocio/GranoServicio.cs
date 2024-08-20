using SiloBolsa.Core.Modelos;
using SiloBolsa.Persistencia.Repositorios;

namespace SiloBolsa.Persistencia.Negocio;

public class GranoServicio
{
    private readonly GranoRepositorio _granoServicio;

    public GranoServicio()
    {
        _granoServicio = new GranoRepositorio();
    }

    public List<Grano> MostrarDescripcion()
    {
        return _granoServicio.MostrarDescripcion();
    }
}