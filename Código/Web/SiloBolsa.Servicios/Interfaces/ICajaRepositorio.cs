using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Interfaces
{
    public interface ICajaRepositorio
    {
        IEnumerable<Caja> GetCajas();
        Caja GetCajasById(Guid id_caja);
        void AddCaja(Caja cajas);
        void UpdateCaja(Caja cajas);
        void DeleteCaja(Guid id_caja);
    }
}