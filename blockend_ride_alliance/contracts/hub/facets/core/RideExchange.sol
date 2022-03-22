//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/RideLibExchange.sol";

contract RideExchange {
    function addXPerYPriceFeed(
        bytes32 _keyX,
        bytes32 _keyY,
        address _priceFeed
    ) external {
        RideLibExchange._addXPerYPriceFeed(_keyX, _keyY, _priceFeed);
    }

    function deriveXPerYPriceFeed(
        bytes32 _keyX,
        bytes32 _keyY,
        bytes32 _keyShared
    ) external {
        RideLibExchange._deriveXPerYPriceFeed(_keyX, _keyY, _keyShared);
    }

    function removeAddedXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY) external {
        RideLibExchange._removeAddedXPerYPriceFeed(_keyX, _keyY);
    }

    function removeDerivedXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
        external
    {
        RideLibExchange._removeDerivedXPerYPriceFeed(_keyX, _keyY);
    }

    function getAddedXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (address)
    {
        RideLibExchange._requireAddedXPerYPriceFeedSupported(_keyX, _keyY);
        return
            RideLibExchange._storageExchange().xToYToXAddedPerYPriceFeed[_keyX][
                _keyY
            ];
    }

    function getAddedXPerYPriceFeedValue(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (uint256)
    {
        RideLibExchange._requireAddedXPerYPriceFeedSupported(_keyX, _keyY);
        return RideLibExchange._getAddedXPerYInWei(_keyX, _keyY);
    }

    function getDerivedXPerYPriceFeedDetails(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (RideLibExchange.DerivedPriceFeedDetails memory)
    {
        RideLibExchange._requireDerivedXPerYPriceFeedSupported(_keyX, _keyY);
        return
            RideLibExchange
                ._storageExchange()
                .xToYToXPerYDerivedPriceFeedDetails[_keyX][_keyY];
    }

    function getDerivedXPerYPriceFeedValue(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (uint256)
    {
        RideLibExchange._requireDerivedXPerYPriceFeedSupported(_keyX, _keyY);
        return RideLibExchange._getDerivedXPerYInWei(_keyX, _keyY);
    }

    function convertCurrency(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX
    ) external view returns (uint256) {
        return RideLibExchange._convertCurrency(_keyX, _keyY, _amountX);
    }
}
