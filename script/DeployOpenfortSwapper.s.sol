// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {OpenfortSwapper} from "../src/OpenfortSwapper.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {MockSwapRouter} from "../src/mock/MockSwapRouter.sol";

contract DeployOpenfortSwapper is Script {
    uint256 private constant INITIAL_FEE = 30; // 30%

    function run() public {
        address[] memory initialRecipients = new address[](0);

        address stablecoin = 0x0DCd1Bf9A1b36cE34237eEaFef220932846BCD82;

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
