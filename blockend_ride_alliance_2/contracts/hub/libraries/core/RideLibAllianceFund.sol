//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

library RideLibAllianceFund {
    bytes32 constant STORAGE_POSITION_ALLIANCEFUND =
        keccak256("ds.alliancefund");

    struct StorageAllianceFund {
        mapping(address => uint256) allianceToFunds;
        mapping(address => mapping(address => uint256)) driverToAllianceToContribution;
    }

    function _storageAllianceFund()
        internal
        pure
        returns (StorageAllianceFund storage s)
    {
        bytes32 position = STORAGE_POSITION_ALLIANCEFUND;
        assembly {
            s.slot := position
        }
    }
}
