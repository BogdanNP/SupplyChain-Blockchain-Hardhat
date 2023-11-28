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
        address id_;
        string name;
        string email;
    }

    struct Product{
        string name;
        string barcodeId;
        string manufacturerName;
        address manufacturer;
        uint256 manufacturingDate;
        uint256 expirationDate;
        string [] composition;
    }
}