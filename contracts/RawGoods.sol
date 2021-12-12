//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract RawGoods {
    uint256 public quantityKg;
    uint256 public pricePerKg;
    uint256 public expirentionalDate;
    address immutable owner;
    address public transporter;
    address public inspector;
    address public packager;
    string public goodsType;
    string public location;
    Stage goodsStage;

    enum Stage {
        gooodsCreated,
        sentForInspection,
        rejectedByInspector,
        approvedByInspector,
        pickedForPackager,
        arrivedAtPackager
    }

    constructor(
        uint256 _quantity,
        uint256 _price,
        uint256 _expDate,
        address _farmer,
        string memory _type,
        string memory _location
    ){
        quantityKg = _quantity;
        pricePerKg = _price;
        expirentionalDate = _expDate;
        owner = _farmer;
        goodsType = _type;
        goodsStage = Stage(0);
        location = _location;
        inspector = address(0);
        transporter = address(0);
    }

    modifier notExpired {
        require(block.timestamp < expirentionalDate, "Good Expired");
        _;
    }

    function sendGoodsForInspection() external notExpired returns (bool){
        require(goodsStage == Stage(0), "Wrong Stage");
        return updateGoodsStatus(1);
    }

    function rejectGoodsAtInspection(address _inspector) external returns (bool) {
        require(goodsStage == Stage(1), "Wrong Stage");
        inspector = _inspector;
        return updateGoodsStatus(2);
    }

    function approveGoodsAtInspection(address _inspector) external notExpired returns (bool) {
        require(goodsStage == Stage(1), "Wrong Stage");
        inspector = _inspector;
        return updateGoodsStatus(3);
    }

    function sendGoodsForShipmment(address _transporter) external notExpired returns (bool) {
        require(goodsStage == Stage(3), "Wrong Stage");
        transporter = _transporter;
        return updateGoodsStatus(4);
    }

    function deliverGoodsToPackager(address _packager) external notExpired returns (bool) {
        require(goodsStage == Stage(4), "Wrong Stage");
        packager = _packager;
        return updateGoodsStatus(5);
    }

    function updateGoodsStatus(uint8 nextStage) private returns (bool) {
        goodsStage = Stage(nextStage);
        return true;
    }

    function returnFarmerInspectorTransporterPackager() external view returns (address, address, address, address){
        require(goodsStage == Stage(5), "Not finished delivery");
        return(owner, inspector, transporter, packager);
    }







}
