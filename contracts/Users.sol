// SPDX-License-Identifier: UNLICENSED

pragma experimental ABIEncoderV2;
pragma solidity >=0.8.0;

import "hardhat/console.sol";
import "./Types.sol";

// TODO: create a method for signup / register
// Manufacturer: code, region,
// Supplier: just the role, buys products from Manufacturer in large quantity
// Vendor: just the role, buys products from Supplier and sells to Client users
// all users except Clients should be verified by the Admin (Authority)
// by default all addresses should have the role Client
contract Users {
    constructor(string memory name_, string memory email_) {
        Types.UserDetails memory admin_ = Types.UserDetails({
            role: Types.UserRole.Admin,
            id: msg.sender,
            name: name_,
            email: email_
        });
        add(admin_);
    }

    uint256 public usersCount;
    uint256 public manufacutersCount;
    uint256 public suppliersCount;
    uint256 public vendorsCount;
    uint256 public customersCount;
    mapping(address => Types.UserDetails) public users;
    mapping(uint256 => address) internal manufacturersList;
    mapping(uint256 => address) internal suppliersList;
    mapping(uint256 => address) internal vendorsList;
    mapping(uint256 => address) internal customersList;
    mapping(string => address) public usersByCIF;
    mapping(uint256 => address) public usersByIndex;
    mapping(address => Types.ManufacturerDetails) public manufacturerDetailList;

    event NewUser(address id, string name, string email, Types.UserRole role);

    function add(Types.UserDetails memory user) internal {
        require(user.id != address(0));
        require(!has(user.role, user.id), "Same user with same role exists");
        usersByIndex[usersCount] = user.id;
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

    function _linkByCIF(address id, string memory cif) public {
        usersByCIF[cif] = id;
    }

    function _register(
        Types.UserDetails memory user,
        address myAccount
    ) public {
        require(myAccount != address(0), "Your address is Empty");
        require(user.id != address(0), "User's address is Empty");
        require(
            myAccount == user.id,
            "User's address different from account address"
        );
        _addUserByRole(user);
    }

    function _addUser(Types.UserDetails memory user, address myAccount) public {
        console.log("My address: %s", myAccount);
        require(myAccount != address(0), "Your address is Empty");
        require(user.id != address(0), "User's address is Empty");
        console.log(
            "id: %s, name: %s, email: %s",
            user.id,
            user.name,
            user.email
        );
        if (get(myAccount).role != Types.UserRole.Admin) {
            revert("Only admin can add other users");
        }
        _addUserByRole(user);
    }

    function _addUserByRole(Types.UserDetails memory user) internal {
        if (user.role == Types.UserRole.Manufacturer) {
            console.log("_addUser: Manufacturer");
            // TODO: create a function for just adding man details
            manufacturerDetailList[user.id] = Types.ManufacturerDetails(
                manufacutersCount,
                usersCount
            );
            manufacturersList[manufacutersCount] = user.id;
            manufacutersCount++;
            add(user);
        } else if (user.role == Types.UserRole.Supplier) {
            suppliersList[suppliersCount] = user.id;
            suppliersCount++;
            add(user);
        } else if (user.role == Types.UserRole.Vendor) {
            vendorsList[vendorsCount] = user.id;
            vendorsCount++;
            add(user);
        } else if (user.role == Types.UserRole.Customer) {
            customersList[customersCount] = user.id;
            customersCount++;
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

    function getManufacturerDetails(
        address account
    ) public view returns (Types.ManufacturerDetails memory) {
        require(account != address(0), "Addres is empty");
        require(users[account].id != address(0), "User does not exist");
        return manufacturerDetailList[account];
    }

    // Metamask error workaround
    // Error: Transaction reverted: function selector was not recognized and there's no fallback function
    /// @dev DON'T give me your money.
    // fallback() external {}
}
