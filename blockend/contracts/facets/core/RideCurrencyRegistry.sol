//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibCurrencyRegistry} from "../../libraries/core/RideLibCurrencyRegistry.sol";
import {RideLibFee} from "../../libraries/core/RideLibFee.sol";

import {IRideCurrencyRegistry} from "../../interfaces/core/IRideCurrencyRegistry.sol";

contract RideCurrencyRegistry is IRideCurrencyRegistry {
    function registerFiat(string memory _code)
        external
        override
        returns (bytes32)
    {
        return RideLibCurrencyRegistry._registerFiat(_code);
    }

    function registerCrypto(address _token)
        external
        override
        returns (bytes32)
    {
        return RideLibCurrencyRegistry._registerCrypto(_token);
    }

    function getKeyFiat(string memory _code)
        external
        view
        override
        returns (bytes32)
    {
        bytes32 key = keccak256(abi.encode(_code));
        RideLibCurrencyRegistry._requireCurrencySupported(key);
        return key;
    }

    function getKeyCrypto(address _token)
        external
        view
        override
        returns (bytes32)
    {
        bytes32 key = bytes32(uint256(uint160(_token)) << 96);
        RideLibCurrencyRegistry._requireCurrencySupported(key);
        return key;
    }

    function removeCurrency(bytes32 _key) external override {
        RideLibCurrencyRegistry._removeCurrency(_key);
    }

    function setupFiatWithFee(
        string memory _code,
        uint256 _cancellationFee,
        uint256 _baseFee,
        uint256 _costPerMinute,
        uint256[] memory _costPerMetre
    ) external override returns (bytes32) {
        bytes32 key = RideLibCurrencyRegistry._registerFiat(_code);
        RideLibFee._setCancellationFee(key, _cancellationFee);
        RideLibFee._setBaseFee(key, _baseFee);
        RideLibFee._setCostPerMinute(key, _costPerMinute);
        RideLibFee._setCostPerMetre(key, _costPerMetre);
        return key;
    }

    function setupCryptoWithFee(
        address _token,
        uint256 _cancellationFee,
        uint256 _baseFee,
        uint256 _costPerMinute,
        uint256[] memory _costPerMetre
    ) external override returns (bytes32) {
        bytes32 key = RideLibCurrencyRegistry._registerCrypto(_token);
        RideLibFee._setCancellationFee(key, _cancellationFee);
        RideLibFee._setBaseFee(key, _baseFee);
        RideLibFee._setCostPerMinute(key, _costPerMinute);
        RideLibFee._setCostPerMetre(key, _costPerMetre);
        return key;
    }
}
