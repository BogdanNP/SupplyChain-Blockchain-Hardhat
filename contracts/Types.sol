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
    }

    struct ProductType {
        string id;
        string name;
        string[] details;
    }

    // barcode
    // EAN-13:
    // 2 number system // region
    // 5 manufacturer code // ~100k manufacurers
    // 5 product code // ~100k products/manufacturer
    //      * link manufacturer => productCodeCounter
    // 1 check digit

    struct Product {
        string name;
        ProductType productType;
        string barcodeId;
        string manufacturerName;
        address manufacturerId;
        uint256 manufacturingDate;
        uint256 expirationDate;
        bool isBatch;
        uint256 batchCount;
        string[] composition;
    }

    struct Recepie {
        mapping(string => uint256) productQuantities; // product type id => quantity in kg
        ProductType result;
        uint256 quantityResult;
    }
}
