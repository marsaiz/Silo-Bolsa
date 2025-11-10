# Guía de despliegue en Railway para Silo-Bolsa

## Pasos para desplegar cambios en Flutter y .NET

1. **Compilar Flutter Web localmente**
   - Ejecuta el script `build_flutter_web.ps1` en `Codigo/Web/`.
   - Esto compila el proyecto Flutter y copia los archivos generados a `Codigo/Web/SiloBolsa.Api/wwwroot/flutter`.

2. **Verificar archivos generados**
   - Asegúrate de que los archivos en `wwwroot/flutter` estén actualizados y listos para commit.

3. **Hacer commit y push de los cambios**
   - Incluye los archivos generados de Flutter y cualquier cambio en el backend.
   - Ejemplo:
     ```
     git add Codigo/Web/SiloBolsa.Api/wwwroot/flutter Codigo/Dockerfile
     git commit -m "feat: Actualizar Flutter y backend"
     git push origin main
     ```

4. **Configuración en Railway**
   - **Root Directory:** (dejar vacío)
   - **Dockerfile Path:** `Codigo/Dockerfile`
   - **Builder:** Dockerfile
   - Si usas Metal Build Environment y hay problemas, prueba desactivarlo.

5. **Despliegue manual si es necesario**
   - Si Railway usa snapshots y no detecta cambios, haz un "Redeploy" manual desde la pestaña Deployments.
   - O agrega una variable de entorno temporal para forzar el build: `RAILWAY_FORCE_BUILD=true`.

6. **Verificar el despliegue**
   - Abre la URL del servicio y haz un refresh completo (`Ctrl+Shift+R`).
   - Verifica que los cambios de Flutter estén visibles (líneas de umbral, etc).

## Notas útiles
- Los archivos generados de Flutter deben estar en el repositorio para que Docker los copie.
- Si cambias la estructura del repo, ajusta las rutas en el Dockerfile.
- Si Railway muestra errores de build, revisa los logs completos y verifica las rutas.
- Ante problemas de cache, fuerza el redeploy manual.

## Detalle del archivo Dockerfile y su funcionamiento en Railway

- El Dockerfile se encuentra en `Codigo/Dockerfile`.
- Railway debe estar configurado con:
  - **Root Directory:** vacío (dejar en blanco)
  - **Dockerfile Path:** `Codigo/Dockerfile`
  - Esto indica a Railway que el contexto de build es la raíz del repositorio y el Dockerfile está en la carpeta `Codigo`.

### ¿Cómo funciona el Dockerfile?

1. **Contexto de build:**
   - Railway envía todo el contenido del repositorio como contexto de build.
   - El Dockerfile usa rutas relativas desde la raíz, por eso todas las copias tienen el prefijo `Codigo/`.

2. **Etapas principales:**
   - **build:** Usa la imagen `mcr.microsoft.com/dotnet/sdk:8.0` para compilar el proyecto .NET.
   - **base/final:** Usa la imagen `mcr.microsoft.com/dotnet/aspnet:8.0` para ejecutar la app publicada.

3. **Copias de archivos:**
   - Copia los archivos `.csproj` desde `Codigo/Web/...` para restaurar dependencias.
   - Copia todo el código fuente con `COPY Codigo/ .`.
   - Compila y publica la API en `/app/publish`.
   - Copia los archivos estáticos de Flutter y la web:
     - `COPY --from=build /src/Web/SiloBolsa.Api/wwwroot ./wwwroot`
     - `COPY --from=build /src/Web/paginaWeb ./paginaWeb`

4. **Importante:**
   - Los archivos generados de Flutter (`wwwroot/flutter`) deben estar presentes antes del build.
   - Si cambias la estructura de carpetas, ajusta las rutas en el Dockerfile.
   - Si Railway muestra errores de rutas, revisa que el contexto y el Dockerfile Path estén correctos.

### Ejemplo de sección clave del Dockerfile

```dockerfile
# Copiar archivos de proyecto y restaurar dependencias
COPY ["Codigo/Web/SiloBolsa.Api/SiloBolsa.Api.csproj", "Web/SiloBolsa.Api/"]
COPY ["Codigo/Web/SiloBolsa.Persistencia/SiloBolsa.Persistencia.csproj", "Web/SiloBolsa.Persistencia/"]
COPY ["Codigo/Web/SiloBolsa.Core/SiloBolsa.Core.csproj", "Web/SiloBolsa.Core/"]
COPY ["Codigo/Web/SiloBolsa.Servicios/SiloBolsa.Servicios.csproj", "Web/SiloBolsa.Servicios/"]

RUN dotnet restore "Web/SiloBolsa.Api/SiloBolsa.Api.csproj"

# Copiar el resto del código fuente
COPY Codigo/ .
```

---
Actualizado: 2025-11-10
