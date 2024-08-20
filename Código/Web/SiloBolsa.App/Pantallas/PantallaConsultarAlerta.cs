namespace SiloBolsa.App.Pantallas;
using SiloBolsa.Persistencia.Negocio;
using SiloBolsa.Core.Modelos;

public class PantallaConsultarAlerta
{
    private readonly AlertaServicio _alertaServicio;

    public PantallaConsultarAlerta()
    {
        _alertaServicio = new AlertaServicio();
    }

    public void ListarAlertas()
    {
        AlertaServicio alertaServicio = new AlertaServicio();
        List<Alerta> listadoAlertas = _alertaServicio.ObtenerAlertas();

        foreach (Alerta alerta in listadoAlertas)
        {
            Console.WriteLine($"Id: {alerta.IdAlerta}, Mensaje: {alerta.Mensaje}");
        }
    }

}
