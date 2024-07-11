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

    struct ManufacturerDetails {
        uint256 code;
        uint256 region;
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

    struct RecipeIngredient {
        uint256 recipeId;
        uint256 productTypeId;
        uint256 productQuantity;
    }

    struct Recipe {
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
        uint256 batchCount;
    }

    struct Product {
        string name;
        uint256 productTypeId;
        string barcodeId;
        string manufacturerName;
        address manufacturerId;
        uint256 manufacturingDate;
        uint256 expirationDate;
        uint256 recipeId;
        uint256 ingredientsCount;
    }

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
