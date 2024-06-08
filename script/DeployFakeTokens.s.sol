// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {MockStablecoin} from "../src/mock/MockStablecoin.sol";
import {MockERC20} from "../src/mock/MockERC20.sol";

contract DeployFakeTokens is Script {
    function run() external {
        vm.startBroadcast();
        MockStablecoin mockUsdcToken = new MockStablecoin("USDC Stable Token", "USDC"); // Stablecoin.
        MockERC20 mockMaticToken = new MockERC20("Matic Token", "MATIC"); // MATIC ERC20 example.
        vm.stopBroadcast();

        console.log("MATIC Token address %s", address(mockMaticToken));
        console.log("USDC Token address %s", address(mockUsdcToken));
    }
}
