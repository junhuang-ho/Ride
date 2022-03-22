// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

library Tester2Lib {
    bytes32 constant STORAGE_POSITION_TESTER2LIB = keccak256("ds.tester2lib");

    struct StorageTester2Lib {
        uint256 value2;
    }

    function _storageTester2Lib()
        internal
        pure
        returns (StorageTester2Lib storage s)
    {
        bytes32 position = STORAGE_POSITION_TESTER2LIB;
        assembly {
            s.slot := position
        }
    }

    function plus(uint256 _num1, uint256 _num2) internal returns (uint256) {
        return _num1 + _num2 + _storageTester2Lib().value2;
    }
}
