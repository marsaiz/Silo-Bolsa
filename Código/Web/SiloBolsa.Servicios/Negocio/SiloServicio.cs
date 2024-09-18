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
        silo.IdSilo = siloDTO.IdSilo;

        silo.GranoSilo = _granoServicio.GetGranoById(siloDTO.IdGrano);

        _siloRepositorio.AddSilo(silo);
    }
    public void DeleteSilo(Guid id_silo)
    {
        throw new NotImplementedException();
    }

    public Silo GetSiloById(Guid id_silo)
    {
        return _siloRepositorio.GetSiloById(id_silo);
    }

    public IEnumerable<Silo> GetSilos()
    {
        return _siloRepositorio.GetSilos();
    }

    public void UpdateSilo(Silo silo)
    {
        throw new NotImplementedException();
    }
}