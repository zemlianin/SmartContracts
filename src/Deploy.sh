export MUMBAI_RPC_URL=https://rpc-amoy.polygon.technology/
# Change a private key
export PRIVATE_KEY=SECRET
export ETHERSCAN_API_KEY=YWMKAZ4G9NTZ1P5CXGA8FUMWYTDNSBB2FQ

forge create --rpc-url $MUMBAI_RPC_URL --constructor-args 1000 \
  --private-key $PRIVATE_KEY \
  src/SoulBoundToken.sol:SoulBoundToken \
  --etherscan-api-key $ETHERSCAN_API_KEY --verify

forge create --rpc-url $MUMBAI_RPC_URL --constructor-args 1000 \
  --private-key $PRIVATE_KEY \
  src/ERC20Token.sol:ERC20TokenWithFeeAndPermit \
  --etherscan-api-key $ETHERSCAN_API_KEY --verify

forge create --rpc-url $MUMBAI_RPC_URL --constructor-args 1000 \
  --private-key $PRIVATE_KEY \
  src/ERC721Token.sol:ERC721Token \
  --etherscan-api-key $ETHERSCAN_API_KEY --verify

forge create --rpc-url $MUMBAI_RPC_URL --constructor-args 1000 \
  --private-key $PRIVATE_KEY \
  src/ERC1155Token.sol:ERC1155Token \
  --etherscan-api-key $ETHERSCAN_API_KEY --verify