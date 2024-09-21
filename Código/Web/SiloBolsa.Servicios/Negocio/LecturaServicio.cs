using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;
using System.Runtime.CompilerServices;

namespace SiloBolsa.Servicios.Negocio;

public class LecturaServicio : ILecturaServicio
{

    // 1. Buscar el Grano para obenter Max y Min
    // 2. Grabar en Base de datos la lectura.
    // 3. Analizar los datos
    // 4- Enviar la alerta

    private ILecturaRepositorio _lecturaRepositorio;
    private ICajaRepositorio _cajaRepositorio;
    public LecturaServicio(ILecturaRepositorio lecturaRepositorio, ICajaRepositorio cajaRepositorio)
    {
        _lecturaRepositorio = lecturaRepositorio;
        _cajaRepositorio = _cajaRepositorio;
    }
    public void AddLectura(LecturaDTO lecturaDTO)
    {
        Lectura lectura = new Lectura();
        lectura.IdLectura = lecturaDTO.IdLectura;
        lectura.FechaHoraLectura = lecturaDTO.FechaHoraLectura;
        lectura.Temp = lecturaDTO.Temp;
        lectura.Humedad = lecturaDTO.Humedad;
        lectura.DioxidoDeCarbono = lecturaDTO.DioxidoDeCarbono;
        lectura.IdCaja = lecturaDTO.IdCaja;

        _lecturaRepositorio.AddLectura(lectura);
    }

    public void DeleteLectura(Guid id_lectura)
    {
        _lecturaRepositorio.DeleteLectura(id_lectura);
    }

    public Lectura GetLecturaById(Guid id_lectura)
    {
        return _lecturaRepositorio.GetLecturaById(id_lectura);
    }

    public IEnumerable<Lectura> GetLecturas()
    {
        return _lecturaRepositorio.GetLecturas();
    }

    public void UpdateLectura(LecturaDTO lecturaDTO)
    {
        var lecturaExistente = _lecturaRepositorio.GetLecturaById(lecturaDTO.IdLectura);

        if(lecturaExistente == null)
        {
            throw new Exception("La lectura no existe");
        }

        lecturaExistente.FechaHoraLectura = lecturaDTO.FechaHoraLectura;
        lecturaExistente.Temp = lecturaDTO.Temp;
        lecturaExistente.Humedad = lecturaDTO.Humedad;
        lecturaExistente.DioxidoDeCarbono = lecturaDTO.DioxidoDeCarbono;
        lecturaExistente.IdCaja = lecturaDTO.IdCaja;

        _lecturaRepositorio.UpdateLectura(lecturaExistente);
    }
}