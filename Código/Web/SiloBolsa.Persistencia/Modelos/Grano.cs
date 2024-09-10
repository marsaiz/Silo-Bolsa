using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SiloBolsa.Persistencia.Modelos
{
    [Table("grano")]
    public class Grano
    {
        [Key]
        [Column("id")]
        public int IdGrano { get; set; }
        
        [Column("descripcion")]
        public string? Descripcion { get; set; }

        [Column("humedad_max")]
        public double HumedadMax { get; set; }

        [Column("humedad_min")]
        public double HumedadMin { get; set; }

        [Column("temp_max")]
        public double TempMax { get; set; }

        [Column("temp_min")]
        public double TempMin { get; set; }

        [Column("nivel_dioxido_max")]
        public double NivelDioxidoMax { get; set; }

        [Column("nivel_dioxido_min")]
        public double NivelDioxidoMin { get; set; }
    }

}