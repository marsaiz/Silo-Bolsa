using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SiloBolsa.Core.Modelos
{
    [Table("silo")]
    public class Silo
    {
        [Key]
        [Column("id_silo")]
        public Guid IdSilo { get; set; }

        [Column("latitud")]
        public double Latitud { get; set; }

        [Column("longitud")]
        public double Longitud { get; set; }

        [Column("capacidad")]
        public int Capacidad { get; set; }

        [Column("tipo_grano")]
        public int TipoGrano{ get; set; }

        [Column("descripcion")]
        public string? Descripcion { get; set; }

        public ICollection<Alerta> Alertas { get; set; }
        public ICollection<Sensores> Sensores { get; set; }
    }
}