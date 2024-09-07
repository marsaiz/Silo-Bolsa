using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using SiloBolsa.App.Interfaces;
using SiloBolsa.Core.Modelos;
using SiloBolsa.Persistencia.Repositorios;


namespace SiloBolsa.Api.Controllers;

[ApiController]
[Route("Controller")]
public class SilosControllers : ControllerBase
{
    private readonly ISiloRepositorio _siloRepositorio;
    public SilosControllers(ISiloRepositorio siloRepositorio)
    {
        _siloRepositorio = siloRepositorio;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Silo>> GetSilos()
    {
        var silos = _siloRepositorio.GetSilos();
        return Ok(silos);
    }

    [HttpGet("{id_silo}")]
    public ActionResult<Silo> GetSiloById(Guid id_silo)
    {
        var silo = _siloRepositorio.GetSiloById(id_silo);
        if (silo == null)
        {
            return NotFound();
        }
        return Ok(silo);
    }

    [HttpPost]
    public IActionResult AddSilo([FromBody] Silo silo)
    {
        _siloRepositorio.AddSilo(silo);
        return CreatedAtAction(nameof(GetSilos), new {id_silo = silo.IdSilo}, silo);
    }

    [HttpPut("{id_silo}")]
        public IActionResult UpdateSilo(Guid id_silo, [FromBody] Silo silo)
        {
            if (id_silo != silo.IdSilo)
            {
                return BadRequest();
            }
            _siloRepositorio.UpdateSilo(silo);
            return NoContent();
        }

        [HttpDelete("{id_silo}")]
        public IActionResult DeleteSilo(Guid id_silo)
        {
            _siloRepositorio.DeleteSilo(id_silo);
            return NoContent();
        }
}
