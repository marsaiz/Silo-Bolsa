# 🚀 Guía de Despliegue en Railway

## 📋 Pasos para Configurar Variables de Entorno en Railway

### 1️⃣ Conectar Base de Datos PostgreSQL

Railway puede proveer una base de datos PostgreSQL automáticamente:

#### Opción A: Agregar PostgreSQL desde Railway
1. En tu proyecto de Railway, haz clic en **"New Service"**
2. Selecciona **"Database" → "PostgreSQL"**
3. Railway creará automáticamente las variables:
   - `PGHOST`
   - `PGPORT`
   - `PGDATABASE`
   - `PGUSER`
   - `PGPASSWORD`
   - `DATABASE_URL` (formato PostgreSQL completo)

#### Opción B: Usar Base de Datos Externa (Neon, Supabase, etc.)
Si ya tienes una base de datos PostgreSQL externa:

1. Ve a tu proyecto en Railway
2. Selecciona tu servicio (SiloBolsa API)
3. Ve a la pestaña **"Variables"**
4. Agrega la variable `ConnectionStrings__DefaultConnection`:

```
ConnectionStrings__DefaultConnection=Host=tu-host.neon.tech;Port=5432;Database=monitoreo_silo_bolsa;User Id=tu-usuario;Password=tu-password;SSL Mode=Require;Trust Server Certificate=true
```

**⚠️ Importante**: Railway usa doble guión bajo `__` para separar secciones de configuración de .NET

---

### 2️⃣ Configurar Variables de Email

En la pestaña **"Variables"** de Railway, agrega:

```
EmailSettings__SmtpServer=smtp.gmail.com
EmailSettings__SmtpPort=587
EmailSettings__SmtpUser=silobolsaproyecto@gmail.com
EmailSettings__SmtpPassword=jpzf gttc aaoq tdcz
```

---

### 3️⃣ Variables Automáticas de Railway

Railway configura automáticamente:

- ✅ `PORT` - Puerto donde correrá la aplicación
- ✅ `RAILWAY_ENVIRONMENT` - Entorno de ejecución
- ✅ `RAILWAY_PROJECT_NAME` - Nombre del proyecto

**No necesitas configurar estas manualmente.**

---

## 🔧 Cómo Funcionan las Migraciones

La aplicación usa **Entity Framework Core Migrations** para gestionar el esquema de la base de datos automáticamente.

### ✅ Funcionamiento Automático:

Cuando despliegues en Railway:

1. **Migraciones incluidas**: El proyecto ya tiene la migración `InitialCreate` generada desde tus modelos
2. **Aplicación automática**: En `Program.cs`, el código ejecuta `dbContext.Database.Migrate()` al iniciar
3. **Sincronización**: Las tablas se crean/actualizan según tus modelos de dominio
4. **Idempotencia**: Es seguro ejecutarlo múltiples veces, solo aplica migraciones pendientes

### 📋 Tablas que se crean automáticamente:

- ✅ `grano` - Tipos de granos con rangos de valores
- ✅ `silo` - Silos con ubicación y capacidad
- ✅ `caja` - Cajas de sensores dentro de silos
- ✅ `lectura` - Lecturas de sensores (temperatura, humedad, CO2)
- ✅ `alerta` - Alertas generadas por el sistema
- ✅ `__EFMigrationsHistory` - Historial de migraciones aplicadas

### 🔄 Agregar Nuevas Migraciones:

Si cambias tus modelos en el futuro:

```bash
# En tu máquina local
cd Codigo/Web
dotnet ef migrations add NombreDeLaMigracion --project SiloBolsa.Persistencia --startup-project SiloBolsa.Api

# Commit y push
git add .
git commit -m "Agregar migración: NombreDeLaMigracion"
git push
```

Railway aplicará automáticamente las nuevas migraciones en el próximo despliegue.

---

## 📁 Estructura de Archivos Actualizada

```
Codigo/Web/
├── Dockerfile                    ✅ Actualizado (sin scripts SQL)
├── .env.example                  ✅ NUEVO (ejemplo de variables)
├── monitoreo_silo_bolsa.sql      ⚠️  (ya no se usa, reemplazado por migraciones)
├── SiloBolsa.Persistencia/
│   └── Migrations/
│       ├── 20251029191145_InitialCreate.cs      ✅ NUEVO (migración inicial)
│       ├── 20251029191145_InitialCreate.Designer.cs
│       └── SiloBolsaContextoModelSnapshot.cs
└── SiloBolsa.Api/
    ├── Program.cs                ✅ Actualizado (aplica migraciones automáticamente)
    └── appsettings.json          ⚠️  (valores por defecto, Railway usa variables)
```

---

## 🌐 Desplegar en Railway

