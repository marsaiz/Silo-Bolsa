using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Interfaces;

public interface ICajaServicio
{
    IEnumerable<Caja> GetCajas();
    Caja GetCajasById(Guid caja);
    void AddCaja(Caja caja);
    void UpdateCaja(Guid id_caja);
    void DeleteCaja(Guid id_caja);
}
