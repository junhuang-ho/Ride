//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideBadge} from "../../facets/core/RideBadge.sol";
import {RideLibBadge} from "../../libraries/core/RideLibBadge.sol";

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
