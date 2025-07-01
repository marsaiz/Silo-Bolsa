using Microsoft.EntityFrameworkCore;
using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;


namespace SiloBolsa.Persistencia.Repositorios;

public class LecturaRepositorio : ILecturaRepositorio
{
    private readonly SiloBolsaContexto _siloBolsaContexto;

    public LecturaRepositorio(SiloBolsaContexto siloBolsaContexto)
    {
        _siloBolsaContexto = siloBolsaContexto;
    }

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

    /* public void UpdateLectura(Lectura lectura)
    {
        _siloBolsaContexto.Lecturas.Update(lectura);
        _siloBolsaContexto.SaveChanges();
    }
 */
    public void DeleteLectura(Guid id_lectura)
    {
        var lectura = _siloBolsaContexto.Lecturas.Find(id_lectura);
        if (lectura != null)
        {
            _siloBolsaContexto.Lecturas.Remove(lectura);
            _siloBolsaContexto.SaveChanges();
        }
    }
    public IEnumerable<Lectura> GetLecturasByIdSilo(Guid id_silo)
    {
        return _siloBolsaContexto.Lecturas
        .Include(l => l.Caja)
        .ThenInclude(c => c.Silo)
        .Where(l => l.Caja != null && l.Caja.Silo != null && l.Caja.Silo.IdSilo == id_silo)
        .ToList();
    }
}
