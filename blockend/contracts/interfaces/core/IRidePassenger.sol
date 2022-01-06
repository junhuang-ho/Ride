// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRidePassenger {
    function requestTicket(
        uint256 _badge,
        bool _strict,
        uint256 _metres,
        uint256 _minutes
    ) external;

    function cancelRequest() external;

    function startTrip(address _driver) external;

    function endTripPax(bool _agree, uint256 _rating) external;

    function forceEndPax() external;

    function setRatingBounds(uint256 _min, uint256 _max) external;

    function getRatingMin() external view returns (uint256);

    function getRatingMax() external view returns (uint256);
}
