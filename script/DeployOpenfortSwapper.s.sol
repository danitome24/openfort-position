// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {OpenfortSwapper} from "../src/OpenfortSwapper.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {MockSwapRouter} from "../src/mock/MockSwapRouter.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployOpenfortSwapper is Script {
    uint256 private constant INITIAL_FEE = 100; // 10%

    function run() public {
        address[] memory initialRecipients = new address[](2);
        initialRecipients[0] = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        initialRecipients[1] = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;

        HelperConfig networkConfig = new HelperConfig();
        (address swapRouter, address stablecoin) = networkConfig.activeNetworkConfig();

        ISwapRouter iSwapRouter = ISwapRouter(swapRouter);
        vm.startBroadcast();
        OpenfortSwapper swapper = new OpenfortSwapper(
            initialRecipients, OpenfortSwapper.ShippingTime.Immediatly, INITIAL_FEE, iSwapRouter, stablecoin
        );
        vm.stopBroadcast();

        console.log("SwapRouter deployed at: %s", address(iSwapRouter));
        console.log("OpenfortSwapper deployed at: %s", address(swapper));
        console.log("Stablecoin deployed at: %s", address(stablecoin));
    }
}
