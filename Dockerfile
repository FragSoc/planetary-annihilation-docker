FROM golang:latest AS downloader

ARG PA_STREAM_NAME=stable
ARG PANET_USERNAME
ARG PANET_PASSWORD

# Download papatcher and use it to download the server
RUN mkdir -p /patserver && \
    curl -o /tmp/papatcher.go https://raw.githubusercontent.com/planetary-annihilation/papatcher/master/papatcher.go && \
    go run /tmp/papatcher.go \
        --stream=${PA_STREAM_NAME} \
        --update-only \
        --dir=/patserver \
        --username ${PANET_USERNAME} \
        --password ${PANET_PASSWORD}

FROM ubuntu AS runner

ARG UID=999
ARG PA_STREAM_NAME=stable

ENV INSTALL_LOC=/patserver
ENV REPLAYS_LOC=/replays
ENV DEBIAN_FRONTEND=noninteractive

# Install PAT dependencies
RUN apt-get update && \
    apt-get install -y libsdl2-2.0-0 libgl1 libstdc++6 libcurl3-gnutls libuuid1

# Create user
RUN useradd -m -u ${UID} patuser
USER patuser

# Get the server files
COPY --from=downloader --chown=patuser /patserver/$PA_STREAM_NAME $INSTALL_LOC
COPY --chown=patuser ./docker-entrypoint.sh /docker-entrypoint.sh

ENV PA_TITANS_ENABLED=yes
ENV PA_AI_ENABLED=yes
ENV PA_SERVER_NAME="A Dockerised PA:T Server"
ENV PA_SERVER_PASSWORD="letmein"
ENV PA_MAX_PLAYERS=12
ENV PA_MAX_SPECTATORS=5
ENV PA_SPECTATORS=5
ENV PA_REPLAY_TIMEOUT=180
ENV PA_GAMEOVER_TIMEOUT=360
ENV PA_EMPTY_TIMEOUT=3600

VOLUME $REPLAYS_LOC
EXPOSE 20545
WORKDIR $INSTALL_LOC
ENTRYPOINT ["/bin/bash", "/docker-entrypoint.sh"]
