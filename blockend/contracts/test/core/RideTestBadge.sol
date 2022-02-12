//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../diamondRideHub/facets/core/RideBadge.sol";
import "../../diamondRideHub/libraries/core/RideLibBadge.sol";

contract RideTestBadge is RideBadge {
    function sBadgeToBadgeMaxScore_(uint256 _badge)
        external
        view
        returns (uint256)
    {
        return RideLibBadge._storageBadge().badgeToBadgeMaxScore[_badge];
    }

    function sDriverToDriverReputation_(address _driver)
        external
        view
        returns (RideLibBadge.DriverReputation memory)
    {
        return RideLibBadge._storageBadge().driverToDriverReputation[_driver];
    }

    function ssDriverToDriverReputation_(
        address _driver,
        uint256 _id,
        string memory _uri,
        uint256 _maxMetresPerTrip,
        uint256 _metresTravelled,
        uint256 _countStart,
        uint256 _countEnd,
        uint256 _totalRating,
        uint256 _countRating
    ) external {
        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();
        s1.driverToDriverReputation[_driver].id = _id;
        s1.driverToDriverReputation[_driver].uri = _uri;
        s1
            .driverToDriverReputation[_driver]
            .maxMetresPerTrip = _maxMetresPerTrip;
        s1.driverToDriverReputation[_driver].metresTravelled = _metresTravelled;
        s1.driverToDriverReputation[_driver].countStart = _countStart;
        s1.driverToDriverReputation[_driver].countEnd = _countEnd;
        s1.driverToDriverReputation[_driver].totalRating = _totalRating;
        s1.driverToDriverReputation[_driver].countRating = _countRating;
    }

    function setBadgesMaxScores_(uint256[] memory _badgesMaxScores) external {
        RideLibBadge._setBadgesMaxScores(_badgesMaxScores);
    }

    function getBadgesCount_() external pure returns (uint256) {
        return RideLibBadge._getBadgesCount();
    }

    function getBadge_(uint256 _score) external view returns (uint256) {
        return RideLibBadge._getBadge(_score);
    }

    function calculateScore_() external view returns (uint256) {
        return RideLibBadge._calculateScore();
    }
}
