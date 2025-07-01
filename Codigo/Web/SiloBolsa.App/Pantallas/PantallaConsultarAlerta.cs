using SiloBolsa.Core.Modelos;
using SiloBolsa.App.Negocio;

namespace SiloBolsa.App.Pantallas;
public class PantallaConsultarAlerta
{
    private readonly AlertaServicio _alertaServicio;

    public PantallaConsultarAlerta(AlertaServicio alertaServicio)
    {
        _alertaServicio = alertaServicio ?? throw new ArgumentNullException(nameof(alertaServicio));    }

    public void ListarAlertas()
    {
        List<Alerta> listadoAlertas = _alertaServicio.ObtenerAlertas();

        foreach (Alerta alerta in listadoAlertas)
        {
            Console.WriteLine($"Id: {alerta.IdAlerta}, Mensaje: {alerta.Mensaje}");
        }
    }

}
