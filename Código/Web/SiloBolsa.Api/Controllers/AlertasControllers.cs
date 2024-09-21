
using Microsoft.AspNetCore.Mvc;
using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Api.Controllers;

[ApiController]
[Route("api/alertas")]
public class AlertasControllers : ControllerBase
{
private readonly IAlertaServicio _alertaServicio;
    public AlertasControllers(IAlertaServicio alertaServicio)
    {
        _alertaServicio = alertaServicio;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Alerta>> GetAlertas()
    {
        var alertas = _alertaServicio.GetAlertas();
        return Ok(alertas);
    }

    [HttpGet("{id_alerta}")] //Con los corchetes se indican variables
    public ActionResult<Alerta> GetAlertaByid(Guid id_alerta)
    {
        var alerta = _alertaServicio.GetAlertaById(id_alerta);
        if (alerta == null)
        {
            return NotFound();
        }
        return Ok(alerta);
    }

    [HttpPost]
    public IActionResult AddAlerta([FromBody] AlertaDTO alerta)
    {
        if(alerta == null)
        {
            return BadRequest("El Alerta no puede ser nulo");
        }

        _alertaServicio.AddAlerta(alerta);
        return Ok("El Alerta agregada correctamente");
       /*  _alertaServicio.AddAlerta(alerta);
        return CreatedAtAction(nameof(GetAlertas), new {id_alerta = alerta.IdAlerta}, alerta); */
    }

    [HttpPut("{id_alerta}")]
        public IActionResult UpdateAlerta(Guid id_alerta, [FromBody] AlertaDTO alerta)
        {
            if (id_alerta != alerta.IdAlerta)
            {
                return BadRequest();
            }
            _alertaServicio.UpdateAlerta(alerta);
            return NoContent();
        }

        [HttpDelete("{id_alerta}")]
        public IActionResult DeleteAlerta(Guid id_alerta)
        {
            _alertaServicio.DeleteAlerta(id_alerta);
            return NoContent();
        }
}
