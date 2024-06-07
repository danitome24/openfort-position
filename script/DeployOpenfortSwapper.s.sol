// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {OpenfortSwapper} from "../src/OpenfortSwapper.sol";
import {MockSwapRouter} from "../src/mock/MockSwapRouter.sol";

contract DeployOpenfortSwapper is Script {
    uint256 private constant INITIAL_FEE = 30; // 30%

    function setUp() public {}

    function run() public {
        address[] memory initialRecipients = new address[](0);

        vm.startBroadcast();
        MockSwapRouter swapRouter = new MockSwapRouter();
        OpenfortSwapper swapper =
            new OpenfortSwapper(initialRecipients, OpenfortSwapper.ShippingTime.Immediatly, INITIAL_FEE, swapRouter);
        vm.stopBroadcast();

        console.log("OpenfortSwapper deployed at: %s", address(swapper));
    }
}
