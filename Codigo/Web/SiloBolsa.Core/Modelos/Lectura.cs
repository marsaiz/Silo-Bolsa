using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SiloBolsa.Core.Modelos
{
    [Table("lectura")]
    public class Lectura
    {
        [Key]
        [Column("id_lectura")]
        public Guid IdLectura { get; set; }

        [Column("fecha_hora_lectura")]
        public DateTime FechaHoraLectura { get; set; }

        [Column("temp")]
        public double Temp { get; set; }

        [Column("humedad")]
        public double Humedad { get; set; }

        [Column("dioxido_de_carbono")]
        public double DioxidoDeCarbono { get; set; }

        // Clave foránea a la tabla caja
        [ForeignKey("Caja")]
        [Column("id_caja")]
        public Guid IdCaja { get; set; }

        // Propiedad de navegación
        public Caja Caja { get; set; }
    }
}