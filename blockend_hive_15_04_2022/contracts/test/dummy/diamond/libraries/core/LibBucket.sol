// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

library LibBucket {
    bytes32 constant STORAGE_POSITION_BUCKET = keccak256("ds.bucket");

    struct StorageBucket {
        uint256 value1;
    }

    function _storageBucket() internal pure returns (StorageBucket storage s) {
        bytes32 position = STORAGE_POSITION_BUCKET;
        assembly {
            s.slot := position
        }
    }

    event StoreBucket(uint256 newValue);

    function _bucketIt(uint256 newValue) internal {
        _storageBucket().value1 = newValue;

        emit StoreBucket(newValue);
    }
}
