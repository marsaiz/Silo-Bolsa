using Microsoft.EntityFrameworkCore;
using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Persistencia.Repositorios;

public class CajaRepositorio : ICajaRepositorio
{
    private readonly SiloBolsaContexto _siloBolsaContexto;

    public CajaRepositorio(SiloBolsaContexto siloBolsaContexto)
    {
        _siloBolsaContexto = siloBolsaContexto;
    }

    public IEnumerable<Caja> GetCajas()
    {
        return _siloBolsaContexto.Cajas.ToList();
    }

    public Caja GetCajasById(Guid id_caja)
    {
        return _siloBolsaContexto.Cajas.Find(id_caja);
    }

    public void AddCaja(Caja cajas)
    {
        _siloBolsaContexto.Cajas.Add(cajas);
        _siloBolsaContexto.SaveChanges();
    }

    public void UpdateCaja(Caja cajas)
    {
        throw new NotImplementedException();
    }
    public void DeleteCaja(Guid id_caja)
    {
        var caja = _siloBolsaContexto.Cajas.Find(id_caja);
        if (caja != null)
        {
            _siloBolsaContexto.Cajas.Remove(caja);
            _siloBolsaContexto.SaveChanges();
        }
    }
}
