// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {TransferHelper} from "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";

contract OpenfortSwapper {
    address[] s_recipients;
    ShippingTime s_shippingTime;
    uint256 s_fee;

    ISwapRouter public immutable i_swapRouter;

    address constant USDC_TOKEN = 0xF4A8f74879182FF2A07468508bec89e1E7464027;
    uint24 public constant POOL_FEE = 3000;

    enum ShippingTime {
        Immediatly,
        OnceADay,
        OnceAWeek
    }

    constructor(address[] memory recipients, ShippingTime shippingTime, uint256 fee, ISwapRouter router) {
        s_recipients = recipients;
        s_shippingTime = shippingTime;
        s_fee = fee;
        i_swapRouter = router;
    }

    function swap(IERC20 token, uint256 amount) external {
        address from = msg.sender;
        address tokenAddress = address(token);
        TransferHelper.safeTransferFrom(tokenAddress, from, address(this), amount);
        TransferHelper.safeApprove(tokenAddress, address(i_swapRouter), amount);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: tokenAddress,
            tokenOut: USDC_TOKEN,
            fee: POOL_FEE,
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: amount,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        uint256 amountOut = i_swapRouter.exactInputSingle(params);
    }

    function setFee(uint256 newFee) external {
        s_fee = newFee;
    }

    function getFee() external view returns (uint256) {
        return s_fee;
    }

    function setShippingTime(ShippingTime newTiming) external {
        s_shippingTime = newTiming;
    }

    function getShippingTime() external view returns (ShippingTime) {
        return s_shippingTime;
    }

    function setRecipients(address[] memory _recipients) external {
        s_recipients = _recipients;
    }

    function getRecipients() external view returns (address[] memory) {
        return s_recipients;
    }
}
