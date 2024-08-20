using Microsoft.EntityFrameworkCore;
using SiloBolsa.Core.Modelos;
using SiloBolsa.Persistencia.Negocio;

namespace SiloBolsa.Persistencia.Repositorios;

public class AlertaRepositorio
{
    private readonly SiloBolsaContexto _siloBolsaContexto;

    public AlertaRepositorio()
    {
        _siloBolsaContexto = SiloBolsaContexto.CrearInstancia();
    }

    internal List<Alerta> ObtenerAlertas()
    {
        return _siloBolsaContexto.Alertas.ToList();
    }

    public List<Alerta> ListarAlertas()
    {
        //return _siloBolsaContexto.Alertas.Include(d => d.Mensaje).ToList();
        return _siloBolsaContexto.Alertas.Include(a => a.Silo).ToList();
    }
}
