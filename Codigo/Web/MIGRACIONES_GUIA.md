# 🔄 Guía de Migraciones EF Core

## ¿Por qué Migraciones en lugar de SQL?

### ✅ **Ventajas de EF Core Migrations**:

1. **Sincronización automática**: Las migraciones se generan desde tus modelos C#
2. **Versionado**: Cada cambio queda registrado en el historial
3. **Seguridad**: No hay riesgo de que el SQL esté desactualizado
4. **Reversibilidad**: Puedes revertir cambios fácilmente
5. **Multiplataforma**: Funcionan en cualquier entorno (local, Railway, Azure, etc.)

### ❌ **Problemas con archivos SQL manuales**:

- 😓 Mantenerlos sincronizados con los modelos
- 🐛 Errores al modificar manualmente
- 📝 Dificultad para rastrear cambios
- 🔄 No hay forma fácil de revertir

---

## 📋 Tu Estructura de Modelos

```
SiloBolsa.Core/Modelos/
├── Grano.cs           → Tabla: grano
├── Silo.cs            → Tabla: silo
├── Caja.cs            → Tabla: caja
├── Lectura.cs         → Tabla: lectura
└── Alerta.cs          → Tabla: alerta
```

### 🔗 Relaciones Configuradas:

```
Grano (1) ←→ (N) Silo
Silo (1) ←→ (N) Caja
Silo (1) ←→ (N) Alerta
Caja (1) ←→ (N) Lectura
```

---

## 🚀 Migración Inicial Generada

### Archivo: `20251029191145_InitialCreate.cs`

Esta migración crea:

#### ✅ Tablas:
- `grano` - Tipos de granos con umbrales de temperatura, humedad y CO2
- `silo` - Silos con ubicación geográfica (lat/long) y capacidad
- `caja` - Cajas sensoras con ubicación dentro del silo
- `lectura` - Lecturas de sensores (temp, humedad, CO2)
- `alerta` - Alertas generadas por el sistema

#### ✅ Relaciones (Foreign Keys):
- `silo.tipo_grano` → `grano.id`
- `caja.id_silo` → `silo.id_silo`
- `lectura.id_caja` → `caja.id_caja`
- `alerta.id_silo` → `silo.id_silo`

#### ✅ Índices:
- `lectura.fecha_hora_lectura` - Para consultas rápidas por fecha
- `alerta.fecha_ḧora_alerta` - Para búsqueda de alertas

#### ✅ Extensiones PostgreSQL:
- `uuid-ossp` - Para generar UUIDs automáticamente

---

## 🔧 Cómo Funcionan las Migraciones

### 1️⃣ **En Desarrollo Local**:

```bash
# Cambias un modelo, por ejemplo:
# Agrega una propiedad nueva a Lectura.cs

# Generas la migración:
cd Codigo/Web
dotnet ef migrations add AgregarNuevocampo --project SiloBolsa.Persistencia --startup-project SiloBolsa.Api

# Aplicas la migración localmente:
dotnet ef database update --project SiloBolsa.Persistencia --startup-project SiloBolsa.Api
```

### 2️⃣ **En Railway (Producción)**:

Cuando haces `git push`:
1. Railway detecta los cambios
2. Construye el Docker container
3. Al iniciar la app, `Program.cs` ejecuta `Database.Migrate()`
4. Se aplican automáticamente todas las migraciones pendientes

---

## 📝 Comandos Útiles

### Ver migraciones disponibles:
```bash
cd Codigo/Web
dotnet ef migrations list --project SiloBolsa.Persistencia --startup-project SiloBolsa.Api
```

### Generar script SQL de una migración (para revisar):
```bash
dotnet ef migrations script --project SiloBolsa.Persistencia --startup-project SiloBolsa.Api
```

### Revertir la última migración:
```bash
dotnet ef migrations remove --project SiloBolsa.Persistencia --startup-project SiloBolsa.Api
```

### Ver el estado de la base de datos:
```bash
dotnet ef database info --project SiloBolsa.Persistencia --startup-project SiloBolsa.Api
```

