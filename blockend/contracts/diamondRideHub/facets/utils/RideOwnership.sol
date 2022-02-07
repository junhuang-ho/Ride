// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {RideLibOwnership} from "../../libraries/utils/RideLibOwnership.sol";
import {IERC173} from "../../interfaces/utils/IERC173.sol";

contract RideOwnership is IERC173 {
    function transferOwnership(address _newOwner) external override {
        RideLibOwnership._requireIsContractOwner();
        RideLibOwnership._setContractOwner(_newOwner);
    }

    function owner() external view override returns (address) {
        return RideLibOwnership._contractOwner();
    }
}
