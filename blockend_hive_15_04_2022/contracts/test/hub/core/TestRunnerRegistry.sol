//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/RunnerRegistry.sol";
import "../../../hub/libraries/core/LibRunnerRegistry.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

contract TestRunnerRegistry is RunnerRegistry {
    function s_runnerIdCounter_()
        external
        view
        returns (Counters.Counter memory)
    {
        return LibRunnerRegistry._storageRunnerRegistry()._runnerIdCounter;
    }

    function requireIsRunner_() external view returns (bool) {
        LibRunnerRegistry._requireIsRunner();
        return true;
    }

    function requireNotRunner_() external view returns (bool) {
        LibRunnerRegistry._requireNotRunner();
        return true;
    }

    function mint_() external returns (uint256) {
        return LibRunnerRegistry._mint();
    }

    function burnFirstRunnerId_() external {
        LibRunnerRegistry._burnFirstRunnerId();
    }

    function approveApplicant_(
        address _runner,
        string memory _uri,
        address _hiveTimelock
    ) external {
        LibRunnerRegistry._approveApplicant(_runner, _uri, _hiveTimelock);
    }
}
