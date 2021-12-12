//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./RawGoods.sol";

contract PackagedGoods {
    address rawGoodsAddress;
    address storageAddress;
    address public transporter;
    address public inspector;
    address public packager;
    uint256 packagesNo;
    uint256 grPerPackages;
    uint256 creationDate;
    uint256 expDate;
    uint256 pricePerPackage;
    string location;
    string packagesType;
    Stage packagesStages;
    address[] retailers;

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
        creationDate = block.timestamp;
        location = RawGoods(rawGoodsAddress).location();
        packagesType = RawGoods(rawGoodsAddress).goodsType();
        packagesStages = Stage(0);
    }

    modifier notExpired {
        require(block.timestamp < expDate, "Good Expired");
        _;
    }

    function sendPackagesForInspection() external notExpired returns (bool) {
        require(packagesStages == Stage(0), "Wrong Stage");
        return updatePackagesStatus(1);
    }
    
    function rejectPackagesAtInspection(address _inspector) external returns (bool) {
        require(packagesStages == Stage(1), "Wrong Stage");
        inspector = _inspector;
        return updatePackagesStatus(2);
    }

    function approveGoodsAtInspection(address _inspector) external notExpired returns (bool) {
        require(packagesStages == Stage(1), "Wrong Stage");
        inspector = _inspector;
        return updatePackagesStatus(3);
    }

    function sendGoodsForShipmment(address _transporter) external notExpired returns (bool) {
        require(packagesStages == Stage(3), "Wrong Stage");
        transporter = _transporter;
        return updatePackagesStatus(4);
    }

    function deliverGoodsToStorage(address _storage) external notExpired returns (bool) {
        require(packagesStages == Stage(4), "Wrong Stage");
        storageAddress = _storage;
        return updatePackagesStatus(5);
    }

    function updatePackagesStatus(uint8 nextStage) private returns (bool) {
        packagesStages = Stage(nextStage);
        return true;
    }

    function returnPackagerInspectorTransporterStorage() external view returns (address, address, address, address){
        require(packagesStages == Stage(5), "Not finished delivery");
        return(packager, inspector, transporter, storageAddress);
    }
}
