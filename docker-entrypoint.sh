#!/bin/sh
set -eo pipefail

PAT_EXECUTABLE \
    --headless \
    --allow-lan \
    --game-mode PAExpansion1:config \
    --server-name "${PAT_SERVER_NAME}" \
    --mt-enabled \
    --output-dir "${REPLAYS_LOC}" \
    --replay-filename "UTCTIMESTAMP" \
    --port 20545
