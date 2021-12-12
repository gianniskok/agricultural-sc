//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

import "./User.sol";
import "./RawGoods.sol";
import "./PackagedGoods.sol";

contract Packager is User {
    mapping(address => address[]) packagerToRawContracts;
    mapping(address => string) public packGoodsAddressToType;

    function createPackGoods(address _rawGoodsAdd, uint256 _grPerPack) external onlyPackager {
        address packager = msg.sender;
        PackagedGoods newGood = new PackagedGoods(_rawGoodsAdd, _grPerPack, packager);
        packagerToRawContracts[msg.sender].push(address(newGood));
        packGoodsAddressToType[address(newGood)] = RawGoods(_rawGoodsAdd).goodsType();
    }

    function sendPackForInspection(address _packAddress) external onlyPackager {
        PackagedGoods(_packAddress).sendPackagesForInspection();
    }

    function getTotalRawContractsOfPackager(address _packager) external view returns (address[] memory){
        return(packagerToRawContracts[_packager]);
    }
}