include .env

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

.PHONY: help
help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make fund ARGS=\"--network sepolia\""

.PHONY: all
all: clean remove install update build

# Clean the repo
.PHONY: clean
clean  :; forge clean

# Remove modules
.PHONY: remove
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

.PHONY: install
install :; forge install OpenZeppelin/openzeppelin-contracts@v5.0.2 --no-commit && forge install @uniswap/v3-periphery --no-commit && forge install @uniswap/v3-core --no-commit && forge install Cyfrin/foundry-devops --no-commit@v0.2.2 --no-commit

.PHONY: build
build:; forge build

.PHONY: test
test :; forge test

.PHONY: anvil
anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing 

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

.PHONY: deploy-anvil
deploy-anvil: deploy-tokens deploy-swapper mint-stable-token mint-erc20-token

.PHONY: deploy-swapper
deploy-swapper:
	@forge script script/DeployOpenfortSwapper.s.sol:DeployOpenfortSwapper $(NETWORK_ARGS)

.PHONY: mins-stable-token
mint-stable-token:
	@forge script script/utils/MintTokens.s.sol:MintStableTokens $(NETWORK_ARGS)

.PHONY: deploy-tokens
deploy-tokens:
	@forge script script/utils/DeployFakeTokens.s.sol:DeployFakeTokens $(NETWORK_ARGS)

.PHONY: mint-erc20-token
mint-erc20-token:
	@forge script script/utils/MintTokens.s.sol:MintERC20Tokens $(NETWORK_ARGS)

.PHONY: check-balance
check-balance:
	@forge script script/utils/CheckBalance.s.sol:CheckBalance $(NETWORK_ARGS)

SENDER_ADDRESS := 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
.PHONY:
swap:
	forge script script/InteractWithSwapper.s.sol:InteractWithSwapper --sender $(SENDER_ADDRESS) $(NETWORK_ARGS)
