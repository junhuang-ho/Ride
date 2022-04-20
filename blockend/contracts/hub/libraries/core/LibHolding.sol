//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "./LibCurrencyRegistry.sol";
import "./LibJobBoard.sol";

library LibHolding {
    bytes32 constant STORAGE_POSITION_HOLDING = keccak256("ds.holding");

    struct StorageHolding {
        mapping(address => mapping(bytes32 => uint256)) userToCurrencyKeyToHolding;
        mapping(address => mapping(bytes32 => uint256)) userToCurrencyKeyToVault;
    }

    function _storageHolding()
        internal
        pure
        returns (StorageHolding storage s)
    {
        bytes32 position = STORAGE_POSITION_HOLDING;
        assembly {
            s.slot := position
        }
    }

    function _requireSufficientHolding(bytes32 _key, uint256 _amount)
        internal
        view
    {
        require(
            _amount <=
                _storageHolding().userToCurrencyKeyToHolding[msg.sender][_key],
            "LibHolding: insufficient holding"
        );
    }

    event FundsLocked(address indexed sender, bytes32 key, uint256 amount);

    function _lockFunds(bytes32 _key, uint256 _amount) internal {
        StorageHolding storage s1 = _storageHolding();

        s1.userToCurrencyKeyToHolding[msg.sender][_key] -= _amount;
        s1.userToCurrencyKeyToVault[msg.sender][_key] += _amount;

        emit FundsLocked(msg.sender, _key, _amount);
    }

    event FundsUnlocked(
        address indexed sender,
        address decrease,
        address increase,
        bytes32 key,
        uint256 amount
    );

    function _unlockFunds(
        bytes32 _key,
        uint256 _amount,
        address _decrease,
        address _increase
    ) internal {
        StorageHolding storage s1 = _storageHolding();

        s1.userToCurrencyKeyToVault[_decrease][_key] -= _amount;
        s1.userToCurrencyKeyToHolding[_increase][_key] += _amount;

        emit FundsUnlocked(msg.sender, _decrease, _increase, _key, _amount);
    }

    function _getFundsLockingDetail(bytes32 _jobId)
        internal
        view
        returns (
            address,
            address,
            bytes32,
            uint256,
            uint256
        )
    {
        LibJobBoard.StorageJobBoard storage s1 = LibJobBoard._storageJobBoard();

        address requester = s1.jobIdToJobDetail[_jobId].requester;
        address runner = s1.jobIdToJobDetail[_jobId].runner;
        bytes32 keyTransact = s1.jobIdToJobDetail[_jobId].keyTransact;
        uint256 value = s1.jobIdToJobDetail[_jobId].value;
        uint256 cancellationFee = s1.jobIdToJobDetail[_jobId].cancellationFee;

        return (requester, runner, keyTransact, value, cancellationFee);
    }

    function _sortFundsUnlocking(
        bytes32 _jobId,
        bool _valueIsTransferred,
        bool _payerIsRequester
    ) internal {
        (
            address requester,
            address runner,
            bytes32 keyTransact,
            uint256 value,
            uint256 cancellationFee
        ) = _getFundsLockingDetail(_jobId);

        uint256 transferredAmount;
        uint256 payerRefundAmount;
        uint256 payeeRefundAmount;
        address payer;
        address payee;

        if (_valueIsTransferred) {
            transferredAmount = value;
            payerRefundAmount = cancellationFee;
        } else {
            transferredAmount = cancellationFee;
            payerRefundAmount = value;
        }
        payeeRefundAmount = value + cancellationFee;

        if (_payerIsRequester) {
            payer = requester;
            payee = runner;
        } else {
            payer = runner;
            payee = requester;
        }

        _unlockFunds(keyTransact, transferredAmount, payer, payee);
        _unlockFunds(keyTransact, payerRefundAmount, payer, payer);
        _unlockFunds(keyTransact, payeeRefundAmount, payee, payee);
    }
}
