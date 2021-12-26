# Desafio Kubedev 
Objetivo deste desafio e transformar esta aplicação em uma imagem Docker seguindo os padrões de documentação.
## Etapa para criar uma imagem
  * Identificar em qual linguagem foi desenvolvida e sua versão caso seja necessário;
  * Identificar dependências além do arquivos de dependências da aplicação;
  * Definir se é uma aplicação stateless ou stateful;
  * Identificar requisitos não funcionais ou serviço de apoio;
    * ex: Vai utilizar um padrão sidecar com logs.
    * ex: vai necessita de banco de dados.
  * Identificar se será necessário variáveis de ambiente;
    * Definir se será variáveis em momento de construção ou momento de execução.
  * Definir porta padrão de trabalho;
    * Definir se é portão será para serviço interno ou externo.
### As etapas anteriores são baseadas nas recomendações 12factor link abaixo.
  [12factor](https://12factor.net/)

## Descrição da Aplicação
  - É uma aplicação desenvolvida em .net 5.0.
    - **ConversaoPeso.Web.csproj** define a versão do meu SDK que irá utilizar para compilar o projeto em .NET.
    * **ConversaoPeso.Web/Properties/launchSettings.json** Arquivo com a definição de porta. Contudo a imagem do SDK irá alterar a porta default para 80. 
  - Porta de padrão de trabalho *80*.
  - Sem necessidade de variáveis na criação do container.
  - Aplicação tipo stateless.
  - Sem requisitos funcionais e de apoio.
  - É recomendado que seja feito um Dockerfile tipo multistage.

## Recomendações
  - Trabalhar com layer de dependências separadas da aplicação, e assim ganhar performance no momento de build.
  - Se possível trabalhar com versão da imagem Alpine.
  - Criar arquivo *.dockerignore*  para evitar de copiar arquivos desnecessários.
  - Criar arquivo *Dockerfile* seguindo as recomendações oficiais Dockerinc.
    - [Best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
    - [exemplo de Dockerfile](https://docs.docker.com/samples/dotnetcore/)
## Exemplo de DockerFile e comentário
  - Abaixo está um exemplo de DockerFile simples.
    - Sempre que realizar um build de uma aplicação em .net utilizando como imagem base as versões microsoft a porta de listen default é *80*. As imagem possuir a variável *ENV ASPNETCORE_URLS=http://+:80*, assim todas asplicações irá rodar por default na porta 80.
  - Toda aplicação .net tem que ser realizado o build primeiro para depois realizar o processo  de deploy.
```sh
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app
COPY /ConversaoPeso.Web/*.csproj ./
# nesta etapa carrega o visual estudio correto.
RUN dotnet restore 

COPY /ConversaoPeso.Web/ .
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 80
ENTRYPOINT [ "dotnet", "ConversaoPeso.Web.dll" ]
  ```
  - Abaixo segue um exemplo de como alterar a porta default de uma aplicação .net.
  ```sh
  FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app
COPY /ConversaoPeso.Web/*.csproj ./
RUN dotnet restore 

COPY /ConversaoPeso.Web/ .
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:5.0
ARG ASPNETCORE_URLS
ENV ASPNETCORE_URLS=http://+:6000
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 6000
ENTRYPOINT [ "dotnet", "ConversaoPeso.Web.dll" ]
  ```
