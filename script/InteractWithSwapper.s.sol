//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {OpenfortSwapper} from "../src/OpenfortSwapper.sol";
import {MockERC20} from "../src/mock/MockERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract InteractWithSwapper is Script {
    function run() external {
        address from = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        address to = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        address swapRouter = DevOpsTools.get_most_recent_deployment("MockSwapRouter", block.chainid);
        address lastSwapperDeployed = DevOpsTools.get_most_recent_deployment("OpenfortSwapper", block.chainid);
        console.log("ISwapper contract address: %s", swapRouter);
        console.log("OpenfortSwap contract address: %s", lastSwapperDeployed);

        IERC20 usdcToken = MockERC20(0x5FbDB2315678afecb367f032d93F642f64180aa3);
        IERC20 maticToken = MockERC20(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512);

        console.log("Before: Sender MATIC balance %s", maticToken.balanceOf(from));
        console.log(
            "Before: Receiver USDC balance: %s", usdcToken.balanceOf(to)
        );
        console.log(
            "Before: Swapper USDC balance: %s", usdcToken.balanceOf(swapRouter)
        );

        vm.startBroadcast();
        maticToken.approve(lastSwapperDeployed, 1);
        maticToken.approve(swapRouter, 1);
        OpenfortSwapper swapper = OpenfortSwapper(lastSwapperDeployed);
        swapper.swap(maticToken, 1);
        vm.stopBroadcast();

        console.log("After: Sender MATIC balance %s", maticToken.balanceOf(from));
        console.log(
            "After: Receiver USDC balance: %s", usdcToken.balanceOf(to)
        );
        console.log(
            "After: Swapper USDC balance: %s", usdcToken.balanceOf(swapRouter)
        );
    }
}
