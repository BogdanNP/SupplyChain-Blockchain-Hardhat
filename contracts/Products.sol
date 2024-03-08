// SPDX-License-Identifier: UNLICENSED

pragma experimental ABIEncoderV2;
pragma solidity >=0.7.3;

import "hardhat/console.sol";
import "./Types.sol";

contract Products {
    constructor() {}

    mapping(uint256 => Types.ProductType) internal productTypes; // product type id => product type
    mapping(string => Types.Product) public products; // barcodeId => product
    mapping(address => string[]) public userLinkedProducts; // address => list of product barcodeIds
    mapping(address => uint256) public productCounter;
    mapping(address => uint256) public productTypeCounter;
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

    event NewProductType(address manufacturerId, string name, uint256 id);

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
        Types.ProductTypeAddDTO memory productType_,
        address myAccount
    ) public {
        productCounter[myAccount]++;
        productTypes[productTypeCounter[myAccount]] = Types.ProductType(
            productTypeCounter[myAccount],
            productType_.name,
            productType_.details
        );
        emit NewProductType(
            myAccount,
            productType_.name,
            productTypeCounter[myAccount]
        );
    }

    function _addProduct(
        Types.ProductAddDTO memory product_,
        string memory manufacturerName,
        address myAccount
    ) public {
        // require(
        //     product_.manufacturerId == myAccount,
        //     "Only manufacturer can add products"
        // );
        string memory barcodeId = "AAA";
        Types.Product memory product = Types.Product(
            product_.name,
            product_.productTypeId,
            barcodeId,
            manufacturerName,
            myAccount,
            product_.manufacturingDate,
            product_.expirationDate,
            product_.isBatch,
            product_.batchCount,
            product_.composition
        );
        products[barcodeId] = product;
        productCounter[msg.sender]++;
        userLinkedProducts[msg.sender].push(barcodeId);

        emit NewProduct(
            product.name,
            product.manufacturerName,
            product.barcodeId,
            product.manufacturingDate,
            product.expirationDate
        );
    }

    function _createProduct(
        Types.Recepie memory recepie_,
        string memory productName,
        Types.UserDetails memory user
    ) public {
        // iterate through required products by the recepie
        for (uint i = 0; i < recepie_.productQuantities.length; ++i) {
            // iterate through user linked products
            for (uint j = 0; j < userLinkedProducts[user.id].length; ++j) {
                // check if user product is in the recepie
                if (
                    recepie_.productQuantities[i].productTypeId ==
                    products[userLinkedProducts[user.id][j]].productTypeId
                ) {
                    // check if the quantity is enough for the recepie
                    require(
                        recepie_.productQuantities[i].quantity <=
                            products[userLinkedProducts[user.id][j]].batchCount,
                        "Recepie requires user to have more quantity of some product"
                    );

                    // update the quantity of used products
                    products[userLinkedProducts[user.id][j]]
                        .batchCount -= recepie_.productQuantities[i].quantity;

                    // check if the quantity is 0 and delete the products
                    if (
                        products[userLinkedProducts[user.id][j]].batchCount == 0
                    ) {
                        // TODO: check this
                        delete products[userLinkedProducts[user.id][j]];
                        delete userLinkedProducts[user.id][j];
                    }
                }
            }
        }

        // create the new product
        Types.Product memory product_ = Types.Product(
            productName,
            recepie_.resultTypeId,
            toString(productCounter[user.id]), //TODO: generate barcode id
            user.name,
            user.id,
            (block.timestamp / 100) * 100,
            (block.timestamp / 100) * 100 + 86400, //TODO: 86400=1day in timestamp
            true,
            recepie_.quantityResult,
            recepie_.composition
        );

        // register the product in the products list
        products[product_.barcodeId] = product_;

        // increase the productCounter
        productCounter[msg.sender]++;

        // link the product to the user
        userLinkedProducts[msg.sender].push(product_.barcodeId);

        // toString(userLinkedProducts[user.id].length),
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
        uint256 currentTime_,
        uint256 quantity_
    ) public {
        Types.Product memory product_ = products[barcodeId_];
        require(product_.batchCount > quantity_, "Unavailable quantity");
        product_.batchCount = quantity_;
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
    ) public {
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

    modifier productTypeIsValid(uint256 id_) {
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
    ) public {
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

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }

        uint256 temp = value;
        uint256 digits;

        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits);

        while (value != 0) {
            digits--;
            buffer[digits] = bytes1(uint8(48 + (value % 10)));
            value /= 10;
        }

        return string(buffer);
    }
}
