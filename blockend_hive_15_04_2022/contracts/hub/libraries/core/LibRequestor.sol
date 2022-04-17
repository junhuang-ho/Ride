//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "./LibJobBoard.sol";

library LibRequestor {
    function _requireMatchJobIdRequestor(address _requestor, bytes32 _jobId)
        internal
        view
    {
        require(
            _requestor ==
                LibJobBoard
                    ._storageJobBoard()
                    .jobIdToJobDetail[_jobId]
                    .requestor,
            "LibRequestor: caller not match job requestor"
        );
    }
}
