#!/bin/bash
set -eo pipefail

log() {
    time=$(date +%T)
    echo "[$time] STARTSCRIPT: $1"
}

COMMAND="${INSTALL_LOC}/server \
    --headless \
    --allow-lan \
    --mt-enabled \
    --output-dir ${REPLAYS_LOC} \
    --replay-filename UTCTIMESTAMP \
    --port 20545 \
    --server-name ${PA_SERVER_NAME} \
    --max-players ${PA_MAX_PLAYERS} \
    --max-spectators ${PA_MAX_SPECTATORS} \
    --spectators ${PA_SPECTATORS}"

# Check for titans enabling
if [[ ${PA_TITANS_ENABLED} == "yes" ]]; then
    COMMAND="$COMMAND --game-mode PAExpansion1:config"
    log "Titans ENABLED"
else
    COMMAND="$COMMAND --game-mode config"
    log "Titans DISABLED"
fi

# Check for AI enabling
if [[ ${PA_AI_ENABLED} != "yes" ]]; then
    COMMAND="$COMMAND --disable-ai"
    log "AI disabled"
fi

# Check for password enabling
if [[ -n ${PA_SERVER_PASSWORD} ]]; then
    COMMAND="$COMMAND --server-password ${PA_SERVER_PASSWORD}"
fi

COMMAND="$COMMAND $@"

log "Starting server with command: $COMMAND"

$COMMAND
