//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/Runner.sol";
import "../../../hub/libraries/core/LibRunner.sol";

contract TestRunner is Runner {
    function requireMatchJobIdRunner_(bytes32 _jobId)
        external
        view
        returns (bool)
    {
        LibRunner._requireMatchJobIdRunner(_jobId);
        return true;
    }
}
