#!/usr/bin/env bash
set -euo pipefail

for FILENAME in $(find . -iname "*.postman_collection.json"); do
    echo "Removing secrets from \"$FILENAME\""
    perl -0777 -p -i -e 's/("key": "(password|username)",\n\s*"value": ")[^"]+(",\n\s*"type": ".*")/\1\3/g' $FILENAME
done

