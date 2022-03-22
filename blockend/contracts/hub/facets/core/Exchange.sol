//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibExchange.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract Exchange is IHubLibraryEvents {
    function addXPerYPriceFeed(
        bytes32 _keyX,
        bytes32 _keyY,
        address _priceFeed
    ) external {
        LibExchange._addXPerYPriceFeed(_keyX, _keyY, _priceFeed);
    }

    function deriveXPerYPriceFeed(
        bytes32 _keyX,
        bytes32 _keyY,
        bytes32 _keyShared
    ) external {
        LibExchange._deriveXPerYPriceFeed(_keyX, _keyY, _keyShared);
    }

    function removeAddedXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY) external {
        LibExchange._removeAddedXPerYPriceFeed(_keyX, _keyY);
    }

    function removeDerivedXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
        external
    {
        LibExchange._removeDerivedXPerYPriceFeed(_keyX, _keyY);
    }

    function getAddedXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (address)
    {
        LibExchange._requireAddedXPerYPriceFeedSupported(_keyX, _keyY);
        return
            LibExchange._storageExchange().xToYToXAddedPerYPriceFeed[_keyX][
                _keyY
            ];
    }

    function getAddedXPerYPriceFeedValue(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (uint256)
    {
        LibExchange._requireAddedXPerYPriceFeedSupported(_keyX, _keyY);
        return LibExchange._getAddedXPerYInWei(_keyX, _keyY);
    }

    function getDerivedXPerYPriceFeedDetails(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (LibExchange.DerivedPriceFeedDetails memory)
    {
        LibExchange._requireDerivedXPerYPriceFeedSupported(_keyX, _keyY);
        return
            LibExchange._storageExchange().xToYToXPerYDerivedPriceFeedDetails[
                _keyX
            ][_keyY];
    }

    function getDerivedXPerYPriceFeedValue(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (uint256)
    {
        LibExchange._requireDerivedXPerYPriceFeedSupported(_keyX, _keyY);
        return LibExchange._getDerivedXPerYInWei(_keyX, _keyY);
    }

    function convertCurrency(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX
    ) external view returns (uint256) {
        return LibExchange._convertCurrency(_keyX, _keyY, _amountX);
    }
}
