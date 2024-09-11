using Microsoft.EntityFrameworkCore;
using SiloBolsa.Core.Interfaces;
using SiloBolsa.Core.Modelos;


namespace SiloBolsa.Persistencia.Repositorios;

public class SensoresRepositorio : ISensoresRepositorio
{

    private readonly SiloBolsaContexto _siloBolsaContexto;

     public IEnumerable<Sensores> GetSensores()
    {
        return _siloBolsaContexto.Sensores.ToList();
    }

    public Sensores GetSensoresById(Guid id_caja)
    {
        return _siloBolsaContexto.Sensores.Find(id_caja);
    }

    public void AddSensores(Sensores sensores)
    {
        _siloBolsaContexto.Sensores.Add(sensores);
        _siloBolsaContexto.SaveChanges();
    }

    public void UpdateSensores (Sensores sensores)
    {
        throw new NotImplementedException();
    }
    public void DeleteSensores(Guid id_caja)
    {
        var caja = _siloBolsaContexto.Sensores.Find(id_caja);
        if (caja != null)
        {
            _siloBolsaContexto.Sensores.Remove(caja);
            _siloBolsaContexto.SaveChanges();
        }
    }


    /* public SensoresRepositorio()
    {
        _siloBolsaContexto = SiloBolsaContexto.CrearInstancia();
    }

    internal List<Sensores> ObtenerDatos()
    {
        return _siloBolsaContexto.Sensores.ToList();
    }

    public List<Sensores> ListarId()
    {
        return _siloBolsaContexto.Sensores.Include(d => d.IdCaja).ToList();
    } */
}
