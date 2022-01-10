//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibFee} from "../../libraries/core/RideLibFee.sol";

import {IRideFee} from "../../interfaces/core/IRideFee.sol";

contract RideFee is IRideFee {
    /**
     * setRequestFee sets request fee
     *
     * @param _requestFee | unit in token
     */
    function setRequestFee(uint256 _requestFee) external override {
        RideLibFee._setRequestFee(_requestFee);
    }

    /**
     * setBaseFee sets base fee
     *
     * @param _baseFee | unit in token
     */
    function setBaseFee(uint256 _baseFee) external override {
        RideLibFee._setBaseFee(_baseFee);
    }

    /**
     * setCostPerMinute sets cost per minute
     *
     * @param _costPerMinute | unit in token
     */
    function setCostPerMinute(uint256 _costPerMinute) external override {
        RideLibFee._setCostPerMinute(_costPerMinute);
    }

    /**
     * setCostPerMetre sets cost per metre
     *
     * @param _costPerMetre | unit in token
     */
    function setCostPerMetre(uint256[] memory _costPerMetre) external override {
        RideLibFee._setCostPerMetre(_costPerMetre);
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
