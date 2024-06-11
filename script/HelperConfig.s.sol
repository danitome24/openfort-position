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
        } else if (block.chainid == 421614) {
            activeNetworkConfig = getArbitrumConfig();
        } else if (block.chainid == 11155420) {
            activeNetworkConfig = getOptimismConfig();
        } else if (block.chainid == 80002) {
            activeNetworkConfig = getPolygonConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    function getSepoliaEthConfig() private pure returns (NetworkConfig memory) {
        address swapRouter = 0x64678314E79781c33a4F9C347d2da58B31866875;
        address stablecoin = 0xD6C223DDe25E6FF9CedE6DeF54AF896841644291;

        NetworkConfig memory networkConfig = NetworkConfig(swapRouter, stablecoin);

        return networkConfig;
    }

    function getArbitrumConfig() private returns (NetworkConfig memory) {}

    function getOptimismConfig() private returns (NetworkConfig memory) {}

    function getPolygonConfig() private returns (NetworkConfig memory) {}

    function getOrCreateAnvilConfig() private returns (NetworkConfig memory) {
        vm.startBroadcast();
        MockSwapRouter mockSwapRouter = new MockSwapRouter();
        MockStablecoin mockStablecoin = new MockStablecoin();
        vm.stopBroadcast();

        return NetworkConfig(address(mockSwapRouter), address(mockStablecoin));
    }
}
