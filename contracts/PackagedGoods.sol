//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./RawGoods.sol";

contract PackagedGoods {
    address rawGoodsAddress;
    address storageAddress;
    address transporter;
    address inspector;
    address packager;
    uint256 packagesNo;
    uint256 grPerPackages;
    uint256 expDate;
    uint256 pricePerPackage;
    string location;
    string packagesType;
    Stage packagesStages;


    enum Stage {
        packagesCreated,
        sentForInspection,
        rejectedByInspector,
        approvedByInspector,
        pickedForStorage,
        arrivedAtStorage
    } 

    constructor (
        address _rawGoodsAddress,
        uint256 _grPerPackage,
        uint256 _quantity,
        address _packager
    ){
        require(grPerPackages > 0, "Not valid gr");
        rawGoodsAddress = _rawGoodsAddress;
        packager = _packager;
        storageAddress = address(0);
        transporter = address(0);
        inspector = address(0);
        grPerPackages = _grPerPackage;
        packagesNo = (_quantity * 1000) / _grPerPackage;
        expDate = RawGoods(rawGoodsAddress).expirentionalDate();
        location = RawGoods(rawGoodsAddress).location();
        packagesType = RawGoods(rawGoodsAddress).goodsType();
        packagesStages = Stage(0);
    }

    modifier notExpired {
        require(block.timestamp < expDate, "Good Expired");
        _;
    }

}
