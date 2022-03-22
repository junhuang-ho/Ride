//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/RideLibDriverRegistry.sol";
import "../../libraries/core/RideLibDriverDetails.sol";
import "../../libraries/core/RideLibTicket.sol";
import "../../libraries/core/RideLibDriver.sol";
import "../../libraries/utils/RideLibAccessControl.sol";

contract RideDriverRegistry {
    event RegisteredAsDriver(address indexed sender);
    event MaxMetresUpdated(address indexed sender, uint256 metres);
    event ApplicantApproved(address indexed applicant);

    /**
     * registerDriver registers approved applicants (has passed background check)
     *
     * @param _maxMetresPerTrip | unit in metre
     *
     * @custom:event RegisteredAsDriver
     */
    function registerAsDriver(uint256 _maxMetresPerTrip) external {
        RideLibDriver._requireNotDriver();
        RideLibTicket._requireNotActive();
        RideLibDriverDetails.StorageDriverDetails
            storage s1 = RideLibDriverDetails._storageDriverDetails();
        require(
            bytes(s1.driverToDriverDetails[msg.sender].uri).length != 0,
            "RideDriverRegistry: URI not set in background check"
        );
        require(msg.sender != address(0), "RideDriverRegistry: Zero address");

        s1.driverToDriverDetails[msg.sender].id = RideLibDriverRegistry._mint();
        s1
            .driverToDriverDetails[msg.sender]
            .maxMetresPerTrip = _maxMetresPerTrip;

        emit RegisteredAsDriver(msg.sender);
    }

    /**
     * updateMaxMetresPerTrip updates maximum metre per trip of driver
     *
     * @param _maxMetresPerTrip | unit in metre
     */
    function updateMaxMetresPerTrip(uint256 _maxMetresPerTrip) external {
        RideLibDriver._requireIsDriver();
        RideLibTicket._requireNotActive();
        RideLibDriverDetails
            ._storageDriverDetails()
            .driverToDriverDetails[msg.sender]
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
    function approveApplicant(
        address _driver,
        string memory _uri,
        address _alliance /** timelock */
    ) external {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl.ALLIANCE_ROLE
        );

        RideLibDriverDetails.StorageDriverDetails
            storage s1 = RideLibDriverDetails._storageDriverDetails();

        require(
            s1.allianceToDrivers[_alliance].length > 0,
            "RideDriverRegistry: Alliance not registered"
        );
        require(
            bytes(s1.driverToDriverDetails[_driver].uri).length == 0,
            "RideDriverRegistry: URI already set"
        );
        s1.driverToDriverDetails[_driver].uri = _uri;
        s1.driverToDriverDetails[_driver].alliance = _alliance;

        emit ApplicantApproved(_driver);
    }

    // TODO: make internal fn to be called together with alliance governor creation?
    function approveNewAlly(
        address _driver,
        string memory _uri,
        address _alliance /** timelock */
    ) external {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl.STRATEGIST_ROLE
        );

        RideLibDriverDetails.StorageDriverDetails
            storage s1 = RideLibDriverDetails._storageDriverDetails();

        require(
            s1.allianceToDrivers[_alliance].length == 0,
            "RideDriverRegistry: First ally already set"
        );
        require(
            bytes(s1.driverToDriverDetails[_driver].uri).length == 0,
            "RideDriverRegistry: URI already set"
        );
        s1.driverToDriverDetails[_driver].uri = _uri;
        s1.driverToDriverDetails[_driver].alliance = _alliance;
        s1.allianceToDrivers[_alliance].push(_driver);

        emit ApplicantApproved(_driver);
    }
}
