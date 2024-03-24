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

    // Deci, nu putem avea liste de liste
    // Asadar trebuie sa ieram fiecare element si sa il salvam in FE

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
        string composition;
    }

    struct ProductAddDTO {
        string name;
        uint256 productTypeId;
        uint256 manufacturingDate;
        uint256 expirationDate;
        bool isBatch;
        uint256 batchCount;
        string composition;
    }

    struct Product {
        string name;
        uint256 productTypeId;
        string barcodeId;
        string manufacturerName;
        address manufacturerId;
        uint256 manufacturingDate;
        uint256 expirationDate;
        bool isBatch;
        uint256 batchCount;
        string composition;
    }
}

// barcode
// EAN-13:
// 2 number system // region
// 5 manufacturer code // ~100k manufacurers
// 5 product code // ~100k products/manufacturer
//      * link manufacturer => productCodeCounter
// 1 check digit
