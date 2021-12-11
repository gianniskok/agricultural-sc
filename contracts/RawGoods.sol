//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract RawGoods {
    uint256 public quantityKg;
    uint256 public pricePerKg;
    uint256 public expirentionalDate;
    address immutable owner;
    address immutable goodsId;
    address transporter;
    address inspector;
    address packager;
    string goodsType;
    string location;
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
        goodsId = address(this);
        goodsType = _type;
        goodsStage = Stage(0);
        location = _location;
    }

    modifier notExpired {
        require(block.timestamp < expirentionalDate, "Good Expired");
        _;
    }

    function sendGoodsForInspection() external notExpired returns (bool){
        require(goodsStage == Stage(0), "Wrong Stage");
        return updateGoodsStatus(1);
    }

    function rejectGoodsAtInspection() external returns (bool) {
        require(goodsStage == Stage(1), "Wrong Stage");
        return updateGoodsStatus(2);
    }

    function approveGoodsAtInspection() external returns (bool) {
        require(goodsStage == Stage(1), "Wrong Stage");
        return updateGoodsStatus(3);
    }

    function sendGoodsForShipmment() external returns (bool) {
        require(goodsStage == Stage(3), "Wrong Stage");
        return updateGoodsStatus(4);
    }

    function deliverGoodsToPackager() external returns (bool) {
        require(goodsStage == Stage(4), "Wrong Stage");
        return updateGoodsStatus(5);
    }

    function updateGoodsStatus(uint8 nextStage) private returns (bool) {
        goodsStage = Stage(nextStage);
        return true;
    }







}
