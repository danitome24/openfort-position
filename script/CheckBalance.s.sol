// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MockERC20} from "../src/mock/MockERC20.sol";

contract CheckBalance is Script {
    address private constant TOKEN_TO_CHECK = 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512; // MATIC.
    address private constant ACCOUNT = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function run() public {
        vm.startBroadcast();
        IERC20 tokenBalance = MockERC20(TOKEN_TO_CHECK);
        uint256 balance = tokenBalance.balanceOf(ACCOUNT);
        vm.stopBroadcast();

        console.log(balance);
    }
}
