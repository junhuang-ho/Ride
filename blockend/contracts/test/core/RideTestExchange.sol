//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideExchange} from "../../diamondRideHub/facets/core/RideExchange.sol";
import {RideLibExchange} from "../../diamondRideHub/libraries/core/RideLibExchange.sol";

contract RideTestExchange is RideExchange {
    function sXToYToXPerYPriceFeed_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (address)
    {
        return
            RideLibExchange._storageExchange().xToYToXPerYPriceFeed[_keyX][
                _keyY
            ];
    }

    function sXToYToXPerYInverse_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (bool)
    {
        return
            RideLibExchange._storageExchange().xToYToXPerYInverse[_keyX][_keyY];
    }

    function ssXToYToXPerYPriceFeed_(
        bytes32 _keyX,
        bytes32 _keyY,
        address _priceFeed
    ) external {
        RideLibExchange._storageExchange().xToYToXPerYPriceFeed[_keyX][
                _keyY
            ] = _priceFeed;
    }

    function ssXToYToXPerYInverse_(
        bytes32 _keyX,
        bytes32 _keyY,
        bool _inverse
    ) external {
        RideLibExchange._storageExchange().xToYToXPerYInverse[_keyX][
                _keyY
            ] = _inverse;
    }

    function requireXPerYPriceFeedSupported_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (bool)
    {
        RideLibExchange._requireXPerYPriceFeedSupported(_keyX, _keyY);
        return true;
    }

    function addXPerYPriceFeed_(
        bytes32 _keyX,
        bytes32 _keyY,
        address _priceFeed
    ) external {
        RideLibExchange._addXPerYPriceFeed(_keyX, _keyY, _priceFeed);
    }

    function removeXPerYPriceFeed_(bytes32 _keyX, bytes32 _keyY) external {
        RideLibExchange._removeXPerYPriceFeed(_keyX, _keyY);
    }

    function convertCurrency_(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX
    ) external view returns (uint256) {
        return RideLibExchange._convertCurrency(_keyX, _keyY, _amountX);
    }

    function convertDirect_(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX
    ) external view returns (uint256) {
        return RideLibExchange._convertDirect(_keyX, _keyY, _amountX);
    }

    function convertInverse_(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX
    ) external view returns (uint256) {
        return RideLibExchange._convertInverse(_keyX, _keyY, _amountX);
    }

    function getXPerYInWei_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (uint256)
    {
        return RideLibExchange._getXPerYInWei(_keyX, _keyY);
    }
}
