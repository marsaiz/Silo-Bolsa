using Microsoft.EntityFrameworkCore;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Persistencia.Repositorios;

public class GranoRepositorio
{
    private readonly SiloBolsaContexto _siloBolsaContexto;

    public GranoRepositorio()
    {
        _siloBolsaContexto = SiloBolsaContexto.CrearInstancia();
    }

    internal List<Grano> ObtenerDatos()
    {
        return _siloBolsaContexto.Granos.ToList();
    }

    public List<Grano> MostrarDescripcion()
    {
        return _siloBolsaContexto.Granos.Include(d => d.Descripcion).ToList();
    }
}