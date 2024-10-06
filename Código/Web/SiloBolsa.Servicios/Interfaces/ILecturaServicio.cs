using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Interfaces;

public interface ILecturaServicio
{
    IEnumerable<Lectura> GetLecturas();
    Lectura GetLecturaById(Guid id_lectura);
    void AddLectura(LecturaDTO lectura);
    //void UpdateLectura(LecturaDTO lectura);
    void DeleteLectura(Guid id_lectura);
}
