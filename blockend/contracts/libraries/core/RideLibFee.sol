//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibOwnership} from "../../libraries/utils/RideLibOwnership.sol";
import {RideLibBadge} from "../../libraries/core/RideLibBadge.sol";

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

    event FeeSetRequest(address indexed sender, uint256 fee);

    /**
     * _setRequestFee sets request fee
     *
     * @param _requestFee | unit in token
     */
    function _setRequestFee(uint256 _requestFee) internal {
        RideLibOwnership.requireIsContractOwner();
        StorageFee storage s1 = _storageFee();
        s1.requestFee = _requestFee; // input format: token in Wei

        emit FeeSetRequest(msg.sender, _requestFee);
    }

    event FeeSetBase(address indexed sender, uint256 fee);

    /**
     * _setBaseFee sets base fee
     *
     * @param _baseFee | unit in token
     */
    function _setBaseFee(uint256 _baseFee) internal {
        RideLibOwnership.requireIsContractOwner();
        StorageFee storage s1 = _storageFee();
        s1.baseFee = _baseFee; // input format: token in Wei

        emit FeeSetBase(msg.sender, _baseFee);
    }

    event FeeSetCostPerMinute(address indexed sender, uint256 fee);

    /**
     * _setCostPerMinute sets cost per minute
     *
     * @param _costPerMinute | unit in token
     */
    function _setCostPerMinute(uint256 _costPerMinute) internal {
        RideLibOwnership.requireIsContractOwner();
        StorageFee storage s1 = _storageFee();
        s1.costPerMinute = _costPerMinute; // input format: token in Wei

        emit FeeSetCostPerMinute(msg.sender, _costPerMinute);
    }

    event FeeSetCostPerMetre(address indexed sender, uint256[] fee);

    /**
     * _setCostPerMetre sets cost per metre
     *
     * @param _costPerMetre | unit in token
     */
    function _setCostPerMetre(uint256[] memory _costPerMetre) internal {
        RideLibOwnership.requireIsContractOwner();
        require(
            _costPerMetre.length == RideLibBadge._getBadgesCount(),
            "_costPerMetre.length must be equal Badges"
        );
        StorageFee storage s1 = _storageFee();
        for (uint256 i = 0; i < _costPerMetre.length; i++) {
            s1.badgeToCostPerMetre[i] = _costPerMetre[i]; // input format: token in Wei // rounded down
        }

        emit FeeSetCostPerMetre(msg.sender, _costPerMetre);
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
