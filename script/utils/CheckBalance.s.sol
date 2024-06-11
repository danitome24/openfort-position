// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MockMaticToken} from "../../src/mock/MockMaticToken.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract CheckBalance is Script {
    address private constant ACCOUNT = 0x610178dA211FEF7D417bC0e6FeD39F05609AD788;

    function run() public {
        //address erc20Token = DevOpsTools.get_most_recent_deployment("MockMaticToken", block.chainid);
        address erc20Token = DevOpsTools.get_most_recent_deployment("MockStablecoin", block.chainid);

        vm.startBroadcast();
        IERC20 tokenBalance = IERC20(erc20Token);
        uint256 balance = tokenBalance.balanceOf(ACCOUNT);
        vm.stopBroadcast();

        console.log(balance / 1e18);
    }
}
