//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/RideLibFee.sol";
import "../../libraries/core/RideLibCurrencyRegistry.sol";

contract RideFee {
    /**
     * setCancellationFee sets cancellation fee
     *
     * @param _key        | currency key
     * @param _cancellationFee | unit in token
     */
    function setCancellationFee(bytes32 _key, uint256 _cancellationFee)
        external
    {
        RideLibFee._setCancellationFee(_key, _cancellationFee);
    }

    /**
     * setBaseFee sets base fee
     *
     * @param _key     | currency key
     * @param _baseFee | unit in token
     */
    function setBaseFee(bytes32 _key, uint256 _baseFee) external {
        RideLibFee._setBaseFee(_key, _baseFee);
    }

    /**
     * setCostPerMinute sets cost per minute
     *
     * @param _key           | currency key
     * @param _costPerMinute | unit in token
     */
    function setCostPerMinute(bytes32 _key, uint256 _costPerMinute) external {
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
    ) external view returns (uint256) {
        return
            RideLibFee._getFare(_key, _badge, _minutesTaken, _metresTravelled);
    }

    function getCancellationFee(bytes32 _key) external view returns (uint256) {
        // note: currency supported check in internal fn (_getCancellationFee) called
        return RideLibFee._getCancellationFee(_key);
    }

    function getBaseFee(bytes32 _key) external view returns (uint256) {
        RideLibCurrencyRegistry._requireCurrencySupported(_key);
        return RideLibFee._storageFee().currencyKeyToBaseFee[_key];
    }

    function getCostPerMinute(bytes32 _key) external view returns (uint256) {
        RideLibCurrencyRegistry._requireCurrencySupported(_key);
        return RideLibFee._storageFee().currencyKeyToCostPerMinute[_key];
    }

    function getCostPerMetre(bytes32 _key, uint256 _badge)
        external
        view
        returns (uint256)
    {
        RideLibCurrencyRegistry._requireCurrencySupported(_key);
        return
            RideLibFee._storageFee().currencyKeyToBadgeToCostPerMetre[_key][
                _badge
            ];
    }
}
