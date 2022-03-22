//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/RideFee.sol";
import "../../../hub/libraries/core/RideLibFee.sol";

contract RideTestFee is RideFee {
    function sCurrencyKeyToCancellationFee_(address _alliance, bytes32 _key)
        external
        view
        returns (uint256)
    {
        return
            RideLibFee._storageFee().allianceToCurrencyKeyToCancellationFee[
                _alliance
            ][_key];
    }

    function sCurrencyKeyToBaseFee_(address _alliance, bytes32 _key)
        external
        view
        returns (uint256)
    {
        return
            RideLibFee._storageFee().allianceToCurrencyKeyToBaseFee[_alliance][
                _key
            ];
    }

    function sCurrencyKeyToCostPerMinute_(address _alliance, bytes32 _key)
        external
        view
        returns (uint256)
    {
        return
            RideLibFee._storageFee().allianceToCurrencyKeyToCostPerMinute[
                _alliance
            ][_key];
    }

    function sCurrencyKeyToBadgeToCostPerMetre_(address _alliance, bytes32 _key)
        external
        view
        returns (uint256)
    {
        return
            RideLibFee._storageFee().allianceToCurrencyKeyToCostPerMetre[
                _alliance
            ][_key];
    }

    function setCancellationFee_(bytes32 _key, uint256 _cancellationFee)
        external
    {
        RideLibFee._setCancellationFee(_key, _cancellationFee);
    }

    function setBaseFee_(bytes32 _key, uint256 _baseFee) external {
        RideLibFee._setBaseFee(_key, _baseFee);
    }

    function setCostPerMinute_(bytes32 _key, uint256 _costPerMinute) external {
        RideLibFee._setCostPerMinute(_key, _costPerMinute);
    }

    function setCostPerMetre_(bytes32 _key, uint256 _costPerMetre) external {
        RideLibFee._setCostPerMetre(_key, _costPerMetre);
    }

    function getFare_(
        address _alliance,
        bytes32 _key,
        uint256 _minutesTaken,
        uint256 _metresTravelled
    ) external view returns (uint256) {
        return
            RideLibFee._getFare(
                _alliance,
                _key,
                _minutesTaken,
                _metresTravelled
            );
    }

    function getCancellationFee_(address _alliance, bytes32 _key)
        external
        view
        returns (uint256)
    {
        return RideLibFee._getCancellationFee(_alliance, _key);
    }
}
