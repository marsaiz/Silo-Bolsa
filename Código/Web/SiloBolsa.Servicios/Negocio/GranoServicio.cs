using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Negocio;

public class GranoServicio : IGranoServicio
{
    private IGranoRepositorio _granoRepositorio;

    public GranoServicio(IGranoRepositorio granoRepositorio)
    {
        _granoRepositorio = granoRepositorio;
    }
    public void AddGrano(GranoDTO granoDTO)
    {
        Grano grano = new Grano();
        grano.IdGrano = granoDTO.IdGrano;
        grano.Descripcion = granoDTO.Descripcion;
        grano.HumedadMax = granoDTO.HumedadMax;
        grano.HumedadMin = granoDTO.HumedadMin;
        grano.TempMax = granoDTO.TempMax;
        grano.TempMin = granoDTO.TempMin;
        grano.NivelDioxidoMax = granoDTO.NivelDioxidoMax;
        grano.NivelDioxidoMin = granoDTO.NivelDioxidoMin;

        _granoRepositorio.AddGrano(grano);
    }

    public Grano GetGranoById(int id)
    {
        return _granoRepositorio.GetGranoById(id);
    }

    public IEnumerable<Grano> GetGranos()
    {
        return _granoRepositorio.GetGranos();
    }

    public void UpdateGrano(Grano grano)
    {
        throw new NotImplementedException();
    }

    public void DeleteGrano(int id)
    {
        throw new NotImplementedException();
    }
}