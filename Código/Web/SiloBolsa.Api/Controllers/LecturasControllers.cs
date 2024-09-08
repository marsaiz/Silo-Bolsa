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
public class LecturasControllers : ControllerBase
{
    private readonly ILecturaRepositorio _lecturaRepositorio;
    public LecturasControllers(ILecturaRepositorio lecuraRepositorio)
    {
        _lecturaRepositorio = lecuraRepositorio;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Silo>> GetLecturas()
    {
        var lecturas = _lecturaRepositorio.GetLecturas();
        return Ok(lecturas);
    }

    [HttpGet("{id_lectura}")]
    public ActionResult<Lectura> GetLecturasById(Guid id_lectura)
    {
        var lectura = _lecturaRepositorio.GetLecturaById(id_lectura);
        if (lectura == null)
        {
            return NotFound();
        }
        return Ok(lectura);
    }

    [HttpPost]
    public IActionResult AddLectura([FromBody] Lectura lectura)
    {
        _lecturaRepositorio.AddLectura(lectura);
        return CreatedAtAction(nameof(GetLecturas), new {id_lectura = lectura.IdLectura }, lectura);
    }

    [HttpPut("{id_lectura}")]
    public IActionResult UpdateLectura(Guid id_lectura, [FromBody] Lectura lectura)
    {
        if (id_lectura != lectura.IdLectura)
        {
            return BadRequest();
        }
        _lecturaRepositorio.UpdateLectura(lectura);
        return NoContent();
    }

    [HttpDelete("{id_lectura}")]
    public IActionResult DeleteLectura(Guid id_lectura)
    {
        _lecturaRepositorio.DeleteLectura(id_lectura);
        return NoContent();
    }
}