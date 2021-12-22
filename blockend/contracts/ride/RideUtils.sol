//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/// @title Utility functions for RideHub
library RideUtils {
    /**
     * _getFare calculates the fare of a trip.
     *
     * @param _baseFare        | unit in token
     * @param _metresTravelled | unit in metre
     * @param _minutesTaken    | unit in minute
     * @param _costPerMetre    | unit in token
     * @param _costPerMinute   | unit in token
     *
     * @return Fare | unit in token
     *
     * _metresTravelled and _minutesTaken are rounded down,
     * for example, if _minutesTaken is 1.5 minutes (90 seconds) then round to 1 minute
     * if _minutesTaken is 0.5 minutes (30 seconds) then round to 0 minute
     */
    function _getFare(
        uint256 _baseFare,
        uint256 _metresTravelled,
        uint256 _minutesTaken,
        uint256 _costPerMetre,
        uint256 _costPerMinute
    ) internal pure returns (uint256) {
        return (_baseFare +
            (_metresTravelled * _costPerMetre) +
            (_minutesTaken * _costPerMinute));
    }

    /**
     * _calculateScore calculates score from driver's reputation details (see params of function)
     *
     * @param _metresTravelled | unit in metre
     * @param _countStart      | unitless integer
     * @param _countEnd        | unitless integer
     * @param _totalRating     | unitless integer
     * @param _countRating     | unitless integer
     * @param _maxRating       | unitless integer
     *
     * @return Driver's score to determine badge rank | unitless integer
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
     * note: Score is used to determine badge rank. To determine which score corresponds to which rank,
     *       can just determine from _metresTravelled, as other variables are just penalization factors.
     */
    function _calculateScore(
        uint256 _metresTravelled,
        uint256 _countStart,
        uint256 _countEnd,
        uint256 _totalRating,
        uint256 _countRating,
        uint256 _maxRating
    ) internal pure returns (uint256) {
        if (_countStart == 0) {
            return 0;
        } else {
            return
                (_metresTravelled * _countEnd * _totalRating) /
                (_countStart * _countRating * _maxRating);
        }
    }

    // function _shuffle(bytes32[] memory _value, uint256 _randomNumber)
    //     internal
    //     pure
    //     returns (bytes32[] memory)
    // {
    //     for (uint256 i = 0; i < _value.length; i++) {
    //         uint256 n = i + (_randomNumber % (_value.length - i)); // uint256(keccak256(abi.encodePacked(block.timestamp)))
    //         bytes32 temp = _value[n];
    //         _value[n] = _value[i];
    //         _value[i] = temp;
    //     }
    //     return _value;
    // }
}
