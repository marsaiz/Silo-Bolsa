using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace SiloBolsa.Core.Modelos
{
    [Table("sensores")]
    public class Sensores
    {
        [Key]
        [Column("id_caja")]
        public int IdCaja { get; set; }

        [Column("ubicacion_en_silo")]
        public int UbicacionEnSilo { get; set; }

        [ForeignKey("silo")]
        [Column("id")]
        public int IdSilo { get; set; }

        public Silo id_silo { get; set; }
    }
}