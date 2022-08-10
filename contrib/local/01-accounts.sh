#!/bin/bash
set -o errexit -o nounset -o pipefail

BASE_ACCOUNT=$(andromad keys show validator -a)
andromad q account "$BASE_ACCOUNT" -o json | jq

echo "## Add new account"
andromad keys add fred

echo "## Check balance"
NEW_ACCOUNT=$(andromad keys show fred -a)
andromad q bank balances "$NEW_ACCOUNT" -o json || true

echo "## Transfer tokens"
andromad tx bank send validator "$NEW_ACCOUNT" 1uandr --gas 1000000 -y --chain-id=testing --node=http://localhost:26657 -b block -o json | jq

echo "## Check balance again"
andromad q bank balances "$NEW_ACCOUNT" -o json | jq
