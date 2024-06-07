//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";

contract InteractWithSwapper is Script {
    function run() external {
        // Hacer que interactue con el swapper.
        OpenfortSwapper swapper = OpenfortSwapper();
    }
}
