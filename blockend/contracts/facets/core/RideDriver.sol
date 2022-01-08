//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibOwnership} from "../../libraries/utils/RideLibOwnership.sol";
import {RideLibBadge} from "../../libraries/core/RideLibBadge.sol";
import {RideLibFee} from "../../libraries/core/RideLibFee.sol";
import {RideLibPenalty} from "../../libraries/core/RideLibPenalty.sol";
import {RideLibTicket} from "../../libraries/core/RideLibTicket.sol";
import {RideLibUser} from "../../libraries/core/RideLibUser.sol";
import {RideLibPassenger} from "../../libraries/core/RideLibPassenger.sol";
import {RideLibDriver} from "../../libraries/core/RideLibDriver.sol";

import {IRideDriver} from "../../interfaces/core/IRideDriver.sol";

contract RideDriver is IRideDriver {
    event RegisteredAsDriver(address indexed sender);

    /**
     * registerDriver registers approved applicants (has passed background check)
     *
     * @param _maxMetresPerTrip | unit in metre
     *
     * @custom:event RegisteredAsDriver
     */
    function registerAsDriver(uint256 _maxMetresPerTrip) external override {
        RideLibDriver.requireNotDriver();
        RideLibUser.requireNotActive();
        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();
        require(
            bytes(s1.addressToDriverReputation[msg.sender].uri).length != 0,
            "uri not set in bg check"
        );
        require(msg.sender != address(0), "0 address");

        s1.addressToDriverReputation[msg.sender].id = RideLibDriver._mint();
        s1
            .addressToDriverReputation[msg.sender]
            .maxMetresPerTrip = _maxMetresPerTrip;
        s1.addressToDriverReputation[msg.sender].metresTravelled = 0;
        s1.addressToDriverReputation[msg.sender].countStart = 0;
        s1.addressToDriverReputation[msg.sender].countEnd = 0;
        s1.addressToDriverReputation[msg.sender].totalRating = 0;
        s1.addressToDriverReputation[msg.sender].countRating = 0;

        emit RegisteredAsDriver(msg.sender);
    }

    event MaxMetresUpdated(address indexed sender, uint256 metres);

    /**
     * updateMaxMetresPerTrip updates maximum metre per trip of driver
     *
     * @param _maxMetresPerTrip | unit in metre
     */
    function updateMaxMetresPerTrip(uint256 _maxMetresPerTrip)
        external
        override
    {
        RideLibDriver.requireIsDriver();
        RideLibUser.requireNotActive();
        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();
        s1
            .addressToDriverReputation[msg.sender]
            .maxMetresPerTrip = _maxMetresPerTrip;

        emit MaxMetresUpdated(msg.sender, _maxMetresPerTrip);
    }

    event AcceptedTicket(address indexed sender, bytes32 indexed tixId);

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
    function acceptTicket(bytes32 _tixId, uint256 _useBadge) external override {
        RideLibDriver.requireIsDriver();
        RideLibUser.requireNotActive();
        RideLibPenalty.requireNotBanned();

        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();
        RideLibTicket.StorageTicket storage s2 = RideLibTicket._storageTicket();
        RideLibUser.StorageUser storage s3 = RideLibUser._storageUser();
        RideLibPassenger.StoragePassenger storage s4 = RideLibPassenger
            ._storagePassenger();

        require(
            s2.tixIdToTicket[_tixId].passenger != address(0),
            "ticket not exists"
        );

        uint256 driverScore = RideLibBadge._calculateScore(
            s1.addressToDriverReputation[msg.sender].metresTravelled,
            s1.addressToDriverReputation[msg.sender].countStart,
            s1.addressToDriverReputation[msg.sender].countEnd,
            s1.addressToDriverReputation[msg.sender].totalRating,
            s1.addressToDriverReputation[msg.sender].countRating,
            s4.ratingMax
        );
        uint256 driverBadge = RideLibBadge._getBadge(driverScore);
        require(_useBadge <= driverBadge, "badge rank not achieved");

        require(
            s3.addressToDeposit[msg.sender] > s2.tixIdToTicket[_tixId].fare,
            "driver's deposit < fare"
        );
        require(
            s2.tixIdToTicket[_tixId].metres <=
                s1.addressToDriverReputation[msg.sender].maxMetresPerTrip,
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
        s2.addressToTixId[msg.sender] = _tixId;

        emit AcceptedTicket(msg.sender, _tixId); // --> update frontend (also, add warning that if passenger cancel, will incure fee)
    }

    event DriverCancelled(address indexed sender, bytes32 indexed tixId);

    /**
     * cancelPickUp cancels pick up, can only be called before startTrip
     *
     * @custom:event DriverCancelled
     */
    function cancelPickUp() external override {
        RideLibDriver.requireDrvMatchTixDrv(msg.sender);
        RideLibPassenger.requireTripNotStart();

        RideLibFee.StorageFee storage s1 = RideLibFee._storageFee();
        RideLibTicket.StorageTicket storage s2 = RideLibTicket._storageTicket();

        bytes32 tixId = s2.addressToTixId[msg.sender];
        address passenger = s2.tixIdToTicket[tixId].passenger;

        RideLibUser._transfer(tixId, s1.requestFee, msg.sender, passenger);

        RideLibTicket._cleanUp(tixId, passenger, msg.sender);

        emit DriverCancelled(msg.sender, tixId); // --> update frontend
    }

    event TripEndedDrv(
        address indexed sender,
        bytes32 indexed tixId,
        bool reached
    );

    /**
     * endTripDrv allows driver to indicate to passenger to end trip and destination is either reached or not
     *
     * @param _reached boolean indicating whether destination has been reach or not
     *
     * @custom:event TripEndedDrv
     */
    // TODO: test that this fn can be recalled immediately after first call so that driver can change _reached status if needed. Test in remix first.
    function endTripDrv(bool _reached) external override {
        RideLibDriver.requireDrvMatchTixDrv(msg.sender);
        RideLibPassenger.requireTripInProgress();

        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();

        bytes32 tixId = s1.addressToTixId[msg.sender];
        // tixToDriverEnd[tixId] = DriverEnd({driver: msg.sender, reached: true}); // takes up more space
        s1.tixToDriverEnd[tixId].driver = msg.sender;
        s1.tixToDriverEnd[tixId].reached = _reached;

        emit TripEndedDrv(msg.sender, tixId, _reached);
    }

    event ForceEndDrv(address indexed sender, bytes32 indexed tixId);

    /**
     * forceEndDrv can be called after tixIdToTicket[tixId].forceEndTimestamp duration
     * and if passenger has not called endTripPax
     *
     * @custom:event ForceEndDrv
     *
     * no fare is paid, but passenger is temporarily banned for banDuration
     */
    function forceEndDrv() external override {
        RideLibDriver.requireDrvMatchTixDrv(msg.sender);
        RideLibPassenger.requireTripInProgress(); /** means both parties still active */
        RideLibPassenger.requireForceEndAllowed();

        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();

        bytes32 tixId = s1.addressToTixId[msg.sender];
        require(
            s1.tixToDriverEnd[tixId].driver != address(0),
            "driver must end trip"
        ); // TODO: test
        address passenger = s1.tixIdToTicket[tixId].passenger;

        RideLibPenalty._temporaryBan(passenger);
        RideLibTicket._cleanUp(tixId, passenger, msg.sender);

        emit ForceEndDrv(msg.sender, tixId);
    }

    event ApplicantApproved(address indexed applicant);

    /**
     * passBackgroundCheck of driver applicants
     *
     * @param _driver applicant
     * @param _uri information of applicant
     *
     * @custom:event ApplicantApproved
     */
    function passBackgroundCheck(address _driver, string memory _uri)
        external
        override
    {
        RideLibOwnership.requireIsContractOwner();

        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();

        require(
            bytes(s1.addressToDriverReputation[_driver].uri).length == 0,
            "uri already set"
        );
        s1.addressToDriverReputation[_driver].uri = _uri;

        emit ApplicantApproved(_driver);
    }
}
