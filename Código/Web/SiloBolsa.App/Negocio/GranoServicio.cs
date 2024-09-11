using SiloBolsa.Core.Interfaces;
using SiloBolsa.Core.Modelos;
using SiloBolsa.Persistencia.Repositorios;

namespace SiloBolsa.App.Negocio;

public class GranoServicio
{
    private readonly IGranoRepositorio _granoRepositorio;
    public GranoServicio(IGranoRepositorio granoRepositorio)
    {
        _granoRepositorio = granoRepositorio;
    }

    public List<Grano> MostrarDescripcion()
    {
        return _granoRepositorio.GetGranos().ToList();
    }
}