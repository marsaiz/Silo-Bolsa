using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SiloBolsa.Core.Modelos
{
    [Table("silo")]
    public class Silo
    {
        [Key]
        [Column("id")]
        public int IdSilo { get; set; }

        [Column("latitud")]
        public double Latitud { get; set; }

        [Column("longitud")]
        public double Longitud { get; set; }

        [Column("capacidad")]
        public int Capacidad { get; set; }

        [Column("tipo_grano")]
        public int TipoGrano{ get; set; }

        public ICollection<Alerta> Alertas { get; set; }
    }
}