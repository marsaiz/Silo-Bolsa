using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore.Storage;

namespace SiloBolsa.Core.Modelos
{
    [Table("sensores")]
    public class Sensores
    {
        [Key]
        [Column("id_caja")]
        public Guid IdCaja { get; set; }

        [Column("ubicacion_en_silo")]
        public int UbicacionEnSilo { get; set; }

        [ForeignKey("Silo")]
        [Column("id_silo")]
        public Guid IdSilo { get; set; }

        public Silo Silo { get; set; }
        public ICollection<Lectura> Lecturas { get; set; }
    }
}