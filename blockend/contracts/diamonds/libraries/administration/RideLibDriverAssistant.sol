//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

library RideLibDriverAssistant {
    bytes32 constant STORAGE_POSITION_DRIVERASSISTANT =
        keccak256("ds.driverassistant");

    struct StorageDriverAssistant {
        mapping(address => string) applicantToUri;
    }

    function _storageDriverAssistant()
        internal
        pure
        returns (StorageDriverAssistant storage s)
    {
        bytes32 position = STORAGE_POSITION_DRIVERASSISTANT;
        assembly {
            s.slot := position
        }
    }
}
