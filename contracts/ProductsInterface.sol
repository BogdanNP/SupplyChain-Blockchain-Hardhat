// SPDX-License-Identifier: UNLICENSED

pragma experimental ABIEncoderV2;
pragma solidity >=0.7.3;

import "./Types.sol";

interface ProductsInterface {
    function _addRecepieList(Types.Recepie[] memory recepieList) external;

    function _addRecepie(Types.Recepie memory recepie) external;

    function _addProductTypeList(
        Types.ProductTypeAddDTO[] memory productTypeList
    ) external;

    function _addProductType(
        Types.ProductTypeAddDTO memory productType
    ) external;

    function _addProduct(
        Types.ProductAddDTO memory product_,
        string memory manufacturerName,
        address myAccount
    ) external;

    function _createProduct(
        uint256 recepieId,
        Types.UserDetails memory user
    ) external;
}
