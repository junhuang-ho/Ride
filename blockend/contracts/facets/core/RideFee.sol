//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibFee} from "../../libraries/core/RideLibFee.sol";
import {RideLibBadge} from "../../libraries/core/RideLibBadge.sol";
import {RideLibOwnership} from "../../libraries/utils/RideLibOwnership.sol";

import {IRideFee} from "../../interfaces/core/IRideFee.sol";

contract RideFee is IRideFee {
    event FeeSetRequest(address indexed sender, uint256 fee);

    /**
     * setRequestFee sets request fee
     *
     * @param _requestFee | unit in token
     */
    function setRequestFee(uint256 _requestFee) public override {
        RideLibOwnership.requireIsContractOwner();
        RideLibFee.StorageFee storage s1 = RideLibFee._storageFee();
        s1.requestFee = _requestFee; // input format: token in Wei

        emit FeeSetRequest(msg.sender, _requestFee);
    }

    event FeeSetBase(address indexed sender, uint256 fee);

    /**
     * setBaseFee sets base fee
     *
     * @param _baseFee | unit in token
     */
    function setBaseFee(uint256 _baseFee) public override {
        RideLibOwnership.requireIsContractOwner();
        RideLibFee.StorageFee storage s1 = RideLibFee._storageFee();
        s1.baseFee = _baseFee; // input format: token in Wei

        emit FeeSetBase(msg.sender, _baseFee);
    }

    event FeeSetCostPerMinute(address indexed sender, uint256 fee);

    /**
     * setCostPerMinute sets cost per minute
     *
     * @param _costPerMinute | unit in token
     */
    function setCostPerMinute(uint256 _costPerMinute) public override {
        RideLibOwnership.requireIsContractOwner();
        RideLibFee.StorageFee storage s1 = RideLibFee._storageFee();
        s1.costPerMinute = _costPerMinute; // input format: token in Wei

        emit FeeSetCostPerMinute(msg.sender, _costPerMinute);
    }

    event FeeSetCostPerMetre(address indexed sender, uint256[] fee);

    /**
     * setCostPerMetre sets cost per metre
     *
     * @param _costPerMetre | unit in token
     */
    function setCostPerMetre(uint256[] memory _costPerMetre) public override {
        RideLibOwnership.requireIsContractOwner();
        require(
            _costPerMetre.length == RideLibBadge._getBadgesCount(),
            "_costPerMetre.length must be equal Badges"
        );
        RideLibFee.StorageFee storage s1 = RideLibFee._storageFee();
        for (uint256 i = 0; i < _costPerMetre.length; i++) {
            s1.badgeToCostPerMetre[i] = _costPerMetre[i]; // input format: token in Wei // rounded down
        }

        emit FeeSetCostPerMetre(msg.sender, _costPerMetre);
    }

    //////////////////////////////////////////////////////////////////////////////////
    ///// ---------------------------------------------------------------------- /////
    ///// -------------------------- getter functions -------------------------- /////
    ///// ---------------------------------------------------------------------- /////
    //////////////////////////////////////////////////////////////////////////////////

    function getRequestFee() external view override returns (uint256) {
        return RideLibFee._storageFee().requestFee;
    }

    function getBaseFee() external view override returns (uint256) {
        return RideLibFee._storageFee().baseFee;
    }

    function getCostPerMinute() external view override returns (uint256) {
        return RideLibFee._storageFee().costPerMinute;
    }

    function getBadgeToCostPerMetre(uint256 _badge)
        external
        view
        override
        returns (uint256)
    {
        return RideLibFee._storageFee().badgeToCostPerMetre[_badge];
    }
}
