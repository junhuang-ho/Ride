// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRidePassenger {
    event RequestTicket(
        address indexed sender,
        bytes32 indexed tixId,
        uint256 minutesTaken,
        uint256 metresTravelled
    );

    function requestTicket(
        bytes32 _keyLocal,
        bytes32 _keyPay,
        uint256 _badge,
        bool _strict,
        uint256 _metres,
        uint256 _minutes
    ) external;

    event RequestCancelled(address indexed sender, bytes32 indexed tixId);

    function cancelRequest() external;

    event TripStarted(
        address indexed passenger,
        bytes32 indexed tixId,
        address driver
    );

    function startTrip(address _driver) external;

    event TripEndedPax(address indexed sender, bytes32 indexed tixId);

    function endTripPax(bool _agree, uint256 _rating) external;

    event ForceEndPax(address indexed sender, bytes32 indexed tixId);

    function forceEndPax() external;
}
