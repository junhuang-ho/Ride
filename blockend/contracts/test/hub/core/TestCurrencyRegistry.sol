//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/CurrencyRegistry.sol";
import "../../../hub/libraries/core/LibCurrencyRegistry.sol";

contract TestCurrencyRegistry is CurrencyRegistry {
    function sCurrencyKeyToSupported_(bytes32 _key)
        external
        view
        returns (bool)
    {
        return
            LibCurrencyRegistry
                ._storageCurrencyRegistry()
                .currencyKeyToSupported[_key];
    }

    function sCurrencyKeyToCrypto_(bytes32 _key) external view returns (bool) {
        return
            LibCurrencyRegistry._storageCurrencyRegistry().currencyKeyToCrypto[
                _key
            ];
    }

    function ssCurrencyKeyToSupported_(bytes32 _key, bool _supported) external {
        LibCurrencyRegistry._storageCurrencyRegistry().currencyKeyToSupported[
                _key
            ] = _supported;
    }

    function ssCurrencyKeyToCrypto_(bytes32 _key, bool _crypto) external {
        LibCurrencyRegistry._storageCurrencyRegistry().currencyKeyToCrypto[
                _key
            ] = _crypto;
    }

    function requireCurrencySupported_(bytes32 _key)
        external
        view
        returns (bool)
    {
        LibCurrencyRegistry._requireCurrencySupported(_key);
        return true;
    }

    function requireIsCrypto_(bytes32 _key) external view returns (bool) {
        LibCurrencyRegistry._requireIsCrypto(_key);
        return true;
    }

    function setNativeToken_(address _token) external {
        LibCurrencyRegistry._setNativeToken(_token);
    }

    function registerFiat_(string memory _code) external returns (bytes32) {
        return LibCurrencyRegistry._registerFiat(_code);
    }

    function registerCrypto_(address _token) external returns (bytes32) {
        return LibCurrencyRegistry._registerCrypto(_token);
    }

    function register_(bytes32 _key) external {
        LibCurrencyRegistry._register(_key);
    }

    function encode_code_(string memory _code) external pure returns (bytes32) {
        return LibCurrencyRegistry._encode_code(_code);
    }

    function encode_token_(address _token) external pure returns (bytes32) {
        return LibCurrencyRegistry._encode_token(_token);
    }

    function removeCurrency_(bytes32 _key) external {
        LibCurrencyRegistry._removeCurrency(_key);
    }
}
