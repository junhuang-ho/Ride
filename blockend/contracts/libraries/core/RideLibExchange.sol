//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import {RideLibOwnership} from "../../libraries/utils/RideLibOwnership.sol";
import {RideLibCurrencyRegistry} from "../../libraries/core/RideLibCurrencyRegistry.sol";

library RideLibExchange {
    bytes32 constant STORAGE_POSITION_EXCHANGE = keccak256("ds.exchange");

    struct StorageExchange {
        mapping(bytes32 => mapping(bytes32 => address)) xToYToXPerYPriceFeed;
        mapping(bytes32 => mapping(bytes32 => bool)) xToYToXPerYInverse;
    }

    function _storageExchange()
        internal
        pure
        returns (StorageExchange storage s)
    {
        bytes32 position = STORAGE_POSITION_EXCHANGE;
        assembly {
            s.slot := position
        }
    }

    function _requireXPerYPriceFeedSupported(bytes32 _keyX, bytes32 _keyY)
        internal
        view
    {
        require(
            _storageExchange().xToYToXPerYPriceFeed[_keyX][_keyY] != address(0),
            "price feed not supported"
        );
    }

    event PriceFeedAdded(
        address indexed sender,
        bytes32 keyX,
        bytes32 keyY,
        address priceFeed
    );

    // NOTE: to add ETH/USD price feed (displayed on chainlink), x = USD, y = ETH
    function _addXPerYPriceFeed(
        bytes32 _keyX,
        bytes32 _keyY,
        address _priceFeed
    ) internal {
        RideLibOwnership._requireIsContractOwner();
        RideLibCurrencyRegistry._requireCurrencySupported(_keyX);
        RideLibCurrencyRegistry._requireCurrencySupported(_keyY);

        require(_priceFeed != address(0), "zero price feed address");
        StorageExchange storage s1 = _storageExchange();
        require(
            s1.xToYToXPerYPriceFeed[_keyX][_keyY] == address(0),
            "price feed already supported"
        );
        s1.xToYToXPerYPriceFeed[_keyX][_keyY] = _priceFeed;
        s1.xToYToXPerYPriceFeed[_keyY][_keyX] = _priceFeed; // reverse pairing
        s1.xToYToXPerYInverse[_keyY][_keyX] = true;

        emit PriceFeedAdded(msg.sender, _keyX, _keyY, _priceFeed);
    }

    event PriceFeedRemoved(address indexed sender, address priceFeed);

    function _removeXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY) internal {
        RideLibOwnership._requireIsContractOwner();
        _requireXPerYPriceFeedSupported(_keyX, _keyY);

        StorageExchange storage s1 = _storageExchange();
        address priceFeed = s1.xToYToXPerYPriceFeed[_keyX][_keyY];
        delete s1.xToYToXPerYPriceFeed[_keyX][_keyY];
        delete s1.xToYToXPerYPriceFeed[_keyY][_keyX]; // reverse pairing
        delete s1.xToYToXPerYInverse[_keyY][_keyX];

        // require(
        //     s1.xToYToXPerYPriceFeed[_keyX][_keyY] == address(0),
        //     "price feed not removed 1"
        // );
        // require(
        //     s1.xToYToXPerYPriceFeed[_keyY][_keyX] == address(0),
        //     "price feed not removed 2"
        // ); // reverse pairing
        // require(!s1.xToYToXPerYInverse[_keyY][_keyX], "reverse not removed");

        emit PriceFeedRemoved(msg.sender, priceFeed);
    }

    // function _getXPerYPriceFeed(bytes32 _keyX, bytes32 _keyY)
    //     internal
    //     view
    //     returns (address)
    // {
    //     _requireXPerYPriceFeedSupported(_keyX, _keyY);
    //     return _storageExchange().xToYToXPerYPriceFeed[_keyX][_keyY];
    // }

    function _convertCurrency(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX
    ) internal view returns (uint256) {
        if (_storageExchange().xToYToXPerYInverse[_keyX][_keyY]) {
            return _convertInverse(_keyX, _keyY, _amountX);
        } else {
            return _convertDirect(_keyX, _keyY, _amountX);
        }
    }

    function _convertDirect(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX
    ) internal view returns (uint256) {
        uint256 xPerYWei = _getXPerYInWei(_keyX, _keyY);
        return ((_amountX * 10**18) / xPerYWei); // note: no rounding occurs as value is converted into wei
    }

    function _convertInverse(
        bytes32 _keyX,
        bytes32 _keyY,
        uint256 _amountX
    ) internal view returns (uint256) {
        uint256 xPerYWei = _getXPerYInWei(_keyX, _keyY);
        return (_amountX * xPerYWei) / 10**18; // note: no rounding occurs as value is converted into wei
    }

    function _getXPerYInWei(bytes32 _keyX, bytes32 _keyY)
        internal
        view
        returns (uint256)
    {
        _requireXPerYPriceFeedSupported(_keyX, _keyY);
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            _storageExchange().xToYToXPerYPriceFeed[_keyX][_keyY]
        );
        (, int256 xPerY, , , ) = priceFeed.latestRoundData();
        uint256 decimals = priceFeed.decimals();
        return uint256(uint256(xPerY) * 10**(18 - decimals)); // convert to wei
    }
}
