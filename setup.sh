#!/bin/bash

# creating directories if not exist

mkdir -p data reports src secrets

echo "Directories confirmed: data, reports, src, secrets"

# checking if transactions.csv file exists

if [ -f data/transactions.csv ]; then
    echo "[SUCCESS]: 'transactions.csv' file present in the 'data/' directory!"
else
    echo "[WARNING]: 'transactions.csv' was not found, please add it before you can proceed."
fi