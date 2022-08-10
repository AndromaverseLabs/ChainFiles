#!/bin/bash
set -o errexit -o nounset -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
BASE_ACCOUNT=$(andromad keys show validator -a)

echo "-----------------------"
echo "## Genesis CosmWasm contract"
andromad add-wasm-genesis-message store "$DIR/../../x/wasm/keeper/testdata/hackatom.wasm" --instantiate-everybody true --builder=foo/bar:latest --run-as validator

echo "-----------------------"
echo "## Genesis CosmWasm instance"
INIT="{\"verifier\":\"$(andromad keys show validator -a)\", \"beneficiary\":\"$(andromad keys show fred -a)\"}"
andromad add-wasm-genesis-message instantiate-contract 1 "$INIT" --run-as validator --label=foobar --amount=100uandr --admin "$BASE_ACCOUNT"

echo "-----------------------"
echo "## Genesis CosmWasm execute"
FIRST_CONTRACT_ADDR=andr18vd8fpwxzck93qlwghaj6arh4p7c5n89k7fvsl
MSG='{"release":{}}'
andromad add-wasm-genesis-message execute $FIRST_CONTRACT_ADDR "$MSG" --run-as validator --amount=1uandr

echo "-----------------------"
echo "## List Genesis CosmWasm codes"
andromad add-wasm-genesis-message list-codes

echo "-----------------------"
echo "## List Genesis CosmWasm contracts"
andromad add-wasm-genesis-message list-contracts
