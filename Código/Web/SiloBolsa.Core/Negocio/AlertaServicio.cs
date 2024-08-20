using SiloBolsa.Core.Modelos;
using SiloBolsa.Persistencia.Repositorios;

namespace SiloBolsa.Persistencia.Negocio;

public class AlertaServicio
{
    private readonly AlertaRepositorio _alertaServicio;

    public AlertaServicio()
    {
        _alertaServicio = new AlertaRepositorio();
    }

    public List<Alerta> ObtenerAlertas()
    {
        return _alertaServicio.ListarAlertas();
    }
}