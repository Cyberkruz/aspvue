ARG REPO=mcr.microsoft.com/dotnet/core
ARG REPO_VERSION=3.1
ARG PROJECT=AspVue.Web

#Build
FROM ${REPO}/sdk:${REPO_VERSION} as build

#add nodejs/npm
RUN apt-get update && apt-get install -yqq --no-install-recommends apt-utils
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -yqq nodejs

WORKDIR /app
COPY src/. .
RUN dotnet publish -c Release /p:PublishTrimmed=true --self-contained -o publish -r linux-x64

# Runtime
FROM ${REPO}/aspnet:${REPO_VERSION} as runtime

WORKDIR /app
COPY --from=build /app/publish/. .

EXPOSE 80

CMD [ "dotnet", "AspVue.Web.dll" ]