using SiloBolsa.Core.Modelos;
using Microsoft.EntityFrameworkCore;

namespace SiloBolsa.Persistencia.Repositorios;
public class SiloBolsaContexto : DbContext
{
public SiloBolsaContexto(DbContextOptions<SiloBolsaContexto> options) : base(options)
{

}
    public DbSet<Alerta> Alertas { get; set; }
    public DbSet<Grano> Granos { get; set; }
    public DbSet<Lectura> Lecturas { get; set; }
    public DbSet<Caja> Cajas { get; set; }
    public DbSet<Silo> Silos { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
    }
}