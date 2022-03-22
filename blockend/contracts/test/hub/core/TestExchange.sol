//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/Exchange.sol";
import "../../../hub/libraries/core/LibExchange.sol";

contract TestExchange is Exchange {
    function sXToYToXAddedPerYPriceFeed_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (address)
    {
        return
            LibExchange._storageExchange().xToYToXAddedPerYPriceFeed[_keyX][
                _keyY
            ];
    }

    function sXToYToXPerYInverse_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (bool)
    {
        return LibExchange._storageExchange().xToYToXPerYInverse[_keyX][_keyY];
    }

    function sXToYToXPerYDerivedPriceFeedDetails_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (LibExchange.DerivedPriceFeedDetails memory)
    {
        return
            LibExchange._storageExchange().xToYToXPerYDerivedPriceFeedDetails[
                _keyX
            ][_keyY];
    }

    function sXToYToXPerYInverseDerived_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (bool)
    {
        return
            LibExchange._storageExchange().xToYToXPerYInverseDerived[_keyX][
                _keyY
            ];
    }

    function sXToYToBaseKeyCount_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (uint256)
    {
        return LibExchange._storageExchange().xToYToBaseKeyCount[_keyX][_keyY];
    }

    function ssXToYToXPerYAddedPriceFeed_(
        bytes32 _keyX,
        bytes32 _keyY,
        address _priceFeed
    ) external {
        LibExchange._storageExchange().xToYToXAddedPerYPriceFeed[_keyX][
                _keyY
            ] = _priceFeed;
    }

    function ssXToYToXPerYInverse_(
        bytes32 _keyX,
        bytes32 _keyY,
        bool _inverse
    ) external {
        LibExchange._storageExchange().xToYToXPerYInverse[_keyX][
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
        LibExchange._storageExchange().xToYToXPerYDerivedPriceFeedDetails[
            _keyX
        ][_keyY] = LibExchange.DerivedPriceFeedDetails({
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
        LibExchange._storageExchange().xToYToXPerYInverseDerived[_keyX][
                _keyY
            ] = _inverse;
    }

    function requireXPerYPriceFeedSupported_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (bool)
    {
        LibExchange._requireAddedXPerYPriceFeedSupported(_keyX, _keyY);
        return true;
    }

    function requireDerivedXPerYPriceFeedSupported_(
        bytes32 _keyX,
        bytes32 _keyY
    ) external view returns (bool) {
        LibExchange._requireDerivedXPerYPriceFeedSupported(_keyX, _keyY);
        return true;
    }

    function addXPerYPriceFeed_(
        bytes32 _keyX,
        bytes32 _keyY,
        address _priceFeed
    ) external {
        LibExchange._addXPerYPriceFeed(_keyX, _keyY, _priceFeed);
    }

    function deriveXPerYPriceFeed_(
        bytes32 _keyX,
        bytes32 _keyY,
        bytes32 _keyShared
    ) external {
        LibExchange._deriveXPerYPriceFeed(_keyX, _keyY, _keyShared);
    }

    function removeAddedXPerYPriceFeed_(bytes32 _keyX, bytes32 _keyY) external {
        LibExchange._removeAddedXPerYPriceFeed(_keyX, _keyY);
    }

    function removeDerivedXPerYPriceFeed_(bytes32 _keyX, bytes32 _keyY)
        external
    {
        LibExchange._removeDerivedXPerYPriceFeed(_keyX, _keyY);
    }

    function convertCurrency_(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX
    ) external view returns (uint256) {
        return LibExchange._convertCurrency(_keyX, _keyY, _amountX);
    }

    function convertDirect_(uint256 _xPerYWei, uint256 _amountX)
        external
        pure
        returns (uint256)
    {
        return LibExchange._convertDirect(_xPerYWei, _amountX);
    }

    function convertInverse_(uint256 _xPerYWei, uint256 _amountX)
        external
        pure
        returns (uint256)
    {
        return LibExchange._convertInverse(_xPerYWei, _amountX);
    }

    function getAddedXPerYInWei_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (uint256)
    {
        return LibExchange._getAddedXPerYInWei(_keyX, _keyY);
    }

    function getDerivedXPerYInWei_(bytes32 _keyX, bytes32 _keyY)
        external
        view
        returns (uint256)
    {
        return LibExchange._getDerivedXPerYInWei(_keyX, _keyY);
    }
}
