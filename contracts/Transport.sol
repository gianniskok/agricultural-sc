//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./User.sol";
import "./RawGoods.sol";
import "./PackagedGoods.sol";

contract Transport is User {

    mapping(address => address[]) addressOfTrasnporterToAddOfRaw;
    mapping(address => address[]) addressOfTrasnporterToAddOfPack;

    function sendRawGoodsForShipmment(address _AddressRaw) external onlyTransporter {
        bool sent = RawGoods(_AddressRaw).sendGoodsForShipmment(msg.sender);
        addressOfTrasnporterToAddOfRaw[msg.sender].push(_AddressRaw);
        console.log(sent);
    }

    function deliverRawGoodsToPackager(address _addressRaw, address _packager) external onlyTransporter {
        require(msg.sender == RawGoods(_addressRaw).transporter(),"Not valid transporter");
        bool delivered = RawGoods(_addressRaw).deliverGoodsToPackager(_packager);
        console.log(delivered);
    }

    function sendPackGoodsForShipmment(address _AddressRaw) external onlyTransporter {
        bool sent = PackagedGoods(_AddressRaw).sendGoodsForShipmment(msg.sender);
        addressOfTrasnporterToAddOfPack[msg.sender].push(_AddressRaw);
        console.log(sent);
    }

    function deliverPackGoodsToStorage(address _addressRaw, address _storage) external onlyTransporter {
        require(msg.sender == PackagedGoods(_addressRaw).transporter(),"Not valid transporter");
        bool delivered = PackagedGoods(_addressRaw).deliverGoodsToStorage(_storage);
        console.log(delivered); 
    }


}