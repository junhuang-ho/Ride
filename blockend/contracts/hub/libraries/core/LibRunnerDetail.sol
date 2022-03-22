//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "./LibRater.sol";
import "../../libraries/utils/LibAccessControl.sol";

library LibRunnerDetail {
    bytes32 constant STORAGE_POSITION_RUNNERDETAIL =
        keccak256("ds.runnerdetail");

    /**
     * lifetime cumulative values of Runners
     */
    struct RunnerDetail {
        uint256 id;
        string uri;
        address hive;
        uint256 maxMetresPerTrip; // TODO: necessary? when ticket showed to runner, he can see destination and metres and choose to accept or not!!
        uint256 metresTravelled;
        uint256 countStart;
        uint256 countEnd;
        uint256 totalRating;
        uint256 countRating;
    }

    struct StorageRunnerDetail {
        mapping(address => RunnerDetail) runnerToRunnerDetail;
        // NOTE: on hiveToRunners
        // any state change operation is to be strictly "push" type
        // otherwise any read / loop strictly used in external functions
        // for example RunnerDetail.calculateCollectiveScore
        // mapping(address => address[]) hiveToRunners;
    }

    function _storageRunnerDetail()
        internal
        pure
        returns (StorageRunnerDetail storage s)
    {
        bytes32 position = STORAGE_POSITION_RUNNERDETAIL;
        assembly {
            s.slot := position
        }
    }

    /**
     * _calculateScore calculates score from runner's reputation detail (see params of function)
     *
     *
     * @return Runner's score | unitless integer
     *
     * Derive Runner's Score Formula:-
     *
     * Score is fundamentally determined based on distance travelled, where the more trips a runner makes,
     * the higher the score. Thus, the base score is directly proportional to:
     *
     * _metresTravelled
     *
     * where _metresTravelled is the total cumulative distance covered by the runner over all trips made.
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
     * Runner score should also be influenced by passenger's rating of the overall trip, thus, the base
     * score is further penalized by the average runner rating over all trips, given by:
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
    function _calculateRunnerScore(address _runner)
        internal
        view
        returns (uint256)
    {
        StorageRunnerDetail storage s1 = _storageRunnerDetail();

        (
            uint256 metresTravelled,
            uint256 countStart,
            uint256 countEnd,
            uint256 totalRating,
            uint256 countRating,
            uint256 maxRating
        ) = _getRunnerScoreDetail(_runner);

        if (countStart == 0) {
            return 0;
        } else {
            return
                (metresTravelled * countEnd * totalRating) /
                (countStart * countRating * maxRating);
        }
    }

    function _getRunnerScoreDetail(address _runner)
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
        StorageRunnerDetail storage s1 = _storageRunnerDetail();

        uint256 metresTravelled = s1
            .runnerToRunnerDetail[_runner]
            .metresTravelled;
        uint256 countStart = s1.runnerToRunnerDetail[_runner].countStart;
        uint256 countEnd = s1.runnerToRunnerDetail[_runner].countEnd;
        uint256 totalRating = s1.runnerToRunnerDetail[_runner].totalRating;
        uint256 countRating = s1.runnerToRunnerDetail[_runner].countRating;
        uint256 maxRating = LibRater._storageRater().ratingMax;

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
