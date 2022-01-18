//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibExchange} from "../../libraries/core/RideLibExchange.sol";

import {IRideExchange} from "../../interfaces/core/IRideExchange.sol";

contract RideExchange is IRideExchange {
    function addXPerYPriceFeed(
        bytes32 _keyX,
        bytes32 _keyY,
        address _priceFeed
    ) external override {
        RideLibExchange._addXPerYPriceFeed(_keyX, _keyY, _priceFeed);
    }

    function removeXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
        external
        override
    {
        RideLibExchange._removeXPerYPriceFeed(_keyX, _keyY);
    }

    function getXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
        external
        view
        override
        returns (address)
    {
        return RideLibExchange._getXPerYPriceFeed(_keyX, _keyY);
    }

    function convertCurrency(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX
    ) external view override {
        RideLibExchange._convertCurrency(_keyX, _keyY, _amountX);
    }
}
