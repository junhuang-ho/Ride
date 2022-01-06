// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRideDriver {
    function registerAsDriver(uint256 _maxMetresPerTrip) external;

    function updateMaxMetresPerTrip(uint256 _maxMetresPerTrip) external;

    function acceptTicket(bytes32 _tixId, uint256 _useBadge) external;

    function cancelPickUp() external;

    function endTripDrv(bool _reached) external;

    function forceEndDrv() external;

    function passBackgroundCheck(address _driver, string memory _uri) external;
}
