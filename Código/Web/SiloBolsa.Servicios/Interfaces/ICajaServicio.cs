using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Interfaces;

public interface ICajaServicio
{
    IEnumerable<Caja> GetCajas();
    Caja GetCajasById(Guid caja);
    void AddCaja(CajaDTO caja);
    void UpdateCaja(CajaDTO caja);
    void DeleteCaja(Guid id_caja);
}
