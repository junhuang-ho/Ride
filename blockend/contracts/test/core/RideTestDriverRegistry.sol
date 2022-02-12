//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../diamondRideHub/facets/core/RideDriverRegistry.sol";
import "../../diamondRideHub/libraries/core/RideLibDriverRegistry.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

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
