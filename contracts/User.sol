//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract User {
    address payable private owner;

    constructor() {
        owner = payable(msg.sender);
    }

   
}
