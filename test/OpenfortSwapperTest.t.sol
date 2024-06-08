// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {OpenfortSwapper} from "../src/OpenfortSwapper.sol";
import {MockSwapRouter} from "../src/mock/MockSwapRouter.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract OpenfortSwapperTest is Test {
    uint256 private constant INIT_FEES = 10; // 10%
    OpenfortSwapper swapper;
    address OWNER = makeAddr("owner");
    address USER_ONE = makeAddr("user1");
    address USER_TWO = makeAddr("user2");

    address STABLECOIN = makeAddr("stable");

    function setUp() external {
        address[] memory initialRecipients = new address[](1);
        initialRecipients[0] = USER_ONE;
        ISwapRouter swapRouter = new MockSwapRouter();
        swapper = new OpenfortSwapper(initialRecipients, OpenfortSwapper.ShippingTime.Immediatly, INIT_FEES, swapRouter, STABLECOIN);
    }

    function testCanSetInitialParameters() public view {
        address[] memory expectedRecipients = new address[](1);
        expectedRecipients[0] = USER_ONE;
        assertEq(INIT_FEES, swapper.getFee());
        assertEq(uint256(OpenfortSwapper.ShippingTime.Immediatly), uint256(swapper.getShippingTime()));
        assertEq(expectedRecipients, swapper.getRecipients());
    }

    function testCanChangeInitialParameters() public {
        address[] memory expectedRecipients = new address[](1);
        expectedRecipients[0] = USER_TWO;
        uint256 expectedFee = 20;
        swapper.setShippingTime(OpenfortSwapper.ShippingTime.OnceADay);
        swapper.setRecipients(expectedRecipients);
        swapper.setFee(expectedFee);

        assertEq(uint256(OpenfortSwapper.ShippingTime.OnceADay), uint256(swapper.getShippingTime()));
        assertEq(expectedRecipients, swapper.getRecipients());
        assertEq(expectedFee, swapper.getFee());
    }
}
