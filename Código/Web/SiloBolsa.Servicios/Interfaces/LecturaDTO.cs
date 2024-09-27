namespace SiloBolsa.Servicios.Interfaces;

public class LecturaDTO
{
    public Guid IdLectura { get; set; }
    public DateTime FechaHoraLectura { get; set; }
    public int Temp { get; set; }
    public double Humedad { get; set; }
    public double DioxidoDeCarbono { get; set; }
    public Guid IdCaja { get; set; }
}
