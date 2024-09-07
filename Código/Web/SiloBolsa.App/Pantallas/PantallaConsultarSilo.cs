using SiloBolsa.Persistencia.Negocio;
using SiloBolsa.Core.Modelos;
using SiloBolsa.Core.Negocio;

namespace SiloBolsa.App.Pantallas;

public class PantallaConsultarSilo
{
    private readonly SiloServicio _siloServicio;

    public PantallaConsultarSilo()
    {
        _siloServicio = new SiloServicio();
    }
    public void ListarSilos()
    {
        var silos = _siloServicio.ObtenerDato();
        foreach (Silo item in silos)
        {
            Console.WriteLine($"Id Silo: {item.IdSilo} - Descripción: {item.Descripcion}");
        }
    }
}
