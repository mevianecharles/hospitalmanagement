# Stage 1 - Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY . .

RUN dotnet restore

RUN dotnet publish -c Release -o /app/publish

# Stage 2 - Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 7005
ENV ASPNETCORE_URLS=http://+:7005
ENV ASPNETCORE_ENVIRONMENT=Production
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "GestorPacientes.dll"]