---

## 🆕 Agregar Nuevas Migraciones

### Ejemplo: Agregar campo "observaciones" a Lectura

#### 1. Modificar el modelo:

```csharp
// Lectura.cs
[Column("observaciones")]
public string? Observaciones { get; set; }
```

#### 2. Generar migración:

```bash
cd Codigo/Web
dotnet ef migrations add AgregarObservacionesALectura --project SiloBolsa.Persistencia --startup-project SiloBolsa.Api
```

#### 3. Revisar la migración generada:

```csharp
// Migrations/20251029XXXXXX_AgregarObservacionesALectura.cs
protected override void Up(MigrationBuilder migrationBuilder)
{
    migrationBuilder.AddColumn<string>(
        name: "observaciones",
        table: "lectura",
        type: "text",
        nullable: true);
}
```

#### 4. Commit y push:

```bash
git add .
git commit -m "Agregar campo observaciones a Lectura"
git push
```

#### 5. Railway aplicará la migración automáticamente ✅

---

## 🔍 Verificar Migraciones en Railway

### En los logs de Railway verás:

```
🔌 Conectando a base de datos: Host=containers-xyz.railway.app
🔍 Verificando migraciones pendientes...
Applying migration '20251029191145_InitialCreate'.
Applying migration '20251029XXXXXX_AgregarObservacionesALectura'.
✅ Migraciones aplicadas exitosamente!
```

### Tabla de historial en la BD:

Railway mantiene una tabla `__EFMigrationsHistory`:

| MigrationId | ProductVersion |
|-------------|----------------|
| 20251029191145_InitialCreate | 8.0.8 |
| 20251029XXXXXX_AgregarObservacionesALectura | 8.0.8 |

---

## 🛡️ Seguridad y Buenas Prácticas

### ✅ **HACER**:
- Generar migraciones después de cada cambio en modelos
- Revisar las migraciones antes de hacer commit
- Probar migraciones localmente antes de desplegar
- Mantener nombres descriptivos en las migraciones
- Hacer commits separados por migración

### ❌ **NO HACER**:
- Modificar migraciones ya aplicadas en producción
- Borrar archivos de migraciones del repositorio
- Editar manualmente la tabla `__EFMigrationsHistory`
- Aplicar `EnsureCreated()` después de usar migraciones
- Hacer cambios directamente en la BD de producción

---

## 🔄 Comparación: SQL vs Migraciones

| Aspecto | SQL Manual | EF Core Migrations |
|---------|------------|-------------------|
| **Sincronización** | 😓 Manual | ✅ Automática |
| **Versionado** | ❌ Difícil | ✅ Integrado |
| **Reversibilidad** | ❌ Manual | ✅ Automática |
| **Testing** | 😓 Complejo | ✅ Simple |
| **Multiplataforma** | ⚠️ Depende del DB | ✅ Sí |
| **Historial** | ❌ No | ✅ Sí |
| **CI/CD** | 😓 Scripts | ✅ Automático |

---

## 🐛 Troubleshooting

### Error: "Migration already applied"
✅ Normal, significa que ya fue aplicada anteriormente. No hay problema.

### Error: "Pending model changes"
```bash
# Genera la migración para los cambios pendientes:
dotnet ef migrations add DescripcionDelCambio --project SiloBolsa.Persistencia --startup-project SiloBolsa.Api
```

### Error: "Connection string not configured"
✅ Verifica variables de entorno en Railway (ver `VARIABLES_ENTORNO.md`)

### Error: "Permission denied to create extension"
```sql
-- Ejecutar en Railway Database Query:
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

---

## 📚 Recursos Adicionales

- [EF Core Migrations](https://learn.microsoft.com/ef/core/managing-schemas/migrations/)
- [Npgsql EF Core Provider](https://www.npgsql.org/efcore/)
- [Railway PostgreSQL](https://docs.railway.app/databases/postgresql)

---

¡Ahora tus migraciones están completamente automatizadas! 🎉