### Método 1: Desde GitHub (Recomendado)

1. **Conecta tu repositorio**:
   - Ve a [railway.app](https://railway.app)
   - Haz clic en **"New Project"**
   - Selecciona **"Deploy from GitHub repo"**
   - Elige tu repositorio `Silo-Bolsa`

2. **Configura el directorio**:
   - Railway detectará el Dockerfile automáticamente
   - Si no, configura el **Root Directory** a: `Codigo/Web`

3. **Agrega PostgreSQL**:
   - Haz clic en **"New Service" → "Database" → "PostgreSQL"**
   - Railway vinculará automáticamente las variables

4. **Configura variables de Email**:
   - Ve a **Variables** y agrega las variables de EmailSettings

5. **Deploy**:
   - Railway construirá y desplegará automáticamente
   - Obtendrás una URL como: `https://tu-proyecto.up.railway.app`

### Método 2: Desde CLI de Railway

```bash
# Instalar Railway CLI
npm install -g @railway/cli

# Login
railway login

# Inicializar proyecto
cd Codigo/Web
railway init

# Agregar PostgreSQL
railway add --database postgresql

# Deploy
railway up
```

---

## 🔍 Verificar Despliegue

### Ver Logs en Railway:
1. Ve a tu proyecto
2. Haz clic en tu servicio
3. Ve a la pestaña **"Deployments"**
4. Haz clic en el deployment activo
5. Verás logs como:

```
🚀 Iniciando SiloBolsa API...
🔌 Conectando a base de datos: Host=tu-host
� Verificando migraciones pendientes...
Applying migration '20251029191145_InitialCreate'.
✅ Migraciones aplicadas exitosamente!
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://0.0.0.0:8080
```

### Probar tu API:
```bash
# Reemplaza con tu URL de Railway
curl https://tu-proyecto.up.railway.app/weatherforecast
```

---

## 🔐 Variables de Entorno en Railway - Resumen

| Variable | Valor | Fuente |
|----------|-------|--------|
| `DATABASE_URL` | `postgresql://user:pass@host:port/db` | Railway (automático) |
| `ConnectionStrings__DefaultConnection` | Connection string de .NET | Manual (si usas DB externa) |
| `EmailSettings__SmtpServer` | `smtp.gmail.com` | Manual |
| `EmailSettings__SmtpPort` | `587` | Manual |
| `EmailSettings__SmtpUser` | Tu email | Manual |
| `EmailSettings__SmtpPassword` | Tu password de app | Manual |
| `PORT` | `8080` (o el que asigne Railway) | Railway (automático) |
| `ASPNETCORE_ENVIRONMENT` | `Production` | Opcional |

---

## ✅ Checklist de Despliegue

- [ ] Repositorio conectado a Railway
- [ ] PostgreSQL agregado (o configurado externamente)
- [ ] Variables de Email configuradas
- [ ] Dockerfile en `Codigo/Web/Dockerfile`
- [ ] Carpeta `Migrations` incluida en el repositorio
- [ ] Deployment exitoso (sin errores en logs)
- [ ] Migraciones aplicadas (ver logs)
- [ ] API responde en la URL de Railway
- [ ] ESP8266 puede enviar datos a la API

---

## 🐛 Solución de Problemas

### Error: "No se puede conectar a la base de datos"
- ✅ Verifica que `DATABASE_URL` o `ConnectionStrings__DefaultConnection` estén configuradas
- ✅ Verifica que el PostgreSQL esté corriendo en Railway
- ✅ Revisa los logs del deployment

### Error: "Tablas no existen"
- ✅ Verifica que la carpeta `Migrations` esté en el repositorio
- ✅ Revisa los logs para ver si las migraciones se aplicaron
- ✅ Verifica que el usuario de la BD tenga permisos para crear tablas

### Error: "Migration already applied"
- ℹ️  Es normal, significa que la migración ya fue aplicada anteriormente
- ✅ No hay problema, la aplicación continuará normalmente

### Las migraciones no se ejecutan
- ✅ Verifica que `Program.cs` tenga el código de `dbContext.Database.Migrate()`
- ✅ Verifica que las migraciones estén en `SiloBolsa.Persistencia/Migrations/`
- ✅ Revisa los logs del contenedor para ver errores específicos

---

## 📚 Recursos Adicionales

- [Railway Documentation](https://docs.railway.app/)
- [Railway Variables](https://docs.railway.app/develop/variables)
- [Entity Framework Core Migrations](https://learn.microsoft.com/ef/core/managing-schemas/migrations/)
- [PostgreSQL Connection Strings](https://www.npgsql.org/doc/connection-string-parameters.html)

---

¡Tu aplicación debería estar funcionando en Railway! 🎉
