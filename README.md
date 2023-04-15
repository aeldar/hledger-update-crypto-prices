# hledger-update-crypto-prices

Update crypto prices for hledger

## Installation

1. Clone the repo
2. `cd` to your binaries' location, which is in $PATH (e.g. to `~/.local/bin`)
3. `ln -s ~/<my_previously_cloned_project>/hledger-update-crypto-prices.sh hledger-update-crypto-prices`

## Usage

By default, the followin crypto coins will be used: **BTC** and **ADA**

```
hledger update-crypto-prices
```

You can add a comma separated list of crypto abbreviations as an argument:

```
hledger update-crypto-prices BTC,ADA,SOL
```

