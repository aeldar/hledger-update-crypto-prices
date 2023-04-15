#!/usr/bin/env sh

set -o errexit
set -o nounset

DEFAULT_LEDGER_FILE=~/.hledger.journal
DEFAULT_CRYPTO_LIST=BTC,ADA
DEFAULT_TARGET_CURRENCY=USD
DATE_FORMAT="%Y-%m-%d"

LEDGER_FILE=${LEDGER_FILE:-$DEFAULT_LEDGER_FILE}
CRYPTO_LIST=${1:-$DEFAULT_CRYPTO_LIST}
TARGET_CURRENCY=${2:-$DEFAULT_TARGET_CURRENCY}

URL="https://min-api.cryptocompare.com/data/pricemulti?fsyms=${CRYPTO_LIST}&tsyms=${TARGET_CURRENCY}"

echo " Trying to fetch the prices from cryptocompare.com for the following crypto:"
echo "   $CRYPTO_LIST"

fetchAndTransform () {
  DATE=$(date +${DATE_FORMAT})
  JQ_NORMALIZE='to_entries | map({ key: .key, value: .value[($TARGET_CURRENCY)] }) | from_entries'
  JQ_TO_HLEDGER_PRICE='to_entries | map("P " + $DATE + " " + .key + " " + (.value|tostring) + " " + $TARGET_CURRENCY)'

  curl "$URL" --silent \
    | jq --arg TARGET_CURRENCY "$TARGET_CURRENCY" "$JQ_NORMALIZE" \
    | jq --arg TARGET_CURRENCY "$TARGET_CURRENCY" --arg DATE "$DATE" "$JQ_TO_HLEDGER_PRICE" \
    | jq --raw-output .[]
}

replaceAbbreviations () {
  sed 's/BTC/₿/g' < /dev/stdin | sed 's/ADA/₳/g' | sed 's/USD/$/g' | sed 's/EUR/€/g'
}

printWithHeader () {
  awk 'BEGIN { print "; --- Crypto prices" } { print } END { print "" }' < /dev/stdin
}

RESULT=$(fetchAndTransform)

if  [ -z "$RESULT" ]
then
  echo " Sorry, failed." >&2
  exit 1
else
  echo "$RESULT" | replaceAbbreviations | printWithHeader >> "$LEDGER_FILE"
  echo " Fetched and appended to $LEDGER_FILE."
fi
