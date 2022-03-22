//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

library RideLibAllianceForger {
    bytes32 constant STORAGE_POSITION_ALLIANCEFORGER =
        keccak256("ds.allianceforger");

    struct StorageAllianceForger {
        uint256 count;
        mapping(bytes32 => address) allianceKeyToAlliance;
        mapping(bytes32 => address) allianceKeyToAllianceTimelock;
        mapping(bytes32 => address) allianceKeyToAllianceGovernor;
        address[] proposers; // empty
        address[] executors; // empty
    }

    function _storageAllianceForger()
        internal
        pure
        returns (StorageAllianceForger storage s)
    {
        bytes32 position = STORAGE_POSITION_ALLIANCEFORGER;
        assembly {
            s.slot := position
        }
    }
}
