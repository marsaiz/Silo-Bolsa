using SiloBolsa.Core.Modelos;
using SiloBolsa.Servicios.Interfaces;

namespace SiloBolsa.Servicios.Negocio;

public class AlertaServicio : IAlertaServicio
{
    private IAlertaRepositorio _alertaRepositorio;
    public AlertaServicio(IAlertaRepositorio alertaRepositorio)
    {
        _alertaRepositorio = alertaRepositorio;
    }
    public void AddAlerta(AlertaDTO alertaDTO)
    {
        Alerta alerta = new Alerta();
        alerta.IdAlerta = Guid.NewGuid();
        alerta.FechaHoraAlerta = alertaDTO.FechaHoraAlerta;
        alerta.Mensaje = alertaDTO.Mensaje;
        alerta.IdSilo = alertaDTO.IdSilo;

        _alertaRepositorio.AddAlerta(alerta);
    }

    public Alerta GetAlertaById(Guid id_alerta)
    {
        return _alertaRepositorio.GetAlertaById(id_alerta);
    }

    public IEnumerable<Alerta> GetAlertas()
    {
        return _alertaRepositorio.GetAlertas();
    }

    public void UpdateAlerta(AlertaDTO alertaDTO)
    {
        var alertaExistente = _alertaRepositorio.GetAlertaById(alertaDTO.IdAlerta);

        if(alertaExistente == null)
        {
            throw new Exception("La alerta no existe");
        }

        alertaExistente.FechaHoraAlerta = alertaDTO.FechaHoraAlerta;
        alertaExistente.Mensaje = alertaDTO.Mensaje;

        _alertaRepositorio.UpdateAlerta(alertaExistente);
    }

    public void DeleteAlerta(Guid id_alerta)
    {
        _alertaRepositorio.DeleteAlerta(id_alerta);
    }
}