//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RidePassenger} from "../../facets/core/RidePassenger.sol";
import {RideLibPassenger} from "../../libraries/core/RideLibPassenger.sol";

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

    // function requestTicket(
    //     bytes32 _keyLocal,
    //     bytes32 _keyPay,
    //     uint256 _badge,
    //     bool _strict,
    //     uint256 _minutes,
    //     uint256 _metres
    // );
    // cancelRequest();
    // startTrip(address _driver);
    // endTripPax(bool _agree, uint256 _rating);
    // forceEndPax();
}
