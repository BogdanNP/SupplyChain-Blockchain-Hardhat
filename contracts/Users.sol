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
        console.log("add: HERE");
        usersCount++;
        users[user.id] = user;
        console.logInt(usersCount);
        emit NewUser(user.id, user.name, user.email, user.role);
    }

    function has(
        Types.UserRole role,
        address account
    ) internal view returns (bool) {
        require(account != address(0));
        return (users[account].id != address(0) && users[account].role == role);
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
        } else if (user.role == Types.UserRole.Manufacturer) {
            console.log("_addUser: Manufacturer");
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

    // Metamask error workaround
    // Error: Transaction reverted: function selector was not recognized and there's no fallback function
    /// @dev DON'T give me your money.
    // fallback() external {}
}
