ARG UBUNTU_VERSION_NAME=latest

FROM ubuntu:${UBUNTU_VERSION_NAME}

EXPOSE 5000
EXPOSE 7160

# Your Property
ARG USER=user
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG DOT_VERSION=6.0

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl gnupg lsb-release sudo dotnet-sdk-${DOT_VERSION} \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >> /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin \
    && apt-get remove -y --purge --autoremove gnupg lsb-release \
    && apt-get clean && rm -rf /var/lib/apt/lists/ \
    && groupadd -g ${GROUP_ID} ${USER} \
    && groupadd docker \
    && useradd -u ${USER_ID} -m -s /bin/bash -g ${USER} -G sudo,docker ${USER} \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ${USER}

ENV PATH=/home/${USER}/.dotnet/tools:$PATH
ENV PATH=$PATH:/usr/libexec/docker/cli-plugins/

# TMP Docker Volume
VOLUME ["/TestDockerWebUI"]

WORKDIR /TestDockerWebUI