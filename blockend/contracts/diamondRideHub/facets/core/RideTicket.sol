//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../interfaces/core/IRideTicket.sol";
import "../../libraries/core/RideLibTicket.sol";

contract RideTicket is IRideTicket {
    function setForceEndDelay(uint256 _delayPeriod) external override {
        RideLibTicket._setForceEndDelay(_delayPeriod);
    }

    function getUserToTixId(address _user)
        external
        view
        override
        returns (bytes32)
    {
        return RideLibTicket._storageTicket().userToTixId[_user];
    }

    function getTixIdToTicket(bytes32 _tixId)
        external
        view
        override
        returns (RideLibTicket.Ticket memory)
    {
        return RideLibTicket._storageTicket().tixIdToTicket[_tixId];
    }

    function getTixIdToDriverEnd(bytes32 _tixId)
        external
        view
        override
        returns (RideLibTicket.DriverEnd memory)
    {
        return RideLibTicket._storageTicket().tixIdToDriverEnd[_tixId];
    }

    function getForceEndDelay() external view override returns (uint256) {
        return RideLibTicket._storageTicket().forceEndDelay;
    }
}
