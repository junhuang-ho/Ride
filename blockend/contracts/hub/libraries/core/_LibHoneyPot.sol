//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

library LibHoneyPot {
    bytes32 constant STORAGE_POSITION_HONEYPOT = keccak256("ds.honeypot");

    struct StorageHoneyPot {
        mapping(address => uint256) hiveToHoney;
        mapping(address => mapping(address => uint256)) runnerToHiveToContribution; // lifetime value
    }

    function _storageHoneyPot()
        internal
        pure
        returns (StorageHoneyPot storage s)
    {
        bytes32 position = STORAGE_POSITION_HONEYPOT;
        assembly {
            s.slot := position
        }
    }
}
