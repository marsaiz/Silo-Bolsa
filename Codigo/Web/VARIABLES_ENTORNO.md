# ⚙️ Configuración de Variables de Entorno en Railway

## 📋 Variables Requeridas

### 🔹 Opción 1: PostgreSQL de Railway (RECOMENDADO)

Si agregas PostgreSQL desde Railway, estas variables se crean **automáticamente**:

```
DATABASE_URL=postgresql://postgres:password@hostname:port/database
PGHOST=hostname
PGPORT=5432
PGDATABASE=railway
PGUSER=postgres
PGPASSWORD=password
```

**Solo necesitas agregar manualmente:**

| Variable | Valor | Descripción |
|----------|-------|-------------|
| `EmailSettings__SmtpServer` | `smtp.gmail.com` | Servidor SMTP |
| `EmailSettings__SmtpPort` | `587` | Puerto SMTP |
| `EmailSettings__SmtpUser` | `silobolsaproyecto@gmail.com` | Usuario email |
| `EmailSettings__SmtpPassword` | `jpzf gttc aaoq tdcz` | Contraseña de app Gmail |

---

### 🔹 Opción 2: Base de Datos Externa (Neon, Supabase, etc.)

Si usas una base de datos externa, debes configurar **todas** estas variables:

| Variable | Ejemplo | Descripción |
|----------|---------|-------------|
| `ConnectionStrings__DefaultConnection` | `Host=ep-xxx.neon.tech;Port=5432;Database=monitoreo_silo_bolsa;User Id=marsaiz;Password=xxxx;SSL Mode=Require;Trust Server Certificate=true` | Connection string completo |
| `EmailSettings__SmtpServer` | `smtp.gmail.com` | Servidor SMTP |
| `EmailSettings__SmtpPort` | `587` | Puerto SMTP |
| `EmailSettings__SmtpUser` | `silobolsaproyecto@gmail.com` | Usuario email |
| `EmailSettings__SmtpPassword` | `jpzf gttc aaoq tdcz` | Contraseña de app Gmail |

---

## 🖥️ Cómo Configurar en Railway (Paso a Paso)

### 📸 Método Visual:

