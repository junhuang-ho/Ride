//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "./RideBase.sol";
import "./RideUtils.sol";

// import "hardhat/console.sol";

/// @title Passenger component of RideHub
contract RidePassenger is RideBase {
    event RequestTicket(bytes32 indexed tixId, address sender);
    event RequestCancelled(bytes32 indexed tixId, address sender);
    event TripStarted(bytes32 indexed tixId, address passenger, address driver);
    event TripEndedPax(bytes32 indexed tixId, address sender);
    event ForceEndPax(bytes32 indexed tixId, address sender);

    modifier paxMatchTixPax() {
        require(
            msg.sender == tixIdToTicket[addressToTixId[msg.sender]].passenger,
            "tix not match pax"
        );
        _;
    }

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
    ) external initializedRideBase notDriver notActive notBan {
        uint256 fare = RideUtils._getFare(
            baseFare,
            _metres,
            _minutes,
            badgeToCostPerMetre[_badge],
            costPerMinute
        );
        require(
            addressToDeposit[msg.sender] > fare,
            "passenger's deposit < fare"
        );

        bytes32 tixId = keccak256(abi.encode(msg.sender, block.timestamp));

        tixIdToTicket[tixId].passenger = msg.sender;
        tixIdToTicket[tixId].badge = _badge;
        tixIdToTicket[tixId].strict = _strict;
        tixIdToTicket[tixId].metres = _metres;
        tixIdToTicket[tixId].fare = fare;

        addressToTixId[msg.sender] = tixId;

        emit RequestTicket(tixId, msg.sender);
    }

    /**
     * cancelRequest cancels ticket, can only be called before startTrip
     *
     * @custom:event RequestCancelled
     */
    function cancelRequest() external paxMatchTixPax tripNotStart {
        bytes32 tixId = addressToTixId[msg.sender];
        address driver = tixIdToTicket[tixId].driver;
        if (driver != address(0)) {
            // case when cancel inbetween driver accepted, but haven't reach passenger
            // give warning at frontend to passenger
            _transfer(tixId, requestFee, msg.sender, driver);
        }

        _cleanUp(tixId, msg.sender, driver);

        emit RequestCancelled(tixId, msg.sender); // --> update frontend request pool
    }

    /**
     * startTrip starts the trip, can only be called once driver reached passenger
     *
     * @param _driver driver's address - get via QR scan?
     *
     * @custom:event TripStarted
     */
    function startTrip(address _driver)
        external
        paxMatchTixPax
        driverMatchTixDriver(_driver)
        tripNotStart
    {
        bytes32 tixId = addressToTixId[msg.sender];
        addressToDriverReputation[_driver].countStart += 1;
        tixIdToTicket[tixId].tripStart = true;
        tixIdToTicket[tixId].forceEndTimestamp = block.timestamp + 1 days; // TODO: change 1 day to setter fn

        emit TripStarted(tixId, msg.sender, _driver); // update frontend
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
    function endTripPax(bool _agree, uint256 _rating)
        external
        paxMatchTixPax
        tripInProgress
    {
        bytes32 tixId = addressToTixId[msg.sender];
        address driver = tixToDriverEnd[tixId].driver;
        require(driver != address(0), "driver must end trip");
        require(
            _agree,
            "pax must agree destination reached or not - indicated by driver"
        );

        _transfer(tixId, tixIdToTicket[tixId].fare, msg.sender, driver);
        if (tixToDriverEnd[tixId].reached) {
            addressToDriverReputation[driver].metresTravelled += tixIdToTicket[
                tixId
            ].metres;
            addressToDriverReputation[driver].countEnd += 1;
        }

        _giveRating(driver, _rating);

        _cleanUp(tixId, msg.sender, driver);

        emit TripEndedPax(tixId, msg.sender);
    }

    /**
     * forceEndPax can be called after tixIdToTicket[tixId].forceEndTimestamp duration
     * and if driver has NOT called endTripDrv
     *
     * @custom:event ForceEndPax
     *
     * no fare is paid, but driver is temporarily banned for banDuration
     */
    function forceEndPax()
        external
        paxMatchTixPax
        tripInProgress /** means both parties still active */
        forceEndAllowed
    {
        bytes32 tixId = addressToTixId[msg.sender];
        require(
            tixToDriverEnd[tixId].driver == address(0),
            "driver ended trip"
        ); // TODO: test
        address driver = tixIdToTicket[tixId].driver;

        _temporaryBan(driver);
        _giveRating(driver, 1);
        _cleanUp(tixId, msg.sender, driver);

        emit ForceEndPax(tixId, msg.sender);
    }

    //////////////////////////////////////////////////////////////////////////////////
    ///// ---------------------------------------------------------------------- /////
    ///// ------------------------- internal functions ------------------------- /////
    ///// ---------------------------------------------------------------------- /////
    //////////////////////////////////////////////////////////////////////////////////

    /**
     * _giveRating
     *
     * @param _driver driver's address
     * @param _rating unitless integer between RATING_MIN and RATING_MAX
     *
     * @custom:event TripStarted
     */
    function _giveRating(address _driver, uint256 _rating) internal {
        require(_rating >= RATING_MIN && _rating <= RATING_MAX); // TODO: contract exceeds size limit when add error msg
        addressToDriverReputation[_driver].totalRating += _rating;
        addressToDriverReputation[_driver].countRating += 1;
    }
}
