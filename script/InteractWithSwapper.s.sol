//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {OpenfortSwapper} from "../src/OpenfortSwapper.sol";
import {MockMaticToken} from "../src/mock/MockMaticToken.sol";
import {MockStablecoin} from "../src/mock/MockStablecoin.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract SetRecipients is Script {
    function run() external {
        address[] memory newRecipients = new address[](3);
        newRecipients[0] = 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65;
        newRecipients[1] = 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc;
        newRecipients[2] = 0x976EA74026E726554dB657fA54763abd0C3a0aa9;

        address openfortSwapper = DevOpsTools.get_most_recent_deployment("OpenfortSwapper", block.chainid);
        OpenfortSwapper swapper = OpenfortSwapper(openfortSwapper);

        vm.broadcast();
        swapper.setRecipients(newRecipients);

        console.log("Recipients updated");
    }
}

contract SetFee is Script {
    /**
     * Put fee on base 1000, so 10% will be 100.
     */
    uint256 constant FEE = 200; // 20%

    function run() external {
        address openfortSwapper = DevOpsTools.get_most_recent_deployment("OpenfortSwapper", block.chainid);
        OpenfortSwapper swapper = OpenfortSwapper(openfortSwapper);

        vm.broadcast();
        swapper.setFee(FEE);

        console.log("Fee set to %s %", FEE / 10);
    }
}

contract Swap is Script {
    uint256 constant AMOUNT_TO_SEND = 2 * 1e18; // 2 MATIC

    function run() external {
        address from = msg.sender;

        address stablecoin = DevOpsTools.get_most_recent_deployment("MockStablecoin", block.chainid);
        address maticTokenAddr = DevOpsTools.get_most_recent_deployment("MockMaticToken", block.chainid);

        address swapRouter = DevOpsTools.get_most_recent_deployment("MockSwapRouter", block.chainid);
        address openfortSwapper = DevOpsTools.get_most_recent_deployment("OpenfortSwapper", block.chainid);

        IERC20 usdcToken = MockStablecoin(stablecoin);
        IERC20 maticToken = MockMaticToken(maticTokenAddr);

        console.log("USDC Token add: %s", address(usdcToken));
        console.log("MATIC Token add: %s", address(maticToken));
        console.log("Swapper is %s", address(swapRouter));
        console.log("Openfortswapper is %s", address(openfortSwapper));

        OpenfortSwapper swapper = OpenfortSwapper(openfortSwapper);
        address[] memory recipients = swapper.getRecipients();

        console.log("Before: Sender MATIC balance %s", maticToken.balanceOf(from));
        for (uint256 i = 0; i < recipients.length; i++) {
            console.log("Before: Recipient %s USDC balance: %s", recipients[i], usdcToken.balanceOf(recipients[i]));
        }
        vm.startBroadcast();
        maticToken.approve(openfortSwapper, AMOUNT_TO_SEND);
        maticToken.approve(swapRouter, AMOUNT_TO_SEND);

        swapper.swap(maticToken, AMOUNT_TO_SEND);
        vm.stopBroadcast();

        console.log("Owner balance %s", usdcToken.balanceOf(swapper.owner()));
        console.log("After: Sender MATIC balance %s", maticToken.balanceOf(from));
        for (uint256 i = 0; i < recipients.length; i++) {
            console.log("After: Recipient %s USDC balance: %s", i, usdcToken.balanceOf(recipients[i]));
        }
    }
}

contract GetFee is Script {
    function run() external view {
        address openfortSwapper = DevOpsTools.get_most_recent_deployment("OpenfortSwapper", block.chainid);
        OpenfortSwapper swapper = OpenfortSwapper(openfortSwapper);

        console.log("Fee is set to %s", swapper.getFee());
    }
}

contract GetRecipients is Script {
    function run() external view {
        address openfortSwapper = DevOpsTools.get_most_recent_deployment("OpenfortSwapper", block.chainid);
        OpenfortSwapper swapper = OpenfortSwapper(openfortSwapper);
        address[] memory recipients = swapper.getRecipients();

        for (uint256 index = 0; index < recipients.length; index++) {
            console.log("Recipient %s with address %s", index, recipients[index]);
        }
    }
}
