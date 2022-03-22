//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/RideLibRater.sol";
import "../../libraries/utils/RideLibAccessControl.sol";

library RideLibDriverDetails {
    bytes32 constant STORAGE_POSITION_DRIVERDETAILS =
        keccak256("ds.driverdetails");

    /**
     * lifetime cumulative values of drivers
     */
    struct DriverDetails {
        uint256 id;
        string uri;
        address alliance;
        uint256 maxMetresPerTrip; // TODO: necessary? when ticket showed to driver, he can see destination and metres and choose to accept or not!!
        uint256 metresTravelled;
        uint256 countStart;
        uint256 countEnd;
        uint256 totalRating;
        uint256 countRating;
    }

    struct StorageDriverDetails {
        mapping(address => DriverDetails) driverToDriverDetails;
        // NOTE: on allianceToDrivers
        // any state change operation is to be strictly "push" type
        // otherwise any read / loop strictly used in external functions
        // for example RideDriverDetails.calculateCollectiveScore
        mapping(address => address[]) allianceToDrivers;
    }

    function _storageDriverDetails()
        internal
        pure
        returns (StorageDriverDetails storage s)
    {
        bytes32 position = STORAGE_POSITION_DRIVERDETAILS;
        assembly {
            s.slot := position
        }
    }

    /**
     * _calculateScore calculates score from driver's reputation details (see params of function)
     *
     *
     * @return Driver's score | unitless integer
     *
     * Derive Driver's Score Formula:-
     *
     * Score is fundamentally determined based on distance travelled, where the more trips a driver makes,
     * the higher the score. Thus, the base score is directly proportional to:
     *
     * _metresTravelled
     *
     * where _metresTravelled is the total cumulative distance covered by the driver over all trips made.
     *
     * To encourage the completion of trips, the base score would be penalized by the amount of incomplete
     * trips, using:
     *
     *  _countEnd / _countStart
     *
     * which is the ratio of number of trips complete to the number of trips started. This gives:
     *
     * _metresTravelled * (_countEnd / _countStart)
     *
     * Driver score should also be influenced by passenger's rating of the overall trip, thus, the base
     * score is further penalized by the average driver rating over all trips, given by:
     *
     * _totalRating / _countRating
     *
     * where _totalRating is the cumulative rating value by passengers over all trips and _countRating is
     * the total number of rates by those passengers. The rating penalization is also divided by the max
     * possible rating score to make the penalization a ratio:
     *
     * (_totalRating / _countRating) / _maxRating
     *
     * The score formula is given by:
     *
     * _metresTravelled * (_countEnd / _countStart) * ((_totalRating / _countRating) / _maxRating)
     *
     * which simplifies to:
     *
     * (_metresTravelled * _countEnd * _totalRating) / (_countStart * _countRating * _maxRating)
     *
     * note: Solidity rounds down return value to the nearest whole number.
     *
     * note: To determine which score corresponds to which rank,
     *       can just determine from _metresTravelled, as other variables are just penalization factors.
     */
    function _calculateIndividualScore(address _driver)
        internal
        view
        returns (uint256)
    {
        StorageDriverDetails storage s1 = _storageDriverDetails();

        (
            uint256 metresTravelled,
            uint256 countStart,
            uint256 countEnd,
            uint256 totalRating,
            uint256 countRating,
            uint256 maxRating
        ) = _getDriverScoreDetails(_driver);

        if (countStart == 0) {
            return 0;
        } else {
            return
                (metresTravelled * countEnd * totalRating) /
                (countStart * countRating * maxRating);
        }
    }

    function _getDriverScoreDetails(address _driver)
        internal
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
        StorageDriverDetails storage s1 = _storageDriverDetails();

        uint256 metresTravelled = s1
            .driverToDriverDetails[_driver]
            .metresTravelled;
        uint256 countStart = s1.driverToDriverDetails[_driver].countStart;
        uint256 countEnd = s1.driverToDriverDetails[_driver].countEnd;
        uint256 totalRating = s1.driverToDriverDetails[_driver].totalRating;
        uint256 countRating = s1.driverToDriverDetails[_driver].countRating;
        uint256 maxRating = RideLibRater._storageRater().ratingMax;

        return (
            metresTravelled,
            countStart,
            countEnd,
            totalRating,
            countRating,
            maxRating
        );
    }
}
