using Microsoft.EntityFrameworkCore;
using SiloBolsa.Core.Modelos;

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
        return _siloBolsaContexto.Alertas.ToList();
    }

    public void CrearAlerta(Alerta alerta)
    {
        _siloBolsaContexto.Alertas.Add(alerta);
        _siloBolsaContexto.SaveChanges();
    }
}
