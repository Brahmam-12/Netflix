#stage 1 
FROM mcr.microsoft.com/dotnet/sdk:10.0 as Build
WORKDIR /src
COPY Netflix.csproj .

RUN pwd
RUN echo "WORKDIR"
RUN ls -la

RUN dotnet restore Netflix.csproj
COPY . .
RUN dotnet publish Netflix.csproj --configuration Release --output /src/publish


#stage 2
FROM mcr.microsoft.com/dotnet/aspnet:10.0 as final
WORKDIR /app
COPY --from=Build /src/publish .   #copy from the Build stage go it inside the src/publish dir and copy here all
EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000
CMD ["dotnet", "Netflix.dll"]
