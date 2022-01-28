// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {RideLibTicket} from "../../libraries/core/RideLibTicket.sol";

interface IRideTicket {
    event ForceEndDelaySet(address indexed sender, uint256 newDelayPeriod);

    function setForceEndDelay(uint256 _delayPeriod) external;

    function getUserToTixId(address _user) external view returns (bytes32);

    function getTixIdToTicket(bytes32 _tixId)
        external
        view
        returns (RideLibTicket.Ticket memory);

    function getTixToDriverEnd(bytes32 _tixId)
        external
        view
        returns (RideLibTicket.DriverEnd memory);

    function getForceEndDelay() external view returns (uint256);

    event TicketCleared(address indexed sender, bytes32 indexed tixId);
}
