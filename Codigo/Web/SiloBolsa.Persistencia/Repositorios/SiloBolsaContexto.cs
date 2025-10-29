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

        // Configurar relaciones y restricciones
        
        // Silo -> Grano (muchos a uno)
        modelBuilder.Entity<Silo>()
            .HasOne(s => s.GranoSilo)
            .WithMany()
            .HasForeignKey(s => s.TipoGrano)
            .OnDelete(DeleteBehavior.Restrict);

        // Silo -> Alertas (uno a muchos)
        modelBuilder.Entity<Silo>()
            .HasMany(s => s.Alertas)
            .WithOne(a => a.Silo)
            .HasForeignKey(a => a.IdSilo)
            .OnDelete(DeleteBehavior.Cascade);

        // Silo -> Cajas (uno a muchos)
        modelBuilder.Entity<Silo>()
            .HasMany(s => s.Cajas)
            .WithOne(c => c.Silo)
            .HasForeignKey(c => c.IdSilo)
            .OnDelete(DeleteBehavior.Cascade);

        // Caja -> Lecturas (uno a muchos)
        modelBuilder.Entity<Caja>()
            .HasMany(c => c.Lecturas)
            .WithOne(l => l.Caja)
            .HasForeignKey(l => l.IdCaja)
            .OnDelete(DeleteBehavior.Cascade);

        // Configurar índices para mejorar rendimiento
        modelBuilder.Entity<Lectura>()
            .HasIndex(l => l.FechaHoraLectura);

        modelBuilder.Entity<Alerta>()
            .HasIndex(a => a.FechaHoraAlerta);

        // Valores por defecto
        modelBuilder.Entity<Alerta>()
            .Property(a => a.CorreoEnviado)
            .HasDefaultValue(false);

        // Crear extensión uuid-ossp para generar UUIDs
        modelBuilder.HasPostgresExtension("uuid-ossp");
    }
}