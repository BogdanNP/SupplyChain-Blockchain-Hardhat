// SPDX-License-Identifier: UNLICENSED 

pragma experimental ABIEncoderV2;
pragma solidity >=0.7.3;

import "hardhat/console.sol";
import "./Products.sol";
import "./Users.sol";
import "./Types.sol";

contract SupplyChain is Users, Products {
    constructor(string memory name_, string memory email_) {
        Types.UserDetails memory mn_ = Types.UserDetails({
            role: Types.UserRole.Admin,
            id_: msg.sender,
            name: name_,
            email: email_ 
        });
        add(mn_);
    }

    function addParty(Types.UserDetails memory user_) public {
        addUser(user_, msg.sender);
    }

    function addProduct(Types.Product memory product_)
        public
        onlyManufacturer
    {
        addAProduct(product_, msg.sender);
    }
}