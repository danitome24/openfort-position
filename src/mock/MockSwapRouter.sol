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

        // Simulamos la transferencia de tokenIn del remitente al contrato
        IERC20(params.tokenIn).transferFrom(msg.sender, address(this), params.amountIn);

        // Simulamos una salida de tokens, simplemente devolvemos el amountIn como amountOut
        amountOut = params.amountIn;

        // Se "transfieren" tokens al destinatario
        IERC20(params.tokenOut).transfer(params.recipient, amountOut);

        return 0;
    }

    function exactOutputSingle(ExactOutputSingleParams calldata params)
        external
        payable
        override
        returns (uint256 amountIn)
    {
        require(params.amountOut > 0, "MockSwapRouter: amountOut must be greater than zero");

        // Simulamos el cálculo del amountIn necesario
        amountIn = params.amountOut;

        // Simulamos la transferencia de tokenIn del remitente al contrato
        IERC20(params.tokenIn).transferFrom(msg.sender, address(this), amountIn);

        // Se "transfieren" tokens al destinatario
        IERC20(params.tokenOut).transfer(params.recipient, params.amountOut);

        return 0;
    }

    function exactInput(ExactInputParams calldata params) external payable returns (uint256 amountOut) {
        return 0;
    }

    function exactOutput(ExactOutputParams calldata params) external payable returns (uint256 amountIn) {
        return 0;
    }

    function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata data) external {}

    // Función para simular agregar balances de tokens para testing
    function addTokenBalance(address token, uint256 amount) external {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        balances[token] += amount;
    }

    // Función para obtener balances de tokens para testing
    function getTokenBalance(address token) external view returns (uint256) {
        return balances[token];
    }
}
