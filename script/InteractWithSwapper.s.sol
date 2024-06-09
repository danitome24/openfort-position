//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {OpenfortSwapper} from "../src/OpenfortSwapper.sol";
import {MockMaticToken} from "../src/mock/MockMaticToken.sol";
import {MockStablecoin} from "../src/mock/MockStablecoin.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract InteractWithSwapper is Script {
    function run() external {
        address from = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        address to = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        uint256 amountToSend = 2;
        address stablecoin = DevOpsTools.get_most_recent_deployment("MockStablecoin", block.chainid);
        address maticTokenAddr = DevOpsTools.get_most_recent_deployment("MockMaticToken", block.chainid);

        HelperConfig helperConfig = new HelperConfig();
        (address swapRouter, address lastSwapperDeployed) = helperConfig.activeNetworkConfig();

        console.log("ISwapper contract address: %s", swapRouter);
        console.log("OpenfortSwap contract address: %s", lastSwapperDeployed);

        IERC20 usdcToken = MockStablecoin(stablecoin);
        IERC20 maticToken = MockMaticToken(maticTokenAddr);

        console.log("Before: Sender MATIC balance %s", maticToken.balanceOf(from));
        console.log("Before: Swapper USDC balance: %s", usdcToken.balanceOf(swapRouter));

        vm.startBroadcast();
        maticToken.approve(lastSwapperDeployed, amountToSend);
        maticToken.approve(swapRouter, amountToSend);
        OpenfortSwapper swapper = OpenfortSwapper(lastSwapperDeployed);
        swapper.swap(maticToken, amountToSend);
        vm.stopBroadcast();

        console.log("After: Sender MATIC balance %s", maticToken.balanceOf(from));
        console.log("After: Swapper USDC balance: %s", usdcToken.balanceOf(swapRouter));
    }
}
