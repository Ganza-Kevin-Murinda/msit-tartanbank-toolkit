#!/bin/bash
# ============================================================
# TartanBank Induction Quiz (Part 1 self-check)
#
# Find each answer yourself using the shell (head, tail, wc,
# grep, cut, sort, uniq ...). Then run this script to check
# them. The correct answers are stored ONLY as SHA-256 hashes,
# so you cannot read the answer key out of this file.
#
# Usage:   ./quiz.sh <your_andrew_id>
#   e.g.   ./quiz.sh jdoe
#
# When you are done, take a screenshot of the whole run
# (the Andrew ID banners at the top and bottom must be visible)
# and add it to your repository as described in the assignment.
# ============================================================

ANDREW_ID="$1"
if [ -z "$ANDREW_ID" ]; then
  read -r -p "Enter your Andrew ID: " ANDREW_ID
fi

echo "======================================================"
echo " TartanBank Induction Quiz"
echo " Andrew ID : $ANDREW_ID"
echo " Started   : $(date)"
echo "======================================================"

# Questions and the salted SHA-256 hash of each correct answer.
# The salt is the question label, so identical answers still
# produce different hashes.
QUESTIONS=(
"Q1: How many transactions are in data/transactions.csv (exclude the header row)?"
"Q2: How many of those transactions are withdrawals?"
"Q3: How many of those transactions are deposits?"
"Q4: How many DISTINCT account IDs appear in the file?"
)
LABELS=("Q1" "Q2" "Q3" "Q4")
EXPECTED=(
"9c77993b94fd059983cd0bac9e3389f3a026b39a41d44a565fd826ae6fa48831"
"87d58ec9951cd356f6d5de32eee7573efe1c3159fe082c884bc666acc7653f7e"
"537b9fbc6542f21050884e4d955fe743243cfa3faaf4645e09bba34646d7d83a"
"acfa349be168f1b9f4863d1da9b6b98163865001f34db23fa6acdb81385375bf"
)

score=0
total=${#QUESTIONS[@]}

for i in "${!QUESTIONS[@]}"; do
  echo
  echo "${QUESTIONS[$i]}"
  read -r -p "  Your answer: " ans
  ans_clean=$(printf "%s" "$ans" | tr -d '[:space:]')
  got=$(printf "%s" "${LABELS[$i]}:${ans_clean}" | sha256sum | cut -d' ' -f1)
  if [ "$got" = "${EXPECTED[$i]}" ]; then
    echo "  [CORRECT]"
    score=$((score + 1))
  else
    echo "  [INCORRECT] -- re-check with the shell and try again"
  fi
done

echo
echo "======================================================"
echo " Score     : $score / $total"
echo " Andrew ID : $ANDREW_ID"
echo " Finished  : $(date)"
echo "======================================================"