//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/utils/LibAccessControl.sol";
import "../../libraries/core/LibCurrencyRegistry.sol";

library LibFee {
    bytes32 constant STORAGE_POSITION_FEE = keccak256("ds.fee");

    struct StorageFee {
        mapping(address => mapping(bytes32 => uint256)) hiveToCurrencyKeyToCancellationFee;
        mapping(address => mapping(bytes32 => uint256)) hiveToCurrencyKeyToBaseFee;
        mapping(address => mapping(bytes32 => uint256)) hiveToCurrencyKeyToCostPerMinute;
        mapping(address => mapping(bytes32 => uint256)) hiveToCurrencyKeyToCostPerMetre;
    }

    function _storageFee() internal pure returns (StorageFee storage s) {
        bytes32 position = STORAGE_POSITION_FEE;
        assembly {
            s.slot := position
        }
    }

    event FeeSetCancellation(address indexed sender, uint256 fee);

    /**
     * _setCancellationFee sets cancellation fee
     *
     * @param _key        | currency key
     * @param _cancellationFee | unit in Wei
     */
    function _setCancellationFee(bytes32 _key, uint256 _cancellationFee)
        internal
    {
        LibAccessControl._requireOnlyRole(LibAccessControl.HIVE_ROLE);
        LibCurrencyRegistry._requireCurrencySupported(_key);
        _storageFee().hiveToCurrencyKeyToCancellationFee[msg.sender][
                _key
            ] = _cancellationFee; // input format: token in Wei // TODO: make sure msg.sender is subDAO timelock address

        emit FeeSetCancellation(msg.sender, _cancellationFee);
    }

    event FeeSetBase(address indexed sender, uint256 fee);

    /**
     * _setBaseFee sets base fee
     *
     * @param _key     | currency key
     * @param _baseFee | unit in Wei
     */
    function _setBaseFee(bytes32 _key, uint256 _baseFee) internal {
        LibAccessControl._requireOnlyRole(LibAccessControl.HIVE_ROLE);
        LibCurrencyRegistry._requireCurrencySupported(_key);
        _storageFee().hiveToCurrencyKeyToBaseFee[msg.sender][_key] = _baseFee; // input format: token in Wei

        emit FeeSetBase(msg.sender, _baseFee);
    }

    event FeeSetCostPerMinute(address indexed sender, uint256 fee);

    /**
     * _setCostPerMinute sets cost per minute
     *
     * @param _key           | currency key
     * @param _costPerMinute | unit in Wei
     */
    function _setCostPerMinute(bytes32 _key, uint256 _costPerMinute) internal {
        LibAccessControl._requireOnlyRole(LibAccessControl.HIVE_ROLE);
        LibCurrencyRegistry._requireCurrencySupported(_key);
        _storageFee().hiveToCurrencyKeyToCostPerMinute[msg.sender][
                _key
            ] = _costPerMinute; // input format: token in Wei

        emit FeeSetCostPerMinute(msg.sender, _costPerMinute);
    }

    event FeeSetCostPerMetre(address indexed sender, uint256 fee);

    /**
     * _setCostPerMetre sets cost per metre
     *
     * @param _key          | currency key
     * @param _costPerMetre | unit in Wei
     */
    function _setCostPerMetre(bytes32 _key, uint256 _costPerMetre) internal {
        LibAccessControl._requireOnlyRole(LibAccessControl.HIVE_ROLE);
        LibCurrencyRegistry._requireCurrencySupported(_key);
        _storageFee().hiveToCurrencyKeyToCostPerMetre[msg.sender][
                _key
            ] = _costPerMetre; // input format: token in Wei

        emit FeeSetCostPerMetre(msg.sender, _costPerMetre);
    }

    /**
     * _getValue calculates the value of a trip.
     *
     * @param _key             | currency key
     * @param _metresTravelled | unit in metre
     * @param _minutesTaken    | unit in minute
     *
     * @return Value | unit in Wei
     *
     * _metresTravelled and _minutesTaken are rounded down,
     * for example, if _minutesTaken is 1.5 minutes (90 seconds) then round to 1 minute
     * if _minutesTaken is 0.5 minutes (30 seconds) then round to 0 minute
     */
    function _getValue(
        address _hive,
        bytes32 _key,
        uint256 _minutesTaken,
        uint256 _metresTravelled
    ) internal view returns (uint256) {
        LibCurrencyRegistry._requireCurrencySupported(_key);
        StorageFee storage s1 = _storageFee();

        uint256 baseFee = s1.hiveToCurrencyKeyToBaseFee[_hive][_key]; // not much diff in terms of gas to assign temporary variable vs using directly (below)
        uint256 costPerMinute = s1.hiveToCurrencyKeyToCostPerMinute[_hive][
            _key
        ];
        uint256 costPerMetre = s1.hiveToCurrencyKeyToCostPerMetre[_hive][_key];

        return (baseFee +
            (costPerMinute * _minutesTaken) +
            (costPerMetre * _metresTravelled));
    }

    function _getCancellationFee(address _hive, bytes32 _key)
        internal
        view
        returns (uint256)
    {
        LibCurrencyRegistry._requireCurrencySupported(_key);
        return _storageFee().hiveToCurrencyKeyToCancellationFee[_hive][_key];
    }
}
