using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Interfaces;

public interface IGranoServicio
{
    IEnumerable<Grano> GetGranos();
    Grano GetGranoById(int id);
    void AddGrano(GranoDTO grano);
    void UpdateGrano(GranoDTO grano);
    void DeleteGrano(int id);
}
