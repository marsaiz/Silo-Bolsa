using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using SiloBolsa.App.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Api.Controllers;

[ApiController]
[Route("controller")]
public class GranosControllers : ControllerBase
{

    private readonly IGranoRepositorio _granoRepositorio;

    public GranosControllers(IGranoRepositorio granoRepositorio)
    {
        _granoRepositorio = granoRepositorio;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Grano>> GetGranos()
    {
        var granos = _granoRepositorio.GetGranos();
        return Ok(granos);
    }

    [HttpGet("{id}")]
    public ActionResult<Grano> GetGranoById(int id)
    {
        var grano = _granoRepositorio.GetGranoById(id);
        if (grano == null)
        {
            return NotFound();
        }
        return Ok(grano);
    }
    [HttpPost]
    public IActionResult AddGrano([FromBody] Grano grano)
    {
        _granoRepositorio.AddGrano(grano);
        return CreatedAtAction(nameof(GetGranos), new { grano = grano.IdGrano }, grano);
    }

    [HttpPut("{id}")]
    public IActionResult UpdateGrano(int id, [FromBody] Grano grano)
    {
        if (id != grano.IdGrano)
        {
            return BadRequest();
        }
        _granoRepositorio.UpdateGrano(grano);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public IActionResult DeleteGrano(int id)
    {
        _granoRepositorio.DeleteGrano(id);
        return NoContent();
    }

}
