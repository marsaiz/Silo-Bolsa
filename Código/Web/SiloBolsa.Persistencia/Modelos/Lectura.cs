using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore.ValueGeneration;

namespace SiloBolsa.Core.Modelos
{
    [Table("lectura")]
    public class Lectura
    {
        [Key]
        [Column("id_lectura")]
        public Guid IdLectura { get; set; }

        [Column("temp")]
        public int Temp { get; set; }

        [Column("fecha_lectura")]
        public DateOnly FechaLecuta { get; set; }

        [Column("hora_lectura")]
        public TimeOnly HoraLecuta { get; set; }
        
        [Column("humedad")]
        public double Humedad { get; set; }

        [Column("dioxido_de_carbono")]
        public double DioxidoDeCarbono { get; set; }

        [ForeignKey("Sensores")]
        [Column("id_caja")]
        public Guid IdCaja { get; set;}

        public Sensores Sensores { get; set; }
    }
}