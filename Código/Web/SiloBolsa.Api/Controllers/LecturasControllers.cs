using Microsoft.AspNetCore.Mvc;
using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Api.Controllers;

[ApiController]
[Route("api/lecturas")]
public class LecturasControllers : ControllerBase
{
    private readonly ILecturaServicio _lecturaServicio;
    public LecturasControllers(ILecturaServicio lecuraServicio)
    {
        _lecturaServicio = lecuraServicio;
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
        if (lectura == null)
        {
            return BadRequest("El objeto Lectura no puede ser nulo");
        }

        _lecturaServicio.AddLectura(lectura); //El servicio genera el IdLectura
        return Ok("Lectura agregada correctamente");
        //return CreatedAtAction(nameof(GetLecturas), new {id_lectura = lectura.IdLectura }, lectura);
    }

    /* [HttpPut("{id_lectura}")]
    public IActionResult UpdateLectura(Guid id_lectura, [FromBody] LecturaDTO lectura)
    {
        if (id_lectura != lectura.IdLectura)
        {
            return BadRequest();
        }
        _lecturaServicio.UpdateLectura(lectura);
        return NoContent();
    } */

    [HttpDelete("{id_lectura}")]
    public IActionResult DeleteLectura(Guid id_lectura)
    {
        _lecturaServicio.DeleteLectura(id_lectura);
        return NoContent();
    }

    [HttpGet("silo/{id_silo}")]
    public ActionResult<LecturaDTO> GetLecturasByIdSilo(String id_silo)
    {
        Guid id_silo_elegido = Guid.Parse(id_silo);
        var lecturas = _lecturaServicio.GetLecturasByIdSilo(id_silo_elegido);
        if (lecturas != null && !lecturas.Any())
        {
            return NotFound("No se econtraron lecturas para el silo especificado.");
        }
        var lecturasDatos = lecturas.Select(l => new LecturaDTO
        {
            FechaHoraLectura = l.FechaHoraLectura,
            Temp = l.Temp,
            Humedad = l.Humedad,
            DioxidoDeCarbono = l.DioxidoDeCarbono,
            IdCaja = l.IdCaja
        }).ToList();
        return Ok(lecturasDatos);
    }
}