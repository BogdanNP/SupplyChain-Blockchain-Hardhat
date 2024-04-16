// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.3;

library Types {
    enum UserRole {
        Admin,
        Manufacturer,
        Supplier,
        Vendor,
        Customer
    }

    struct UserDetails {
        UserRole role;
        address id;
        string name;
        string email;
        // TODO: add this
        // string cf;
    }

    struct ProductTypeAddDTO {
        string name;
        string details;
    }

    struct ProductType {
        uint256 id;
        string name;
        string details;
    }

    struct RecepieIngredient {
        uint256 recepieId;
        uint256 productTypeId;
        uint256 productQuantity;
    }

    struct Recepie {
        uint256 id;
        uint256 resultTypeId;
        string resultTypeName;
        uint256 ingredientsCount;
        uint256 quantityResult;
    }

    struct ProductAddDTO {
        uint256 productTypeId;
        uint256 manufacturingDate;
        uint256 expirationDate;
        bool isBatch;
        // maybe keep this? IDK
        uint256 batchCount;
    }

    // each product should be unique
    struct Product {
        string name;
        uint256 productTypeId;
        string barcodeId;
        string manufacturerName;
        address manufacturerId;
        uint256 manufacturingDate;
        uint256 expirationDate;
        uint256 recepieId;
        uint256 ingredientsCount;
    }

    // we create this
    // userLinkedProducts: user id -> list of stock item
    // we need 2 counters because a user can have bought
    // stock items or created stock items, so for productCreation
    // we need a separate counter
    // QUESTION: should a stock item be unique?
    // what if i buy 3 items and then buy other 3 with the same barcodeId?
    // ANSWER: i think that in that case we can just increase the quantity,
    // so each stockItem is unique
    // LETS'S IMPLEMENT THIS!!!
    struct StockItem {
        string barcodeId;
        uint256 quantity;
    }

    enum ObjectStatus {
        Pending,
        Accepted,
        Refused
    }

    struct Transfer {
        uint256 id;
        address sender;
        address receiver;
        string barcodeId;
        uint256 quantity;
        ObjectStatus status;
    }
}

// barcode
// EAN-13:
// 2 number system // region
// 5 manufacturer code // ~100k manufacurers
// 5 product code // ~100k products/manufacturer
//      * link manufacturer => productCodeCounter
// 1 check digit
