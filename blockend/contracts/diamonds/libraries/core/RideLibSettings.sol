//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/utils/RideLibOwnership.sol";

library RideLibSettings {
    bytes32 constant STORAGE_POSITION_SETTINGS = keccak256("ds.settings");

    struct StorageSettings {
        address administration;
    }

    function _storageSettings()
        internal
        pure
        returns (StorageSettings storage s)
    {
        bytes32 position = STORAGE_POSITION_SETTINGS;
        assembly {
            s.slot := position
        }
    }

    function _setAdministrationAddress(address _administration) internal {
        RideLibOwnership._requireIsOwner();
        _storageSettings().administration = _administration;
    }
}
