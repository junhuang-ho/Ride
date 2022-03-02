//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

library BoxLib {
    bytes32 constant STORAGE_POSITION_BOXLIB = keccak256("ds.boxlib");

    struct StorageBoxLib {
        uint256 value;
    }

    function _storageBoxLib() internal pure returns (StorageBoxLib storage s) {
        bytes32 position = STORAGE_POSITION_BOXLIB;
        assembly {
            s.slot := position
        }
    }
}
