#!/bin/bash
echo "Starting the script - $(date)"
# Check if JSON file argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <json_file> [reset] [sendData]"
    exit 1
fi

JSON_FILE="$1"
ARG2="$2"  # Will be "reset" if provided
ARG3="$3"

for arg in "$ARG2" "$ARG3"; do
    if [ "$arg" == "reset" ]; then
        RESET_MODE="reset"
    elif [ "$arg" == "send" ]; then
        SEND_TO_NR="sendData"
    fi
done

# update path to the project working directory
cd /path-to-downloaded-repo/02-rss2relic

# Check if the JSON file exists
if [ ! -f "$JSON_FILE" ]; then
    echo "Error: File '$JSON_FILE' does not exist."
    exit 1
fi
# Extract IDs from JSON
ids=$(jq -r '.[].id' "$JSON_FILE")

for id in $ids; do
    filename="${id}maxval"
        # reset mode
    if [ "$RESET_MODE" == "reset" ]; then
            echo "0" > "$filename"
            echo "Created file: $filename with value 0"
    else
        # Normal mode: create file if it doesn't exist
        if [ ! -f "$filename" ]; then
            echo "0" > "$filename"
            echo "Created file: $filename with value 0"
        else
            echo "File $filename already exists. Skipping."
        fi
    fi
done

if [ "$SEND_TO_NR" == "sendData" ]; then
    ./nri-flex -config_path rss.yml -pretty -insights_api_key  "<nr-insights-api-key>" -insights_url "https://insights-collector.newrelic.com/v1/accounts/{accountId}/events" -verbose
    echo "rss-event sent to NR"
else
    ./nri-flex -config_path rss.yml -pretty -verbose
fi
