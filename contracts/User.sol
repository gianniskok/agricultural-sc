//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract User {
    using Counters for Counters.Counter;
    Counters.Counter private _userId;

    address  payable private immutable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "#OWCA"); // only owner can access
        _;
    }

    modifier onlyAdmin {
        require(addressToUser[msg.sender].role == UserRole.Admin, "#OACA"); //Only admin can access this
        _;
    }

    modifier onlyFarmer {
        require(addressToUser[msg.sender].role == UserRole.Farm, "#OFCA"); //Only farmer can access this
        _;
    }

    modifier onlyStorage {
        require(addressToUser[msg.sender].role == UserRole.Storage, "#OSCA"); //Only storage worker can access this
        _;
    }

    modifier onlyTransporter {
        require(addressToUser[msg.sender].role == UserRole.Transport, "#OTCA"); //Only transporter can access this
        _;
    }

    modifier onlyInpector {
        require(addressToUser[msg.sender].role == UserRole.Inspector, "#OICA"); //Only inspector can access this
        _;
    }

    modifier onlyPackager {
        require(addressToUser[msg.sender].role == UserRole.Package, "#OPCA"); //Only packager can access this
        _;
    }

    modifier onlyRetailer {
        require(addressToUser[msg.sender].role == UserRole.Retail, "#ORCA"); //Only retailer can access this
        _;
    }

    enum UserRole {
        Farm,
        Transport,
        Storage,
        Inspector,
        Package,
        Retail,
        Admin
    }

    struct UserInfo {
        address userAddress;
        string userName;
        UserRole role;
        bool isActive;
        uint256 registrationDate;
        uint256 userId;
    }

    UserInfo[] public userInfo;

    mapping(address => UserInfo) public addressToUser;

    event adminRegistered(address indexed userAddress, string userName, uint256 userId);
    event userRegistered(address indexed userAddress, string userName, uint256 userId, UserRole role);
    event userDeactivated(address indexed userAddress);
    event userReactivated(address indexed userAddress);

    function registerAdmin(string memory _userName, address _userAddress) external onlyOwner {
        require(addressToUser[_userAddress].userAddress != _userAddress, "UAE"); //User already exists
        UserInfo memory newUser;
        _userId.increment();
        newUser.userName = _userName;
        newUser.userAddress = _userAddress;
        newUser.userId = _userId.current();
        newUser.isActive = true;
        newUser.role = UserRole.Admin;
        newUser.registrationDate = block.timestamp;
        addressToUser[_userAddress] = newUser;
        userInfo.push(newUser);
        emit adminRegistered(_userAddress, _userName, _userId.current());
    }

    function registerUser(string memory _userName, address _userAddress, uint256 _userRole) external onlyAdmin {
        require(addressToUser[_userAddress].userAddress != _userAddress, "UAE"); //User already exists
        UserInfo memory newUser;
        _userId.increment();
        newUser.userName = _userName;
        newUser.userAddress = _userAddress;
        newUser.userId = _userId.current();
        newUser.isActive = true;
        newUser.role = UserRole(_userRole);
        newUser.registrationDate = block.timestamp;
        addressToUser[_userAddress] = newUser;
        userInfo.push(newUser);
        emit userRegistered(_userAddress, _userName, _userId.current(), UserRole(_userRole));
    }

    function deActivateUser(address _userAddress) external onlyAdmin {
        require(addressToUser[_userAddress].userAddress == _userAddress, "UDE"); //User doesnt exist
        require(addressToUser[_userAddress].isActive == true, "UAD"); //User Already Deactivated
        addressToUser[_userAddress].isActive = false;
        userInfo[addressToUser[_userAddress].userId -1].isActive = false;
        emit userDeactivated(_userAddress);
    }

    function reActivateUser(address _userAddress) external onlyAdmin {
        require(addressToUser[_userAddress].userAddress == _userAddress, "UDE"); //User doesnt exist
        require(addressToUser[_userAddress].isActive == false, "UND"); //User Not Deactivated
        addressToUser[_userAddress].isActive = true;
        userInfo[addressToUser[_userAddress].userId -1].isActive = true;
        emit userReactivated(_userAddress);
    }
   
}
