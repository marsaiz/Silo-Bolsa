using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore.Storage.Json;

namespace SiloBolsa.Core.Modelos;

[Table("alerta")]
public class Alerta
{
    [Key]
    [Column("id_alerta")]
    public Guid IdAlerta { get; set; }

    [Column("fecha_ḧora_alerta")]
    public DateTime FechaHoraAlerta { get; set; }

    [Column("mensaje")]
    public string? Mensaje { get; set; }

    [ForeignKey("Silo")]
    [Column("id_silo")]
    //[ForeignKey("IdSilo")]
    public Guid IdSilo { get; set; }

    public Silo Silo { get; set; }
}