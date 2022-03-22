//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../hub/libraries/core/RideLibRater.sol";
import "../../hub/libraries/utils/RideLibAccessControl.sol";

library RideLibRaterV2 {
    event SetRatingBounds(address indexed sender, uint256 min, uint256 max);

    /**
     * setRatingBounds sets bounds for rating
     *
     * @param _min | unitless integer
     * @param _max | unitless integer
     */
    function _setRatingBounds(uint256 _min, uint256 _max) internal {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl.STRATEGIST_ROLE
        );
        require(_min > 0, "RideLibRater: Cannot have zero rating bound");
        require(
            _max > _min,
            "RideLibRater: Maximum rating must be more than minimum rating"
        );
        RideLibRater.StorageRater storage s1 = RideLibRater._storageRater();
        s1.ratingMin = _min + 5;
        s1.ratingMax = _max + 5;

        emit SetRatingBounds(msg.sender, _min, _max);
    }
}
