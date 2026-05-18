# Stage 1 - Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project files with EXACT folder names
COPY GestorPacientes/GestorPacientes.csproj ./GestorPacientes/
COPY GestorPacientes.Core.Application/GestorPacientes.Core.Application.csproj ./GestorPacientes.Core.Application/
COPY GestorPacientes.Core.Domain/GestorPacientes.Core.Domain.csproj ./GestorPacientes.Core.Domain/
COPY GestorPacientes.Infrastructure.Persistence/GestorPacientes.Infrastructure.Persistence.csproj ./GestorPacientes.Infrastructure.Persistence/

# Restore dependencies
RUN dotnet restore "GestorPacientes/GestorPacientes.csproj"

# Copy everything else
COPY . .

# Publish
RUN dotnet publish "GestorPacientes/GestorPacientes.csproj" -c Release -o /app/publish

# Stage 2 - Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "GestorPacientes.dll"]