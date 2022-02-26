// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRideCurrencyRegistry {
    event CurrencyRegistered(address indexed sender, bytes32 key);

    function registerFiat(string memory _code) external returns (bytes32);

    function registerCrypto(address _token) external returns (bytes32);

    function getKeyFiat(string memory _code) external view returns (bytes32);

    function getKeyCrypto(address _token) external view returns (bytes32);

    event CurrencyRemoved(address indexed sender, bytes32 key);

    function removeCurrency(bytes32 _key) external;

    function setupFiatWithFee(
        string memory _code,
        uint256 _cancellationFee,
        uint256 _baseFee,
        uint256 _costPerMinute,
        uint256[] memory _costPerMetre
    ) external returns (bytes32);

    function setupCryptoWithFee(
        address _token,
        uint256 _cancellationFee,
        uint256 _baseFee,
        uint256 _costPerMinute,
        uint256[] memory _costPerMetre
    ) external returns (bytes32);
}
