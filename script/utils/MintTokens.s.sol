// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {MockStablecoin} from "../../src/mock/MockStablecoin.sol";
import {MockMaticToken} from "../../src/mock/MockMaticToken.sol";

contract MintStableTokens is Script {
    uint256 constant MINT_AMOUNT = 200 * 1e18;

    function run() external {
        address latestMockStablecoin = DevOpsTools.get_most_recent_deployment("MockStablecoin", block.chainid);
        address latestMockSwapRouter = DevOpsTools.get_most_recent_deployment("MockSwapRouter", block.chainid);

        vm.startBroadcast();
        MockStablecoin mockStablecoin = MockStablecoin(latestMockStablecoin);
        mockStablecoin.mint(latestMockSwapRouter, MINT_AMOUNT);
        console.log("Minted %s USDC to %s", MINT_AMOUNT, latestMockSwapRouter);
        vm.stopBroadcast();
    }
}

contract MintERC20Tokens is Script {
    uint256 constant MINT_AMOUNT = 20 * 1e18;

    function run() external {
        address latestMockERC20 = DevOpsTools.get_most_recent_deployment("MockMaticToken", block.chainid);
        address minter = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // First anvil address.

        vm.startBroadcast();
        MockMaticToken mockERC20 = MockMaticToken(latestMockERC20);
        mockERC20.mint(minter, MINT_AMOUNT);
        vm.stopBroadcast();
    }
}
