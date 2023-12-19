// SPDX-License-Identifier: UNLICENSED

pragma experimental ABIEncoderV2;
pragma solidity >=0.7.3;

import "hardhat/console.sol";
import "./Products.sol";
import "./Users.sol";
import "./Types.sol";

contract SupplyChain is Users, Products {
    constructor(string memory name_, string memory email_) {
        Types.UserDetails memory admin_ = Types.UserDetails({
            role: Types.UserRole.Admin,
            id: msg.sender,
            name: name_,
            email: email_
        });
        add(admin_);
    }

    function addUser(Types.UserDetails memory user_) public {
        _addUser(user_, msg.sender);
    }

    function addProduct(Types.Product memory product_) public onlyManufacturer {
        _addProduct(product_, msg.sender);
    }

    function addProductType(
        Types.ProductType memory productType_
    ) public onlyManufacturer {
        _addProductType(productType_);
    }

    // function sellProduct(
    //     address buyerId_,
    //     string memory barcodeId_,
    //     uint256 currentTime_
    // ) public {
    //     Types.UserDetails memory user = users[buyerId_];
    //     _sellProduct(buyerId_, barcodeId_, user, currentTime_);
    // }

    function createSellRequest(
        address buyerId_,
        string memory barcodeId_,
        uint256 currentTime_
    ) public {
        Types.UserDetails memory buyer = users[buyerId_];
        Types.UserDetails memory seller = users[msg.sender];
        _createSellRequest(barcodeId_, buyer, seller, currentTime_);
    }

    function acceptSellRequest(
        address sellerId_,
        string memory barcodeId_,
        uint256 currentTime_,
        bool acceptSell
    ) public {
        Types.UserDetails memory buyer = users[msg.sender];
        Types.UserDetails memory seller = users[sellerId_];
        _acceptSellRequest(barcodeId_, buyer, seller, currentTime_, acceptSell);
    }
}
