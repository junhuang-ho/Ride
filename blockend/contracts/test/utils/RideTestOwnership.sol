//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideOwnership} from "../../facets/utils/RideOwnership.sol";
import {RideLibOwnership} from "../../libraries/utils/RideLibOwnership.sol";

contract RideTestOwnership is RideOwnership {
    function sContractOwner() external view returns (address) {
        return RideLibOwnership._storageOwnership().contractOwner;
    }

    function ssContractOwner(address _owner) external {
        RideLibOwnership._storageOwnership().contractOwner = _owner;
    }

    function requireIsContractOwner_() external view returns (bool) {
        RideLibOwnership._requireIsContractOwner();
        return true;
    }

    function setContractOwner_(address _newOwner) external {
        RideLibOwnership._setContractOwner(_newOwner);
    }

    function contractOwner_() external view returns (address) {
        return RideLibOwnership._contractOwner();
    }
}
