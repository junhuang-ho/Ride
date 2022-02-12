//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../interfaces/core/IRideDriverRegistry.sol";
import "../../libraries/core/RideLibDriverRegistry.sol";
import "../../libraries/core/RideLibBadge.sol";
import "../../libraries/core/RideLibTicket.sol";
import "../../libraries/core/RideLibDriver.sol";
import "../../libraries/utils/RideLibOwnership.sol";

contract RideDriverRegistry is IRideDriverRegistry {
    /**
     * registerDriver registers approved applicants (has passed background check)
     *
     * @param _maxMetresPerTrip | unit in metre
     *
     * @custom:event RegisteredAsDriver
     */
    function registerAsDriver(uint256 _maxMetresPerTrip) external override {
        RideLibDriver._requireNotDriver();
        RideLibTicket._requireNotActive();
        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();
        require(
            bytes(s1.driverToDriverReputation[msg.sender].uri).length != 0,
            "uri not set in bg check"
        );
        require(msg.sender != address(0), "0 address");

        s1.driverToDriverReputation[msg.sender].id = RideLibDriverRegistry
            ._mint();
        // s1.driverToDriverReputation[msg.sender].uri = _uri; // URI set from another contract to prevent anyone passing random string
        s1
            .driverToDriverReputation[msg.sender]
            .maxMetresPerTrip = _maxMetresPerTrip;
        // s1.driverToDriverReputation[msg.sender].metresTravelled = 0;
        // s1.driverToDriverReputation[msg.sender].countStart = 0;
        // s1.driverToDriverReputation[msg.sender].countEnd = 0;
        // s1.driverToDriverReputation[msg.sender].totalRating = 0;
        // s1.driverToDriverReputation[msg.sender].countRating = 0;

        emit RegisteredAsDriver(msg.sender);
    }

    /**
     * updateMaxMetresPerTrip updates maximum metre per trip of driver
     *
     * @param _maxMetresPerTrip | unit in metre
     */
    function updateMaxMetresPerTrip(uint256 _maxMetresPerTrip)
        external
        override
    {
        RideLibDriver._requireIsDriver();
        RideLibTicket._requireNotActive();
        RideLibBadge
            ._storageBadge()
            .driverToDriverReputation[msg.sender]
            .maxMetresPerTrip = _maxMetresPerTrip;

        emit MaxMetresUpdated(msg.sender, _maxMetresPerTrip);
    }

    /**
     * approveApplicant of driver applicants
     *
     * @param _driver applicant
     * @param _uri information of applicant
     *
     * @custom:event ApplicantApproved
     */
    function approveApplicant(address _driver, string memory _uri)
        external
        override
    {
        RideLibOwnership._requireIsOwner();

        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();

        require(
            bytes(s1.driverToDriverReputation[_driver].uri).length == 0,
            "uri already set"
        );
        s1.driverToDriverReputation[_driver].uri = _uri;

        emit ApplicantApproved(_driver);
    }
}
