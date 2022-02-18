//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../interfaces/core/IRideExchange.sol";
import "../../libraries/core/RideLibExchange.sol";

contract RideExchange is IRideExchange {
    function addXPerYPriceFeed(
        bytes32 _keyX,
        bytes32 _keyY,
        address _priceFeed
    ) external override {
        RideLibExchange._addXPerYPriceFeed(_keyX, _keyY, _priceFeed);
    }

    function deriveXPerYPriceFeed(
        bytes32 _keyX,
        bytes32 _keyY,
        bytes32 _keyShared
    ) external override {
        RideLibExchange._deriveXPerYPriceFeed(_keyX, _keyY, _keyShared);
    }

    function removeXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
        external
        override
    {
        RideLibExchange._removeXPerYPriceFeed(_keyX, _keyY);
    }

    function removeDerivedXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
        external
        override
    {
        RideLibExchange._removeDerivedXPerYPriceFeed(_keyX, _keyY);
    }

    function getXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
        external
        view
        override
        returns (address)
    {
        RideLibExchange._requireXPerYPriceFeedSupported(_keyX, _keyY);
        return
            RideLibExchange._storageExchange().xToYToXPerYPriceFeed[_keyX][
                _keyY
            ];
    }

    function getDerivedXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
        external
        view
        override
        returns (RideLibExchange.DerivedPriceFeedDetails memory)
    {
        RideLibExchange._requireDerivedXPerYPriceFeedSupported(_keyX, _keyY);
        return
            RideLibExchange
                ._storageExchange()
                .xToYToXPerYDerivedPriceFeedDetails[_keyX][_keyY];
    }

    // TODO: deriveXPerYPriceFeed

    function convertCurrency(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX
    ) external view override returns (uint256) {
        return RideLibExchange._convertCurrency(_keyX, _keyY, _amountX);
    }
}
