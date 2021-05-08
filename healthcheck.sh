#!/bin/bash

# Based on https://stackoverflow.com/questions/9609130/efficiently-test-if-a-port-is-open-on-linux
exec 6<>/dev/tcp/127.0.0.1/20545
success=$?

exec 6>&- # close output connection
exec 6<&- # close input connection

if [[ $? != 0 ]]; then
    exit 1
else
    exit 0
fi
