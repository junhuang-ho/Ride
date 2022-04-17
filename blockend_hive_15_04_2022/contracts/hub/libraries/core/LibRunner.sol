//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "./LibJobBoard.sol";

library LibRunner {
    function _requireMatchJobIdRunner(bytes32 _jobId) internal view {
        require(
            msg.sender ==
                LibJobBoard._storageJobBoard().jobIdToJobDetail[_jobId].runner,
            "LibRunner: caller not match job id runner"
        );
    }
}
