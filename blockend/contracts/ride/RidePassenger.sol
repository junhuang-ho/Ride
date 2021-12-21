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
    event TripEnded(bytes32 indexed tixId, address sender);
    event ForceEndPassenger(bytes32 indexed tixId, address sender);

    modifier paxMatchTixPax(bytes32 _tixId, address _passenger) {
        require(
            _passenger == tixIdToTicket[_tixId].passenger,
            "pax not match tix pax"
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

        addressToActive[msg.sender] = true;

        emit RequestTicket(tixId, msg.sender);
    }

    /**
     * cancelRequest cancels ticket, can only be called before startTrip
     *
     * @param _tixId Ticket ID
     *
     * @custom:event RequestCancelled
     */
    function cancelRequest(bytes32 _tixId)
        external
        paxMatchTixPax(_tixId, msg.sender)
        tripNotStart(_tixId)
    {
        address driver = tixIdToTicket[_tixId].driver;
        if (driver != address(0)) {
            // case when cancel inbetween driver accepted, but haven't reach passenger
            // give warning at frontend to passenger
            _transfer(_tixId, requestFee, msg.sender, driver);
        }

        _cleanUp(_tixId, msg.sender, driver);

        emit RequestCancelled(_tixId, msg.sender); // --> update frontend request pool
    }

    /**
     * startTrip starts the trip, can only be called once driver reached passenger
     *
     * @param _tixId Ticket ID
     * @param _driver driver's address - get via QR scan?
     *
     * @custom:event TripStarted
     */
    function startTrip(bytes32 _tixId, address _driver)
        external
        paxMatchTixPax(_tixId, msg.sender)
        driverMatchTixDriver(_tixId, _driver)
        tripNotStart(_tixId)
    {
        addressToDriverReputation[_driver].countStart += 1;
        tixIdToTicket[_tixId].tripStart = true;
        tixIdToTicket[_tixId].forceEndTimestamp = block.timestamp + 1 days;

        emit TripStarted(_tixId, msg.sender, _driver); // update frontend
    }

    /**
     * endTrip ends the trip, can only be called once driver has called either destinationReached or destinationNotReached
     *
     * @param _tixId Ticket ID
     * @param _confirmation confirmation from passenger that either destination has been reached or not
     * @param _rating refer _giveRating
     *
     * @custom:event TripEnded
     *
     * driver would select destination reached or not, and event will emit to passenger's UI
     * then passenger would confirm if this is true or false (via frontend UI), followed by a rating
     */
    function endTrip(
        bytes32 _tixId,
        bool _confirmation,
        uint256 _rating
    ) external paxMatchTixPax(_tixId, msg.sender) tripInProgress(_tixId) {
        address driver = tixToEndDetails[_tixId].driver;
        require(driver != address(0), "driver must end trip");
        require(
            _confirmation,
            "pax must confirm destination reached or not - indicated by driver"
        );

        if (tixToEndDetails[_tixId].reached) {
            _transfer(_tixId, tixIdToTicket[_tixId].fare, msg.sender, driver);
            addressToDriverReputation[driver].metresTravelled += tixIdToTicket[
                _tixId
            ].metres;
            addressToDriverReputation[driver].countEnd += 1;
        }

        _giveRating(driver, _rating);

        _cleanUp(_tixId, msg.sender, driver);

        emit TripEnded(_tixId, msg.sender);
    }

    /**
     * forceEndPassenger can be called after tixIdToTicket[_tixId].forceEndTimestamp duration
     * and if driver has not called destinationReached or destinationNotReached
     *
     * @param _tixId Ticket ID
     *
     * @custom:event ForceEndPassenger
     *
     * no fare is paid, but driver is temporarily banned for banDuration
     */
    function forceEndPassenger(bytes32 _tixId)
        external
        paxMatchTixPax(_tixId, msg.sender)
        tripInProgress(_tixId) /** means both parties still active */
        forceEndAllowed(_tixId)
    {
        require(
            tixToEndDetails[_tixId].driver == address(0),
            "driver ended trip"
        ); // TODO: test
        address driver = tixIdToTicket[_tixId].driver;

        _temporaryBan(driver);
        _cleanUp(_tixId, msg.sender, driver);

        emit ForceEndPassenger(_tixId, msg.sender);
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
     * @param _rating unitless integer between 0 and 100
     *
     * @custom:event TripStarted
     */
    function _giveRating(address _driver, uint256 _rating) internal {
        addressToDriverReputation[_driver].totalRating += _rating;
        addressToDriverReputation[_driver].countRating += 1;
    }
}
