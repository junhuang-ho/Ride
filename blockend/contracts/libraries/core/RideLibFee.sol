//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

library RideLibFee {
    bytes32 constant STORAGE_POSITION_FEE = keccak256("ds.fee");

    struct StorageFee {
        uint256 requestFee;
        uint256 baseFee;
        uint256 costPerMinute;
        mapping(uint256 => uint256) badgeToCostPerMetre;
    }

    function _storageFee() internal pure returns (StorageFee storage s) {
        bytes32 position = STORAGE_POSITION_FEE;
        assembly {
            s.slot := position
        }
    }

    /**
     * _getFare calculates the fare of a trip.
     *
     * @param _baseFee        | unit in token
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
        uint256 _baseFee,
        uint256 _metresTravelled,
        uint256 _minutesTaken,
        uint256 _costPerMetre,
        uint256 _costPerMinute
    ) internal pure returns (uint256) {
        return (_baseFee +
            (_metresTravelled * _costPerMetre) +
            (_minutesTaken * _costPerMinute));
    }
}
