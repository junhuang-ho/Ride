//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibOwnership} from "../../libraries/utils/RideLibOwnership.sol";
import {RideLibBadge} from "../../libraries/core/RideLibBadge.sol";
import {RideLibTicket} from "../../libraries/core/RideLibTicket.sol";

library RideLibPassenger {
    bytes32 constant STORAGE_POSITION_PASSENGER = keccak256("ds.passenger");

    struct StoragePassenger {
        uint256 ratingMin;
        uint256 ratingMax;
    }

    function _storagePassenger()
        internal
        pure
        returns (StoragePassenger storage s)
    {
        bytes32 position = STORAGE_POSITION_PASSENGER;
        assembly {
            s.slot := position
        }
    }

    function requirePaxMatchTixPax() internal view {
        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();
        require(
            msg.sender ==
                s1.tixIdToTicket[s1.addressToTixId[msg.sender]].passenger,
            "pax not match tix pax"
        );
    }

    function requireTripNotStart() internal view {
        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();
        require(
            !s1.tixIdToTicket[s1.addressToTixId[msg.sender]].tripStart,
            "trip already started"
        );
    }

    function requireTripInProgress() internal view {
        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();
        require(
            s1.tixIdToTicket[s1.addressToTixId[msg.sender]].tripStart,
            "trip not started"
        );
    }

    function requireForceEndAllowed() internal view {
        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();
        require(
            block.timestamp >
                s1
                    .tixIdToTicket[s1.addressToTixId[msg.sender]]
                    .forceEndTimestamp,
            "too early"
        );
    }

    /**
     * setRatingBounds sets bounds for rating
     *
     * @param _min | unitless integer
     * @param _max | unitless integer
     */
    function _setRatingBounds(uint256 _min, uint256 _max) internal {
        RideLibOwnership.requireIsContractOwner();
        StoragePassenger storage s1 = _storagePassenger();
        s1.ratingMin = _min;
        s1.ratingMax = _max;
    }

    /**
     * _giveRating
     *
     * @param _driver driver's address
     * @param _rating unitless integer between RATING_MIN and RATING_MAX
     *
     */
    function _giveRating(address _driver, uint256 _rating) internal {
        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();
        StoragePassenger storage s2 = _storagePassenger();

        require(s2.ratingMin > 0, "minimum rating must be more than zero");
        require(s2.ratingMax > 0, "maximum rating must be more than zero");
        require(
            _rating >= s2.ratingMin && _rating <= s2.ratingMax,
            "rating must be within min and max ratings (inclusive)"
        );

        s1.addressToDriverReputation[_driver].totalRating += _rating;
        s1.addressToDriverReputation[_driver].countRating += 1;
    }
}
