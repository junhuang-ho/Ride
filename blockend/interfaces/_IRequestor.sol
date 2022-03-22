//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

interface IRequestor {
    event RequestRunner(address indexed sender, bytes32 indexed jobId);

    function requestRunner(
        address _hive,
        address _package,
        bytes32 _locationPackage,
        bytes32 _locationDestination,
        bytes32 _keyLocal,
        bytes32 _keyTransact,
        uint256 _minutes,
        uint256 _metres
    ) external;
}
