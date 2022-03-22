// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./Tester2Lib.sol";

library Tester1Lib {
    bytes32 constant STORAGE_POSITION_TESTER1LIB = keccak256("ds.tester1lib");

    struct StorageTester1Lib {
        uint256 value1;
    }

    function _storageTester1Lib()
        internal
        pure
        returns (StorageTester1Lib storage s)
    {
        bytes32 position = STORAGE_POSITION_TESTER1LIB;
        assembly {
            s.slot := position
        }
    }

    function calculate(uint256 _num1, uint256 _num2)
        internal
        returns (uint256)
    {
        return _num1 * Tester2Lib.plus(_num1, _num2);
    }
}
