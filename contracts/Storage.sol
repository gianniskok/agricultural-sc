//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

import "./User.sol";
import "./PackagedGoods.sol";

contract Storage is User {
    mapping(address => address[]) storageToPackAddress;
    uint256 lastIndex = 0;

    function sellToRetailer(uint256 _quantity ,address _packAddress, address _retailer) external onlyStorage {
        uint256 maxPack = PackagedGoods(_packAddress).packagesNo();
        require(lastIndex + _quantity < maxPack, "Not enough packages");
        bool result = PackagedGoods(_packAddress).setPackagesRetailer(_quantity, _retailer, lastIndex);
        console.log(result);
        storageToPackAddress[msg.sender].push(_packAddress);
        lastIndex += _quantity;
    }

    function getTotalPackContractsOfStorage(address _storage) external view returns (address[] memory){
        return(storageToPackAddress[_storage]);
    }
    
}