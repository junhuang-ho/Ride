// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRidePassenger {
    event RequestTicket(
        address indexed sender,
        bytes32 indexed tixId,
        uint256 baseFee,
        uint256 costPerMinute,
        uint256 costPerMetre,
        uint256 minutesTaken,
        uint256 metresTravelled
    );

    function requestTicket(
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

    event SetRatingBounds(address indexed sender, uint256 min, uint256 max);

    function setRatingBounds(uint256 _min, uint256 _max) external;

    function getRatingMin() external view returns (uint256);

    function getRatingMax() external view returns (uint256);
}
