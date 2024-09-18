using System.Threading.Tasks.Dataflow;
using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Negocio;

public class SiloServicio : ISiloServicio
{
    private ISiloRepositorio _siloRepositorio;
    private readonly IGranoServicio _granoServicio;

    public SiloServicio(ISiloRepositorio siloRepositorio, IGranoServicio granoServicio)
    {
        _siloRepositorio = siloRepositorio;
        _granoServicio = granoServicio;
    }
    public void AddSilo(SiloDTO siloDTO)
    {
        Silo silo = new Silo();
        silo.IdSilo = Guid.NewGuid();
        silo.Latitud = siloDTO.Latitud;
        silo.Longitud = siloDTO.Longitud;
        silo.Capacidad = siloDTO.Capacidad;
        //silo.GranoSilo = _granoServicio.GetGranoById(siloDTO.IdGrano);
        silo.Descripcion = siloDTO.Descripcion;

        _siloRepositorio.AddSilo(silo);
    }
    public void DeleteSilo(Guid id_silo)
    {
        _siloRepositorio.DeleteSilo(id_silo);
    }

    public Silo GetSiloById(Guid id_silo)
    {
        return _siloRepositorio.GetSiloById(id_silo);
    }

    public IEnumerable<Silo> GetSilos()
    {
        return _siloRepositorio.GetSilos();
    }

    public void UpdateSilo(SiloDTO siloDTO)
    {
        var siloExistente = _siloRepositorio.GetSiloById(siloDTO.IdSilo);

        if(siloExistente == null)
        {
            throw new Exception("El silo no existe");
        }

        siloExistente.Latitud = siloDTO.Latitud;
        siloExistente.Longitud = siloDTO.Longitud;
        siloExistente.Capacidad = siloDTO.Capacidad;
        siloExistente.Descripcion = siloDTO.Descripcion;

        _siloRepositorio.UpdateSilo(siloExistente);
    }
}