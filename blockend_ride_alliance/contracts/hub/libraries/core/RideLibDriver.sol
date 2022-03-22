//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/RideLibDriverDetails.sol";
import "../../libraries/core/RideLibTicket.sol";

library RideLibDriver {
    function _requireDrvMatchTixDrv(address _driver) internal view {
        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();
        require(
            _driver == s1.tixIdToTicket[s1.userToTixId[msg.sender]].driver,
            "RideLibDriver: Driver not match ticket driver"
        );
    }

    function _requireIsDriver() internal view {
        require(
            RideLibDriverDetails
                ._storageDriverDetails()
                .driverToDriverDetails[msg.sender]
                .id != 0,
            "RideLibDriver: Caller not driver"
        );
    }

    function _requireNotDriver() internal view {
        require(
            RideLibDriverDetails
                ._storageDriverDetails()
                .driverToDriverDetails[msg.sender]
                .id == 0,
            "RideLibDriver: Caller is driver"
        );
    }
}
