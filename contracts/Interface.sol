//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./Farm.sol";
import "./Transport.sol";
import "./Inspect.sol";
import "./Storage.sol";


contract Interface is Farm, Transport, Inspect, Storage {
    constructor(){}
}