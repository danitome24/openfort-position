// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockStablecoin is ERC20 {
    constructor() ERC20("USDT Token", "USDT") {}

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }
}
