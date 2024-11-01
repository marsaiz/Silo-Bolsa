using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Servicios.Interfaces;

public interface IAlertaServicio
{
    IEnumerable<Alerta> GetAlertas();
    Alerta GetAlertaById(Guid id_alerta);
    void AddAlerta(AlertaDTO alerta);
    void UpdateAlerta(AlertaDTO alerta);
    void DeleteAlerta(Guid id_alerta);
}
