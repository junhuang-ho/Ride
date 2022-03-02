//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/RideLibRater.sol";

contract RideRater {
    /**
     * setRatingBounds sets bounds for rating
     *
     * @param _min | unitless integer
     * @param _max | unitless integer
     */
    function setRatingBounds(uint256 _min, uint256 _max) external {
        RideLibRater._setRatingBounds(_min, _max);
    }

    //////////////////////////////////////////////////////////////////////////////////
    ///// ---------------------------------------------------------------------- /////
    ///// -------------------------- getter functions -------------------------- /////
    ///// ---------------------------------------------------------------------- /////
    //////////////////////////////////////////////////////////////////////////////////

    function getRatingMin() external view returns (uint256) {
        return RideLibRater._storageRater().ratingMin;
    }

    function getRatingMax() external view returns (uint256) {
        return RideLibRater._storageRater().ratingMax;
    }
}
