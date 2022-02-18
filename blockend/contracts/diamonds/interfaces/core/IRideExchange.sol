//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/RideLibExchange.sol";

interface IRideExchange {
    event PriceFeedAdded(
        address indexed sender,
        bytes32 keyX,
        bytes32 keyY,
        address priceFeed
    );

    function addXPerYPriceFeed(
        bytes32 _keyX,
        bytes32 _keyY,
        address _priceFeed
    ) external;

    event PriceFeedDerived(
        address indexed sender,
        bytes32 keyX,
        bytes32 keyY,
        bytes32 keyShared
    );

    function deriveXPerYPriceFeed(
        bytes32 _keyX,
        bytes32 _keyY,
        bytes32 _keyShared
    ) external;

    event PriceFeedRemoved(
        address indexed sender,
        address priceFeed,
        bytes32[] derivedPriceFeedKeyXs,
        bytes32[] derivedPriceFeedKeyYs
    );

    function removeXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY) external;

    event DerivedPriceFeedRemoved(
        address indexed sender,
        bytes32 keyX,
        bytes32 keyY
    );

    function removeDerivedXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY) external;

    function getXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (address);

    function getDerivedXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (RideLibExchange.DerivedPriceFeedDetails memory);

    function convertCurrency(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX
    ) external view returns (uint256);
}
