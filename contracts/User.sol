//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract User {
    address  payable private immutable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    enum UserRole {
        Farmer,
        Transporter,
        Storage,
        Inspector,
        Packager,
        Retailer
    }

   
}
