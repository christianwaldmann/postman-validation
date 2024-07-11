#!/usr/bin/env bash
set -euo pipefail

HERE=$(dirname "$0")
cd $HERE

# Remove secrets from collections
for FILENAME in $(find ../collections -iname "*.postman_*.json"); do
    echo -n "Removed "
    perl -0777 -p -i -e '$k+= s/("key": "(?:password|username|Authorization|value)",\n\s*"value": ")(?:\s*[^{]{2,2}.+[^}]{2,2}\s*)(",\n\s*"type": ".*")/\1\2/g; END{print "$k"}' $FILENAME
    echo " secrets from \"$FILENAME\""
done

# Remove secrets from environments
for FILENAME in $(find ../environments -iname "*.postman_*.json"); do
    echo -n "Removed "
    perl -0777 -p -i -e '$k+= s/("key": ".+",\n\s*"value": ").+(",\n\s*"type": "secret")/\1\2/g; END{print "$k"}' $FILENAME
    echo " secrets from \"$FILENAME\""
done
