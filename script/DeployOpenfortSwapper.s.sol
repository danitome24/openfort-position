// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {OpenfortSwapper} from "../src/OpenfortSwapper.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {MockSwapRouter} from "../src/mock/MockSwapRouter.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployOpenfortSwapper is Script {
    uint256 private constant INITIAL_FEE = 30; // 30%

    function run() public {
        address[] memory initialRecipients = new address[](0);

        HelperConfig helperConfig = new HelperConfig();
        (address swapRouter, address stablecoin) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        ISwapRouter iSwapRouter = ISwapRouter(swapRouter);
        OpenfortSwapper swapper = new OpenfortSwapper(
            initialRecipients, OpenfortSwapper.ShippingTime.Immediatly, INITIAL_FEE, iSwapRouter, stablecoin
        );
        vm.stopBroadcast();

        console.log("SwapRouter deployed at: %s", address(iSwapRouter));
        console.log("OpenfortSwapper deployed at: %s", address(swapper));
        console.log("Stablecoin deployed at: %s", address(stablecoin));
    }
}
