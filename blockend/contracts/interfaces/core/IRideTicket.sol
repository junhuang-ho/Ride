// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {RideLibTicket} from "../../libraries/core/RideLibTicket.sol";

interface IRideTicket {
    function getAddressToTixId(address _address)
        external
        view
        returns (bytes32);

    function getTixIdToTicket(bytes32 _tixId)
        external
        view
        returns (RideLibTicket.Ticket memory);

    function getTixToDriverEnd(bytes32 _tixId)
        external
        view
        returns (RideLibTicket.DriverEnd memory);

    event TicketCleared(address indexed sender, bytes32 indexed tixId);
}
