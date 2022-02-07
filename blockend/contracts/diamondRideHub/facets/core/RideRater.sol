//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibRater} from "../../libraries/core/RideLibRater.sol";

import {IRideRater} from "../../interfaces/core/IRideRater.sol";

contract RideRater is IRideRater {
    /**
     * setRatingBounds sets bounds for rating
     *
     * @param _min | unitless integer
     * @param _max | unitless integer
     */
    function setRatingBounds(uint256 _min, uint256 _max) external override {
        RideLibRater._setRatingBounds(_min, _max);
    }

    //////////////////////////////////////////////////////////////////////////////////
    ///// ---------------------------------------------------------------------- /////
    ///// -------------------------- getter functions -------------------------- /////
    ///// ---------------------------------------------------------------------- /////
    //////////////////////////////////////////////////////////////////////////////////

    function getRatingMin() external view override returns (uint256) {
        return RideLibRater._storageRater().ratingMin;
    }

    function getRatingMax() external view override returns (uint256) {
        return RideLibRater._storageRater().ratingMax;
    }
}
