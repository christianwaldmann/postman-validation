#!/usr/bin/env bash

HERE=$(dirname "$0")
cd $HERE

REGEX='"key": "(password|username)",\n\s*"value": "[^"]+",\n\s*"type": ".*"$'

for FILENAME in $(find ../collections -iname "*.postman_collection.json"); do
    echo "Checking Postman collection \"$FILENAME\""
    SECRET_COUNT=$(pcre2grep -c -M "$REGEX" "$FILENAME")
    if [ "$SECRET_COUNT" -gt 0 ]; then
        echo "Found secrets in Postman collection \"$FILENAME\""
        echo "Please remove the exposed secrets either manually or by executing \"./remove-secrets.sh\". Make sure to rotate the compromised secrets to prevent misue by malicious actors. The secrets were detected on the following lines:"
        for i in $(pcre2grep --line-offsets -M "$REGEX" "$FILENAME" | cut -d ':' -f 1); do echo "$i+1" | bc; done
        exit 1
    else
        echo "\"$FILENAME\" OK"
    fi
done
