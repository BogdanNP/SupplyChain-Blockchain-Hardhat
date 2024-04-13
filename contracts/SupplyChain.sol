// SPDX-License-Identifier: UNLICENSED

pragma experimental ABIEncoderV2;
pragma solidity >=0.8.0;

import "hardhat/console.sol";
import "./Products.sol";
import "./UsersInterface.sol";
import "./ProductsInterface.sol";
import "./Types.sol";

contract SupplyChain {
    UsersInterface public users;
    ProductsInterface public products;

    constructor(address usersAddress, address productsAddress) {
        users = UsersInterface(usersAddress);
        products = ProductsInterface(productsAddress);
    }

    function addUser(Types.UserDetails memory user_) public {
        users._addUser(user_, msg.sender);
    }

    function getUser(
        address userAddress
    ) public view returns (Types.UserDetails memory user) {
        return users.get(userAddress);
    }

    function addProduct(
        Types.ProductAddDTO memory product_
    ) public onlyManufacturer {
        products._addProduct(product_, users.get(msg.sender).name, msg.sender);
    }

    function addProductType(
        Types.ProductTypeAddDTO memory productType_ // TODO: add a modifier, maybe onlyAdmin ?
    ) public {
        products._addProductType(productType_);
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
        uint256 currentTime_,
        uint256 quantity
    ) public {
        Types.UserDetails memory buyer = users.get(buyerId_);
        Types.UserDetails memory seller = users.get(msg.sender);
        products._createSellRequest(
            barcodeId_,
            buyer,
            seller,
            currentTime_,
            quantity
        );
    }

    function acceptSellRequest(
        address sellerId_,
        string memory barcodeId_,
        uint256 currentTime_,
        bool acceptSell
    ) public {
        Types.UserDetails memory buyer = users.get(msg.sender);
        Types.UserDetails memory seller = users.get(sellerId_);
        products._acceptSellRequest(
            barcodeId_,
            buyer,
            seller,
            currentTime_,
            acceptSell
        );
    }

    function createProduct(uint256 recepieId) public onlyManufacturer {
        Types.UserDetails memory user = users.get(msg.sender);
        products._createProduct(recepieId, user);
    }

    // Modifiers
    modifier onlyManufacturer() {
        require(msg.sender != address(0), "Sender's address is Empty");
        require(
            users.get(msg.sender).id != address(0),
            "User's address is Empty"
        );
        // TODO: restore this
        // require(
        //     Types.UserRole(users.get(msg.sender).role) ==
        //         Types.UserRole.Manufacturer,
        //     "Manufacturer role required"
        // );
        _;
    }
}
