#!/bin/bash

# make sure the folder structure exists

./setup.sh

# paths (input file and today's dated report)

INPUT="data/transactions.csv"
REPORT="reports/report_$(date +%F).txt"

# fail clearly if the input file is missing

if [ ! -f "$INPUT" ]; then
    echo "Error: $INPUT not found. Please add the transactions file and try again."
    exit 1
fi

# run the Python processor, passing input and dated report path
python3 src/process.py "$INPUT" "$REPORT"

# print a short summary
transaction_count=$(tail -n +2 "$INPUT" | wc -l | tr -d ' ')
echo ""
echo "Nightly run complete."
echo "Transactions in input (excluding header): $transaction_count"

echo "Flagged withdrawals:"
grep "declined withdrawal of" "$REPORT"

# Step 6: tell the user where the report is
echo ""
echo "Full report saved to: $REPORT"
echo ""