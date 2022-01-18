//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibBadge} from "../../libraries/core/RideLibBadge.sol";
import {RideLibFee} from "../../libraries/core/RideLibFee.sol";
import {RideLibPenalty} from "../../libraries/core/RideLibPenalty.sol";
import {RideLibTicket} from "../../libraries/core/RideLibTicket.sol";
import {RideLibHolding} from "../../libraries/core/RideLibHolding.sol";
import {RideLibPassenger} from "../../libraries/core/RideLibPassenger.sol";
import {RideLibDriver} from "../../libraries/core/RideLibDriver.sol";

import {RideLibExchange} from "../../libraries/core/RideLibExchange.sol";

import {IRideDriver} from "../../interfaces/core/IRideDriver.sol";

contract RideDriver is IRideDriver {
    /**
     * acceptTicket allows driver to accept passenger's ticket request
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
    function acceptTicket(
        bytes32 _keyLocal,
        bytes32 _keyAccept,
        bytes32 _tixId,
        uint256 _useBadge
    ) external override {
        RideLibDriver._requireIsDriver();
        RideLibTicket._requireNotActive();
        RideLibPenalty._requireNotBanned();
        RideLibExchange._requireXPerYPriceFeedSupported(_keyLocal, _keyAccept);

        RideLibTicket.StorageTicket storage s2 = RideLibTicket._storageTicket();

        require(
            s2.tixIdToTicket[_tixId].passenger != address(0),
            "ticket not exists"
        );
        require(
            s2.tixIdToTicket[_tixId].keyLocal == _keyLocal,
            "local currency key not match"
        );
        require(
            s2.tixIdToTicket[_tixId].keyPay == _keyAccept,
            "payment currency key not match"
        );

        uint256 driverScore = RideLibBadge._calculateScore();
        uint256 driverBadge = RideLibBadge._getBadge(driverScore);
        require(_useBadge <= driverBadge, "badge rank not achieved");

        uint256 holdingAmount = RideLibHolding._getHolding(
            msg.sender,
            _keyAccept
        );
        require(
            (holdingAmount > s2.tixIdToTicket[_tixId].requestFee) &&
                (holdingAmount > s2.tixIdToTicket[_tixId].fare),
            "driver's holding < requestFee or fare"
        );

        require(
            s2.tixIdToTicket[_tixId].metres <=
                RideLibBadge
                    ._storageBadge()
                    .driverToDriverReputation[msg.sender]
                    .maxMetresPerTrip,
            "trip too long"
        );
        if (s2.tixIdToTicket[_tixId].strict) {
            require(
                _useBadge == s2.tixIdToTicket[_tixId].badge,
                "driver not meet badge - strict"
            );
        } else {
            require(
                _useBadge >= s2.tixIdToTicket[_tixId].badge,
                "driver not meet badge"
            );
        }

        s2.tixIdToTicket[_tixId].driver = msg.sender;
        s2.userToTixId[msg.sender] = _tixId;

        emit AcceptedTicket(msg.sender, _tixId); // --> update frontend (also, add warning that if passenger cancel, will incure fee)
    }

    /**
     * cancelPickUp cancels pick up, can only be called before startTrip
     *
     * @custom:event DriverCancelled
     */
    function cancelPickUp() external override {
        RideLibDriver._requireDrvMatchTixDrv(msg.sender);
        RideLibPassenger._requireTripNotStart();

        RideLibTicket.StorageTicket storage s2 = RideLibTicket._storageTicket();

        bytes32 tixId = s2.userToTixId[msg.sender];
        address passenger = s2.tixIdToTicket[tixId].passenger;

        RideLibHolding._transferCurrency(
            tixId,
            s2.tixIdToTicket[tixId].keyPay,
            s2.tixIdToTicket[tixId].requestFee,
            msg.sender,
            passenger
        );

        RideLibTicket._cleanUp(tixId, passenger, msg.sender);

        emit DriverCancelled(msg.sender, tixId); // --> update frontend
    }

    /**
     * endTripDrv allows driver to indicate to passenger to end trip and destination is either reached or not
     *
     * @param _reached boolean indicating whether destination has been reach or not
     *
     * @custom:event TripEndedDrv
     */
    // TODO: test that this fn can be recalled immediately after first call so that driver can change _reached status if needed. Test in remix first.
    function endTripDrv(bool _reached) external override {
        RideLibDriver._requireDrvMatchTixDrv(msg.sender);
        RideLibPassenger._requireTripInProgress();

        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();

        bytes32 tixId = s1.userToTixId[msg.sender];
        // tixToDriverEnd[tixId] = DriverEnd({driver: msg.sender, reached: true}); // takes up more space
        s1.tixToDriverEnd[tixId].driver = msg.sender;
        s1.tixToDriverEnd[tixId].reached = _reached;

        emit TripEndedDrv(msg.sender, tixId, _reached);
    }

    /**
     * forceEndDrv can be called after tixIdToTicket[tixId].forceEndTimestamp duration
     * and if passenger has not called endTripPax
     *
     * @custom:event ForceEndDrv
     *
     * no fare is paid, but passenger is temporarily banned for banDuration
     */
    function forceEndDrv() external override {
        RideLibDriver._requireDrvMatchTixDrv(msg.sender);
        RideLibPassenger._requireTripInProgress(); /** means both parties still active */
        RideLibPassenger._requireForceEndAllowed();

        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();

        bytes32 tixId = s1.userToTixId[msg.sender];
        require(
            s1.tixToDriverEnd[tixId].driver != address(0),
            "driver must end trip"
        ); // TODO: test
        address passenger = s1.tixIdToTicket[tixId].passenger;

        RideLibPenalty._temporaryBan(passenger);
        RideLibTicket._cleanUp(tixId, passenger, msg.sender);

        emit ForceEndDrv(msg.sender, tixId);
    }
}
