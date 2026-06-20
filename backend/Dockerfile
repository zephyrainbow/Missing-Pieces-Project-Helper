FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY backend/MissingPieces.sln backend/
COPY backend/MissingPieces.Api/MissingPieces.Api.csproj backend/MissingPieces.Api/
COPY backend/MissingPieces.Data/MissingPieces.Data.csproj backend/MissingPieces.Data/
COPY backend/MissingPieces.Models/MissingPieces.Models.csproj backend/MissingPieces.Models/
RUN dotnet restore backend/MissingPieces.sln

COPY backend/. backend/
RUN dotnet publish backend/MissingPieces.Api/MissingPieces.Api.csproj -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "MissingPieces.Api.dll"]
