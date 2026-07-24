#!/bin/bash

# read the values from secrets/credentials.txt

operator_id=$(grep '^operator_id:' secrets/credentials.txt | cut -d' ' -f2)
passphrase=$(grep '^passphrase:' secrets/credentials.txt | cut -d' ' -f2)

# hash the passphrase with SHA-256
# used (shasum -a 256) on macos equivalent to linux SHA-256

passphrase_hash=$(printf '%s' "$passphrase" | shasum -a 256 | cut -d' ' -f1)

# write the operator id and the hash to operator.hash file

echo "operator_id: $operator_id" > secrets/operator.hash
echo "passphrase_hash: $passphrase_hash" >> secrets/operator.hash

# confirmation message

echo "[SUCCESS]: Stored '$operator_id' with hashed passphrase in secrets/operator.hash"