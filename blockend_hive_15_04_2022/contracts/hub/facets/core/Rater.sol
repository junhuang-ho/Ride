//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibRater.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract Rater is IHubLibraryEvents {
    /**
     * setRatingBounds sets bounds for rating
     *
     * @param _min | unitless integer
     * @param _max | unitless integer
     */
    function setRatingBounds(uint256 _min, uint256 _max) external {
        LibRater._setRatingBounds(_min, _max);
    }

    function giveRating(bytes32 _jobId, uint256 _rating) external {
        LibRater._giveRating(_jobId, _rating);
    }

    function getRatingMin() external view returns (uint256) {
        return LibRater._storageRater().ratingMin;
    }

    function getRatingMax() external view returns (uint256) {
        return LibRater._storageRater().ratingMax;
    }
}
