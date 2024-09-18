using Microsoft.AspNetCore.Mvc;
using SiloBolsa.Servicios.Interfaces;
using SiloBolsa.Core.Modelos;

namespace SiloBolsa.Api.Controllers;

[ApiController]
[Route("api/granos")]
public class GranosControllers : ControllerBase
{

    private readonly IGranoServicio _granoServicio;

    public GranosControllers(IGranoServicio granoServicio)
    {
        _granoServicio = granoServicio;
    }

    [HttpGet]
    public ActionResult<IEnumerable<Grano>> GetGranos()
    {
        var granos = _granoServicio.GetGranos();
        return Ok(granos);
    }

    [HttpGet("{id}")]
    public ActionResult<Grano> GetGranoById(int id)
    {
        var grano = _granoServicio.GetGranoById(id);
        if (grano == null)
        {
            return NotFound();
        }
        return Ok(grano);
    }
    [HttpPost]
    public IActionResult AddGrano([FromBody] Grano grano)
    {
        _granoServicio.AddGrano(grano);
        return CreatedAtAction(nameof(GetGranos), new { grano = grano.IdGrano }, grano);
    }

    [HttpPut("{id}")]
    public IActionResult UpdateGrano(int id, [FromBody] Grano grano)
    {
        if (id != grano.IdGrano)
        {
            return BadRequest();
        }
        _granoServicio.UpdateGrano(grano);
        return NoContent();
    }

    [HttpDelete("{id}")]
    public IActionResult DeleteGrano(int id)
    {
        _granoServicio.DeleteGrano(id);
        return NoContent();
    }

}
