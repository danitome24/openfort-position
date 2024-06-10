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
    uint256 private constant INIT_FEES = 10; // 1%
    OpenfortSwapper swapper;
    ISwapRouter swapRouter;
    MockStablecoin stablecoin;
    // TODO: Owner tiene q ser el creador del contrato, no el que hace swap
    address OWNER = makeAddr("owner");
    address USER_ONE = makeAddr("user1");
    address USER_TWO = makeAddr("user2");

    event StablecoinSendedToRecipient(address indexed to, uint256 amount);

    function setUp() external {
        address[] memory initialRecipients = new address[](1);
        initialRecipients[0] = USER_ONE;
        stablecoin = new MockStablecoin();

        swapRouter = new MockSwapRouter();
        stablecoin.mint(address(swapRouter), 100);
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
        uint256 amountIn = 60;
        uint256 fee = 100; // 10%
        MockMaticToken erc20Token = new MockMaticToken();
        erc20Token.mint(OWNER, amountIn);

        address[] memory recipients = new address[](2);
        recipients[0] = USER_ONE;
        recipients[1] = USER_TWO;
        swapper.setRecipients(recipients);
        swapper.setFee(fee);

        vm.prank(OWNER);
        erc20Token.approve(address(swapRouter), amountIn);
        vm.prank(OWNER);
        erc20Token.approve(address(swapper), amountIn);

        uint256 expectedAmountPerRecipient = 27;
        vm.expectEmit(true, true, false, true);
        emit StablecoinSendedToRecipient(recipients[0], expectedAmountPerRecipient);
        vm.expectEmit(true, true, false, true);
        emit StablecoinSendedToRecipient(recipients[1], expectedAmountPerRecipient);

        vm.prank(OWNER);
        swapper.swap(erc20Token, amountIn);

        assertEq(stablecoin.balanceOf(USER_ONE), expectedAmountPerRecipient);
        assertEq(stablecoin.balanceOf(USER_TWO), expectedAmountPerRecipient);
    }

    function testOnlyOwnerCanModifyParameters() public {
        address[] memory recipients = new address[](1);
        recipients[0] = USER_TWO;
        uint256 newFee = 1;

        vm.startPrank(USER_ONE);
        vm.expectRevert();
        swapper.setRecipients(recipients);
        vm.expectRevert();
        swapper.setFee(newFee);
        vm.expectRevert();
        swapper.setShippingTime(OpenfortSwapper.ShippingTime.OnceADay);
        vm.stopPrank();
    }
}
