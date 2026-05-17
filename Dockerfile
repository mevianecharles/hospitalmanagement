# Stage 1 - Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy each project file
COPY GestorPacientes/GestorPacientes.csproj ./GestorPacientes/
COPY GestorPacientes.Core.Applicat/GestorPacientes.Core.Applicat.csproj ./GestorPacientes.Core.Applicat/
COPY GestorPacientes.Core.Domain/GestorPacientes.Core.Domain.csproj ./GestorPacientes.Core.Domain/
COPY GestorPacientes.Infrastructure/GestorPacientes.Infrastructure.csproj ./GestorPacientes.Infrastructure/

# Restore dependencies
RUN dotnet restore "GestorPacientes/GestorPacientes.csproj"

# Copy everything else
COPY . .

# Publish the MVC web project
RUN dotnet publish "GestorPacientes/GestorPacientes.csproj" -c Release -o /app/publish

# Stage 2 - Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "GestorPacientes.dll"]