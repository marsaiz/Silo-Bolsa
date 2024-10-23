namespace SiloBolsa.Servicios.Interfaces;

public class AlertaDTO
{
    public Guid IdAlerta { get; set; }
    public DateTime FechaHoraAlerta { get; set; }
    public string? Mensaje { get; set; }
    public Guid IdSilo { get; set; }
    public bool CorreoEnviado { get; set; }
}
