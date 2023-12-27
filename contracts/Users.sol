// SPDX-License-Identifier: UNLICENSED

pragma experimental ABIEncoderV2;
pragma solidity >=0.7.3;

import "hardhat/console.sol";
import "./Types.sol";

contract Users {
    int256 public usersCount;
    mapping(address => Types.UserDetails) public users;
    mapping(address => Types.UserDetails[]) internal manufacturersList;
    mapping(address => Types.UserDetails[]) internal suppliersList;
    mapping(address => Types.UserDetails[]) internal vendorsList;
    mapping(address => Types.UserDetails[]) internal customersList;

    event NewUser(address id, string name, string email, Types.UserRole role);

    function add(Types.UserDetails memory user) internal {
        require(user.id != address(0));
        require(!has(user.role, user.id), "Same user with same role exists");
        usersCount++;
        users[user.id] = user;
        emit NewUser(user.id, user.name, user.email, user.role);
    }

    function has(
        Types.UserRole role,
        address account
    ) internal view returns (bool) {
        require(account != address(0));
        return (users[account].id != address(0) && users[account].role == role);
    }

    function _addUser(
        Types.UserDetails memory user,
        address myAccount
    ) internal {
        require(myAccount != address(0), "Your address is Empty");
        require(user.id != address(0), "User's address is Empty");
        if (get(myAccount).role != Types.UserRole.Admin) {
            revert("Only admin can add other users");
        } else if (user.role == Types.UserRole.Manufacturer) {
            manufacturersList[myAccount].push(user);
            add(user);
        } else if (user.role == Types.UserRole.Supplier) {
            suppliersList[myAccount].push(user);
            add(user);
        } else if (user.role == Types.UserRole.Vendor) {
            vendorsList[myAccount].push(user);
            add(user);
        } else if (user.role == Types.UserRole.Customer) {
            customersList[myAccount].push(user);
            add(user);
        } else {
            revert("User's type is invalid");
        }
    }

    function get(
        address account
    ) public view returns (Types.UserDetails memory) {
        require(account != address(0), "Addres is empty");
        require(users[account].id != address(0), "User does not exist");
        return users[account];
    }

    modifier onlyManufacturer() {
        require(msg.sender != address(0), "Sender's address is Empty");
        require(users[msg.sender].id != address(0), "User's address is Empty");
        require(
            Types.UserRole(users[msg.sender].role) ==
                Types.UserRole.Manufacturer,
            "Manufacturer role required"
        );
        _;
    }
}
