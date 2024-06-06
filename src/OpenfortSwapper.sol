// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OpenfortSwapper {
    address[] s_recipients;
    ShippingTime s_shippingTime;
    uint256 s_fee;

    enum ShippingTime {
        Immediatly,
        OnceADay,
        OnceAWeek
    }

    constructor(address[] memory recipients, ShippingTime shippingTime, uint256 fee) {
        s_recipients = recipients;
        s_shippingTime = shippingTime;
        s_fee = fee;
    }

    function swap(IERC20 paidToken) external {}

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
