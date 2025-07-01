namespace SiloBolsa.Servicios.Interfaces;

public class GranoDTO
{
    public int IdGrano { get; set; }
    public string? Descripcion { get; set; }
    public double HumedadMax { get; set; }
    public double HumedadMin { get; set; }
    public double TempMax { get; set; }
    public double TempMin { get; set; }
    public double NivelDioxidoMax { get; set; }
    public double NivelDioxidoMin { get; set; }
}
