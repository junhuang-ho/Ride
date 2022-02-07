//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

import {RideDriverRegistry} from "../../diamondRideHub/facets/core/RideDriverRegistry.sol";
import {RideLibDriverRegistry} from "../../diamondRideHub/libraries/core/RideLibDriverRegistry.sol";

contract RideTestDriverRegistry is RideDriverRegistry {
    function s_driverIdCounter_()
        external
        view
        returns (Counters.Counter memory)
    {
        return RideLibDriverRegistry._storageDriverRegistry()._driverIdCounter;
    }

    function mint_() external returns (uint256) {
        return RideLibDriverRegistry._mint();
    }

    function burnFirstDriverId_() external {
        RideLibDriverRegistry._burnFirstDriverId();
    }
}
