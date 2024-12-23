using Microsoft.AspNetCore.Mvc;
using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Api.Controllers;

[ApiController]
[Route("api/cajas")]
public class CajaControllers : ControllerBase
{
    private readonly ICajaServicio _cajaServicio;
    public CajaControllers(ICajaServicio cajaServicio)
    {
        _cajaServicio = cajaServicio;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Caja>> GetCajas()
    {
        var cajas = _cajaServicio.GetCajas();
        return Ok(cajas);
    }

    [HttpGet("{id_caja}")]
    public ActionResult<Caja> GetCajasById(Guid id_caja)
    {
        var cajas = _cajaServicio.GetCajasById(id_caja);
        if (cajas == null)
        {
            return NotFound();
        }
        return Ok(cajas);
    }

    [HttpPost]
    public IActionResult AddCaja([FromBody] CajaDTO caja)
    {
        if(caja == null)
        {
            return BadRequest("La Caja no puede ser nulo");
        }

        _cajaServicio.AddCaja(caja);
        return Ok("Caja agregada correctamente");

        /* _cajaServicio.AddCaja(caja);
        return CreatedAtAction(nameof(GetCajas), new {id_caja = caja.IdCaja}, caja);*/
    }

    [HttpPut("{id_caja}")]
        public IActionResult UpdateCaja(Guid id_caja, [FromBody] CajaDTO caja)
        {
            if (id_caja != caja.IdCaja)
            {
                return BadRequest();
            }
            _cajaServicio.UpdateCaja(caja);
            return NoContent();
        }

        [HttpDelete("{id_caja}")]
        public IActionResult DeleteCaja(Guid id_caja)
        {
            _cajaServicio.DeleteCaja(id_caja);
            return NoContent();
        }

}
