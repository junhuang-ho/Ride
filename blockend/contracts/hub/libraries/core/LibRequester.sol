//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "./LibJobBoard.sol";

library LibRequester {
    function _requireMatchJobIdRequester(address _requester, bytes32 _jobId)
        internal
        view
    {
        require(
            _requester ==
                LibJobBoard
                    ._storageJobBoard()
                    .jobIdToJobDetail[_jobId]
                    .requester,
            "LibRequester: caller not match job requester"
        );
    }
}
