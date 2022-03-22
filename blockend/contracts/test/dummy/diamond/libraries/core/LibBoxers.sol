// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

library LibBoxers {
    bytes32 constant STORAGE_POSITION_BOXERS = keccak256("ds.boxers");

    struct StorageBoxers {
        uint256 value1;
        uint256 value2;
    }

    function _storageBoxers() internal pure returns (StorageBoxers storage s) {
        bytes32 position = STORAGE_POSITION_BOXERS;
        assembly {
            s.slot := position
        }
    }

    event ValueChanged(uint256 newValue);

    function _store(uint256 newValue) internal {
        _storageBoxers().value1 = newValue;

        emit ValueChanged(newValue);
    }
}
