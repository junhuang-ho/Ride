//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

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

    event PriceFeedRemoved(address indexed sender, address priceFeed);

    function removeXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY) external;

    function getXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (address);

    function convertCurrency(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX
    ) external view;
}
