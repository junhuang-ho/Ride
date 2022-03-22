//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/Rater.sol";
import "../../../hub/libraries/core/LibRater.sol";

contract TestRater is Rater {
    function sRatingMin_() external view returns (uint256) {
        return LibRater._storageRater().ratingMin;
    }

    function sRatingMax_() external view returns (uint256) {
        return LibRater._storageRater().ratingMax;
    }

    function setRatingBounds_(uint256 _min, uint256 _max) external {
        LibRater._setRatingBounds(_min, _max);
    }

    function giveRating_(bytes32 _jobId, uint256 _rating) external {
        LibRater._giveRating(_jobId, _rating);
    }
}
