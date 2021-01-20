FROM golang:latest AS downloader

ARG PANET_USERNAME
ARG PANET_PASSWORD

# Download papatcher and use it to download the server
RUN mkdir -p /patserver
RUN curl -o /tmp/papatcher.go https://raw.githubusercontent.com/planetary-annihilation/papatcher/master/papatcher.go
RUN go run /tmp/papatcher.go \
    --stream=stable \
    --update-only \
    --dir=/patserver \
    --username ${PANET_USERNAME} \
    --password ${PANET_PASSWORD}

FROM ubuntu AS runner

ARG UID=999

ENV INSTALL_LOC=/patserver
ENV REPLAYS_LOC=/replays
ENV DEBIAN_FRONTEND=noninteractive

ENV PAT_SERVER_NAME="A dockerised Planetary Annihilation: Titans server"

# Install PAT dependencies
RUN apt-get update && \
    apt-get install -y libsdl2-dev libgl1 libstdc++6 libcurl4 libuuid1

# Get the server files
COPY --from=downloader /patserver $INSTALL_LOC
COPY ./docker-entrypoint.sh /docker-entrypoint.sh

# Create user and setup permissions
RUN useradd -m -u ${UID} planetaryannihilation && \
    chown -R planetaryannihilation ${INSTALL_LOC} /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

USER planetaryannihilation
VOLUME $REPLAYS_LOC

EXPOSE 20545

ENTRYPOINT ["/docker-entrypoint.sh"]
