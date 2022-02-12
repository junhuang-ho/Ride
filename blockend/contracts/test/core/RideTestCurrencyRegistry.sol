//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../diamondRideHub/facets/core/RideCurrencyRegistry.sol";
import "../../diamondRideHub/libraries/core/RideLibCurrencyRegistry.sol";

contract RideTestCurrencyRegistry is RideCurrencyRegistry {
    function sCurrencyKeyToSupported_(bytes32 _key)
        external
        view
        returns (bool)
    {
        return
            RideLibCurrencyRegistry
                ._storageCurrencyRegistry()
                .currencyKeyToSupported[_key];
    }

    function sCurrencyKeyToCrypto_(bytes32 _key) external view returns (bool) {
        return
            RideLibCurrencyRegistry
                ._storageCurrencyRegistry()
                .currencyKeyToCrypto[_key];
    }

    function ssCurrencyKeyToSupported_(bytes32 _key, bool _supported) external {
        RideLibCurrencyRegistry
            ._storageCurrencyRegistry()
            .currencyKeyToSupported[_key] = _supported;
    }

    function ssCurrencyKeyToCrypto_(bytes32 _key, bool _crypto) external {
        RideLibCurrencyRegistry._storageCurrencyRegistry().currencyKeyToCrypto[
                _key
            ] = _crypto;
    }

    function requireCurrencySupported_(bytes32 _key)
        external
        view
        returns (bool)
    {
        RideLibCurrencyRegistry._requireCurrencySupported(_key);
        return true;
    }

    function requireIsCrypto_(bytes32 _key) external view returns (bool) {
        RideLibCurrencyRegistry._requireIsCrypto(_key);
        return true;
    }

    function registerFiat_(string memory _code) external returns (bytes32) {
        return RideLibCurrencyRegistry._registerFiat(_code);
    }

    function registerCrypto_(address _token) external returns (bytes32) {
        return RideLibCurrencyRegistry._registerCrypto(_token);
    }

    function register_(bytes32 _key) external {
        RideLibCurrencyRegistry._register(_key);
    }

    function removeCurrency_(bytes32 _key) external {
        RideLibCurrencyRegistry._removeCurrency(_key);
    }
}
