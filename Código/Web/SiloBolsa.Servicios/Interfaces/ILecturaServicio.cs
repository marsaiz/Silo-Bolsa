using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Interfaces;

public interface ILecturaServicio
{
    IEnumerable<Lectura> GetLecturas();
    Lectura GetLecturaById(Guid id_lectura);
    void AddLectura(Lectura lectura);
    void UpdateLectura(Lectura lectura);
    void DeleteLectura(Guid id_lectura);
}
