//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Owner.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
contract User is Owner {
    using Counters for Counters.Counter;
    Counters.Counter private _userId;

    enum UserRole {
        Farmer,
        Transporter,
        Storage,
        Inspector,
        Packager,
        Retailer,
        Admin
    }

    struct UserDetails {
        string userName;
        address userAddress;
        uint256 userId;
        bool isActive;
        UserRole role;
        uint256 registrationDate;        
    }

    UserDetails[] public UserStruct;
    mapping(address => UserDetails) public addressToUser;

    modifier onlyAdmin {
        require(addressToUser[msg.sender].role == UserRole.Admin, "#OACA"); //Only admin can access this
        _;
    }

    event adminRegistered(address indexed userAddress);
    event userRegistered(address indexed userAddress);
    event userDeactivated(address indexed userAddress);

    function registerAdmin(string memory _userName, address _userAddress) external onlyOwner {
        require(addressToUser[_userAddress].userAddress != _userAddress, "UAE"); //User already exists
        UserDetails memory newUser;
        _userId.increment();
        newUser.userName = _userName;
        newUser.userAddress = _userAddress;
        newUser.userId = _userId.current();
        newUser.isActive = true;
        newUser.role = UserRole.Admin;
        newUser.registrationDate = block.timestamp;
        addressToUser[_userAddress] = newUser;
        UserStruct.push(newUser);
        emit adminRegistered(_userAddress);
    }

    function registerUser(string memory _userName, address _userAddress, uint256 _userRole) external onlyAdmin {
        require(addressToUser[_userAddress].userAddress != _userAddress, "UAE"); //User already exists
        UserDetails memory newUser;
        _userId.increment();
        newUser.userName = _userName;
        newUser.userAddress = _userAddress;
        newUser.userId = _userId.current();
        newUser.isActive = true;
        newUser.role = UserRole(_userRole);
        newUser.registrationDate = block.timestamp;
        addressToUser[_userAddress] = newUser;
        UserStruct.push(newUser);
        emit userRegistered(_userAddress);
    }

    function deActivateUser(address _userAddress) external onlyAdmin {
        require(addressToUser[_userAddress].userAddress == _userAddress, "UDE"); //User doesnt exist
        require(addressToUser[_userAddress].isActive == true, "UAD"); //User Already Deactivated
        addressToUser[_userAddress].isActive = false;
        UserStruct[addressToUser[_userAddress].userId -1].isActive = false;
        emit userDeactivated(_userAddress);
    }
   
}
