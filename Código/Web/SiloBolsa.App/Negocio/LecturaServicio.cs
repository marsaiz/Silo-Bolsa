using SiloBolsa.Core.Interfaces;
using SiloBolsa.Core.Modelos;
using SiloBolsa.Persistencia.Repositorios;

namespace SiloBolsa.App.Negocio;

public class LecturaServicio
{
    private readonly ILecturaRepositorio _lecturaRepositorio;

    public LecturaServicio(ILecturaRepositorio lecturaRepositorio)
    {
        _lecturaRepositorio = lecturaRepositorio;
    }

    public List<Lectura> ObtenerTemperatura()
    {
        return _lecturaRepositorio.GetLecturas().ToList();
    }
}