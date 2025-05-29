#!/bin/bash

# Set the RPC endpoint
RPC_URL="https://rpc.testnet-02.midnight.network"

# Detect running container (adjust name if needed)
CONTAINER_NAME="midnight-shell"
KEYS_FILE="./partner-chains-public-keys.json"

# Extract keys by executing jq inside the container
SIDECHAIN_PUB_KEY=$(jq -r '.sidechain_pub_key' "$KEYS_FILE")
AURA_PUB_KEY=$(jq -r '.aura_pub_key' "$KEYS_FILE")
GRANDPA_PUB_KEY=$(jq -r '.grandpa_pub_key' "$KEYS_FILE")

# If any key is missing, fail early
if [[ -z "$SIDECHAIN_PUB_KEY" || -z "$AURA_PUB_KEY" || -z "$GRANDPA_PUB_KEY" ]]; then
  echo -e "\033[31m[ERROR]\033[0m Failed to load keys from inside Docker container."
  exit 1
fi

echo -e "\n\033[1;34m--- Validator Public Keys ---\033[0m"
echo -e "\033[32mSidechain Pub Key:\033[0m $SIDECHAIN_PUB_KEY"
echo -e "\033[32mAura Pub Key:\033[0m $AURA_PUB_KEY"
echo -e "\033[32mGrandpa Pub Key:\033[0m $GRANDPA_PUB_KEY"

# Get the current epoch
echo -e "\n\033[1;34mFetching current epoch...\033[0m"
EPOCH_RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" -d '{
  "jsonrpc": "2.0",
  "method": "sidechain_getStatus",
  "params": [],
  "id": 1
}' "$RPC_URL")

SIDECHAIN_EPOCH=$(echo "$EPOCH_RESPONSE" | jq -r '.result.sidechain.epoch')
MAINCHAIN_EPOCH=$(echo "$EPOCH_RESPONSE" | jq -r '.result.mainchain.epoch')

echo -e "\033[33mSidechain Epoch:\033[0m $SIDECHAIN_EPOCH"
echo -e "\033[33mMainchain Epoch:\033[0m $MAINCHAIN_EPOCH"

# Check current epoch
echo -e "\n\033[1;34mFetching Ariadne parameters for Mainchain Epoch $MAINCHAIN_EPOCH...\033[0m"
ARIADNE_RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" -d "{
  \"jsonrpc\": \"2.0\",
  \"method\": \"sidechain_getAriadneParameters\",
  \"params\": [$MAINCHAIN_EPOCH],
  \"id\": 1
}" "$RPC_URL")

echo -e "\n\033[1;34mChecking if the Sidechain Public Key is registered in epoch $MAINCHAIN_EPOCH...\033[0m"
if echo "$ARIADNE_RESPONSE" | jq -e ".result | .. | objects | select(.sidechainPubKey == \"$SIDECHAIN_PUB_KEY\")" > /dev/null; then
  echo -e "\033[32m✅ Sidechain Public Key ($SIDECHAIN_PUB_KEY) is registered in epoch $MAINCHAIN_EPOCH!\033[0m"
else
  echo -e "\033[31m❌ Sidechain Public Key ($SIDECHAIN_PUB_KEY) is NOT registered in epoch $MAINCHAIN_EPOCH.\033[0m"

  FUTURE_EPOCH=$((MAINCHAIN_EPOCH + 2))
  echo -e "\n\033[1;34mChecking future epoch $FUTURE_EPOCH for registration...\033[0m"
  FUTURE_RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" -d "{
    \"jsonrpc\": \"2.0\",
    \"method\": \"sidechain_getAriadneParameters\",
    \"params\": [$FUTURE_EPOCH],
    \"id\": 1
  }" "$RPC_URL")

  if echo "$FUTURE_RESPONSE" | jq -e ".result | .. | objects | select(.sidechainPubKey == \"$SIDECHAIN_PUB_KEY\")" > /dev/null; then
    echo -e "\033[36m🕒 Your validator *will be registered* in epoch $FUTURE_EPOCH.\033[0m"
  else
    echo -e "\033[31m❌ Still NOT registered in epoch $FUTURE_EPOCH.\033[0m"
  fi
fi

# Print detailed info if already registered
if echo "$ARIADNE_RESPONSE" | jq -e ".result | .. | objects | select(.sidechainPubKey == \"$SIDECHAIN_PUB_KEY\")" > /dev/null; then
  echo -e "\n\033[1;34mRetrieving detailed validator information...\033[0m"
  VALIDATOR_INFO=$(echo "$ARIADNE_RESPONSE" | jq ".result | .. | objects | select(.sidechainPubKey == \"$SIDECHAIN_PUB_KEY\")")
  echo -e "\n\033[32m✅ Validator details found:\033[0m"
  echo "$VALIDATOR_INFO" | jq '. | {
    "Sidechain PubKey": .sidechainPubKey,
    "Sidechain Account ID": .sidechainAccountId,
    "Mainchain PubKey": .mainchainPubKey,
    "Cross-Chain PubKey": .crossChainPubKey,
    "Aura PubKey": .auraPubKey,
    "Grandpa PubKey": .grandpaPubKey,
    "Sidechain Signature": .sidechainSignature,
    "Mainchain Signature": .mainchainSignature,
    "Cross-Chain Signature": .crossChainSignature,
    "UTXO ID": .utxo.utxoId,
    "Epoch Number": .utxo.epochNumber,
    "Block Number": .utxo.blockNumber,
    "Slot Number": .utxo.slotNumber,
    "Transaction Index": .utxo.txIndexWithinBlock,
    "Stake Delegation": .stakeDelegation,
    "Validator Status": .isValid
  }' | jq -C
fi
