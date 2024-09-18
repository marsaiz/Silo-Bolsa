using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Negocio;

public class LecturaServicio : ILecturaServicio
{

    // 1. Buscar el Grano para obenter Max y Min
    // 2. Grabar en Base de datos la lectura.
    // 3. Analizar los datos
    // 4- Enviar la alerta
    public void AddLectura(Lectura lectura)
    {
        throw new NotImplementedException();
    }

    public void DeleteLectura(Guid id_lectura)
    {
        throw new NotImplementedException();
    }

    public Lectura GetLecturaById(Guid id_lectura)
    {
        throw new NotImplementedException();
    }

    public IEnumerable<Lectura> GetLecturas()
    {
        throw new NotImplementedException();
    }

    public void UpdateLectura(Lectura lectura)
    {
        throw new NotImplementedException();
    }
}