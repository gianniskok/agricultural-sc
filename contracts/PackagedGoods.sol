//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./RawGoods.sol";

contract PackagedGoods {
    address rawGoodsAddress;
    address storageAddress;
    address public transporter;
    address public inspector;
    address public packager;
    uint256 public packagesNo;
    uint256 grPerPackages;
    uint256 creationDate;
    uint256 expDate;
    uint256 pricePerPackage;
    string location;
    string packagesType;
    Stage packagesStages;

    mapping(uint256 => uint256) public firstToLastIndex;
    mapping(uint256 => bool) public indexToValid;
    struct Packages {
        uint256 id;
        address retailer;
        address transporter;
        AfterStage stage;
        bool sold;
    }

    Packages[] public package;
    mapping(uint256 => address) public indexToTransporter;

    enum Stage {
        packagesCreated,
        sentForInspection,
        rejectedByInspector,
        approvedByInspector,
        pickedForStorage,
        arrivedAtStorage
    } 

    enum AfterStage {
        waitingForTransporter,
        pickedForRetailer,
        arrivedAtretailer
    }

    constructor (
        address _rawGoodsAddress,
        uint256 _grPerPackage,
        address _packager
    ){
        require(grPerPackages > 0, "Not valid gr");
        rawGoodsAddress = _rawGoodsAddress;
        packager = _packager;
        storageAddress = address(0);
        transporter = address(0);
        inspector = address(0);
        grPerPackages = _grPerPackage;
        uint256 _quantity = RawGoods(rawGoodsAddress).quantityKg();
        packagesNo = (_quantity * 1000) / _grPerPackage;
        expDate = RawGoods(rawGoodsAddress).expirentionalDate();
        creationDate = block.timestamp;
        location = RawGoods(rawGoodsAddress).location();
        packagesType = RawGoods(rawGoodsAddress).goodsType();
        packagesStages = Stage(0);
        for(uint i= 0; i<packagesNo; i++){
            package.push(Packages(i, address(0), address(0), AfterStage(0), false));
        }
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

    function approvePackagesAtInspection(address _inspector) external notExpired returns (bool) {
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

    function setPackagesRetailer(uint256 _quantity, address _retailer, uint256 _index) external returns (bool) {
        require(packagesStages == Stage(5), "Not at Storage");
        for(uint i =_index; i<_index + _quantity; i++){
            require(package[i].stage == AfterStage(0), "Error");
            require(package[i].retailer == address(0), "Error2");
            package[i].retailer = _retailer;
        }
        firstToLastIndex[_index] = _quantity + _index;
        indexToValid[_index] = true;
        return true;
    }

    function sendToRetailer(address _transporter, uint256 _index) external returns (bool){
        require(indexToValid[_index], "Not valid");
        require(packagesStages == Stage(5), "Not at Storage");
        for(uint i =_index; i<firstToLastIndex[_index]; i++){
            require(package[i].stage == AfterStage(0), "Error");
            require(package[i].retailer != address(0), "Error2");
            package[i].transporter = _transporter;
            package[i].stage = AfterStage(1);
        }
        indexToTransporter[_index] = _transporter;
        return true;
    }

    function deliverToRetailer(uint256 _index) external returns (bool){
        require(indexToValid[_index], "Not valid");
        require(packagesStages == Stage(5), "Not at Storage");
        for(uint i =_index; i<firstToLastIndex[_index]; i++){
            require(package[i].stage == AfterStage(1), "Error");
            require(package[i].retailer != address(0), "Error2");
            require(package[i].transporter != address(0), "Error2");
            package[i].stage = AfterStage(2);
        }
        return true;
    }

    function returnPackagerInspectorTransporterStorage() external view returns (address, address, address, address){
        require(packagesStages == Stage(5), "Not finished delivery");
        return(packager, inspector, transporter, storageAddress);
    }
}
