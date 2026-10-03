# Stage 1
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

WORKDIR /src

COPY Netflix.csproj .

RUN pwd
RUN echo "WORKDIR"
RUN ls -la

RUN dotnet restore Netflix.csproj

COPY . .

RUN dotnet publish Netflix.csproj \
    --configuration Release \
    --output /src/publish


# Stage 2
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final

WORKDIR /app

# Copy published application from build stage
COPY --from=build /src/publish .

EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

CMD ["dotnet", "Netflix.dll"]