//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";

import "./RideBase.sol";
import "./RideUtils.sol";

/// @title Driver component of RideHub
contract RideDriver is RideBase {
    using Counters for Counters.Counter;
    Counters.Counter private _driverIdCounter;

    event RegisteredAsDriver(address sender);
    event AcceptedTicket(bytes32 indexed tixId, address sender);
    event DriverCancelled(bytes32 indexed tixId, address sender);
    event TripEndedDrv(bytes32 indexed tixId, bool reached, address sender);
    event ForceEndDrv(bytes32 indexed tixId, address sender);

    modifier isDriver() {
        require(
            addressToDriverReputation[msg.sender].id != 0,
            "caller not driver"
        );
        _;
    }

    constructor() {
        _burnFirstDriverId();
    }

    /**
     * registerDriver registers approved applicants (has passed background check)
     *
     * @param _maxMetresPerTrip | unit in metre
     *
     * @custom:event RegisteredAsDriver
     */
    function registerAsDriver(uint256 _maxMetresPerTrip)
        external
        initializedRideBase
        notDriver
        notActive
    {
        require(
            bytes(addressToDriverReputation[msg.sender].uri).length != 0,
            "uri not set in bg check"
        );
        require(msg.sender != address(0), "0 address");

        addressToDriverReputation[msg.sender].id = _mint();
        addressToDriverReputation[msg.sender]
            .maxMetresPerTrip = _maxMetresPerTrip;
        addressToDriverReputation[msg.sender].metresTravelled = 0;
        addressToDriverReputation[msg.sender].countStart = 0;
        addressToDriverReputation[msg.sender].countEnd = 0;
        addressToDriverReputation[msg.sender].totalRating = 0;
        addressToDriverReputation[msg.sender].countRating = 0;

        emit RegisteredAsDriver(msg.sender);
    }

    /**
     * updateMaxMetresPerTrip updates maximum metre per trip of driver
     *
     * @param _maxMetresPerTrip | unit in metre
     */
    function updateMaxMetresPerTrip(uint256 _maxMetresPerTrip)
        external
        isDriver
        notActive
    {
        addressToDriverReputation[msg.sender]
            .maxMetresPerTrip = _maxMetresPerTrip;
    }

    /**
     * getTicket allows driver to accept passenger's ticket request
     *
     * @param _tixId Ticket ID
     * @param _useBadge allows driver to use any badge rank equal to or lower than current rank 
     (this is to give driver the option of lower cosr per metre rates)
     *
     * @custom:event AcceptedTicket
     *
     * higher badge can charge higher price, but what if passenger always choose lower price?
     * (badgeToCostPerMetre[_badge], at RidePassenger.sol) then higher badge driver wont get chosen at all
     * solution: _useBadge that allows driver to choose which badge rank they want to use up to achieved badge rank
     * at frontend, default _useBadge to driver's current badge rank
     */
    function getTicket(bytes32 _tixId, uint256 _useBadge)
        external
        isDriver
        notActive
        notBan
    {
        uint256 driverScore = RideUtils._calculateScore(
            addressToDriverReputation[msg.sender].metresTravelled,
            addressToDriverReputation[msg.sender].countStart,
            addressToDriverReputation[msg.sender].countEnd,
            addressToDriverReputation[msg.sender].totalRating,
            addressToDriverReputation[msg.sender].countRating,
            RATING_MAX
        );
        uint256 driverBadge = _getBadge(driverScore);
        require(_useBadge <= driverBadge, "badge rank not achieved");

        require(
            addressToDeposit[msg.sender] > tixIdToTicket[_tixId].fare,
            "driver's deposit < fare"
        );
        require(
            tixIdToTicket[_tixId].metres <=
                addressToDriverReputation[msg.sender].maxMetresPerTrip,
            "trip too long"
        );
        if (tixIdToTicket[_tixId].strict) {
            require(
                _useBadge == tixIdToTicket[_tixId].badge,
                "driver not meet badge - strict"
            );
        } else {
            require(
                _useBadge >= tixIdToTicket[_tixId].badge,
                "driver not meet badge"
            );
        }

        tixIdToTicket[_tixId].driver = msg.sender;
        addressToTixId[msg.sender] = _tixId;

        emit AcceptedTicket(_tixId, msg.sender); // --> update frontend (also, add warning that if passenger cancel, will incure fee)
    }

    /**
     * cancelPickUp cancels pick up, can only be called before startTrip
     *
     * @custom:event DriverCancelled
     */
    function cancelPickUp()
        external
        driverMatchTixDriver(msg.sender)
        tripNotStart
    {
        bytes32 tixId = addressToTixId[msg.sender];
        address passenger = tixIdToTicket[tixId].passenger;

        _transfer(tixId, requestFee, msg.sender, passenger);

        _cleanUp(tixId, passenger, msg.sender);

        emit DriverCancelled(tixId, msg.sender); // --> update frontend
    }

    /**
     * endTripDrv allows driver to indicate to passenger to end trip and destination is either reached or not
     *
     * @param _reached boolean indicating whether destination has been reach or not
     *
     * @custom:event TripEndedDrv
     */
    // TODO: test that this fn can be recalled immediately after first call so that driver can change _reached status if needed. Test in remix first.
    function endTripDrv(bool _reached)
        external
        driverMatchTixDriver(msg.sender)
        tripInProgress
    {
        bytes32 tixId = addressToTixId[msg.sender];
        // tixToDriverEnd[tixId] = DriverEnd({driver: msg.sender, reached: true}); // takes up more space
        tixToDriverEnd[tixId].driver = msg.sender;
        tixToDriverEnd[tixId].reached = _reached;

        emit TripEndedDrv(tixId, _reached, msg.sender);
    }

    /**
     * forceEndDrv can be called after tixIdToTicket[tixId].forceEndTimestamp duration
     * and if passenger has not called endTripPax
     *
     * @custom:event ForceEndDrv
     *
     * no fare is paid, but passenger is temporarily banned for banDuration
     */
    function forceEndDrv()
        external
        driverMatchTixDriver(msg.sender)
        tripInProgress /** means both parties still active */
        forceEndAllowed
    {
        bytes32 tixId = addressToTixId[msg.sender];
        require(
            tixToDriverEnd[tixId].driver != address(0),
            "driver must end trip"
        ); // TODO: test
        address passenger = tixIdToTicket[tixId].passenger;

        _temporaryBan(passenger);
        _cleanUp(tixId, passenger, msg.sender);

        emit ForceEndDrv(tixId, msg.sender);
    }

    //////////////////////////////////////////////////////////////////////////////////
    ///// ---------------------------------------------------------------------- /////
    ///// ------------------------- internal functions ------------------------- /////
    ///// ---------------------------------------------------------------------- /////
    //////////////////////////////////////////////////////////////////////////////////

    /**
     * _mint a driver ID
     *
     * @return driver ID
     */
    function _mint() internal returns (uint256) {
        uint256 id = _driverIdCounter.current();
        _driverIdCounter.increment();
        return id;
    }

    /**
     * _burnFirstDriverId burns driver ID 0
     * can only be called at RideHub deployment
     */
    function _burnFirstDriverId() internal {
        assert(_driverIdCounter.current() == 0);
        _driverIdCounter.increment();
    }
}
