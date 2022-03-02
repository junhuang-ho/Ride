//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../diamonds/facets/core/RidePassenger.sol";
import "../../diamonds/libraries/core/RideLibPassenger.sol";

contract RideTestPassenger is RidePassenger {
    function requirePaxMatchTixPax_() external view returns (bool) {
        RideLibPassenger._requirePaxMatchTixPax();
        return true;
    }

    function requireTripNotStart_() external view returns (bool) {
        RideLibPassenger._requireTripNotStart();
        return true;
    }

    function requireTripInProgress_() external view returns (bool) {
        RideLibPassenger._requireTripInProgress();
        return true;
    }

    function requireForceEndAllowed_() external view returns (bool) {
        RideLibPassenger._requireForceEndAllowed();
        return true;
    }
}
