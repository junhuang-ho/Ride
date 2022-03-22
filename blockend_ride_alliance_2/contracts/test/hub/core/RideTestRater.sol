//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/RideRater.sol";
import "../../../hub/libraries/core/RideLibRater.sol";

contract RideTestRater is RideRater {
    function sRatingMin_() external view returns (uint256) {
        return RideLibRater._storageRater().ratingMin;
    }

    function sRatingMax_() external view returns (uint256) {
        return RideLibRater._storageRater().ratingMax;
    }

    function setRatingBounds_(uint256 _min, uint256 _max) external {
        RideLibRater._setRatingBounds(_min, _max);
    }

    function giveRating_(address _driver, uint256 _rating) external {
        RideLibRater._giveRating(_driver, _rating);
    }

    // getRatingMin() returns (uint256);
    // getRatingMax() returns (uint256);
}
