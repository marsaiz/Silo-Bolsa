using Microsoft.EntityFrameworkCore;
using SiloBolsa.Persistencia.Modelos;


namespace SiloBolsa.Persistencia.Repositorios;

public class LecturaRepositorio
{
    private readonly SiloBolsaContexto _siloBolsaContexto;

     public IEnumerable<Lectura> GetLecturas()
    {
        return _siloBolsaContexto.Lecturas.ToList();
    }

    public Lectura GetLecturaById(Guid id_lectura)
    {
        return _siloBolsaContexto.Lecturas.Find(id_lectura);
    }

    public void AddLectura(Lectura lectura)
    {
        _siloBolsaContexto.Lecturas.Add(lectura);
        _siloBolsaContexto.SaveChanges();
    }

    public void UpdateLectura (Lectura lectura)
    {
        throw new NotImplementedException();
    }
    public void DeleteLectura(Guid id_lectura)
    {
        var lectura = _siloBolsaContexto.Alertas.Find(id_lectura);
        if (lectura != null)
        {
            _siloBolsaContexto.Alertas.Remove(lectura);
            _siloBolsaContexto.SaveChanges();
        }
    }


    /* public LecturaRepositorio()
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
    } */
}
