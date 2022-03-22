//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/Fee.sol";
import "../../../hub/libraries/core/LibFee.sol";

contract TestFee is Fee {
    function sCurrencyKeyToCancellationFee_(address _hive, bytes32 _key)
        external
        view
        returns (uint256)
    {
        return
            LibFee._storageFee().hiveToCurrencyKeyToCancellationFee[_hive][
                _key
            ];
    }

    function sCurrencyKeyToBaseFee_(address _hive, bytes32 _key)
        external
        view
        returns (uint256)
    {
        return LibFee._storageFee().hiveToCurrencyKeyToBaseFee[_hive][_key];
    }

    function sCurrencyKeyToCostPerMinute_(address _hive, bytes32 _key)
        external
        view
        returns (uint256)
    {
        return
            LibFee._storageFee().hiveToCurrencyKeyToCostPerMinute[_hive][_key];
    }

    function sCurrencyKeyToBadgeToCostPerMetre_(address _hive, bytes32 _key)
        external
        view
        returns (uint256)
    {
        return
            LibFee._storageFee().hiveToCurrencyKeyToCostPerMetre[_hive][_key];
    }

    function setCancellationFee_(bytes32 _key, uint256 _cancellationFee)
        external
    {
        LibFee._setCancellationFee(_key, _cancellationFee);
    }

    function setBaseFee_(bytes32 _key, uint256 _baseFee) external {
        LibFee._setBaseFee(_key, _baseFee);
    }

    function setCostPerMinute_(bytes32 _key, uint256 _costPerMinute) external {
        LibFee._setCostPerMinute(_key, _costPerMinute);
    }

    function setCostPerMetre_(bytes32 _key, uint256 _costPerMetre) external {
        LibFee._setCostPerMetre(_key, _costPerMetre);
    }

    function getValue_(
        address _hive,
        bytes32 _key,
        uint256 _minutesTaken,
        uint256 _metresTravelled
    ) external view returns (uint256) {
        return LibFee._getValue(_hive, _key, _minutesTaken, _metresTravelled);
    }

    function getCancellationFee_(address _hive, bytes32 _key)
        external
        view
        returns (uint256)
    {
        return LibFee._getCancellationFee(_hive, _key);
    }
}
