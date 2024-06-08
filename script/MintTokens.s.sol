// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {MockStablecoin} from "../src/mock/MockStablecoin.sol";
import {MockERC20} from "../src/mock/MockERC20.sol";

contract MintStableTokens is Script {
    function run() external {
        address latestMockStablecoin = DevOpsTools.get_most_recent_deployment("MockStablecoin", block.chainid);
        address latestMockSwapRouter = DevOpsTools.get_most_recent_deployment("MockSwapRouter", block.chainid);

        vm.startBroadcast();
        MockStablecoin mockStablecoin = MockStablecoin(latestMockStablecoin);
        mockStablecoin.mint(latestMockSwapRouter, 100);
        vm.stopBroadcast();
    }
}

contract MintERC20Tokens is Script {
    function run() external {
        address latestMockERC20 = DevOpsTools.get_most_recent_deployment("MockERC20", block.chainid);
        address latestMockSwapRouter = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // First anvil address.

        vm.startBroadcast();
        MockERC20 mockERC20 = MockERC20(latestMockERC20);
        mockERC20.mint(latestMockSwapRouter, 10);
        vm.stopBroadcast();
    }
}
