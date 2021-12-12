//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./User.sol";
import "./RawGoods.sol";
import "./PackagedGoods.sol";

contract Inspect is User {
    mapping(address => address[]) addOfInspectorToRawGoodsAdd;
    mapping(address => address[]) addOfInspectorToPackGoodsAdd;

    function approoveRawGoodsAtInspection(address _rawAddress) external onlyInspector {
        bool approoved = RawGoods(_rawAddress).approveGoodsAtInspection(msg.sender);
        console.log(approoved);
        addOfInspectorToRawGoodsAdd[msg.sender].push(_rawAddress);
    }

    function rejectRawGoodsAtInspection(address _rawAddress) external onlyInspector {
        bool rejected = RawGoods(_rawAddress).rejectGoodsAtInspection(msg.sender);
        console.log(rejected);
        addOfInspectorToRawGoodsAdd[msg.sender].push(_rawAddress);
    }

    function approovePackGoodsAtInspection(address _packAddress) external onlyInspector {
        bool approoved = PackagedGoods(_packAddress).approvePackagesAtInspection(msg.sender);
        console.log(approoved);
        addOfInspectorToPackGoodsAdd[msg.sender].push(_packAddress);
    }

    function rejectPackGoodsAtInspection(address _packAddress) external onlyInspector {
        bool rejected = PackagedGoods(_packAddress).rejectPackagesAtInspection(msg.sender);
        console.log(rejected);
        addOfInspectorToPackGoodsAdd[msg.sender].push(_packAddress); 
    }

    function getTotalRawContractsOfInspector(address _inspector) external view returns (address[] memory){
        return(addOfInspectorToRawGoodsAdd[_inspector]);
    }

    function getTotalPackContractsOfInspector(address _inspector) external view returns (address[] memory){
        return(addOfInspectorToPackGoodsAdd[_inspector]);
    }
}
