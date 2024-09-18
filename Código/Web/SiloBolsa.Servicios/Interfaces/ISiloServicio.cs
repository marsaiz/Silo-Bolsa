using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Interfaces;

public interface ISiloServicio
{
    IEnumerable<Silo> GetSilos();
    Silo GetSiloById(Guid id_silo);
    void AddSilo(SiloDTO silo);
    void UpdateSilo(SiloDTO siloDTO);
    void DeleteSilo(Guid id_silo);
}