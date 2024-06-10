// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {OpenfortSwapper} from "../src/OpenfortSwapper.sol";
import {MockSwapRouter} from "../src/mock/MockSwapRouter.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MockMaticToken} from "../src/mock/MockMaticToken.sol";
import {MockStablecoin} from "../src/mock/MockStablecoin.sol";

contract OpenfortSwapperTest is Test {
    uint256 private constant INIT_FEES = 10; // 10%
    OpenfortSwapper swapper;
    ISwapRouter swapRouter;
    MockStablecoin stablecoin;
    address OWNER = makeAddr("owner");
    address USER_ONE = makeAddr("user1");
    address USER_TWO = makeAddr("user2");

    function setUp() external {
        address[] memory initialRecipients = new address[](1);
        initialRecipients[0] = USER_ONE;
        stablecoin = new MockStablecoin();
        swapRouter = new MockSwapRouter();
        swapper = new OpenfortSwapper(
            initialRecipients, OpenfortSwapper.ShippingTime.Immediatly, INIT_FEES, swapRouter, address(stablecoin)
        );
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

    function testSwap() public {
        // Prepare
        MockMaticToken erc20Token = new MockMaticToken();
        address[] memory recipients = new address[](2);
        recipients[0] = USER_ONE;
        recipients[1] = USER_TWO;
        swapper.setRecipients(recipients);
        uint256 amountIn = 6;
        erc20Token.mint(OWNER, amountIn);
        stablecoin.mint(address(swapRouter), amountIn);

        vm.startPrank(OWNER);
        erc20Token.approve(address(swapRouter), amountIn);
        erc20Token.approve(address(swapper), amountIn);

        swapper.swap(erc20Token, amountIn);
        vm.stopPrank();

        uint256 expectedAmount = 3;
        assertEq(stablecoin.balanceOf(USER_ONE), expectedAmount);
        assertEq(stablecoin.balanceOf(USER_TWO), expectedAmount);
    }
}
