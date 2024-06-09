//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockSwapRouter is ISwapRouter {
    mapping(address => uint256) public balances;

    function exactInputSingle(ExactInputSingleParams calldata params)
        external
        payable
        override
        returns (uint256 amountOut)
    {
        require(params.amountIn > 0, "MockSwapRouter: amountIn must be greater than zero");

        IERC20(params.tokenIn).transferFrom(msg.sender, address(this), params.amountIn);

        // Simulamos una salida de tokens, simplemente devolvemos el amountIn como amountOut
        amountOut = params.amountIn;

        // Se "transfieren" tokens al destinatario
        IERC20(params.tokenOut).transfer(params.recipient, amountOut);

        return amountOut;
    }

    function exactOutputSingle(ExactOutputSingleParams calldata params)
        external
        payable
        override
        returns (uint256 amountIn)
    {
        return params.amountInMaximum;
    }

    function exactInput(ExactInputParams calldata params) external payable returns (uint256 amountOut) {
        return params.amountIn;
    }

    function exactOutput(ExactOutputParams calldata params) external payable returns (uint256 amountIn) {
        return params.amountInMaximum;
    }

    function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata data) external {}
}
