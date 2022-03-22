//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../hub/libraries/core/LibRater.sol";
import "../../hub/libraries/utils/LibAccessControl.sol";

library RideLibRaterV2 {
    event SetRatingBounds(address indexed sender, uint256 min, uint256 max);

    /**
     * setRatingBounds sets bounds for rating
     *
     * @param _min | unitless integer
     * @param _max | unitless integer
     */
    function _setRatingBounds(uint256 _min, uint256 _max) internal {
        LibAccessControl._requireOnlyRole(LibAccessControl.STRATEGIST_ROLE);
        require(_min > 0, "RideLibRater: Cannot have zero rating bound");
        require(
            _max > _min,
            "RideLibRater: Maximum rating must be more than minimum rating"
        );
        LibRater.StorageRater storage s1 = LibRater._storageRater();
        s1.ratingMin = _min + 5;
        s1.ratingMax = _max + 5;

        emit SetRatingBounds(msg.sender, _min, _max);
    }
}
