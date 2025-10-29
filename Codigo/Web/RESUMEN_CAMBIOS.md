# 🚀 Resumen de Cambios - Migraciones EF Core en Railway

## 📝 Archivos Modificados

### ✅ `Dockerfile`
- Configurado para incluir herramientas de EF Core
- Las migraciones se aplican automáticamente al iniciar

### ✅ `Program.cs`
- Lee variables de entorno de Railway (`DATABASE_URL`)
- Convierte automáticamente el formato PostgreSQL de Railway a .NET
- Aplica `Database.Migrate()` para ejecutar migraciones automáticamente

### ✅ `SiloBolsaContexto.cs`
- Configuradas todas las relaciones entre entidades
- Agregados índices para mejorar rendimiento
- Configurada extensión `uuid-ossp` para PostgreSQL

### ✅ `SiloBolsa.Api.csproj` y `SiloBolsa.Persistencia.csproj`
- Agregado `Microsoft.EntityFrameworkCore.Design` para generación de migraciones

### ✅ `appsettings.json`
- Valores por defecto seguros (localhost)
- Las credenciales reales se configuran en Railway

## 📁 Archivos Nuevos

### ✅ `Migrations/` (Carpeta completa)
- `20251029191145_InitialCreate.cs` - Migración inicial generada desde tus modelos
- `20251029191145_InitialCreate.Designer.cs` - Metadatos de la migración
- `SiloBolsaContextoModelSnapshot.cs` - Snapshot del estado actual

### ✅ `.env.example`
Plantilla de variables de entorno para Railway

### ✅ `DEPLOY_RAILWAY.md`
Guía completa de despliegue con instrucciones paso a paso

### ✅ `.gitignore`
Protege credenciales sensibles

### ⚠️ `docker-entrypoint.sh` y `monitoreo_silo_bolsa.sql`
Ya no se necesitan - las migraciones EF Core los reemplazan

---

## 🔧 Variables de Entorno en Railway

### 🔹 Configuración Mínima Requerida:

```bash
# OPCIÓN 1: Railway provee DATABASE_URL automáticamente si agregas PostgreSQL
# No necesitas configurar nada más para la BD

# OPCIÓN 2: Si usas BD externa (Neon, Supabase, etc.)
ConnectionStrings__DefaultConnection=Host=tu-host;Port=5432;Database=db;User Id=user;Password=pass;SSL Mode=Require;Trust Server Certificate=true

# Email (REQUERIDO)
EmailSettings__SmtpServer=smtp.gmail.com
EmailSettings__SmtpPort=587
EmailSettings__SmtpUser=silobolsaproyecto@gmail.com
EmailSettings__SmtpPassword=tu-password-aqui
```

### 📍 Dónde Configurar en Railway:
1. Ve a tu proyecto en [railway.app](https://railway.app)
2. Selecciona tu servicio (SiloBolsa API)
3. Click en la pestaña **"Variables"**
4. Click en **"New Variable"**
5. Agrega cada variable (nombre y valor)
6. Click en **"Deploy"** para aplicar cambios

---

## ✅ Checklist de Despliegue

### 1. Preparar Repositorio
- [ ] Commit de todos los cambios
- [ ] Push a GitHub

### 2. Configurar Railway
- [ ] Crear proyecto en Railway
- [ ] Conectar repositorio de GitHub
- [ ] Agregar PostgreSQL (o configurar BD externa)
- [ ] Configurar variables de Email
- [ ] Configurar Root Directory: `Codigo/Web`

### 3. Verificar Despliegue
- [ ] Ver logs del deployment
- [ ] Verificar que dice "✅ Base de datos inicializada"
- [ ] Probar endpoint: `https://tu-url.railway.app/weatherforecast`
- [ ] Probar envío de datos desde Arduino

---

## 🔍 Cómo Verificar que Funciona

### Ver Logs en Railway:
```
🚀 Iniciando SiloBolsa API...
⏳ Esperando a que PostgreSQL esté disponible...
📍 Conectando a: tu-host:5432/railway
✅ PostgreSQL está disponible!
🔧 Ejecutando script de inicialización de base de datos...
✅ Base de datos inicializada correctamente!
🔌 Conectando a base de datos: Host=tu-host
🔍 Verificando estado de la base de datos...
✅ Base de datos creada exitosamente!
🚀 Iniciando aplicación...
```

### Probar API:
```bash
# Reemplaza con tu URL de Railway
curl https://tu-proyecto.up.railway.app/api/lecturas

# Enviar datos de prueba
curl -X POST https://tu-proyecto.up.railway.app/api/lecturas \
  -H "Content-Type: application/json" \
  -d '{
    "fechaHoraLectura": "2025-10-29T10:00:00Z",
    "temp": 25.5,
    "humedad": 65.0,
    "dioxidoDeCarbono": 800,
    "idCaja": "cac70d5d-4df3-451f-bba9-59bcea039425"
  }'
```

---

## 🐛 Problemas Comunes

### ❌ Error: "Database connection failed"
**Solución**: 
- Verifica que PostgreSQL esté agregado en Railway
- Verifica variables de entorno en Railway → Variables

### ❌ Error: "Tables not found"
**Solución**: 
- Verifica que `monitoreo_silo_bolsa.sql` esté en el repositorio
- Verifica logs para ver si el script se ejecutó
- Ejecuta manualmente desde Railway Shell:
  ```bash
  railway run psql $DATABASE_URL -f monitoreo_silo_bolsa.sql
  ```

### ❌ Error: "Permission denied: docker-entrypoint.sh"
**Solución**: 
Ya está configurado en el Dockerfile con `chmod +x`, pero si persiste:
```bash
git update-index --chmod=+x docker-entrypoint.sh
git commit -m "Fix permissions"
git push
```

---

## 🎯 Próximos Pasos

1. **Desplegar en Railway** siguiendo `DEPLOY_RAILWAY.md`
2. **Actualizar URL en Arduino**:
   ```cpp
   #define serverName "https://tu-proyecto.up.railway.app/api/lecturas"
   ```
3. **Probar envío de datos** desde ESP8266
4. **Verificar en Railway** que los datos lleguen correctamente

---

## 📞 Soporte

Si tienes problemas:
1. Revisa los logs en Railway → Deployments → Ver logs
2. Verifica variables de entorno en Railway → Variables
3. Consulta `DEPLOY_RAILWAY.md` para instrucciones detalladas

---

¡Todo listo para desplegar! 🚀
