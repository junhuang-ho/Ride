//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibTicket} from "../../libraries/core/RideLibTicket.sol";

import {IRideTicket} from "../../interfaces/core/IRideTicket.sol";

contract RideTicket is IRideTicket {
    function getAddressToTixId(address _address)
        external
        view
        override
        returns (bytes32)
    {
        return RideLibTicket._storageTicket().addressToTixId[_address];
    }

    function getTixIdToTicket(bytes32 _tixId)
        external
        view
        override
        returns (RideLibTicket.Ticket memory)
    {
        return RideLibTicket._storageTicket().tixIdToTicket[_tixId];
    }

    function getTixToDriverEnd(bytes32 _tixId)
        external
        view
        override
        returns (RideLibTicket.DriverEnd memory)
    {
        return RideLibTicket._storageTicket().tixToDriverEnd[_tixId];
    }
}
