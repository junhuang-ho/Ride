//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/Requester.sol";
import "../../../hub/libraries/core/LibRequester.sol";

contract TestRequester is Requester {
    function requireMatchJobIdRequester_(address _requester, bytes32 _jobId)
        external
        view
        returns (bool)
    {
        LibRequester._requireMatchJobIdRequester(_requester, _jobId);
        return true;
    }
}
