using SiloBolsa.Core.Modelos;
using SiloBolsa.Core.Interfaces;

namespace SiloBolsa.App.Negocio;

public class AlertaServicio
{
    private readonly IAlertaRepositorio _alertaRepositorio;

    public AlertaServicio(IAlertaRepositorio alertaRepositorio)
    {
        _alertaRepositorio = alertaRepositorio;
    }

    public List<Alerta> ObtenerAlertas()
    {
        return _alertaRepositorio.GetAlertas().ToList();
    }

    public void AgregarAlerta(Alerta alerta)
    {
        _alertaRepositorio.AddAlerta(alerta);
    }
}