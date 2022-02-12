//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../diamondRideHub/facets/utils/RideOwnership.sol";
import "../../diamondRideHub/libraries/utils/RideLibOwnership.sol";

contract RideTestOwnership is RideOwnership {
    function sOwner() external view returns (address) {
        return RideLibOwnership._storageOwnership().owner;
    }

    function ssOwner(address _owner) external {
        RideLibOwnership._storageOwnership().owner = _owner;
    }

    function requireIsOwner_() external view returns (bool) {
        RideLibOwnership._requireIsOwner();
        return true;
    }

    function setOwner_(address _newOwner) external {
        RideLibOwnership._setOwner(_newOwner);
    }

    function getOwner_() external view returns (address) {
        return RideLibOwnership._getOwner();
    }
}
