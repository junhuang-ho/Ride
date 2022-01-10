// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRideDriver {
    event RegisteredAsDriver(address indexed sender);

    function registerAsDriver(uint256 _maxMetresPerTrip) external;

    event MaxMetresUpdated(address indexed sender, uint256 metres);

    function updateMaxMetresPerTrip(uint256 _maxMetresPerTrip) external;

    event AcceptedTicket(address indexed sender, bytes32 indexed tixId);

    function acceptTicket(bytes32 _tixId, uint256 _useBadge) external;

    event DriverCancelled(address indexed sender, bytes32 indexed tixId);

    function cancelPickUp() external;

    event TripEndedDrv(
        address indexed sender,
        bytes32 indexed tixId,
        bool reached
    );

    function endTripDrv(bool _reached) external;

    event ForceEndDrv(address indexed sender, bytes32 indexed tixId);

    function forceEndDrv() external;

    event ApplicantApproved(address indexed applicant);

    function passBackgroundCheck(address _driver, string memory _uri) external;
}
