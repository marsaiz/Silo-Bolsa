using SiloBolsa.Core.Modelos;
using Microsoft.EntityFrameworkCore;

namespace SiloBolsa.Persistencia.Repositorios;
public class SiloBolsaContexto : DbContext
{
    private static SiloBolsaContexto instanciaContexto;
    private readonly string _cadenaConexion;
    private SiloBolsaContexto(string cadenaConexion)
    {
        _cadenaConexion = cadenaConexion;
    }

    public DbSet<Alerta> Alertas { get; set; }
    public DbSet<Grano> Granos { get; set; }
    public DbSet<Lectura> Lecturas { get; set; }
    public DbSet<Sensores> Sensores { get; set; }
    public DbSet<Silo> Silos { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
    }

    /*
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseNpgsql(_cadenaConexion);
            base.OnConfiguring(optionsBuilder);
        }

         protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Silo>().HasNoKey();
            base.OnModelCreating(modelBuilder);
        }
        public static SiloBolsaContexto CrearInstancia()
        {
            if (instanciaContexto == null)
            {
                instanciaContexto = new SiloBolsaContexto("Server=localhost;Database=monitoreo_silo_bolsa;User Id=postgres;Password=itesql");
            }
            return instanciaContexto;
        }
        */
}