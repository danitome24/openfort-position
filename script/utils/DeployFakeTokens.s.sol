// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {MockStablecoin} from "../../src/mock/MockStablecoin.sol";
import {MockMaticToken} from "../../src/mock/MockMaticToken.sol";

contract DeployFakeTokens is Script {
    function run() external {
        vm.startBroadcast();
        MockMaticToken erc20Token = new MockMaticToken();
        MockStablecoin mockUsdcToken = new MockStablecoin();
        vm.stopBroadcast();

        console.log("USDC Token address %s", address(mockUsdcToken));
        console.log("MATIC Token address %s", address(erc20Token));
    }
}
