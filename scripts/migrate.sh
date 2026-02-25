#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

COMMAND=$1
NAME=$2

case $COMMAND in
    "up")
        migrate -path migrations -database "$DATABASE_URL" up
        ;;
    "down")
        if [ -n "$NAME" ]; then
            COUNT=$NAME
        else
            COUNT="1"
        fi

        echo "Rolling back $COUNT migration(s). Continue [y/n]"
        read -r confirm

        if [ "$confirm" == "y" ]; then
            migrate -path migrations -database "$DATABASE_URL" down "$COUNT"
        else
            echo "Migration cancelled"
        fi
        ;;
    "create")
        migrate create -ext sql -dir migrations -seq "$NAME"
        ;;
    "status")
        migrate -path migrations -database "$DATABASE_URL" version
        ;;
    *)
        echo "Unknown command: $COMMAND"
        echo "Usage: $0 {up|down [count]|create [name]|status}"
        ;;
esac
