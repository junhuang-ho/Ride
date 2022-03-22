//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/RideExchange.sol";
import "../../../hub/libraries/core/RideLibExchange.sol";

contract RideTestExchange is RideExchange {
    function sXToYToXAddedPerYPriceFeed_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (address)
    {
        return
            RideLibExchange._storageExchange().xToYToXAddedPerYPriceFeed[_keyX][
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

    function sXToYToXPerYDerivedPriceFeedDetails_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (RideLibExchange.DerivedPriceFeedDetails memory)
    {
        return
            RideLibExchange
                ._storageExchange()
                .xToYToXPerYDerivedPriceFeedDetails[_keyX][_keyY];
    }

    function sXToYToXPerYInverseDerived_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (bool)
    {
        return
            RideLibExchange._storageExchange().xToYToXPerYInverseDerived[_keyX][
                _keyY
            ];
    }

    function sXToYToBaseKeyCount_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (uint256)
    {
        return
            RideLibExchange._storageExchange().xToYToBaseKeyCount[_keyX][_keyY];
    }

    function ssXToYToXPerYAddedPriceFeed_(
        bytes32 _keyX,
        bytes32 _keyY,
        address _priceFeed
    ) external {
        RideLibExchange._storageExchange().xToYToXAddedPerYPriceFeed[_keyX][
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

    function ssXToYToXPerYDerivedPriceFeedDetails_(
        bytes32 _keyX,
        bytes32 _keyY,
        bytes32 _keyShared,
        address _numerator,
        address _denominator,
        bool _numeratorInverse,
        bool _denominatorInverse
    ) external {
        RideLibExchange._storageExchange().xToYToXPerYDerivedPriceFeedDetails[
            _keyX
        ][_keyY] = RideLibExchange.DerivedPriceFeedDetails({
            keyShared: _keyShared,
            numerator: _numerator,
            denominator: _denominator,
            numeratorInverse: _numeratorInverse,
            denominatorInverse: _denominatorInverse
        });
    }

    function ssXToYToXPerYInverseDerived_(
        bytes32 _keyX,
        bytes32 _keyY,
        bool _inverse
    ) external {
        RideLibExchange._storageExchange().xToYToXPerYInverseDerived[_keyX][
                _keyY
            ] = _inverse;
    }

    function requireXPerYPriceFeedSupported_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (bool)
    {
        RideLibExchange._requireAddedXPerYPriceFeedSupported(_keyX, _keyY);
        return true;
    }

    function requireDerivedXPerYPriceFeedSupported_(
        bytes32 _keyX,
        bytes32 _keyY
    ) external view returns (bool) {
        RideLibExchange._requireDerivedXPerYPriceFeedSupported(_keyX, _keyY);
        return true;
    }

    function addXPerYPriceFeed_(
        bytes32 _keyX,
        bytes32 _keyY,
        address _priceFeed
    ) external {
        RideLibExchange._addXPerYPriceFeed(_keyX, _keyY, _priceFeed);
    }

    function deriveXPerYPriceFeed_(
        bytes32 _keyX,
        bytes32 _keyY,
        bytes32 _keyShared
    ) external {
        RideLibExchange._deriveXPerYPriceFeed(_keyX, _keyY, _keyShared);
    }

    function removeAddedXPerYPriceFeed_(bytes32 _keyX, bytes32 _keyY) external {
        RideLibExchange._removeAddedXPerYPriceFeed(_keyX, _keyY);
    }

    function removeDerivedXPerYPriceFeed_(bytes32 _keyX, bytes32 _keyY)
        external
    {
        RideLibExchange._removeDerivedXPerYPriceFeed(_keyX, _keyY);
    }

    function convertCurrency_(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX
    ) external view returns (uint256) {
        return RideLibExchange._convertCurrency(_keyX, _keyY, _amountX);
    }

    function convertDirect_(uint256 _xPerYWei, uint256 _amountX)
        external
        pure
        returns (uint256)
    {
        return RideLibExchange._convertDirect(_xPerYWei, _amountX);
    }

    function convertInverse_(uint256 _xPerYWei, uint256 _amountX)
        external
        pure
        returns (uint256)
    {
        return RideLibExchange._convertInverse(_xPerYWei, _amountX);
    }

    function getAddedXPerYInWei_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (uint256)
    {
        return RideLibExchange._getAddedXPerYInWei(_keyX, _keyY);
    }

    function getDerivedXPerYInWei_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (uint256)
    {
        return RideLibExchange._getDerivedXPerYInWei(_keyX, _keyY);
    }
}
