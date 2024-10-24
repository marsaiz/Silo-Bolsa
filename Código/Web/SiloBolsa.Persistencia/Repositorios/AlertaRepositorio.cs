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

public Alerta? GetAlertaActivaPorSilo(Guid id_silo)
{
    return _siloBolsaContexto.Alertas.FirstOrDefault(a => a.IdSilo == id_silo && a.CorreoEnviado == true);
}
    public void AddAlerta(Alerta alerta)
    {
        _siloBolsaContexto.Alertas.Add(alerta);
        _siloBolsaContexto.SaveChanges();
    }

    public void UpdateAlerta (Alerta alerta)
    {
        alerta.FechaHoraAlerta = DateTime.SpecifyKind(alerta.FechaHoraAlerta, DateTimeKind.Utc);
        
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

    public void SaveChanges()
    {
        _siloBolsaContexto.SaveChanges();
    }
}
