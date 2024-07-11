#!/usr/bin/env bash

HERE=$(dirname "$0")
cd $HERE

IS_SECRETS_EXPOSED=false

# Validate collections
for FILENAME in $(find ../collections -iname "*.postman_*.json"); do

    SECRETS=$(jq '[.. | objects | select((.key=="password" or .key=="username" or .key=="Authorization" or .key=="value") and .value!="") | select(.value | startswith("{{") and endswith("}}") | not) | .value]' $FILENAME)

    if [ "$SECRETS" != "[]" ]; then
        echo "\"$FILENAME\": NOT OK, found the following secrets:"
        echo "$SECRETS"
        IS_SECRETS_EXPOSED=true
    else
        echo "\"$FILENAME\": OK"
    fi
done

# Validate environments
for FILENAME in $(find ../environments -iname "*.postman_*.json"); do

    SECRETS=$(jq '[.. | objects | select(.type=="secret" and .value!="") | .value]' $FILENAME)

    if [ "$SECRETS" != "[]" ]; then
        echo "\"$FILENAME\": NOT OK, found the following secrets:"
        echo "$SECRETS"
        IS_SECRETS_EXPOSED=true
    else
        echo "\"$FILENAME\": OK"
    fi
done

if [ "$IS_SECRETS_EXPOSED" = true ]; then
    echo
    echo "Please remove the exposed secrets manually or by executing \"./remove-secrets.sh\". Make sure to invalidate/rotate them to prevent misue by malicious actors."
    exit 1
fi
