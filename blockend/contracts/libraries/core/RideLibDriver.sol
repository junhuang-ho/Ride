//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibBadge} from "../../libraries/core/RideLibBadge.sol";
import {RideLibTicket} from "../../libraries/core/RideLibTicket.sol";

library RideLibDriver {
    function requireDrvMatchTixDrv(address _driver) internal view {
        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();
        require(
            _driver == s1.tixIdToTicket[s1.addressToTixId[msg.sender]].driver,
            "drv not match tix drv"
        );
    }

    function requireIsDriver() internal view {
        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();
        require(
            s1.addressToDriverReputation[msg.sender].id != 0,
            "caller not driver"
        );
    }

    function requireNotDriver() internal view {
        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();
        require(
            s1.addressToDriverReputation[msg.sender].id == 0,
            "caller is driver"
        );
    }
}
