using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Interfaces;

public class SiloDTO
{
    public Guid IdSilo { get; set; }
    public double Latitud { get; set; }
    public double Longitud { get; set; }
    public int Capacidad { get; set; }
    public int TipoGrano { get; set; }
    public string? Descripcion { get; set; }
}
