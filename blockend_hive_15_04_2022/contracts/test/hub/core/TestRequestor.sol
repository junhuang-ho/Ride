//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/Requestor.sol";
import "../../../hub/libraries/core/LibRequestor.sol";

contract TestRequestor is Requestor {
    function requireMatchJobIdRequestor_(address _requestor, bytes32 _jobId)
        external
        view
        returns (bool)
    {
        LibRequestor._requireMatchJobIdRequestor(_requestor, _jobId);
        return true;
    }
}
