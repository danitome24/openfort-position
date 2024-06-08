// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MockERC20} from "../src/mock/MockERC20.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract CheckBalance is Script {
    address private constant ACCOUNT = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function run() public {
        address mockMaticToken = DevOpsTools.get_most_recent_deployment("MockERC20", block.chainid);

        vm.startBroadcast();
        IERC20 tokenBalance = MockERC20(mockMaticToken);
        uint256 balance = tokenBalance.balanceOf(ACCOUNT);
        vm.stopBroadcast();

        console.log(balance);
    }
}
