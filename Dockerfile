#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
#Modified the line to this 
COPY ["DockerWebappEg3.csproj", ""]
#Remove the folder name again
RUN dotnet restore "DockerWebappEg3.csproj"
COPY . .
#removed directoy name and put .
WORKDIR "/src/."
RUN dotnet build "DockerWebappEg3.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DockerWebappEg3.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerWebappEg3.dll"]