#!/bin/bash

# Usage:
# ./verify.sh <ADDRESS> <CONTRACT_NAME>

source .env && forge verify-contract --rpc-url $RPC_URL $@