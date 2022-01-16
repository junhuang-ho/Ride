//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibFee} from "../../libraries/core/RideLibFee.sol";

import {IRideFee} from "../../interfaces/core/IRideFee.sol";

contract RideFee is IRideFee {
    /**
     * setRequestFee sets request fee
     *
     * @param _key        | currency key
     * @param _requestFee | unit in token
     */
    function setRequestFee(bytes32 _key, uint256 _requestFee)
        external
        override
    {
        RideLibFee._setRequestFee(_key, _requestFee);
    }

    /**
     * setBaseFee sets base fee
     *
     * @param _key     | currency key
     * @param _baseFee | unit in token
     */
    function setBaseFee(bytes32 _key, uint256 _baseFee) external override {
        RideLibFee._setBaseFee(_key, _baseFee);
    }

    /**
     * setCostPerMinute sets cost per minute
     *
     * @param _key           | currency key
     * @param _costPerMinute | unit in token
     */
    function setCostPerMinute(bytes32 _key, uint256 _costPerMinute)
        external
        override
    {
        RideLibFee._setCostPerMinute(_key, _costPerMinute);
    }

    /**
     * setCostPerMetre sets cost per metre
     *
     * @param _key          | currency key
     * @param _costPerMetre | unit in token
     */
    function setCostPerMetre(bytes32 _key, uint256[] memory _costPerMetre)
        external
        override
    {
        RideLibFee._setCostPerMetre(_key, _costPerMetre);
    }

    //////////////////////////////////////////////////////////////////////////////////
    ///// ---------------------------------------------------------------------- /////
    ///// -------------------------- getter functions -------------------------- /////
    ///// ---------------------------------------------------------------------- /////
    //////////////////////////////////////////////////////////////////////////////////

    function getFare(
        bytes32 _key,
        uint256 _badge,
        uint256 _minutesTaken,
        uint256 _metresTravelled
    ) external view override returns (uint256) {
        return
            RideLibFee._getFare(_key, _badge, _minutesTaken, _metresTravelled);
    }

    function getRequestFee(bytes32 _key)
        external
        view
        override
        returns (uint256)
    {
        return RideLibFee._getRequestFee(_key);
    }

    function getBaseFee(bytes32 _key) external view override returns (uint256) {
        return RideLibFee._getBaseFee(_key);
    }

    function getCostPerMinute(bytes32 _key)
        external
        view
        override
        returns (uint256)
    {
        return RideLibFee._getCostPerMinute(_key);
    }

    function getCostPerMetre(bytes32 _key, uint256 _badge)
        external
        view
        override
        returns (uint256)
    {
        return RideLibFee._getCostPerMetre(_key, _badge);
    }
}
