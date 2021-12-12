//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

import "./User.sol";
import "./RawGoods.sol";

contract Farm is User {
    mapping(address => address[]) farmerToRawContracts;
    mapping(address => string) public rawGoodsAddressToType;

    function createRawGoods(uint256 _quantity, uint256 _price, uint256 _expDate, string memory _type, string memory _location) external onlyFarmer {
        address farmer = msg.sender;
        RawGoods newGood = new RawGoods(_quantity, _price, _expDate, farmer, _type, _location);
        farmerToRawContracts[msg.sender].push(address(newGood));
        rawGoodsAddressToType[address(newGood)] = _type;
    }

    function sendGoodsForInspection(address _rawAddress) external onlyFarmer {
        RawGoods(_rawAddress).sendGoodsForInspection();
    }

    function getTotalRawContractsOfFarmmer(address _farmer) external view returns (address[] memory){
        return(farmerToRawContracts[_farmer]);
    }
}