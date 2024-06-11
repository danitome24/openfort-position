// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {MockSwapRouter} from "../../src/mock/MockSwapRouter.sol";

contract DeploySwapRouter is Script {
    function run() external {
        vm.startBroadcast();
        MockSwapRouter mockSwapRouter = new MockSwapRouter();
        vm.stopBroadcast();

        console.log("Mock Swap router address %s", address(mockSwapRouter));
    }
}
