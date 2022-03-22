//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/RideLibCurrencyRegistry.sol";
import "../../libraries/core/RideLibFee.sol";

contract RideCurrencyRegistry {
    function registerFiat(string memory _code) external returns (bytes32) {
        return RideLibCurrencyRegistry._registerFiat(_code);
    }

    function registerCrypto(address _token) external returns (bytes32) {
        return RideLibCurrencyRegistry._registerCrypto(_token);
    }

    //
    // note:
    // these getter functions needs _requireCurrencySupported check
    // as without it, these getters would return a key but it won't
    // be clear if this key is supported or not
    //

    function getKeyFiat(string memory _code) external view returns (bytes32) {
        bytes32 key = RideLibCurrencyRegistry._encode_code(_code);
        RideLibCurrencyRegistry._requireCurrencySupported(key);
        return key;
    }

    function getKeyCrypto(address _token) external view returns (bytes32) {
        bytes32 key = RideLibCurrencyRegistry._encode_token(_token);
        RideLibCurrencyRegistry._requireCurrencySupported(key);
        return key;
    }

    function removeCurrency(bytes32 _key) external {
        RideLibCurrencyRegistry._removeCurrency(_key);
    }

    // function setupFiatWithFee(
    //     string memory _code,
    //     uint256 _cancellationFee,
    //     uint256 _baseFee,
    //     uint256 _costPerMinute,
    //     uint256 _costPerMetre
    // ) external returns (bytes32) {
    //     bytes32 key = RideLibCurrencyRegistry._registerFiat(_code);
    //     RideLibFee._setCancellationFee(key, _cancellationFee);
    //     RideLibFee._setBaseFee(key, _baseFee);
    //     RideLibFee._setCostPerMinute(key, _costPerMinute);
    //     RideLibFee._setCostPerMetre(key, _costPerMetre);
    //     return key;
    // }

    // function setupCryptoWithFee(
    //     address _token,
    //     uint256 _cancellationFee,
    //     uint256 _baseFee,
    //     uint256 _costPerMinute,
    //     uint256 _costPerMetre
    // ) external returns (bytes32) {
    //     bytes32 key = RideLibCurrencyRegistry._registerCrypto(_token);
    //     RideLibFee._setCancellationFee(key, _cancellationFee);
    //     RideLibFee._setBaseFee(key, _baseFee);
    //     RideLibFee._setCostPerMinute(key, _costPerMinute);
    //     RideLibFee._setCostPerMetre(key, _costPerMetre);
    //     return key;
    // }
}
