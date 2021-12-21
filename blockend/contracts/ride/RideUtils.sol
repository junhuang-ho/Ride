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
     * @param _totalRating     | unitless integer
     * @param _countStart      | unitless integer
     * @param _countEnd        | unitless integer
     *
     * @return Driver's score to determine badge rank | unitless integer
     *
     * Derive Driver's Score Formula
     * metresTravelled == m
     * countStart == s
     * countEnd == e
     * totalRating == rt (sum(r1, r2, ... rN)
     * countRating == rc
     *
     * baseScore = m * e (accounts for [short distance | high count] && [long distance | low count])
     * apply weighting ratio to baseScore: baseScore * e/s
     * averageRating = rt/rc
     * apply weighting ratio to averageRating: averageRating * rc/e
     * combined score: m*e*(e/s) * (rt/rc)*(rc/e)
     * simplify: (m*e*rt)/s
     */
    function _calculateScore(
        uint256 _metresTravelled,
        uint256 _totalRating,
        uint256 _countStart,
        uint256 _countEnd
    ) internal pure returns (uint256) {
        if (_countStart == 0) {
            return 0;
        } else {
            return (_metresTravelled * _totalRating * _countEnd) / _countStart;
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
