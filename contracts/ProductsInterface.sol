// SPDX-License-Identifier: UNLICENSED

pragma experimental ABIEncoderV2;
pragma solidity >=0.7.3;

import "./Types.sol";

interface ProductsInterface {
    function _addProductType(
        Types.ProductTypeAddDTO memory productType_,
        address myAccount
    ) external;

    function _addProduct(
        Types.ProductAddDTO memory product_,
        string memory manufacturerName,
        address myAccount
    ) external;

    function _createProduct(
        Types.Recepie memory recepie_,
        string memory productName,
        Types.UserDetails memory user
    ) external;
}
