using Microsoft.EntityFrameworkCore;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Persistencia.Repositorios;

public class LecturaRepositorio
{
    private readonly SiloBolsaContexto _siloBolsaContexto;

    public LecturaRepositorio()
    {
        _siloBolsaContexto = SiloBolsaContexto.CrearInstancia();
    }

    internal List<Lectura> ObtenerLectura()
    {
        return _siloBolsaContexto.Lecturas.ToList();
    }

    public List<Lectura> MostrarTemperatura()
    {
        return _siloBolsaContexto.Lecturas.Include(d => d.Temp).ToList();
    }
}
