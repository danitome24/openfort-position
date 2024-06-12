//SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

library FeeCalculator {
    /**
     * Base 1000
     * Fee from 1 to 1000, being 1 = 0.1% and 1000 = 100%
     */
    uint256 constant PERCENTAGE_BASE = 1000;

    function calculateFeeFromAmount(uint256 amount, uint256 fee) internal pure returns (uint256) {
        return (amount * fee) / PERCENTAGE_BASE;
    }
}
