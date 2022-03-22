//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/Holding.sol";
import "../../../hub/libraries/core/LibHolding.sol";

contract TestHolding is Holding {
    function sUserToCurrencyKeyToHolding_(address _user, bytes32 _key)
        external
        view
        returns (uint256)
    {
        return
            LibHolding._storageHolding().userToCurrencyKeyToHolding[_user][
                _key
            ];
    }

    function sUserToCurrencyKeyToVault_(address _user, bytes32 _key)
        external
        view
        returns (uint256)
    {
        return
            LibHolding._storageHolding().userToCurrencyKeyToVault[_user][_key];
    }

    function ssUserToCurrencyKeyToHolding_(
        address _user,
        bytes32 _key,
        uint256 _holding
    ) external {
        LibHolding._storageHolding().userToCurrencyKeyToHolding[_user][
                _key
            ] = _holding;
    }

    function ssUserToCurrencyKeyToVault_(
        address _user,
        bytes32 _key,
        uint256 _vault
    ) external {
        LibHolding._storageHolding().userToCurrencyKeyToVault[_user][
            _key
        ] = _vault;
    }

    function requireSufficientHolding_(bytes32 _key, uint256 _amount)
        external
        view
        returns (bool)
    {
        LibHolding._requireSufficientHolding(_key, _amount);
        return true;
    }

    function lockFunds_(bytes32 _key, uint256 _amount) external {
        LibHolding._lockFunds(_key, _amount);
    }

    function unlockFunds_(
        bytes32 _key,
        uint256 _amount,
        address _decrease,
        address _increase
    ) external {
        LibHolding._unlockFunds(_key, _amount, _decrease, _increase);
    }

    function getFundsLockingDetail_(bytes32 _jobId)
        external
        view
        returns (
            address,
            address,
            bytes32,
            uint256,
            uint256
        )
    {
        return LibHolding._getFundsLockingDetail(_jobId);
    }

    function sortFundsUnlocking_(
        bytes32 _jobId,
        bool _valueIsTransferred,
        bool _payerIsRequestor
    ) external {
        LibHolding._sortFundsUnlocking(
            _jobId,
            _valueIsTransferred,
            _payerIsRequestor
        );
    }
}
