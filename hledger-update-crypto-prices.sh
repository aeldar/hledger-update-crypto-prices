#!/usr/bin/env sh

DEFAULT_LEDGER_FILE=~/.hledger.journal

LEDGER_FILE=${LEDGER_FILE:-$DEFAULT_LEDGER_FILE}

URL="https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ADA&tsyms=USD"

JQ_NORMALIZE='to_entries | map({ key: .key, value: .value.USD }) | from_entries'

DATE=`date +%Y-%m-%d`

JQ_TO_HLEDGER_PRICE='to_entries | map("P " + $DATE + " " + .key + " " + (.value|tostring) + " $")'

echo " Trying to fetch crypto prices from cryptocompare.com..."

curl $URL --silent \
  | jq "$JQ_NORMALIZE" \
  | jq --arg DATE "$DATE" "$JQ_TO_HLEDGER_PRICE" \
  | jq --raw-output .[] \
  | sed 's/BTC/₿/g' \
  | sed 's/ADA/₳/g' \
  | awk 'BEGIN { print "; --- Crypto prices" } { print } END { print "" }' \
  >> $LEDGER_FILE

echo " Fetched and appended to $LEDGER_FILE."

