using Microsoft.AspNetCore.Mvc;
using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Api.Controllers;

[ApiController]
[Route("api/lecturas")]
public class LecturasControllers : ControllerBase
{
    private readonly ILecturaServicio _lecturaServicio;
    private readonly ILecturaRepositorio _lecturaRepositorio;
    public LecturasControllers(ILecturaServicio lecuraRepositorio)
    {
        _lecturaServicio = lecuraRepositorio;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Lectura>> GetLecturas()
    {
        var lecturas = _lecturaServicio.GetLecturas();
        return Ok(lecturas);
    }

    [HttpGet("{id_lectura}")]
    public ActionResult<Lectura> GetLecturasById(Guid id_lectura)
    {
        var lectura = _lecturaServicio.GetLecturaById(id_lectura);
        if (lectura == null)
        {
            return NotFound();
        }
        return Ok(lectura);
    }

    [HttpPost]
    public IActionResult AddLectura([FromBody] LecturaDTO lectura)
    {
        _lecturaServicio.AddLectura(lectura);
        return CreatedAtAction(nameof(GetLecturas), new {id_lectura = lectura.IdLectura }, lectura);
    }

    [HttpPut("{id_lectura}")]
    public IActionResult UpdateLectura(Guid id_lectura, [FromBody] LecturaDTO lectura)
    {
        if (id_lectura != lectura.IdLectura)
        {
            return BadRequest();
        }
        _lecturaServicio.UpdateLectura(lectura);
        return NoContent();
    }

    [HttpDelete("{id_lectura}")]
    public IActionResult DeleteLectura(Guid id_lectura)
    {
        _lecturaServicio.DeleteLectura(id_lectura);
        return NoContent();
    }

    [HttpGet("temperaturas/{id_silo}")]
    public ActionResult<Lectura> GetLecturasBySilo(Guid id_silo)
    {
        var temperaturas = _lecturaRepositorio.GetLecturasBySilo(id_silo);
        return Ok();
    }
}