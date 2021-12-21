//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "../ride/RideUtils.sol";

contract TestRideUtils {
    function _getFare_(
        uint256 _baseFare,
        uint256 _metresTravelled,
        uint256 _minutesTaken,
        uint256 _costPerMetre,
        uint256 _costPerMinute
    ) public pure returns (uint256) {
        return
            RideUtils._getFare(
                _baseFare,
                _metresTravelled,
                _minutesTaken,
                _costPerMetre,
                _costPerMinute
            );
    }

    function _calculateScore_(
        uint256 _metresTravelled,
        uint256 _totalRating,
        uint256 _countStart,
        uint256 _countEnd
    ) public pure returns (uint256) {
        return
            RideUtils._calculateScore(
                _metresTravelled,
                _totalRating,
                _countStart,
                _countEnd
            );
    }
}
