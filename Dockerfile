FROM golang:latest AS downloader

ARG PA_STREAM_NAME=stable
ARG PANET_USERNAME
ARG PANET_PASSWORD

# Download papatcher and use it to download the server
RUN mkdir -p /patserver
RUN curl -o /tmp/papatcher.go https://raw.githubusercontent.com/planetary-annihilation/papatcher/master/papatcher.go
RUN go run /tmp/papatcher.go \
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

VOLUME $REPLAYS_LOC
EXPOSE 20545
WORKDIR $INSTALL_LOC
ENTRYPOINT ["/bin/bash", "/docker-entrypoint.sh"]
CMD ["--max-players", "12", "--server-name", "Docker PAT Server", "--server-password", "letmein"]
