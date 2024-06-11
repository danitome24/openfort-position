# Openfort challenge

This repository contains the Openfort Swapper smart contract, which allows the swapping of ERC20 tokens to Stablecoins and the distribution of the Stablecoins to specified recipients. The contract uses Uniswap V3 for swapping and includes a fee mechanism. You can read all challenge at [SmarContractChallenge.md](./SmartContractChallenge.md)

## Requirements

* [Foundry](https://getfoundry.sh/): You'll need to install foundry to get this project run and test. [Here](https://book.getfoundry.sh/getting-started/installation) you can see how to install it.

## Development decisions

* Usage of UniswapV3 Swapper: I needed to swap between ERC20 tokens so I decided to use a library provided by Uniswap. It helps me to swap from ERC20 token to another ERC20 token. I choose UniswapV3 because is one of the most used DEX and supports many Networks.
* Fees: When there's any swap owners can set a fee. This fee is sended to owner's contract in USDC, to make it easier ERC20 Tokens management. So we don't have many ERC20 Tokens in owner address.
* Ownable: For managing smart contract ownership, I've used the Openzeppelin libraries. These are a secure and audited implementations and it helps to not reinventing the wheel.

## Missing features
There are some features that I had no time to implement but I want to type what would I have done.

* Timing: When timing is set to immediately, the code would remain the same as it currently is. However, for delayed swap and transfer (once per day, weekly, etc.), I would have updated the code so that when swap occur, I store all swap data into an array (source token, amount, recipients), and when the time is met (manually triggered by owner) swap and send all transactions in that array.

* Pausable: I've seen that there's a [Pausable library](https://docs.openzeppelin.com/contracts/5.x/api/utils#Pausable) from Openzeppelin to stop if needed the Smart Contract. So I would have used this library. Just extends this and use modifiers in functions.

## Usage

There is a Makefile with most common commands to be used in project. These are helpful for development and testing stages. You can open it and use it. An example how to use it:

```
$ make deploy-anvil
$ make swap
```

### Deploy

* Anvil network (development)
```
make deploy-anvil
```

This deployment will set up everything to let you interact with OpenFortSwapper contract.

### Interact with contract

There are some interactions to do with swapper that you can found at `script/InteractWithSwapper.s.sol`. For example to make a swap simply run:

```
make swap
```

### Testing

Run
 
```
make test
```

## Contracts and testnets

This Openfort Swapper has been deployed in *Sepolia Testnet*. All deployed contracts available in [Etherscan.](https://sepolia.etherscan.io/)

**Tokens:**
```
Stablecoin: 0xD6C223DDe25E6FF9CedE6DeF54AF896841644291
ERC20Token (MockMaticToken): 0xf1896c4d0b81f41df70a722a1841b8a0789745d2
```

**Swappers**

```
OpenfortSwapper: 0x5482437be3b8600b238ddae9433ea6407919457c
ISwapRouter (MockSwapRouter): 0x64678314e79781c33a4f9c347d2da58b31866875
```


## Contact

Daniel Tomé Fernández <danieltomefer@gmail.com>