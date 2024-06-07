// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {MockERC20} from "../src/mock/MockERC20.sol";

contract DeployFakeTokens is Script {
    function run() external {
        vm.startBroadcast();
        MockERC20 mockUsdcToken = new MockERC20("USDC Stable Token", "USDC");
        MockERC20 mockMaticToken = new MockERC20("Matic Token", "MATIC");
        vm.stopBroadcast();

        console.log("USDC Token address %s", address(mockUsdcToken));
        console.log("MATIC Token address %s", address(mockMaticToken));
    }
}