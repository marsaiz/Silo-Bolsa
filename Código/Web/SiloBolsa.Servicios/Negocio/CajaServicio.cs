using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Negocio;

public class CajaServicio : ICajaServicio
{
    private ICajaRepositorio _cajaRepositorio;

    public CajaServicio(ICajaRepositorio cajaRepositorio)
    {
        _cajaRepositorio = cajaRepositorio;
    }
    public void AddCaja(CajaDTO cajaDTO)
    {
        Caja caja = new Caja();
        caja.IdCaja = Guid.NewGuid();
        caja.UbicacionEnSilo = cajaDTO.UbicacionEnSilo;
        caja.IdSilo = cajaDTO.IdSilo;

        _cajaRepositorio.AddCaja(caja);
    }

    public void DeleteCaja(Guid id_caja)
    {
        _cajaRepositorio.DeleteCaja(id_caja);
    }

    public IEnumerable<Caja> GetCajas()
    {
        return _cajaRepositorio.GetCajas();
    }

    public Caja GetCajasById(Guid id_caja)
    {
        return _cajaRepositorio.GetCajasById(id_caja);
    }

    public void UpdateCaja(CajaDTO cajaDTO)
    {
        var cajaExistente = _cajaRepositorio.GetCajasById(cajaDTO.IdCaja);

        if(cajaExistente == null)
        {
            throw new Exception("La Caja no existe");
        }

        cajaExistente.UbicacionEnSilo =  cajaDTO.UbicacionEnSilo;

        _cajaRepositorio.UpdateCaja(cajaExistente);
    }
}
