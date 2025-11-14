# Imagen base para aplicaciones ASP.NET Core
# Build: 2025-11-10 Flutter threshold fixes
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# Imagen para build (incluye el SDK de .NET y herramientas de EF Core)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Instalar herramientas de Entity Framework Core
RUN dotnet tool install --global dotnet-ef --version 8.0.8
ENV PATH="${PATH}:/root/.dotnet/tools"

# Copiar archivos de proyecto y restaurar dependencias (el contexto es Codigo/)
COPY ["Web/SiloBolsa.Api/SiloBolsa.Api.csproj", "Web/SiloBolsa.Api/"]
COPY ["Web/SiloBolsa.Persistencia/SiloBolsa.Persistencia.csproj", "Web/SiloBolsa.Persistencia/"]
COPY ["Web/SiloBolsa.Core/SiloBolsa.Core.csproj", "Web/SiloBolsa.Core/"]
COPY ["Web/SiloBolsa.Servicios/SiloBolsa.Servicios.csproj", "Web/SiloBolsa.Servicios/"]

RUN dotnet restore "Web/SiloBolsa.Api/SiloBolsa.Api.csproj"

# Copiar el resto del código fuente
COPY . .

# Construir la API
WORKDIR "/src/Web/SiloBolsa.Api"
RUN dotnet build "SiloBolsa.Api.csproj" -c Release -o /app/build

# Publicar la aplicación
FROM build AS publish
WORKDIR "/src/Web/SiloBolsa.Api"
RUN dotnet publish "SiloBolsa.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Imagen final
FROM base AS final
WORKDIR /app

# Copiar la aplicación publicada
COPY --from=publish /app/publish .

# Copiar archivos estáticos (paginaWeb)
COPY --from=build /src/Web/paginaWeb ./paginaWeb

# Copiar Flutter Web precompilado (compilado localmente, incluido en Git)
COPY --from=build /src/Web/SiloBolsa.Api/wwwroot ./wwwroot

# La aplicación aplicará las migraciones automáticamente al iniciar (ver Program.cs)
# Build: Nov 1, 2025 - Flutter model actualizado con parseo correcto de fechas
ENTRYPOINT ["dotnet", "SiloBolsa.Api.dll"]