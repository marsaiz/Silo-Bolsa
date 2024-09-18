using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Persistencia.Repositorios;

public class GranoRepositorio : IGranoRepositorio
{
    private readonly SiloBolsaContexto _siloBolsaContexto;

    public GranoRepositorio(SiloBolsaContexto siloBolsaContexto)
    {
        _siloBolsaContexto = siloBolsaContexto;
    }

    public IEnumerable<Grano> GetGranos()
    {
        return _siloBolsaContexto.Granos.ToList();
    }

    public Grano GetGranoById(int id)
    {
        return _siloBolsaContexto.Granos.Find(id);
    }

    public void AddGrano(Grano grano)
    {
        _siloBolsaContexto.Granos.Add(grano);
        _siloBolsaContexto.SaveChanges();
    }

    public void UpdateGrano(Grano grano)
    {
        throw new NotImplementedException();
    }
    public void DeleteGrano(int id)
    {
        var grano = _siloBolsaContexto.Granos.Find(id);
        if (grano != null)
        {
            _siloBolsaContexto.Granos.Remove(grano);
            _siloBolsaContexto.SaveChanges();
        }
    }
}