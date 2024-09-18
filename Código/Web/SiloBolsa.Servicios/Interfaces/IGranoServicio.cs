using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Interfaces;

public interface IGranoServicio
{
    IEnumerable<Grano> GetGranos();
    Grano GetGranoById(int id);
    void AddGrano(Grano grano);
    void UpdateGrano(Grano grano);
    void DeleteGrano(int id);
}
