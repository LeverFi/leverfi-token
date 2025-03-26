#!/bin/bash

# Usage:
# ./deploy.sh --aws : Simulate with AWS KMS
# ./deploy.sh --broadcast --aws : Execute with AWS KMS
# ./deploy.sh --broadcast --private-key <RAW_PRIVATE_KEY> : Execute with private key

#forge clean && forge build
#./flatten.sh
source .env && forge script \
  scripts/deploy-lever.s.sol \
  --slow \
  --rpc-url $RPC_URL \
  $@
