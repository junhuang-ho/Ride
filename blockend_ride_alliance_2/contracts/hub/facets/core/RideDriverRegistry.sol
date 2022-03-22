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

    /**
     * registerDriver registers approved applicants (has passed background check)
     *
     * @param _maxMetresPerTrip | unit in metre
     *
     * @custom:event RegisteredAsDriver
     */
    // TODO: test this not callable for driver switching alliances (after registered for second alliance)
    function registerAsDriver(uint256 _maxMetresPerTrip) external {
        RideLibDriver._requireNotDriver();
        RideLibTicket._requireNotActive();
        RideLibDriverDetails.StorageDriverDetails
            storage s1 = RideLibDriverDetails._storageDriverDetails();
        require(
            bytes(s1.driverToDriverDetails[msg.sender].uri).length != 0,
            "RideDriverRegistry: URI not set"
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

    function approveApplicant(address _driver, string memory _uri) external {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl.ALLIANCE_ROLE
        ); // alliance timelock

        RideLibDriverRegistry._approveApplicant(_driver, _uri, msg.sender);
    }

    // note: in case URI set wrongly
    function resetURI(address _driver, string memory _uri) external {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl.ALLIANCE_ROLE
        ); // alliance timelock

        RideLibDriverDetails
            ._storageDriverDetails()
            .driverToDriverDetails[_driver]
            .uri = _uri;
    }

    event SecededFromAlliance(address indexed sender, address alliance);

    function secedeFromAlliance() external {
        RideLibDriver._requireIsDriver();
        RideLibTicket._requireNotActive();

        RideLibDriverDetails.StorageDriverDetails
            storage s1 = RideLibDriverDetails._storageDriverDetails();

        address alliance = s1.driverToDriverDetails[msg.sender].alliance;
        require(
            alliance != address(0),
            "RideDriverRegistry: caller not in alliance"
        );

        s1.driverToDriverDetails[msg.sender].alliance = address(0);

        emit SecededFromAlliance(msg.sender, alliance);
    }
}
