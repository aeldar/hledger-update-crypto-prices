#!/usr/bin/env sh

set -o errexit
set -o nounset

DEFAULT_LEDGER_FILE=~/.hledger.journal
DEFAULT_CRYPTO_LIST=BTC,ADA

CRYPTO_LIST=${1:-$DEFAULT_CRYPTO_LIST}

LEDGER_FILE=${LEDGER_FILE:-$DEFAULT_LEDGER_FILE}

URL="https://min-api.cryptocompare.com/data/pricemulti?fsyms=${CRYPTO_LIST}&tsyms=USD"

JQ_NORMALIZE='to_entries | map({ key: .key, value: .value.USD }) | from_entries'

DATE=$(date +%Y-%m-%d)

JQ_TO_HLEDGER_PRICE='to_entries | map("P " + $DATE + " " + .key + " " + (.value|tostring) + " $")'

echo " Fetching the following crypto: ${1:-$DEFAULT_CRYPTO_LIST}"

echo " Trying to fetch the prices from cryptocompare.com for the following crypto:"
echo "   $CRYPTO_LIST"
echo "   ..."

curl "$URL" --silent \
  | jq "$JQ_NORMALIZE" \
  | jq --arg DATE "$DATE" "$JQ_TO_HLEDGER_PRICE" \
  | jq --raw-output .[] \
  | sed 's/BTC/₿/g' \
  | sed 's/ADA/₳/g' \
  | awk 'BEGIN { print "; --- Crypto prices" } { print } END { print "" }' \
  >> "$LEDGER_FILE"

echo " Fetched and appended to $LEDGER_FILE."

