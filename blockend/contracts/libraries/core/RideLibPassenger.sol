//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibTicket} from "../../libraries/core/RideLibTicket.sol";

library RideLibPassenger {
    function _requirePaxMatchTixPax() internal view {
        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();
        require(
            msg.sender ==
                s1.tixIdToTicket[s1.userToTixId[msg.sender]].passenger,
            "pax not match tix pax"
        );
    }

    function _requireTripNotStart() internal view {
        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();
        require(
            !s1.tixIdToTicket[s1.userToTixId[msg.sender]].tripStart,
            "trip already started"
        );
    }

    function _requireTripInProgress() internal view {
        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();
        require(
            s1.tixIdToTicket[s1.userToTixId[msg.sender]].tripStart,
            "trip not started"
        );
    }

    function _requireForceEndAllowed() internal view {
        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();
        require(
            block.timestamp >
                s1.tixIdToTicket[s1.userToTixId[msg.sender]].forceEndTimestamp,
            "too early"
        );
    }
}
