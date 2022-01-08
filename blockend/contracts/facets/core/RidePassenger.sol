//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibBadge} from "../../libraries/core/RideLibBadge.sol";
import {RideLibFee} from "../../libraries/core/RideLibFee.sol";
import {RideLibPenalty} from "../../libraries/core/RideLibPenalty.sol";
import {RideLibTicket} from "../../libraries/core/RideLibTicket.sol";
import {RideLibUser} from "../../libraries/core/RideLibUser.sol";
import {RideLibPassenger} from "../../libraries/core/RideLibPassenger.sol";
import {RideLibDriver} from "../../libraries/core/RideLibDriver.sol";

import {IRidePassenger} from "../../interfaces/core/IRidePassenger.sol";

contract RidePassenger is IRidePassenger {
    /**
     * requestTicket allows passenger to request for ride
     *
     * @param _badge badge rank requested
     * @param _strict whether driver must meet requested badge rank exactly (true) or default - any badge rank equal or greater than (false)
     * @param _metres estimated distance from origin to destination as determined by Maps API
     * @param _minutes estimated time taken from origin to destination as determined by Maps API
     *
     * @custom:event RequestTicket
     */
    function requestTicket(
        uint256 _badge,
        bool _strict,
        uint256 _metres,
        uint256 _minutes
    ) external override {
        RideLibDriver.requireNotDriver();
        RideLibUser.requireNotActive();
        RideLibPenalty.requireNotBanned();

        RideLibFee.StorageFee storage s1 = RideLibFee._storageFee();
        RideLibTicket.StorageTicket storage s2 = RideLibTicket._storageTicket();
        RideLibUser.StorageUser storage s3 = RideLibUser._storageUser();

        uint256 fare = RideLibFee._getFare(
            s1.baseFee,
            _metres,
            _minutes,
            s1.badgeToCostPerMetre[_badge],
            s1.costPerMinute
        );
        require(
            s3.addressToDeposit[msg.sender] > fare,
            "passenger's deposit < fare"
        );

        bytes32 tixId = keccak256(abi.encode(msg.sender, block.timestamp));

        s2.tixIdToTicket[tixId].passenger = msg.sender;
        s2.tixIdToTicket[tixId].badge = _badge;
        s2.tixIdToTicket[tixId].strict = _strict;
        s2.tixIdToTicket[tixId].metres = _metres;
        s2.tixIdToTicket[tixId].fare = fare;

        s2.addressToTixId[msg.sender] = tixId;

        emit RequestTicket(
            msg.sender,
            tixId,
            s1.baseFee,
            s1.costPerMinute,
            s1.badgeToCostPerMetre[_badge],
            _minutes,
            _metres
        );
    }

    /**
     * cancelRequest cancels ticket, can only be called before startTrip
     *
     * @custom:event RequestCancelled
     */
    function cancelRequest() external override {
        RideLibPassenger.requirePaxMatchTixPax();
        RideLibPassenger.requireTripNotStart();

        RideLibFee.StorageFee storage s1 = RideLibFee._storageFee();
        RideLibTicket.StorageTicket storage s2 = RideLibTicket._storageTicket();

        bytes32 tixId = s2.addressToTixId[msg.sender];
        address driver = s2.tixIdToTicket[tixId].driver;
        if (driver != address(0)) {
            // case when cancel inbetween driver accepted, but haven't reach passenger
            // give warning at frontend to passenger
            RideLibUser._transfer(tixId, s1.requestFee, msg.sender, driver);
        }

        RideLibTicket._cleanUp(tixId, msg.sender, driver);

        emit RequestCancelled(msg.sender, tixId); // --> update frontend request pool
    }

    /**
     * startTrip starts the trip, can only be called once driver reached passenger
     *
     * @param _driver driver's address - get via QR scan?
     *
     * @custom:event TripStarted
     */
    function startTrip(address _driver) external override {
        RideLibPassenger.requirePaxMatchTixPax();
        RideLibDriver.requireDrvMatchTixDrv(_driver);
        RideLibPassenger.requireTripNotStart();

        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();
        RideLibTicket.StorageTicket storage s2 = RideLibTicket._storageTicket();

        bytes32 tixId = s2.addressToTixId[msg.sender];
        s1.addressToDriverReputation[_driver].countStart += 1;
        s2.tixIdToTicket[tixId].tripStart = true;
        s2.tixIdToTicket[tixId].forceEndTimestamp = block.timestamp + 1 days; // TODO: change 1 day to setter fn

        emit TripStarted(msg.sender, tixId, _driver); // update frontend
    }

    /**
     * endTripPax ends the trip, can only be called once driver has called either endTripDrv
     *
     * @param _agree agreement from passenger that either destination has been reached or not
     * @param _rating refer _giveRating
     *
     * @custom:event TripEndedPax
     *
     * Driver would select destination reached or not, and event will emit to passenger's UI
     * then passenger would agree if this is true or false (via frontend UI), followed by a rating.
     * No matter what, passenger needs to pay fare, so incentive to passenger to be kind so driver
     * get passenger to destination. This prevents passenger abuse.
     */
    function endTripPax(bool _agree, uint256 _rating) external override {
        RideLibPassenger.requirePaxMatchTixPax();
        RideLibPassenger.requireTripInProgress();

        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();
        RideLibTicket.StorageTicket storage s2 = RideLibTicket._storageTicket();

        bytes32 tixId = s2.addressToTixId[msg.sender];
        address driver = s2.tixToDriverEnd[tixId].driver;
        require(driver != address(0), "driver must end trip");
        require(
            _agree,
            "pax must agree destination reached or not - indicated by driver"
        );

        RideLibUser._transfer(
            tixId,
            s2.tixIdToTicket[tixId].fare,
            msg.sender,
            driver
        );
        if (s2.tixToDriverEnd[tixId].reached) {
            s1.addressToDriverReputation[driver].metresTravelled += s2
                .tixIdToTicket[tixId]
                .metres;
            s1.addressToDriverReputation[driver].countEnd += 1;
        }

        RideLibPassenger._giveRating(driver, _rating);

        RideLibTicket._cleanUp(tixId, msg.sender, driver);

        emit TripEndedPax(msg.sender, tixId);
    }

    /**
     * forceEndPax can be called after tixIdToTicket[tixId].forceEndTimestamp duration
     * and if driver has NOT called endTripDrv
     *
     * @custom:event ForceEndPax
     *
     * no fare is paid, but driver is temporarily banned for banDuration
     */
    function forceEndPax() external override {
        RideLibPassenger.requirePaxMatchTixPax();
        RideLibPassenger.requireTripInProgress(); /** means both parties still active */
        RideLibPassenger.requireForceEndAllowed();

        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();

        bytes32 tixId = s1.addressToTixId[msg.sender];
        require(
            s1.tixToDriverEnd[tixId].driver == address(0),
            "driver ended trip"
        ); // TODO: test
        address driver = s1.tixIdToTicket[tixId].driver;

        RideLibPenalty._temporaryBan(driver);
        RideLibPassenger._giveRating(driver, 1);
        RideLibTicket._cleanUp(tixId, msg.sender, driver);

        emit ForceEndPax(msg.sender, tixId);
    }

    /**
     * setRatingBounds sets bounds for rating
     *
     * @param _min | unitless integer
     * @param _max | unitless integer
     */
    function setRatingBounds(uint256 _min, uint256 _max) external override {
        RideLibPassenger._setRatingBounds(_min, _max);
    }

    //////////////////////////////////////////////////////////////////////////////////
    ///// ---------------------------------------------------------------------- /////
    ///// -------------------------- getter functions -------------------------- /////
    ///// ---------------------------------------------------------------------- /////
    //////////////////////////////////////////////////////////////////////////////////

    function getRatingMin() external view override returns (uint256) {
        return RideLibPassenger._storagePassenger().ratingMin;
    }

    function getRatingMax() external view override returns (uint256) {
        return RideLibPassenger._storagePassenger().ratingMax;
    }
}
