using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using SiloBolsa.Core.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Api.Controllers;

[ApiController]
[Route("Controller")]
public class SensoresControllers : ControllerBase
{
    private readonly ISensoresRepositorio _sensoresRepositorio;
    public SensoresControllers(ISensoresRepositorio sensoresRepositorio)
    {
        _sensoresRepositorio = sensoresRepositorio;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Sensores>> GetSensores()
    {
        var sensores = _sensoresRepositorio.GetSensores();
        return Ok(sensores);
    }

    [HttpGet("{id_caja}")]
    public ActionResult<Sensores> GetSensoresById(Guid id_caja)
    {
        var sensor = _sensoresRepositorio.GetSensoresById(id_caja);
        if (sensor == null)
        {
            return NotFound();
        }
        return Ok(sensor);
    }

    [HttpPost]
    public IActionResult AddSensor([FromBody] Sensores sensores)
    {
        _sensoresRepositorio.AddSensores(sensores);
        return CreatedAtAction(nameof(GetSensores), new {id_caja = sensores.IdCaja}, sensores);
    }

    [HttpPut("{id_caja}")]
        public IActionResult UpdateSensor(Guid id_caja, [FromBody] Sensores sensores)
        {
            if (id_caja != sensores.IdCaja)
            {
                return BadRequest();
            }
            _sensoresRepositorio.UpdateSensores(sensores);
            return NoContent();
        }

        [HttpDelete("{id_caja}")]
        public IActionResult DeleteSensor(Guid id_caja)
        {
            _sensoresRepositorio.DeleteSensores(id_caja);
            return NoContent();
        }

}
