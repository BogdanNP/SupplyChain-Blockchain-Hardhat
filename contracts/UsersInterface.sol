// SPDX-License-Identifier: UNLICENSED

pragma experimental ABIEncoderV2;
pragma solidity >=0.7.3;

import "./Types.sol";

interface UsersInterface {
    function _addUser(
        Types.UserDetails memory user,
        address myAccount
    ) external;

    function get(
        address account
    ) external view returns (Types.UserDetails memory);

    function getManufacturerDetails(
        address account
    ) external view returns (Types.ManufacturerDetails memory);
}
