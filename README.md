# Openfort challenge

This repository contains the Openfort Swapper smart contract, which allows the swapping of ERC20 tokens to stablecoins and the distribution of the stablecoins to specified recipients. The contract uses Uniswap V3 for swapping and includes a fee mechanism.

## Requirements

* [Foundry](https://getfoundry.sh/): You'll need to install foundry to get this project run and test. [Here](https://book.getfoundry.sh/getting-started/installation) you can see how to install it.

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
