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
    uint256 constant AMOUNT_TO_SEND = 2 * 1e18; // 2 MATIC

    function run() external {
        address from = msg.sender;
        address[] memory recipients = new address[](2);
        recipients[0] = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        recipients[1] = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;

        address stablecoin = DevOpsTools.get_most_recent_deployment("MockStablecoin", block.chainid);
        address maticTokenAddr = DevOpsTools.get_most_recent_deployment("MockMaticToken", block.chainid);

        address swapRouter = DevOpsTools.get_most_recent_deployment("MockSwapRouter", block.chainid);
        address lastSwapperDeployed = DevOpsTools.get_most_recent_deployment("OpenfortSwapper", block.chainid);

        //console.log("STablecoin %s", stablecoin);
        //console.log("Matic %s", maticTokenAddr);
        //console.log("SwapRouter contract address: %s", swapRouter);
        //console.log("OpenfortSwap contract address: %s", lastSwapperDeployed);

        IERC20 usdcToken = MockStablecoin(stablecoin);
        IERC20 maticToken = MockMaticToken(maticTokenAddr);

        console.log("Before: Sender MATIC balance %s", maticToken.balanceOf(from));
        console.log("Before: Swapper USDC balance: %s", usdcToken.balanceOf(swapRouter));

        vm.startBroadcast();
        maticToken.approve(lastSwapperDeployed, AMOUNT_TO_SEND);
        maticToken.approve(swapRouter, AMOUNT_TO_SEND);

        OpenfortSwapper swapper = OpenfortSwapper(lastSwapperDeployed);
        swapper.setRecipients(recipients);
        swapper.swap(maticToken, AMOUNT_TO_SEND);
        vm.stopBroadcast();
        console.log("Owner is %s", swapper.owner());
        console.log("After: Sender MATIC balance %s", maticToken.balanceOf(from));
        console.log("After: Swapper USDC balance: %s", usdcToken.balanceOf(swapRouter));
    }
}
