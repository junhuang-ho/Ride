//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "./RideControl.sol";

/// @title Badge rank for drivers
contract RideBadge is RideControl {
    enum Badges {
        Newbie,
        Bronze,
        Silver,
        Gold,
        Platinum,
        Veteran
    }
    uint256 internal constant badgesCount = 6;

    mapping(uint256 => uint256) public badgeToBadgeMaxScore;

    /**
     * setBadgesMaxScores maps score to badge
     *
     * @param _badgesMaxScores Score that defines a specific badge rank
     */
    function setBadgesMaxScores(uint256[] memory _badgesMaxScores)
        public
        onlyOwner
    {
        require(
            _badgesMaxScores.length == badgesCount - 1,
            "_badgesMaxScores.length must be 1 less than Badges"
        );
        for (uint256 i = 0; i < _badgesMaxScores.length; i++) {
            badgeToBadgeMaxScore[i] = _badgesMaxScores[i];
        }
    }

    /**
     * _getBadge returns the badge rank for given score
     *
     * @param _score | unitless integer
     *
     * @return badge rank
     */
    function _getBadge(uint256 _score) internal view returns (uint256) {
        if (_score <= badgeToBadgeMaxScore[0]) {
            return uint256(Badges.Newbie);
        } else if (
            _score > badgeToBadgeMaxScore[0] &&
            _score <= badgeToBadgeMaxScore[1]
        ) {
            return uint256(Badges.Bronze);
        } else if (
            _score > badgeToBadgeMaxScore[1] &&
            _score <= badgeToBadgeMaxScore[2]
        ) {
            return uint256(Badges.Silver);
        } else if (
            _score > badgeToBadgeMaxScore[2] &&
            _score <= badgeToBadgeMaxScore[3]
        ) {
            return uint256(Badges.Gold);
        } else if (
            _score > badgeToBadgeMaxScore[3] &&
            _score <= badgeToBadgeMaxScore[4]
        ) {
            return uint256(Badges.Platinum);
        } else {
            return uint256(Badges.Veteran);
        }
    }
}
