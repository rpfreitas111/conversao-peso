FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app
COPY /ConversaoPeso.Web/*.csproj ./
RUN dotnet restore 

COPY /ConversaoPeso.Web/ .
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 80
ENTRYPOINT [ "dotnet", "ConversaoPeso.Web.dll" ]

