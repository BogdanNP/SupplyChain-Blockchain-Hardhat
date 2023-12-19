// SPDX-License-Identifier: UNLICENSED

pragma experimental ABIEncoderV2;
pragma solidity >=0.7.3;

import "hardhat/console.sol";
import "./Types.sol";

contract Products {
    mapping(string => Types.ProductType) internal productTypes; // product type id => product type
    mapping(string => Types.Product) internal products; // barcodeId => product
    mapping(address => string[]) internal userLinkedProducts; // address => list of product barcodeIds
    mapping(address => uint256) internal productCounter;
    mapping(address => mapping(string => Types.Product))
        internal waitingProducts;
    // Events

    event NewProduct(
        string name,
        string manufacturerName,
        string barcodeId,
        uint256 manDateEpoch,
        uint256 expDateEpoch
    );

    event NewProductType(string name, string id);

    event ProductOwnershipTransferRequest(
        string name,
        string manufacurerName,
        string barcodeId,
        string buyerName,
        string buyerEmail,
        string sellerName,
        string sellerEmail,
        uint256 requestTime
    );

    event ProductOwnershipTransferResponse(
        string name,
        string manufacurerName,
        string barcodeId,
        string buyerName,
        string buyerEmail,
        string sellerName,
        string sellerEmail,
        uint256 responseTime,
        string status
    );

    // Contract Methods

    function _addProductType(
        Types.ProductType memory productType_
    ) internal productTypeIsValid(productType_.id) {
        productTypes[productType_.id] = productType_;
        emit NewProductType(productType_.name, productType_.id);
    }

    function _addProduct(
        Types.Product memory product_,
        address myAccount
    ) internal productIsValid(product_.barcodeId) {
        require(
            product_.manufacturerId == myAccount,
            "Only manufacturer can add products"
        );
        products[product_.barcodeId] = product_;
        productCounter[msg.sender]++;
        userLinkedProducts[msg.sender].push(product_.barcodeId);

        emit NewProduct(
            product_.name,
            product_.manufacturerName,
            product_.barcodeId,
            product_.manufacturingDate,
            product_.expirationDate
        );
    }

    function _createSellRequest(
        string memory barcodeId_,
        Types.UserDetails memory buyer_,
        Types.UserDetails memory seller_,
        uint256 currentTime_
    ) internal {
        Types.Product memory product_ = products[barcodeId_];
        // store sell request
        waitingProducts[buyer_.id][product_.barcodeId] = product_;
        emit ProductOwnershipTransferRequest(
            product_.name,
            product_.manufacturerName,
            product_.barcodeId,
            buyer_.name,
            buyer_.email,
            seller_.name,
            seller_.email,
            currentTime_
        );
    }

    function _acceptSellRequest(
        string memory barcodeId_,
        Types.UserDetails memory buyer_,
        Types.UserDetails memory seller_,
        uint256 currentTime_,
        bool acceptSell
    ) internal {
        Types.Product memory product_ = products[barcodeId_];
        delete waitingProducts[buyer_.id][product_.barcodeId];

        if (acceptSell) {
            transferOwnership(seller_.id, buyer_.id, barcodeId_);
        }
        emit ProductOwnershipTransferResponse(
            product_.name,
            product_.manufacturerName,
            product_.barcodeId,
            buyer_.name,
            buyer_.email,
            seller_.name,
            seller_.email,
            currentTime_,
            acceptSell ? "ACCEPTED" : "REJECTED"
        );
    }

    // function _sellProduct(
    //     address buyerId_,
    //     string memory barcodeId_,
    //     Types.UserDetails memory buyer_,
    //     uint256 currentTime_
    // ) internal {
    //     Types.Product memory product_ = products[barcodeId_];
    //     //creaza cerere
    //     //cumparatorul confirma/refuza cererea
    //     transferOwnership(msg.sender, buyerId_, barcodeId_);
    //     // emit ProductOwnershipTransfer(
    //     //     product_.name,
    //     //     product_.manufacturerName,
    //     //     product_.barcodeId,
    //     //     buyer_.name,
    //     //     buyer_.email,
    //     //     currentTime_
    //     // );
    // }

    // Modifiers

    modifier productTypeIsValid(string memory id_) {
        require(
            compareStrings(productTypes[id_].name, ""),
            "Product type already exists"
        );
        _;
    }

    modifier productIsValid(string memory barcodeId) {
        require(
            compareStrings(products[barcodeId].barcodeId, ""),
            "Product already exists"
        );
        _;
    }

    // Internal functions

    function transferOwnership(
        address sellerId_,
        address buyerId_,
        string memory barcodeId_
    ) internal {
        string[] memory sellerProducts_ = userLinkedProducts[sellerId_];
        uint256 matchIndex_ = (sellerProducts_.length + 1);
        for (uint256 i = 0; i < sellerProducts_.length; ++i) {
            if (compareStrings(sellerProducts_[i], barcodeId_)) {
                matchIndex_ = i;
                break;
            }
        }

        require(matchIndex_ < sellerProducts_.length, "Product not found");

        if (sellerProducts_.length == 1) {
            delete userLinkedProducts[sellerId_];
        } else {
            userLinkedProducts[sellerId_][matchIndex_] = userLinkedProducts[
                sellerId_
            ][sellerProducts_.length - 1];
            delete userLinkedProducts[sellerId_][sellerProducts_.length - 1];
            userLinkedProducts[sellerId_].pop();
        }
        userLinkedProducts[buyerId_].push(barcodeId_);
    }

    function compareStrings(
        string memory a,
        string memory b
    ) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }
}
