using SiloBolsa.Core.Modelos;
using SiloBolsa.Persistencia.Repositorios;

namespace SiloBolsa.Persistencia.Negocio;

public class LecturaServicio
{
    private readonly LecturaRepositorio _lecturaServicio;

    public LecturaServicio()
    {
        _lecturaServicio = new LecturaRepositorio();
    }

    public List<Lectura> ObtenerTemperatura()
    {
        return _lecturaServicio.MostrarTemperatura();
    }
}