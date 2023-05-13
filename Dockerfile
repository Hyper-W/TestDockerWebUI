ARG DOT_VERSION=6.0
FROM mcr.microsoft.com/dotnet/sdk:${DOT_VERSION}-alpine AS Builder

COPY ./ /TestDockerWebUI

RUN dotnet publish /TestDockerWebUI/TestDockerWebUI.csproj -c Release -r linux-musl-x64 \
    /p:PublishSingleFile=true /p:PublishReadyToRun=true /p:IncludeNativeLibrariesForSelfExtract=true \ 
    --self-contained true

FROM mcr.microsoft.com/dotnet/runtime-deps:${DOT_VERSION}-alpine AS APP

EXPOSE 5000

ENV urls="http://*:5000"

# Your Property
ARG USER=user
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG DOT_VERSION=6.0

RUN apk update && apk add --no-cache docker-cli docker-cli-compose \
    && addgroup -g ${GROUP_ID} ${USER} \
    && addgroup docker \
    && adduser -D -u ${USER_ID} -s /bin/sh -G ${USER} ${USER} \
    && adduser ${USER} docker

ENV PATH=$PATH:/usr/libexec/docker/cli-plugins/

USER ${USER}

COPY --from=Builder /TestDockerWebUI/bin/Release/net${DOT_VERSION}/linux-musl-x64/publish/TestDockerWebUI /TestDockerWebUI/TestDockerWebUI
COPY --from=Builder /TestDockerWebUI/bin/Release/net${DOT_VERSION}/linux-musl-x64/publish/wwwroot /TestDockerWebUI/wwwroot
# COPY ./compose/nginx /TestDockerWebUI/compose/nginx

VOLUME [ "/TestDockerWebUI/compose/nginx" ]

WORKDIR /TestDockerWebUI

CMD [ "/TestDockerWebUI/TestDockerWebUI" ]