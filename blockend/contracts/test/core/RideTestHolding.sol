//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../diamondRideHub/facets/core/RideHolding.sol";
import "../../diamondRideHub/libraries/core/RideLibHolding.sol";

contract RideTestHolding is RideHolding {
    function sUserToCurrencyKeyToHolding_(address _user, bytes32 _key)
        external
        view
        returns (uint256)
    {
        return
            RideLibHolding._storageHolding().userToCurrencyKeyToHolding[_user][
                _key
            ];
    }

    function ssUserToCurrencyKeyToHolding_(
        address _user,
        bytes32 _key,
        uint256 _holding
    ) external {
        RideLibHolding._storageHolding().userToCurrencyKeyToHolding[_user][
                _key
            ] = _holding;
    }

    function transferCurrency_(
        bytes32 _tixId,
        bytes32 _key,
        uint256 _amount,
        address _decrease,
        address _increase
    ) external {
        RideLibHolding._transferCurrency(
            _tixId,
            _key,
            _amount,
            _decrease,
            _increase
        );
    }
}
