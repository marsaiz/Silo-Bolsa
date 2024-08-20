using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SiloBolsa.Core.Modelos
{
    [Table("lectura")]
    public class Lectura
    {
        [Key]
        [Column("id_lectura")]
        public int IdLectura { get; set; }

        [Column("temp")]
        public int Temp { get; set; }

        [Column("fecha_lectura")]
        public DateOnly FechaLecuta { get; set; }

        [Column("hora_lectura")]
        public TimeOnly HoraLecuta { get; set; }
        
        [Column("humedad")]
        public float Humedad { get; set; }

        [Column("dioxido_de_carbono")]
        public float DioxidoDeCarbono { get; set; }

        [ForeignKey("sensores")]
        [Column("id_caja")]
        public int IdCaja { get; set;}

        public Sensores id_caja { get; set; }
    }
}