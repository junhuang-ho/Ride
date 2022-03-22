//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibCurrencyRegistry.sol";
import "../../libraries/core/LibFee.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract CurrencyRegistry is IHubLibraryEvents {
    function setNativeToken(address _token) external {
        LibCurrencyRegistry._setNativeToken(_token);
    }

    function getNativeToken() external view returns (address) {
        return LibCurrencyRegistry._storageCurrencyRegistry().nativeToken;
    }

    function registerFiat(string memory _code) external returns (bytes32) {
        return LibCurrencyRegistry._registerFiat(_code);
    }

    function registerCrypto(address _token) external returns (bytes32) {
        return LibCurrencyRegistry._registerCrypto(_token);
    }

    //
    // note:
    // these getter functions needs _requireCurrencySupported check
    // as without it, these getters would return a key but it won't
    // be clear if this key is supported or not
    //

    function getKeyFiat(string memory _code) external view returns (bytes32) {
        bytes32 key = LibCurrencyRegistry._encode_code(_code);
        LibCurrencyRegistry._requireCurrencySupported(key);
        return key;
    }

    function getKeyCrypto(address _token) external view returns (bytes32) {
        bytes32 key = LibCurrencyRegistry._encode_token(_token);
        LibCurrencyRegistry._requireCurrencySupported(key);
        return key;
    }

    function removeCurrency(bytes32 _key) external {
        LibCurrencyRegistry._removeCurrency(_key);
    }
}
