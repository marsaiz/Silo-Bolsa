# Imagen base para aplicaciones ASP.NET Core
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# Imagen para build (incluye el SDK de .NET y herramientas de EF Core)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Instalar herramientas de Entity Framework Core
RUN dotnet tool install --global dotnet-ef --version 8.0.8
ENV PATH="${PATH}:/root/.dotnet/tools"

# Instalar Flutter SDK para compilar Flutter Web
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa
RUN git clone https://github.com/flutter/flutter.git -b stable /flutter
ENV PATH="${PATH}:/flutter/bin"
RUN flutter doctor -v
RUN flutter config --enable-web

# Copiar archivos de proyecto y restaurar dependencias
COPY ["Web/SiloBolsa.Api/SiloBolsa.Api.csproj", "Web/SiloBolsa.Api/"]
COPY ["Web/SiloBolsa.Persistencia/SiloBolsa.Persistencia.csproj", "Web/SiloBolsa.Persistencia/"]
COPY ["Web/SiloBolsa.Core/SiloBolsa.Core.csproj", "Web/SiloBolsa.Core/"]
COPY ["Web/SiloBolsa.Servicios/SiloBolsa.Servicios.csproj", "Web/SiloBolsa.Servicios/"]

RUN dotnet restore "Web/SiloBolsa.Api/SiloBolsa.Api.csproj"

# Copiar el resto del código fuente
COPY . .

# Compilar Flutter Web
WORKDIR "/src/Flutter/silo_bolsa_flutter"
RUN flutter pub get
RUN flutter build web --release

# Volver al directorio de la API y construir
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

# Copiar Flutter Web compilado desde el stage de build
COPY --from=build /src/Flutter/silo_bolsa_flutter/build/web ./wwwroot/flutter

# La aplicación aplicará las migraciones automáticamente al iniciar (ver Program.cs)
ENTRYPOINT ["dotnet", "SiloBolsa.Api.dll"]