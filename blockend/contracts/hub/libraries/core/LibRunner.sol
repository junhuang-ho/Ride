//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "./LibJobBoard.sol";

import "./LibRequesterDetail.sol";
import "./LibRunnerDetail.sol";

library LibRunner {
    function _requireMatchJobIdRunner(bytes32 _jobId) internal view {
        require(
            msg.sender ==
                LibJobBoard._storageJobBoard().jobIdToJobDetail[_jobId].runner,
            "LibRunner: caller not match job id runner"
        );
    }

    function _recordCollectStats(bytes32 _jobId) internal {
        LibJobBoard.StorageJobBoard storage s1 = LibJobBoard._storageJobBoard();

        LibRunnerDetail
            ._storageRunnerDetail()
            .runnerToRunnerDetail[msg.sender]
            .countStart += 1;

        LibRequesterDetail
            ._storageRequesterDetail()
            .requesterToRequesterDetail[s1.jobIdToJobDetail[_jobId].requester]
            .countStart += 1;

        s1.jobIdToJobDetail[_jobId].collectStatsRecorded = true;
    }
}
