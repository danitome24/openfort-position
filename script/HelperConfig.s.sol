//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {MockSwapRouter} from "../src/mock/MockSwapRouter.sol";
import {MockStablecoin} from "../src/mock/MockStablecoin.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address swapRouter;
        address stablecoin;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    function getSepoliaEthConfig() private view returns (NetworkConfig memory) {}

    function getMainnetEthConfig() private view returns (NetworkConfig memory) {}

    function getOrCreateAnvilConfig() private returns (NetworkConfig memory) {
        address swapRouter;
        address stablecoin;

        if (activeNetworkConfig.swapRouter == address(0)) {
            vm.broadcast();
            MockSwapRouter mockSwapRouter = new MockSwapRouter();
            swapRouter = address(mockSwapRouter);
        } else {
            swapRouter = DevOpsTools.get_most_recent_deployment("MockSwapRouter", block.chainid);
        }
        if (activeNetworkConfig.stablecoin == address(0)) {
            vm.broadcast();
            MockStablecoin mockStablecoin = new MockStablecoin();
            stablecoin = address(mockStablecoin);
        } else {
            stablecoin = DevOpsTools.get_most_recent_deployment("MockStablecoin", block.chainid);
        }

        return NetworkConfig(swapRouter, stablecoin);
    }
}
