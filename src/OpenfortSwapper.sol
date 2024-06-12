// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {TransferHelper} from "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {FeeCalculator} from "./FeeCalculator.sol";

contract OpenfortSwapper is Ownable {
    using FeeCalculator for uint256;

    event StablecoinSendedToRecipient(address indexed to, uint256 amount);

    address[] s_recipients;
    ShippingTime s_shippingTime;
    uint256 s_fee; // From 1 to 1000, being 1 = 0.1% and 1000 = 100%

    ISwapRouter public immutable i_swapRouter;
    address immutable i_stablecoin;

    uint24 constant POOL_FEE = 3000;

    enum ShippingTime {
        Immediatly,
        OnceADay,
        OnceAWeek
    }

    constructor(
        address[] memory recipients,
        ShippingTime shippingTime,
        uint256 fee,
        ISwapRouter router,
        address stablecoin
    ) Ownable(msg.sender) {
        s_recipients = recipients;
        s_shippingTime = shippingTime;
        s_fee = fee;
        i_swapRouter = router;
        i_stablecoin = stablecoin;
    }

    /**
     * @param token ERC20 token to swap from
     * @param amount Must be defined by (1e18)
     */
    function swap(IERC20 token, uint256 amount) external {
        require(address(token) != address(0), "ERC20 Token address not valid");
        require(amount > 0, "Amount to swap must be > than 0");

        address from = msg.sender;
        address tokenAddress = address(token);

        TransferHelper.safeTransferFrom(tokenAddress, from, address(this), amount);
        TransferHelper.safeApprove(tokenAddress, address(i_swapRouter), amount);

        swapToStableAndSend(tokenAddress, amount);
    }

    function swapToStableAndSend(address token, uint256 amount) private {
        uint256 amountOut = swapToStable(token, amount);
        sendStableToRecipients(amountOut);
    }

    function swapToStable(address token, uint256 amount) private returns (uint256) {
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: token,
            tokenOut: i_stablecoin,
            fee: POOL_FEE,
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: amount,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        uint256 amountOut = i_swapRouter.exactInputSingle(params);

        return amountOut;
    }

    function sendStableToRecipients(uint256 amountOut) private {
        address[] memory recipients = s_recipients;
        uint256 recipientsLength = recipients.length;

        uint256 fee = amountOut.calculateFeeFromAmount(s_fee);
        uint256 amountOutAfterFee = amountOut - fee;

        IERC20(i_stablecoin).transfer(owner(), fee);
        emit StablecoinSendedToRecipient(owner(), fee);

        uint256 amountOutPerRecipient = amountOutAfterFee / recipientsLength;
        for (uint256 i = 0; i < recipientsLength; i++) {
            IERC20(i_stablecoin).transfer(recipients[i], amountOutPerRecipient);
            emit StablecoinSendedToRecipient(recipients[i], amountOutPerRecipient);
        }
    }

    function setFee(uint256 newFee) external onlyOwner {
        require(newFee <= 1000, "Fee must be lower than 1000");

        s_fee = newFee;
    }

    function getFee() external view returns (uint256) {
        return s_fee;
    }

    function setShippingTime(ShippingTime newTiming) external onlyOwner {
        s_shippingTime = newTiming;
    }

    function getShippingTime() external view returns (ShippingTime) {
        return s_shippingTime;
    }

    function setRecipients(address[] memory _recipients) external onlyOwner {
        s_recipients = _recipients;
    }

    function getRecipients() external view returns (address[] memory) {
        return s_recipients;
    }
}
