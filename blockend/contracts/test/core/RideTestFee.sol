//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideFee} from "../../facets/core/RideFee.sol";
import {RideLibFee} from "../../libraries/core/RideLibFee.sol";

contract RideTestFee is RideFee {
    function sCurrencyKeyToRequestFee_(bytes32 _key)
        external
        view
        returns (uint256)
    {
        return RideLibFee._storageFee().currencyKeyToRequestFee[_key];
    }

    function sCurrencyKeyToBaseFee_(bytes32 _key)
        external
        view
        returns (uint256)
    {
        return RideLibFee._storageFee().currencyKeyToBaseFee[_key];
    }

    function sCurrencyKeyToCostPerMinute_(bytes32 _key)
        external
        view
        returns (uint256)
    {
        return RideLibFee._storageFee().currencyKeyToCostPerMinute[_key];
    }

    function sCurrencyKeyToBadgeToCostPerMetre_(bytes32 _key, uint256 _badge)
        external
        view
        returns (uint256)
    {
        return
            RideLibFee._storageFee().currencyKeyToBadgeToCostPerMetre[_key][
                _badge
            ];
    }

    function setRequestFee_(bytes32 _key, uint256 _requestFee) external {
        RideLibFee._setRequestFee(_key, _requestFee);
    }

    function setBaseFee_(bytes32 _key, uint256 _baseFee) external {
        RideLibFee._setBaseFee(_key, _baseFee);
    }

    function setCostPerMinute_(bytes32 _key, uint256 _costPerMinute) external {
        RideLibFee._setCostPerMinute(_key, _costPerMinute);
    }

    function setCostPerMetre_(bytes32 _key, uint256[] memory _costPerMetre)
        external
    {
        RideLibFee._setCostPerMetre(_key, _costPerMetre);
    }

    function getFare_(
        bytes32 _key,
        uint256 _badge,
        uint256 _minutesTaken,
        uint256 _metresTravelled
    ) external view returns (uint256) {
        return
            RideLibFee._getFare(_key, _badge, _minutesTaken, _metresTravelled);
    }

    function getRequestFee_(bytes32 _key) external view returns (uint256) {
        return RideLibFee._getRequestFee(_key);
    }

    // getBaseFee(bytes32 _key) returns (uint256);
    // getCostPerMinute(bytes32 _key) returns (uint256);
    // getCostPerMetre(bytes32 _key, uint256 _badge) returns (uint256);
}
