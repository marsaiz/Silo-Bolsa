using System.Threading.Tasks.Dataflow;
using SiloBolsa.Core.Interfaces;
using SiloBolsa.Core.Modelos;
using SiloBolsa.Persistencia.Repositorios;


namespace SiloBolsa.App.Negocio;

public class SiloServicio
{
    private readonly ISiloRepositorio _siloRepositorio;

    public SiloServicio(ISiloRepositorio siloRepositorio)
    {
        _siloRepositorio = siloRepositorio;
    }

    public List<Silo> ObtenerDato()
    {
        return _siloRepositorio.GetSilos().ToList();
    }

    /* public List<Silo> ObtenerSiloPorId(Guid id_silo)
    {
        return _siloRepositorio.GetSiloById(id_silo);
    } */
    public void AgregarSilo(Silo silo)
    {
        _siloRepositorio.AddSilo(silo);
    }
}
