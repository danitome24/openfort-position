// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockMaticToken is ERC20 {
    constructor() ERC20("Matic Token", "MATIC") {}

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }
}
