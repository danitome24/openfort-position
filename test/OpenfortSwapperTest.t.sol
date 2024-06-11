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

    address OWNER = makeAddr("owner");
    address WHO_SWAPS = makeAddr("userSwapper");
    address RECIPIENT_ONE = makeAddr("userReceiver1");
    address RECIPIENT_TWO = makeAddr("userReceiver2");
    address RECIPIENT_THREE = makeAddr("userReceiver3");

    event StablecoinSendedToRecipient(address indexed to, uint256 amount);

    function setUp() external {
        address[] memory initialRecipients = new address[](1);
        initialRecipients[0] = RECIPIENT_ONE;

        vm.startPrank(OWNER);
        stablecoin = new MockStablecoin();
        swapRouter = new MockSwapRouter();
        stablecoin.mint(address(swapRouter), 100);
        swapper = new OpenfortSwapper(
            initialRecipients, OpenfortSwapper.ShippingTime.Immediatly, INIT_FEES, swapRouter, address(stablecoin)
        );
        vm.stopPrank();
    }

    function testCanSetInitialParameters() public view {
        address[] memory expectedRecipients = new address[](1);
        expectedRecipients[0] = RECIPIENT_ONE;

        assertEq(INIT_FEES, swapper.getFee());
        assertEq(uint256(OpenfortSwapper.ShippingTime.Immediatly), uint256(swapper.getShippingTime()));
        assertEq(expectedRecipients, swapper.getRecipients());
    }

    function testOwnerCanChangeInitialParameters() public {
        address[] memory expectedRecipients = new address[](1);
        expectedRecipients[0] = RECIPIENT_TWO;
        uint256 expectedFee = 20;

        vm.startPrank(OWNER);
        swapper.setShippingTime(OpenfortSwapper.ShippingTime.OnceADay);
        swapper.setRecipients(expectedRecipients);
        swapper.setFee(expectedFee);
        vm.stopPrank();

        assertEq(uint256(OpenfortSwapper.ShippingTime.OnceADay), uint256(swapper.getShippingTime()));
        assertEq(expectedRecipients, swapper.getRecipients());
        assertEq(expectedFee, swapper.getFee());
    }

    function testRecipientsGetStablecoinAferSwap() public {
        // Prepare
        uint256 amountIn = 60;
        uint256 fee = 100; // 10%
        MockMaticToken erc20Token = new MockMaticToken();
        erc20Token.mint(WHO_SWAPS, amountIn);

        address[] memory recipients = new address[](2);
        recipients[0] = RECIPIENT_ONE;
        recipients[1] = RECIPIENT_TWO;

        vm.startPrank(OWNER);
        swapper.setRecipients(recipients);
        swapper.setFee(fee);
        vm.stopPrank();

        vm.startPrank(WHO_SWAPS);
        erc20Token.approve(address(swapRouter), amountIn);
        erc20Token.approve(address(swapper), amountIn);
        vm.stopPrank();

        uint256 expectedAmountPerRecipient = 27;
        vm.expectEmit(true, true, false, true);
        emit StablecoinSendedToRecipient(recipients[0], expectedAmountPerRecipient);
        vm.expectEmit(true, true, false, true);
        emit StablecoinSendedToRecipient(recipients[1], expectedAmountPerRecipient);

        vm.prank(WHO_SWAPS);
        swapper.swap(erc20Token, amountIn);

        assertEq(stablecoin.balanceOf(RECIPIENT_ONE), expectedAmountPerRecipient);
        assertEq(stablecoin.balanceOf(RECIPIENT_TWO), expectedAmountPerRecipient);
    }

    function testFeeOnSwap() public {
        // Prepare
        uint256 amountIn = 60;
        uint256 fee = 100; // 10%
        MockMaticToken erc20Token = new MockMaticToken();
        erc20Token.mint(WHO_SWAPS, amountIn);

        address[] memory recipients = new address[](2);
        recipients[0] = RECIPIENT_ONE;
        recipients[1] = RECIPIENT_TWO;

        vm.startPrank(OWNER);
        swapper.setRecipients(recipients);
        swapper.setFee(fee);
        vm.stopPrank();

        vm.startPrank(WHO_SWAPS);
        erc20Token.approve(address(swapRouter), amountIn);
        erc20Token.approve(address(swapper), amountIn);
        vm.stopPrank();

        uint256 expectedAmountFee = 6;

        vm.prank(WHO_SWAPS);
        swapper.swap(erc20Token, amountIn);

        assertEq(stablecoin.balanceOf(OWNER), expectedAmountFee);
    }

    function testOnlyOwnerCanModifyParameters() public {
        address[] memory recipients = new address[](1);
        recipients[0] = RECIPIENT_TWO;
        uint256 newFee = 1;

        vm.startPrank(RECIPIENT_ONE);
        vm.expectRevert();
        swapper.setRecipients(recipients);
        vm.expectRevert();
        swapper.setFee(newFee);
        vm.expectRevert();
        swapper.setShippingTime(OpenfortSwapper.ShippingTime.OnceADay);
        vm.stopPrank();
    }
}
