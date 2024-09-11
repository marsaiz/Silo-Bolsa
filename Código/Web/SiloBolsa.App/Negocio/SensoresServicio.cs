using SiloBolsa.Core.Interfaces;
using SiloBolsa.Core.Modelos;
using SiloBolsa.Persistencia.Repositorios;

namespace SiloBolsa.App.Negocio;

public class SensoresServicio
{
    private readonly ISensoresRepositorio _sensoresReposiorio;

    public SensoresServicio(ISensoresRepositorio sensoresRepositorio)
    {
        _sensoresReposiorio = sensoresRepositorio;
    }

    public List<Sensores> ObtenerDatos()
    {
        return _sensoresReposiorio.GetSensores().ToList();
    }
}
