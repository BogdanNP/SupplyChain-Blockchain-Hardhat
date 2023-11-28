// SPDX-License-Identifier: UNLICENSED 

pragma experimental ABIEncoderV2;
pragma solidity >=0.7.3;

import "hardhat/console.sol";
import "./Types.sol";

contract Products {
    Types.Product[] internal products;
    mapping(string => Types.Product) internal product;
    mapping(address => string[]) internal userLinkedProducts;

event NewProduct(
        string name,
        string manufacturerName,
        string barcodeId,
        uint256 manDateEpoch,
        uint256 expDateEpoch
    );

    function addAProduct(Types.Product memory product_, address myAccount)
        internal
        productNotExists(product_.barcodeId)
    {
        require(
            product_.manufacturer == myAccount,
            "Only manufacturer can add products"
        );
        products.push(product_);
        product[product_.barcodeId] = product_;
        
        emit NewProduct(
            product_.name,
            product_.manufacturerName,
            product_.barcodeId,
            product_.manufacturingDate,
            product_.expirationDate
        );
    }

    modifier productNotExists(string memory id_) {
        require(compareStrings(product[id_].barcodeId, ""), "Product already exists");
        _;
    }

    function compareStrings(string memory a, string memory b)
        internal
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }
}