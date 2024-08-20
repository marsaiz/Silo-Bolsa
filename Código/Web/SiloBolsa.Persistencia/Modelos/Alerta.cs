using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore.Storage.Json;

namespace SiloBolsa.Core.Modelos
{
    [Table("alerta")]
    public class Alerta
    {
        [Key]
        [Column("id_alerta")]
        public int IdAlerta { get; set; }

        [Column("fecha_alerta")]
        public DateOnly FechaAlerta { get; set; }

        [Column("hora_alerta")]
        public TimeOnly HoraAlerta { get; set; }

        [Column("mensaje")]
        public string? Mensaje { get; set; }

        [ForeignKey("Silo")]
        [Column("id_silo")]
        public int IdSilo { get; set;}

        public Silo Silo { get; set;}
    }
}