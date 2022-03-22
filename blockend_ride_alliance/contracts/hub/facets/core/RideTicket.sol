//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/RideLibTicket.sol";

contract RideTicket {
    function setForceEndDelay(uint256 _delayPeriod) external {
        RideLibTicket._setForceEndDelay(_delayPeriod);
    }

    function getUserToTixId(address _user) external view returns (bytes32) {
        return RideLibTicket._storageTicket().userToTixId[_user];
    }

    function getTixIdToTicket(bytes32 _tixId)
        external
        view
        returns (RideLibTicket.Ticket memory)
    {
        return RideLibTicket._storageTicket().tixIdToTicket[_tixId];
    }

    function getTixIdToDriverEnd(bytes32 _tixId)
        external
        view
        returns (RideLibTicket.DriverEnd memory)
    {
        return RideLibTicket._storageTicket().tixIdToDriverEnd[_tixId];
    }

    function getForceEndDelay(address _alliance)
        external
        view
        returns (uint256)
    {
        return
            RideLibTicket._storageTicket().allianceToForceEndDelay[_alliance];
    }
}
