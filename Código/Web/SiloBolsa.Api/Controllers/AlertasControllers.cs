using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using SiloBolsa.App.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Api.Controllers;

[ApiController]
[Route("Controller")]
public class AlertasControllers : ControllerBase
{
private readonly IAlertaRepositorio _alertaRepositorio;
    public AlertasControllers(IAlertaRepositorio alertaRepositorio)
    {
        _alertaRepositorio = alertaRepositorio;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Alerta>> GetAlertas()
    {
        var alertas = _alertaRepositorio.GetAlertas();
        return Ok(alertas);
    }

    [HttpGet("{id_alerta}")]
    public ActionResult<Alerta> GetAlertaByid(Guid id_alerta)
    {
        var alerta = _alertaRepositorio.GetAlertaById(id_alerta);
        if (alerta == null)
        {
            return NotFound();
        }
        return Ok(alerta);
    }

    [HttpPost]
    public IActionResult AddAlerta([FromBody] Alerta alerta)
    {
        _alertaRepositorio.AddAlerta(alerta);
        return CreatedAtAction(nameof(GetAlertas), new {id_alerta = alerta.IdAlerta}, alerta);
    }

    [HttpPut("{id_alerta}")]
        public IActionResult UpdateAlerta(Guid id_alerta, [FromBody] Alerta alerta)
        {
            if (id_alerta != alerta.IdAlerta)
            {
                return BadRequest();
            }
            _alertaRepositorio.UpdateAlerta(alerta);
            return NoContent();
        }

        [HttpDelete("{id_alerta}")]
        public IActionResult DeleteAlerta(Guid id_alerta)
        {
            _alertaRepositorio.DeleteAlerta(id_alerta);
            return NoContent();
        }
}
