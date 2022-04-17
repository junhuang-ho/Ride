//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibJobBoard.sol";
import "../../libraries/core/LibHolding.sol";
import "../../libraries/core/LibRequestor.sol";
import "../../libraries/core/LibRunnerRegistry.sol";
import "../../libraries/core/LibExchange.sol";
import "../../libraries/core/LibFee.sol";
import "../../libraries/core/LibPenalty.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract Requestor is IHubLibraryEvents {
    event RequestRunner(address indexed sender, bytes32 indexed jobId);

    function requestRunner(
        address _hive,
        address _package,
        bytes32 _locationPackage,
        bytes32 _locationDestination,
        bytes32 _keyLocal,
        bytes32 _keyTransact,
        uint256 _minutes,
        uint256 _metres
    ) external {
        LibRunnerRegistry._requireNotRunner();
        LibPenalty._requireNotBanned(_hive);
        // RideLibExchange._requireXPerYPriceFeedSupported(_keyLocal, _keyTransact); // note: double check on currency supported (check is already done indirectly by _getCancellationFee & _getFare, directly by currency conversion)
        // /**
        //  * Note: if frontend implement correctly, removing this line
        //  *       RideLibExchange._requireXPerYPriceFeedSupported(_keyLocal, _keyPay);
        //  *       would NOT be a problem
        //  */

        // get value / cancellation fee
        uint256 cancellationFeeLocal = LibFee._getCancellationFee(
            _hive,
            _keyLocal
        );
        uint256 valueLocal = LibFee._getValue(
            _hive,
            _keyLocal,
            _minutes,
            _metres
        );

        // convert currency
        uint256 cancellationFeeTransact;
        uint256 valueTransact;
        if (_keyLocal == _keyTransact) {
            // when local is in crypto token
            cancellationFeeTransact = cancellationFeeLocal;
            valueTransact = valueLocal;
        } else {
            cancellationFeeTransact = LibExchange._convertCurrency(
                _keyLocal,
                _keyTransact,
                cancellationFeeLocal
            );
            valueTransact = LibExchange._convertCurrency(
                _keyLocal,
                _keyTransact,
                valueLocal
            );
        }

        LibHolding._requireSufficientHolding(
            _keyTransact,
            valueTransact + cancellationFeeTransact
        );
        LibHolding._lockFunds(
            _keyTransact,
            valueTransact + cancellationFeeTransact
        );

        bytes32 jobId = keccak256(abi.encode(msg.sender, block.timestamp)); // TODO: make more unique? // encode gas seems less? but diff very small

        LibJobBoard.StorageJobBoard storage s1 = LibJobBoard._storageJobBoard();

        s1.jobIdToJobDetail[jobId].requestor = msg.sender;
        s1.jobIdToJobDetail[jobId].package = _package;
        s1.jobIdToJobDetail[jobId].locationPackage = _locationPackage;
        s1.jobIdToJobDetail[jobId].locationDestination = _locationDestination;
        s1.jobIdToJobDetail[jobId].keyLocal = _keyLocal;
        s1.jobIdToJobDetail[jobId].keyTransact = _keyTransact;
        s1.jobIdToJobDetail[jobId].metres = _metres;
        s1.jobIdToJobDetail[jobId].value = valueTransact;
        s1.jobIdToJobDetail[jobId].cancellationFee = cancellationFeeTransact;
        s1.jobIdToJobDetail[jobId].state = LibJobBoard.JobState.Pending;

        s1.userToJobIdCount[msg.sender] += 1;

        emit RequestRunner(msg.sender, jobId);
    }

    event RequestorCancelled(address indexed sender, bytes32 indexed jobId);

    function cancelFromRequestor(bytes32 _jobId) external {
        LibRequestor._requireMatchJobIdRequestor(msg.sender, _jobId);

        LibJobBoard.StorageJobBoard storage s1 = LibJobBoard._storageJobBoard();

        require(
            s1.jobIdToJobDetail[_jobId].state == LibJobBoard.JobState.Pending ||
                s1.jobIdToJobDetail[_jobId].state ==
                LibJobBoard.JobState.Accepted ||
                s1.jobIdToJobDetail[_jobId].state ==
                LibJobBoard.JobState.Collected ||
                s1.jobIdToJobDetail[_jobId].state ==
                LibJobBoard.JobState.Delivered,
            "Runner: job state not pending or accepted or collected or delivered"
        );

        if (s1.jobIdToJobDetail[_jobId].state == LibJobBoard.JobState.Pending) {
            (
                ,
                ,
                bytes32 keyTransact,
                uint256 value,
                uint256 cancellationFee
            ) = LibHolding._getFundsLockingDetail(_jobId);

            LibHolding._unlockFunds(
                keyTransact,
                value + cancellationFee,
                msg.sender,
                msg.sender
            );
        } else if (
            s1.jobIdToJobDetail[_jobId].state == LibJobBoard.JobState.Accepted
        ) {
            LibHolding._sortFundsUnlocking(_jobId, false, true);
        } else if (
            s1.jobIdToJobDetail[_jobId].state == LibJobBoard.JobState.Collected
        ) {
            if (s1.jobIdToJobDetail[_jobId].packageVerified) {
                LibHolding._sortFundsUnlocking(_jobId, true, true);
            } else {
                LibHolding._sortFundsUnlocking(_jobId, false, true);
            }
        } else if (
            s1.jobIdToJobDetail[_jobId].state == LibJobBoard.JobState.Delivered
        ) {
            // note: this case is needed in case where runner does NOT completeJob
            /** TODO:
             * need have verifiedPackage condition here?
             * not really for now as verified is whether package collected or not
             * not if reach destination or not
             */

            if (s1.jobIdToJobDetail[_jobId].dispute) {
                LibHolding._sortFundsUnlocking(_jobId, false, true);
            } else {
                LibHolding._sortFundsUnlocking(_jobId, true, true);
            }
        }

        s1.userToJobIdCount[msg.sender] -= 1;

        s1.jobIdToJobDetail[_jobId].state = LibJobBoard.JobState.Cancelled; // note: not used as job cleared before this point

        emit RequestorCancelled(msg.sender, _jobId);
    }

    event Dispute(address indexed sender, bytes32 indexed jobId);

    function dispute(bytes32 _jobId, bool _dispute) external {
        LibRequestor._requireMatchJobIdRequestor(msg.sender, _jobId);

        LibJobBoard.StorageJobBoard storage s1 = LibJobBoard._storageJobBoard();

        if (
            s1.jobIdToJobDetail[_jobId].state == LibJobBoard.JobState.Collected
        ) {
            // only allow set dispute=true if not verified
            if (!s1.jobIdToJobDetail[_jobId].packageVerified) {
                s1.jobIdToJobDetail[_jobId].dispute = _dispute;
            } else if (
                s1.jobIdToJobDetail[_jobId].packageVerified &&
                s1.jobIdToJobDetail[_jobId].dispute
            ) {
                s1.jobIdToJobDetail[_jobId].dispute = _dispute; // opportunity to set dispute=false
            } else {
                revert("Requestor: already verified");
            }
        } else if (
            s1.jobIdToJobDetail[_jobId].state == LibJobBoard.JobState.Delivered
        ) {
            if (_dispute) {
                require(
                    block.timestamp <
                        s1.jobIdToJobDetail[_jobId].disputeExpiryTimestamp,
                    "Requestor: dispute period expired"
                );
            } // note: to allow set false

            s1.jobIdToJobDetail[_jobId].dispute = _dispute;
        }

        emit Dispute(msg.sender, _jobId);
    }
}
