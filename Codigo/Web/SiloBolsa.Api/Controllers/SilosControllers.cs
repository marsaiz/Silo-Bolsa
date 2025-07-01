using Microsoft.AspNetCore.Mvc;
using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;


namespace SiloBolsa.Api.Controllers;

[ApiController]
[Route("api/silos")]
public class SilosControllers : ControllerBase
{
    private readonly ISiloServicio _siloServicio;
    public SilosControllers(ISiloServicio siloServicio)
    {
        _siloServicio = siloServicio;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Silo>> GetSilos()
    {
        var silos = _siloServicio.GetSilos();
        return Ok(silos);
    }

    [HttpGet("{id_silo}")] //Entre llaves se llama a un campo de una tabla de base de datos.
    public ActionResult<Silo> GetSiloById(Guid id_silo)
    {
        var silo = _siloServicio.GetSiloById(id_silo);
        if (silo == null)
        {
            return NotFound();
        }
        return Ok(silo);
    }

    [HttpPost]
    public IActionResult AddSilo([FromBody] SiloDTO silo)
    {
        if (silo == null)
        {
            return BadRequest("El objeto Silo no puede ser nulo");
        }

        _siloServicio.AddSilo(silo); // El servicio genera el IdSilo
        return Ok("Silo agregado correctamente");
        
        /* _siloServicio.AddSilo(silo);
        return CreatedAtAction(nameof(GetSilos), new {id_silo = silo.IdSilo}, silo); */
    }

    [HttpPut("{id_silo}")]
    public IActionResult UpdateSilo(Guid id_silo, [FromBody] SiloDTO silo)
    {
        if (id_silo != silo.IdSilo)
        {
            return BadRequest();
        }
        _siloServicio.UpdateSilo(silo);
        return NoContent();
    }

    [HttpDelete("{id_silo}")]
    public IActionResult DeleteSilo(Guid id_silo)
    {
        _siloServicio.DeleteSilo(id_silo);
        return NoContent();
    }
}
