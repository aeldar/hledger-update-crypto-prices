# hledger-update-crypto-prices

Update crypto prices for [Hledger](https://hledger.org/)

## Installation

1. Clone the repo
2. `cd` to your binaries' location, which is in $PATH (e.g. to `~/.local/bin`)
3. `ln -s ~/<my_previously_cloned_project>/hledger-update-crypto-prices.sh hledger-update-crypto-prices`

## Usage

Run:

```shell
hledger update-crypto-prices
```

You can add a comma separated list of crypto abbreviations as an argument (_BTC,ADA_ by default):

```shell
hledger update-crypto-prices BTC,ADA,SOL
```

You can specify a target currency as a second argument (_USD_ by default):

```shell
hledger update-crypto-prices BTC,ADA,SOL EUR
```

## Currency abbreviations

Some currencies' abbreviations are automatically converted to their symbols. Remove in the code, if you don't need it.
