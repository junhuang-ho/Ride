//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibJobBoard.sol";
import "../../libraries/core/LibRunnerRegistry.sol";
import "../../libraries/core/LibRunnerDetail.sol";
import "../../libraries/core/LibRunner.sol";
import "../../libraries/core/LibRequestor.sol";
import "../../libraries/core/LibRequestorDetail.sol";
import "../../libraries/core/LibHolding.sol";
import "../../libraries/core/LibExchange.sol";

import "../../libraries/core/LibPenalty.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract Runner is IHubLibraryEvents {
    event RequestAccepted(address indexed sender, bytes32 indexed jobId);

    function acceptRequest(
        bytes32 _keyLocal,
        bytes32 _keyTransact,
        bytes32 _jobId
    ) external {
        LibRunnerRegistry._requireIsRunner();

        LibRunnerDetail.StorageRunnerDetail storage s2 = LibRunnerDetail
            ._storageRunnerDetail();

        LibPenalty._requireNotBanned(s2.runnerToRunnerDetail[msg.sender].hive); // TODO: test possible for hives to ban their own runner
        LibExchange._requireAddedXPerYPriceFeedSupported(
            _keyLocal,
            _keyTransact
        );

        LibJobBoard.StorageJobBoard storage s1 = LibJobBoard._storageJobBoard();

        require(
            s1.jobIdToJobDetail[_jobId].requestor != address(0),
            "Runner: job not exists"
        );

        require(
            s1.jobIdToJobDetail[_jobId].state == LibJobBoard.JobState.Pending,
            "Runner: job state not pending"
        );

        require(
            s1.jobIdToJobDetail[_jobId].keyLocal == _keyLocal,
            "Runner: local currency key not match"
        );
        require(
            s1.jobIdToJobDetail[_jobId].keyTransact == _keyTransact,
            "Runner: transact currency key not match"
        );

        require(
            s1.jobIdToJobDetail[_jobId].metres <=
                s2.runnerToRunnerDetail[msg.sender].maxMetresPerTrip,
            "Runner: exceed max metres"
        );

        LibHolding._requireSufficientHolding(
            _keyTransact,
            s1.jobIdToJobDetail[_jobId].value +
                s1.jobIdToJobDetail[_jobId].cancellationFee
        );
        LibHolding._lockFunds(
            _keyTransact,
            s1.jobIdToJobDetail[_jobId].value +
                s1.jobIdToJobDetail[_jobId].cancellationFee
        );

        s1.jobIdToJobDetail[_jobId].runner = msg.sender;
        s1.jobIdToJobDetail[_jobId].state = LibJobBoard.JobState.Accepted;

        s1.userToJobIdCount[msg.sender] += 1;

        emit RequestAccepted(msg.sender, _jobId);
    }

    event PackageCollected(address indexed sender, bytes32 indexed jobId);

    function collectPackage(bytes32 _jobId, address _package) external {
        LibRunner._requireMatchJobIdRunner(_jobId);

        LibJobBoard.StorageJobBoard storage s1 = LibJobBoard._storageJobBoard();

        require(
            s1.jobIdToJobDetail[_jobId].state == LibJobBoard.JobState.Accepted,
            "Runner: job state not accepted"
        );

        LibJobBoard._setJobDisputeExpiry(_jobId);

        verify(_jobId, _package);

        if (s1.jobIdToJobDetail[_jobId].packageVerified) {
            // runner & requestor incentivised to get verified to get stats
            // TODO: re-study this logic where if verified only can gain stats
            LibRunnerDetail
                ._storageRunnerDetail()
                .runnerToRunnerDetail[msg.sender]
                .countStart += 1;

            LibRequestorDetail
                ._storageRequestorDetail()
                .requestorToRequestorDetail[
                    s1.jobIdToJobDetail[_jobId].requestor
                ]
                .countStart += 1;
        }

        s1.jobIdToJobDetail[_jobId].state = LibJobBoard.JobState.Collected;

        emit PackageCollected(msg.sender, _jobId);
    }

    event PackageDelivered(address indexed sender, bytes32 indexed jobId);

    function deliverPackage(bytes32 _jobId) external {
        LibRunner._requireMatchJobIdRunner(_jobId);

        LibJobBoard.StorageJobBoard storage s1 = LibJobBoard._storageJobBoard();

        require(
            s1.jobIdToJobDetail[_jobId].state == LibJobBoard.JobState.Collected,
            "Runner: job state not collected"
        );

        LibJobBoard._requireDisputePeriodExpired(_jobId);
        require(
            !s1.jobIdToJobDetail[_jobId].dispute,
            "Runner: requestor dispute"
        );

        LibJobBoard._setJobDisputeExpiry(_jobId);

        s1.jobIdToJobDetail[_jobId].state = LibJobBoard.JobState.Delivered;

        emit PackageDelivered(msg.sender, _jobId);
    }

    event JobCompleted(address indexed sender, bytes32 indexed jobId);

    function completeJob(bytes32 _jobId, bool _accept) external {
        LibRunner._requireMatchJobIdRunner(_jobId);

        LibJobBoard.StorageJobBoard storage s1 = LibJobBoard._storageJobBoard();

        require(
            s1.jobIdToJobDetail[_jobId].state == LibJobBoard.JobState.Delivered,
            "Runner: job state not delivered"
        );

        LibJobBoard._requireDisputePeriodExpired(_jobId);

        require(_accept, "Runner: not accept"); // accept whether disputed or not

        LibRunnerDetail.StorageRunnerDetail storage s2 = LibRunnerDetail
            ._storageRunnerDetail();

        if (s1.jobIdToJobDetail[_jobId].dispute) {
            LibHolding._sortFundsUnlocking(_jobId, false, true);
        } else {
            LibHolding._sortFundsUnlocking(_jobId, true, true);

            if (s1.jobIdToJobDetail[_jobId].packageVerified) {
                // TODO: re-study this logic where if verified only can gain stats
                s2.runnerToRunnerDetail[msg.sender].metresTravelled += s1
                    .jobIdToJobDetail[_jobId]
                    .metres;
                s2.runnerToRunnerDetail[msg.sender].countEnd += 1;

                LibRequestorDetail
                    ._storageRequestorDetail()
                    .requestorToRequestorDetail[
                        s1.jobIdToJobDetail[_jobId].requestor
                    ]
                    .countEnd += 1;
            }
        }

        s1.userToJobIdCount[msg.sender] -= 1;

        s1.jobIdToJobDetail[_jobId].state = LibJobBoard.JobState.Completed; // note: not used as job cleared before this point

        emit JobCompleted(msg.sender, _jobId);
    }

    event RunnerCancelled(address indexed sender, bytes32 indexed jobId);

    function cancelFromRunner(bytes32 _jobId) external {
        LibRunner._requireMatchJobIdRunner(_jobId);

        LibJobBoard.StorageJobBoard storage s1 = LibJobBoard._storageJobBoard();

        require(
            s1.jobIdToJobDetail[_jobId].state ==
                LibJobBoard.JobState.Accepted ||
                s1.jobIdToJobDetail[_jobId].state ==
                LibJobBoard.JobState.Collected,
            "Runner: job state not accepted or collected"
        );

        if (
            s1.jobIdToJobDetail[_jobId].state == LibJobBoard.JobState.Accepted
        ) {
            LibHolding._sortFundsUnlocking(_jobId, false, false);
        } else if (
            s1.jobIdToJobDetail[_jobId].state == LibJobBoard.JobState.Collected
        ) {
            // runner need pay value to prevent steal
            LibHolding._sortFundsUnlocking(_jobId, true, false);
        }

        s1.userToJobIdCount[msg.sender] -= 1;

        s1.jobIdToJobDetail[_jobId].state = LibJobBoard.JobState.Cancelled; // note: not used as job cleared before this point

        emit RunnerCancelled(msg.sender, _jobId);
    }

    event PackageVerified(address indexed sender, bytes32 indexed jobId);

    function verify(bytes32 _jobId, address _package) public {
        LibJobBoard.StorageJobBoard storage s1 = LibJobBoard._storageJobBoard();

        if (_package == s1.jobIdToJobDetail[_jobId].package) {
            s1.jobIdToJobDetail[_jobId].packageVerified = true;

            emit PackageVerified(msg.sender, _jobId);
        }
    }
}