1. **Accede a tu proyecto**
   - Ve a [railway.app](https://railway.app)
   - Entra a tu proyecto `Silo-Bolsa`

2. **Selecciona tu servicio**
   - Click en el servicio de tu API (no en PostgreSQL)

3. **Abre la configuración de Variables**
   - Click en la pestaña **"Variables"** (icono de llave 🔑)

4. **Agregar nueva variable**
   - Click en **"New Variable"** o **"Add Variable"**
   - Ingresa el **nombre** de la variable
   - Ingresa el **valor** de la variable
   - Click en **"Add"**

5. **Repetir para cada variable**
   - Agrega todas las variables de la tabla de arriba

6. **Deploy**
   - Railway redesplegará automáticamente
   - O haz click en **"Deploy"** manualmente

---

## 🔗 Formato de Connection String

### ✅ Formato .NET (ConnectionStrings__DefaultConnection):
```
Host=hostname;Port=5432;Database=dbname;User Id=username;Password=password;SSL Mode=Require;Trust Server Certificate=true
```

### ✅ Formato PostgreSQL (DATABASE_URL):
```
postgresql://username:password@hostname:port/database
```

**Railway convierte automáticamente** `DATABASE_URL` al formato .NET si está configurado en `Program.cs` (ya lo hicimos ✅)

---

## 📧 Configuración de Gmail para SMTP

### Generar Contraseña de Aplicación:

1. **Habilita la verificación en 2 pasos** en tu cuenta de Gmail
   - Ve a https://myaccount.google.com/security
   - Activa "Verificación en dos pasos"

2. **Genera una contraseña de aplicación**
   - Ve a https://myaccount.google.com/apppasswords
   - Selecciona "Correo" y tu dispositivo
   - Copia la contraseña generada (16 caracteres sin espacios)

3. **Usa esta contraseña** en `EmailSettings__SmtpPassword`

**⚠️ NO uses tu contraseña normal de Gmail**

---

## 🧪 Variables para Testing/Development

Si quieres probar localmente antes de desplegar, crea un archivo `.env` (NO subir a Git):

```bash
# .env (solo para desarrollo local)
ConnectionStrings__DefaultConnection=Host=localhost;Port=5432;Database=monitoreo_silo_bolsa;User Id=postgres;Password=postgres
EmailSettings__SmtpServer=smtp.gmail.com
EmailSettings__SmtpPort=587
EmailSettings__SmtpUser=tu-email@gmail.com
EmailSettings__SmtpPassword=tu-password-aqui
PORT=8080
ASPNETCORE_ENVIRONMENT=Development
```

Para usar el archivo `.env` localmente, instala:
```bash
dotnet add package DotNetEnv
```

Y en `Program.cs`:
```csharp
DotNetEnv.Env.Load();
```

---

## ✅ Verificar Variables Configuradas

### En Railway Dashboard:
1. Ve a tu servicio
2. Click en **"Variables"**
3. Verás todas las variables configuradas (contraseñas ocultas con `***`)

### En Logs:
Cuando despliegues, verás en los logs:
```
🔌 Conectando a base de datos: Host=tu-host
```

Si ves esto, ¡las variables están bien configuradas! ✅

---

## 🔐 Seguridad

### ✅ HACER:
- Usar variables de entorno en Railway
- Usar contraseñas de aplicación para Gmail
- Usar SSL Mode=Require para conexiones a BD
- Mantener `appsettings.json` con valores por defecto

### ❌ NO HACER:
- Subir credenciales reales a Git
- Compartir variables de entorno públicamente
- Usar contraseñas normales de Gmail
- Hardcodear credenciales en el código

---

## 📊 Tabla Resumen

| Variable | ¿Automática? | ¿Requerida? | Valor por Defecto |
|----------|--------------|-------------|-------------------|
| `DATABASE_URL` | ✅ (con PG de Railway) | ✅ | Railway lo crea |
| `ConnectionStrings__DefaultConnection` | ❌ | Solo si BD externa | - |
| `EmailSettings__SmtpServer` | ❌ | ✅ | `smtp.gmail.com` |
| `EmailSettings__SmtpPort` | ❌ | ✅ | `587` |
| `EmailSettings__SmtpUser` | ❌ | ✅ | Tu email |
| `EmailSettings__SmtpPassword` | ❌ | ✅ | Password de app |
| `PORT` | ✅ | ✅ | Railway lo asigna |
| `ASPNETCORE_ENVIRONMENT` | ❌ | ❌ | `Production` |

---

## 🎯 Ejemplo Completo (PostgreSQL de Railway)

```bash
# Variables automáticas (Railway las crea):
DATABASE_URL=postgresql://postgres:ABCxyz123@containers-xyz.railway.app:5432/railway
PGHOST=containers-xyz.railway.app
PGPORT=5432
PGDATABASE=railway
PGUSER=postgres
PGPASSWORD=ABCxyz123
PORT=3000

# Variables manuales (debes agregarlas):
EmailSettings__SmtpServer=smtp.gmail.com
EmailSettings__SmtpPort=587
EmailSettings__SmtpUser=silobolsaproyecto@gmail.com
EmailSettings__SmtpPassword=abcd efgh ijkl mnop
```

---

## 🆘 Troubleshooting

### ❌ "Connection refused"
- Verifica que `DATABASE_URL` o `ConnectionStrings__DefaultConnection` estén configuradas
- Verifica que el PostgreSQL esté running en Railway

### ❌ "Authentication failed"
- Verifica usuario y contraseña
- Para BD externa, verifica que permita conexiones SSL

### ❌ "Email sending failed"
- Verifica que uses contraseña de aplicación (no contraseña normal)
- Verifica que la verificación en 2 pasos esté activada
- Verifica que el puerto sea 587 (no 465)

---

¡Listo para configurar! 🚀
