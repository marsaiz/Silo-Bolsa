namespace SiloBolsa.Servicios.Interfaces;

public class SiloDTO
{
    public Guid IdSilo { get; set; }
    public double Latitude { get; set; }
    public double Longitude { get; set; }   
    public int Capacidad { get; set; }
    public int IdGrano { get; set; }
}
