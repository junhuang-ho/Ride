//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/RideLibDriverDetails.sol";

contract RideDriverDetails {
    function getDriverToDriverDetails(address _driver)
        external
        view
        returns (RideLibDriverDetails.DriverDetails memory)
    {
        return
            RideLibDriverDetails._storageDriverDetails().driverToDriverDetails[
                _driver
            ];
    }

    function calculateIndividualScore(address _driver)
        external
        view
        returns (uint256)
    {
        return RideLibDriverDetails._calculateIndividualScore(_driver);
    }

    function calculateCollectiveScore(address _alliance)
        external
        view
        returns (uint256)
    {
        address[] memory drivers = RideLibDriverDetails
            ._storageDriverDetails()
            .allianceToDrivers[_alliance];

        uint256 metresTravelled;
        uint256 countStart;
        uint256 countEnd;
        uint256 totalRating;
        uint256 countRating;
        uint256 maxRating;
        for (uint256 i = 0; i < drivers.length; i++) {
            (
                uint256 _metresTravelled,
                uint256 _countStart,
                uint256 _countEnd,
                uint256 _totalRating,
                uint256 _countRating,
                uint256 _maxRating
            ) = RideLibDriverDetails._getDriverScoreDetails(drivers[i]);

            metresTravelled += _metresTravelled;
            countStart += _countStart;
            countEnd += _countEnd;
            totalRating += _totalRating;
            countRating += _countRating;
            maxRating += _maxRating;
        }

        if (countStart == 0) {
            return 0;
        } else {
            return
                (metresTravelled * countEnd * totalRating) /
                (countStart * countRating * maxRating);
        }
    }
}
