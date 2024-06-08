//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {MockERC20} from "../src/mock/MockERC20.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address swapRouter;
        address openfortSwapper;
        address stablecoin;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    function getSepoliaEthConfig() private view returns (NetworkConfig memory) {}

    function getMainnetEthConfig() private view returns (NetworkConfig memory) {}

    function getAnvilConfig() private view returns (NetworkConfig memory) {
        address swapRouter = DevOpsTools.get_most_recent_deployment("MockSwapRouter", block.chainid);
        address lastSwapperDeployed = DevOpsTools.get_most_recent_deployment("OpenfortSwapper", block.chainid);
        address stablecoin = 0x5FbDB2315678afecb367f032d93F642f64180aa3;

        return NetworkConfig(swapRouter, lastSwapperDeployed, stablecoin);
    }
}
