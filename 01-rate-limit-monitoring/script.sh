#!/bin/sh
echo "Starting the script - $(date)"
# update passkey with the value that was used to encrypt data
export passkey="<replace with pass key>"

cd /path-to-downloaded-repo/01-rate-limit-monitoring
./nri-flex -config_path rate.yml -pretty -insights_api_key  "<nr-insights-api-key>" -insights_url "https://insights-collector.newrelic.com/v1/accounts/{accountId}/events" -verbose