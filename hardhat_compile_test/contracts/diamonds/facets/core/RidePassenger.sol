//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/RideLibPassenger.sol";
import "../../libraries/core/RideLibFee.sol";
import "../../libraries/core/RideLibRater.sol";
import "../../libraries/core/RideLibBadge.sol";
import "../../libraries/core/RideLibDriver.sol";
import "../../libraries/core/RideLibTicket.sol";
import "../../libraries/core/RideLibPenalty.sol";
import "../../libraries/core/RideLibHolding.sol";
import "../../libraries/core/RideLibExchange.sol";

contract RidePassenger {
    event RequestTicket(
        address indexed sender,
        bytes32 indexed tixId,
        uint256 fare
    );
    event RequestCancelled(address indexed sender, bytes32 indexed tixId);
    event TripStarted(
        address indexed passenger,
        bytes32 indexed tixId,
        address driver
    );
    event TripEndedPax(address indexed sender, bytes32 indexed tixId);
    event ForceEndPax(address indexed sender, bytes32 indexed tixId);

    /**
     * requestTicket allows passenger to request for ride
     *
     * @param _badge badge rank requested
     * @param _strict whether driver must meet requested badge rank exactly (true) or default - any badge rank equal or greater than (false)
     * @param _minutes estimated time taken from origin to destination as determined by Maps API
     * @param _metres estimated distance from origin to destination as determined by Maps API
     *
     * @custom:event RequestTicket
     */
    function requestTicket(
        bytes32 _keyLocal,
        bytes32 _keyPay,
        uint256 _badge,
        bool _strict,
        uint256 _minutes,
        uint256 _metres
    ) external {
        RideLibDriver._requireNotDriver();
        RideLibTicket._requireNotActive();
        RideLibPenalty._requireNotBanned();
        // RideLibExchange._requireXPerYPriceFeedSupported(_keyLocal, _keyPay); // note: double check on currency supported (check is already done indirectly by _getCancellationFee & _getFare, directly by currency conversion)
        /**
         * Note: if frontend implement correctly, removing this line
         *       RideLibExchange._requireXPerYPriceFeedSupported(_keyLocal, _keyPay);
         *       would NOT be a problem
         */

        RideLibTicket.StorageTicket storage s2 = RideLibTicket._storageTicket();

        uint256 cancellationFeeLocal = RideLibFee._getCancellationFee(
            _keyLocal
        );
        uint256 fareLocal = RideLibFee._getFare(
            _keyLocal,
            _badge,
            _minutes,
            _metres
        );
        uint256 cancellationFeePay;
        uint256 farePay;
        if (_keyLocal == _keyPay) {
            // when local is in crypto token
            cancellationFeePay = cancellationFeeLocal;
            farePay = fareLocal;
        } else {
            cancellationFeePay = RideLibExchange._convertCurrency(
                _keyLocal,
                _keyPay,
                cancellationFeeLocal
            );
            farePay = RideLibExchange._convertCurrency(
                _keyLocal,
                _keyPay,
                fareLocal
            );
        }
        uint256 holdingAmount = RideLibHolding
            ._storageHolding()
            .userToCurrencyKeyToHolding[msg.sender][_keyPay];
        require(
            (holdingAmount > cancellationFeePay) && (holdingAmount > farePay),
            "RidePassenger: Passenger's holding < cancellationFee or fare"
        );

        bytes32 tixId = keccak256(abi.encode(msg.sender, block.timestamp)); // encode gas seems less? but diff very small

        s2.tixIdToTicket[tixId].passenger = msg.sender;
        s2.tixIdToTicket[tixId].badge = _badge;
        s2.tixIdToTicket[tixId].strict = _strict;
        s2.tixIdToTicket[tixId].metres = _metres;
        s2.tixIdToTicket[tixId].keyLocal = _keyLocal;
        s2.tixIdToTicket[tixId].keyPay = _keyPay;
        s2.tixIdToTicket[tixId].cancellationFee = cancellationFeePay;
        s2.tixIdToTicket[tixId].fare = farePay;

        s2.userToTixId[msg.sender] = tixId;

        emit RequestTicket(msg.sender, tixId, farePay);
    }

    /**
     * cancelRequest cancels ticket, can only be called before startTrip
     *
     * @custom:event RequestCancelled
     */
    function cancelRequest() external {
        RideLibPassenger._requirePaxMatchTixPax();
        RideLibPassenger._requireTripNotStart();

        RideLibTicket.StorageTicket storage s2 = RideLibTicket._storageTicket();

        bytes32 tixId = s2.userToTixId[msg.sender];
        address driver = s2.tixIdToTicket[tixId].driver;
        if (driver != address(0)) {
            // case when cancel inbetween driver accepted, but haven't reach passenger
            // give warning at frontend to passenger
            RideLibHolding._transferCurrency(
                tixId,
                s2.tixIdToTicket[tixId].keyPay,
                s2.tixIdToTicket[tixId].cancellationFee,
                msg.sender,
                driver
            );
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
    function startTrip(address _driver) external {
        RideLibPassenger._requirePaxMatchTixPax();
        RideLibDriver._requireDrvMatchTixDrv(_driver);
        RideLibPassenger._requireTripNotStart();

        RideLibTicket.StorageTicket storage s2 = RideLibTicket._storageTicket();

        bytes32 tixId = s2.userToTixId[msg.sender];
        RideLibBadge
            ._storageBadge()
            .driverToDriverReputation[_driver]
            .countStart += 1;
        s2.tixIdToTicket[tixId].tripStart = true;
        s2.tixIdToTicket[tixId].forceEndTimestamp =
            block.timestamp +
            s2.forceEndDelay;

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
    function endTripPax(bool _agree, uint256 _rating) external {
        RideLibPassenger._requirePaxMatchTixPax();
        RideLibPassenger._requireTripInProgress();

        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();
        RideLibTicket.StorageTicket storage s2 = RideLibTicket._storageTicket();

        bytes32 tixId = s2.userToTixId[msg.sender];
        address driver = s2.tixIdToDriverEnd[tixId].driver;
        require(driver != address(0), "RidePassenger: Driver must end trip");
        require(
            _agree,
            "RidePassenger: Passenger must agree destination reached or not - indicated by driver"
        );

        RideLibHolding._transferCurrency(
            tixId,
            s2.tixIdToTicket[tixId].keyPay,
            s2.tixIdToTicket[tixId].fare,
            msg.sender,
            driver
        );
        if (s2.tixIdToDriverEnd[tixId].reached) {
            s1.driverToDriverReputation[driver].metresTravelled += s2
                .tixIdToTicket[tixId]
                .metres;
            s1.driverToDriverReputation[driver].countEnd += 1;
        }

        RideLibRater._giveRating(driver, _rating);

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
    function forceEndPax() external {
        RideLibPassenger._requirePaxMatchTixPax();
        RideLibPassenger._requireTripInProgress(); /** means both parties still active */
        RideLibPassenger._requireForceEndAllowed();

        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();

        bytes32 tixId = s1.userToTixId[msg.sender];
        require(
            s1.tixIdToDriverEnd[tixId].driver == address(0),
            "RidePassenger: Driver ended trip"
        ); // TODO: test
        address driver = s1.tixIdToTicket[tixId].driver;

        RideLibPenalty._temporaryBan(driver);
        RideLibRater._giveRating(driver, 1);
        RideLibTicket._cleanUp(tixId, msg.sender, driver);

        emit ForceEndPax(msg.sender, tixId);
    }
}
