//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "./RideLibRaterV2.sol";

contract RideRaterV2 {
    function setRatingBoundsV2(uint256 _min, uint256 _max) external {
        RideLibRaterV2._setRatingBounds(_min, _max);
    }
}
