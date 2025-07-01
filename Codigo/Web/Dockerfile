# Imagen base para aplicaciones ASP.NET Core
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# Imagen para build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar el archivo de proyecto y restaurar dependencias
COPY ["SiloBolsa.Api/SiloBolsa.Api.csproj", "SiloBolsa.Api/"]
# Si tienes otros proyectos (por ejemplo, Persistencia, Servicios, etc.), copia sus .csproj aquí también
COPY ["SiloBolsa.Persistencia/SiloBolsa.Persistencia.csproj", "SiloBolsa.Persistencia/"]
COPY ["SiloBolsa.Core/SiloBolsa.Core.csproj", "SiloBolsa.Dominio/"]
COPY ["SiloBolsa.Servicios/SiloBolsa.Servicios.csproj", "SiloBolsa.Servicios/"]



RUN dotnet restore "SiloBolsa.Api/SiloBolsa.Api.csproj"

# Copiar el resto del código fuente y construir el proyecto
COPY . .
WORKDIR "/src/SiloBolsa.Api"
RUN dotnet build "SiloBolsa.Api.csproj" -c Release -o /app/build

FROM build AS publish
WORKDIR "/src/SiloBolsa.Api"
RUN dotnet publish "SiloBolsa.Api.csproj" -c Release -o /app/publish

COPY SiloBolsa.Api/paginaWeb /app/publish/paginaWeb


FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SiloBolsa.Api.dll"]