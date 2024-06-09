// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {OpenfortSwapper} from "../src/OpenfortSwapper.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {MockSwapRouter} from "../src/mock/MockSwapRouter.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract DeployOpenfortSwapper is Script {
    uint256 private constant INITIAL_FEE = 30; // 30%

    function run() public {
        address[] memory initialRecipients = new address[](2);
        initialRecipients[0] = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        initialRecipients[1] = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;

        address stablecoin = DevOpsTools.get_most_recent_deployment("MockStablecoin", block.chainid);

        vm.startBroadcast();
        ISwapRouter swapRouter = new MockSwapRouter();
        OpenfortSwapper swapper = new OpenfortSwapper(
            initialRecipients, OpenfortSwapper.ShippingTime.Immediatly, INITIAL_FEE, swapRouter, stablecoin
        );
        vm.stopBroadcast();

        console.log("SwapRouter deployed at: %s", address(swapRouter));
        console.log("OpenfortSwapper deployed at: %s", address(swapper));
    }
}
