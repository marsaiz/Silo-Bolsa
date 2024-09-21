using Microsoft.EntityFrameworkCore;
using SiloBolsa.Core.Modelos;
using SiloBolsa.Servicios.Interfaces;

namespace SiloBolsa.Persistencia.Repositorios;
public class AlertaRepositorio : IAlertaRepositorio
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
        _siloBolsaContexto.Alertas.Update(alerta);
        _siloBolsaContexto.SaveChanges();
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
}
