using Microsoft.EntityFrameworkCore;
using SiloBolsa.Persistencia.Modelos;


namespace SiloBolsa.Persistencia.Repositorios;

public class AlertaRepositorio
{
    private readonly SiloBolsaContexto _siloBolsaContexto;

    public AlertaRepositorio(SiloBolsaContexto siloBolsaContexto)
    {
        _siloBolsaContexto = siloBolsaContexto;
    }

    public IEnumerable<Alerta> GetAlertas()
    {
        return _siloBolsaContexto.Alertas.ToList();
    }

    public Alerta GetAlertaById(Guid id_alerta)
    {
        return _siloBolsaContexto.Alertas.Find(id_alerta);
    }

    public void AddAlerta(Alerta alerta)
    {
        _siloBolsaContexto.Alertas.Add(alerta);
        _siloBolsaContexto.SaveChanges();
    }

    public void UpdateAlerta (Alerta alerta)
    {
        throw new NotImplementedException();
    }
    public void DeleteAlerta(Guid id_alerta)
    {
        var alerta = _siloBolsaContexto.Alertas.Find(id_alerta);
        if (alerta != null)
        {
            _siloBolsaContexto.Alertas.Remove(alerta);
            _siloBolsaContexto.SaveChanges();
        }
    }

    /*  public AlertaRepositorio()
         {
             _siloBolsaContexto = SiloBolsaContexto.CrearInstancia();
         } 

        internal List<Alerta> ObtenerAlertas()
        {
            return _siloBolsaContexto.Alertas.ToList();
        }

        public List<Alerta> ListarAlertas()
        {
            return _siloBolsaContexto.Alertas.ToList();
        }

        public void CrearAlerta(Alerta alerta)
        {
            _siloBolsaContexto.Alertas.Add(alerta);
            _siloBolsaContexto.SaveChanges();
        }*/
}
