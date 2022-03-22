//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/RideDriverDetails.sol";
import "../../../hub/libraries/core/RideLibDriverDetails.sol";

contract RideTestDriverDetails is RideDriverDetails {
    function sDriverToDriverDetails_(address _driver)
        external
        view
        returns (RideLibDriverDetails.DriverDetails memory)
    {
        return
            RideLibDriverDetails._storageDriverDetails().driverToDriverDetails[
                _driver
            ];
    }

    function sAllianceToDrivers_(address _alliance)
        external
        view
        returns (address[] memory)
    {
        return
            RideLibDriverDetails._storageDriverDetails().allianceToDrivers[
                _alliance
            ];
    }

    function ssDriverToDriverDetails_(
        address _driver,
        uint256 _id,
        string memory _uri,
        address _alliance,
        uint256 _maxMetresPerTrip,
        uint256 _metresTravelled,
        uint256 _countStart,
        uint256 _countEnd,
        uint256 _totalRating,
        uint256 _countRating
    ) external {
        RideLibDriverDetails.StorageDriverDetails
            storage s1 = RideLibDriverDetails._storageDriverDetails();
        s1.driverToDriverDetails[_driver].id = _id;
        s1.driverToDriverDetails[_driver].uri = _uri;
        s1.driverToDriverDetails[_driver].alliance = _alliance;
        s1.driverToDriverDetails[_driver].maxMetresPerTrip = _maxMetresPerTrip;
        s1.driverToDriverDetails[_driver].metresTravelled = _metresTravelled;
        s1.driverToDriverDetails[_driver].countStart = _countStart;
        s1.driverToDriverDetails[_driver].countEnd = _countEnd;
        s1.driverToDriverDetails[_driver].totalRating = _totalRating;
        s1.driverToDriverDetails[_driver].countRating = _countRating;
    }

    function ssAllianceToDrivers_(address _alliance, address[] memory _drivers)
        external
    {
        RideLibDriverDetails._storageDriverDetails().allianceToDrivers[
                _alliance
            ] = _drivers;
    }

    function calculateIndividualScore_(address _driver)
        external
        view
        returns (uint256)
    {
        return RideLibDriverDetails._calculateIndividualScore(_driver);
    }

    function getDriverScoreDetails_(address _driver)
        external
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return RideLibDriverDetails._getDriverScoreDetails(_driver);
    }
}
