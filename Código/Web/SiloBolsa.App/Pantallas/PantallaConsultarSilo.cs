using SiloBolsa.Core.Modelos;
using SiloBolsa.App.Negocio;

namespace SiloBolsa.App.Pantallas;

public class PantallaConsultarSilo
{
    private readonly SiloServicio _siloServicio;

    public PantallaConsultarSilo(SiloServicio siloServicio)
    {
        _siloServicio = siloServicio ?? throw new ArgumentNullException(nameof(siloServicio));
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
