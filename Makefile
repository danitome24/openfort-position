.PHONY: all test clean deploy-swapper fund help install snapshot format anvil mint-fake-token swap

include .env

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make fund ARGS=\"--network sepolia\""

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install OpenZeppelin/openzeppelin-contracts@v5.0.2 --no-commit && forge install @uniswap/v3-periphery --no-commit && forge install @uniswap/v3-core --no-commit && forge install Cyfrin/foundry-devops --no-commit@v0.2.2 --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing 

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

deploy-swapper:
	@forge script script/DeployOpenfortSwapper.s.sol:DeployOpenfortSwapper $(NETWORK_ARGS)

deploy-tokens:
	@forge script script/DeployFakeTokens.s.sol:DeployFakeTokens $(NETWORK_ARGS)

# Mint MATIC token to sender and mint USDC token to swapper.
mint-fake-token:
	@cast send 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "mint(address,uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 1000 --private-key $(DEFAULT_ANVIL_KEY) --rpc-url http://localhost:8545

mint-usdc-token:
	@cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "mint(address,uint256)" 0x0B306BF915C4d645ff596e518fAf3F9669b97016 1000 --private-key $(DEFAULT_ANVIL_KEY) --rpc-url http://localhost:8545

SENDER_ADDRESS := 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
swap:
	forge script script/InteractWithSwapper.s.sol:InteractWithSwapper --sender $(SENDER_ADDRESS) $(NETWORK_ARGS)
