//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibFee.sol";
import "../../libraries/core/LibCurrencyRegistry.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract Fee is IHubLibraryEvents {
    /**
     * setCancellationFee sets cancellation fee
     *
     * @param _key        | currency key
     * @param _cancellationFee | unit in token
     */
    function setCancellationFee(bytes32 _key, uint256 _cancellationFee)
        external
    {
        LibFee._setCancellationFee(_key, _cancellationFee);
    }

    /**
     * setBaseFee sets base fee
     *
     * @param _key     | currency key
     * @param _baseFee | unit in token
     */
    function setBaseFee(bytes32 _key, uint256 _baseFee) external {
        LibFee._setBaseFee(_key, _baseFee);
    }

    /**
     * setCostPerMinute sets cost per minute
     *
     * @param _key           | currency key
     * @param _costPerMinute | unit in token
     */
    function setCostPerMinute(bytes32 _key, uint256 _costPerMinute) external {
        LibFee._setCostPerMinute(_key, _costPerMinute);
    }

    /**
     * setCostPerMetre sets cost per metre
     *
     * @param _key          | currency key
     * @param _costPerMetre | unit in token
     */
    function setCostPerMetre(bytes32 _key, uint256 _costPerMetre) external {
        LibFee._setCostPerMetre(_key, _costPerMetre);
    }

    //////////////////////////////////////////////////////////////////////////////////
    ///// ---------------------------------------------------------------------- /////
    ///// -------------------------- getter functions -------------------------- /////
    ///// ---------------------------------------------------------------------- /////
    //////////////////////////////////////////////////////////////////////////////////

    function getValue(
        address _hive,
        bytes32 _key,
        uint256 _minutesTaken,
        uint256 _metresTravelled
    ) external view returns (uint256) {
        return LibFee._getValue(_hive, _key, _minutesTaken, _metresTravelled);
    }

    //
    // note:
    // the getter functions here needs _requireCurrencySupported
    // because a return of 0 value could be for a supported currency as well
    // without _requireCurrencySupported, if a key returns 0 value,
    // it won't be clear that if this key is supported or not
    //

    function getCancellationFee(address _hive, bytes32 _key)
        external
        view
        returns (uint256)
    {
        // note: currency supported check in internal fn (_getCancellationFee) called
        return LibFee._getCancellationFee(_hive, _key);
    }

    function getBaseFee(address _hive, bytes32 _key)
        external
        view
        returns (uint256)
    {
        LibCurrencyRegistry._requireCurrencySupported(_key);
        return LibFee._storageFee().hiveToCurrencyKeyToBaseFee[_hive][_key];
    }

    function getCostPerMinute(address _hive, bytes32 _key)
        external
        view
        returns (uint256)
    {
        LibCurrencyRegistry._requireCurrencySupported(_key);
        return
            LibFee._storageFee().hiveToCurrencyKeyToCostPerMinute[_hive][_key];
    }

    function getCostPerMetre(address _hive, bytes32 _key)
        external
        view
        returns (uint256)
    {
        LibCurrencyRegistry._requireCurrencySupported(_key);
        return
            LibFee._storageFee().hiveToCurrencyKeyToCostPerMetre[_hive][_key];
    }
}
