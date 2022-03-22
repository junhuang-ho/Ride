//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./LibRunnerDetail.sol";

library LibRunnerRegistry {
    using Counters for Counters.Counter;

    bytes32 constant STORAGE_POSITION_RUNNERREGISTRY =
        keccak256("ds.runnerregistry");

    struct StorageRunnerRegistry {
        Counters.Counter _runnerIdCounter;
    }

    function _storageRunnerRegistry()
        internal
        pure
        returns (StorageRunnerRegistry storage s)
    {
        bytes32 position = STORAGE_POSITION_RUNNERREGISTRY;
        assembly {
            s.slot := position
        }
    }

    function _requireIsRunner() internal view {
        require(
            LibRunnerDetail
                ._storageRunnerDetail()
                .runnerToRunnerDetail[msg.sender]
                .id != 0,
            "LibRunnerRegistry: caller not runner"
        );
    }

    function _requireNotRunner() internal view {
        require(
            LibRunnerDetail
                ._storageRunnerDetail()
                .runnerToRunnerDetail[msg.sender]
                .id == 0,
            "LibRunnerRegistry: caller is runner"
        );
    }

    /**
     * _mint a runner ID
     *
     * @return runner ID
     */
    function _mint() internal returns (uint256) {
        StorageRunnerRegistry storage s1 = _storageRunnerRegistry();
        uint256 id = s1._runnerIdCounter.current();
        s1._runnerIdCounter.increment();
        return id;
    }

    /**
     * _burnFirstRunnerId burns runner ID 0
     * can only be called at Hub deployment
     *
     * TODO: call at init ONLY
     */
    function _burnFirstRunnerId() internal {
        StorageRunnerRegistry storage s1 = _storageRunnerRegistry();
        require(
            s1._runnerIdCounter.current() == 0,
            "LibRunnerRegistry: Must be zero"
        );
        s1._runnerIdCounter.increment();
    }

    event ApplicantApproved(address indexed sender, address applicant);

    function _approveApplicant(
        address _runner,
        string memory _uri,
        address _hiveTimelock
    ) internal {
        LibRunnerDetail.StorageRunnerDetail storage s1 = LibRunnerDetail
            ._storageRunnerDetail();

        require(
            s1.runnerToRunnerDetail[_runner].hive == address(0),
            "LibRunnerRegistry: hive exist for applicant"
        );
        s1.runnerToRunnerDetail[_runner].uri = _uri; // note: possible to override URI when joining new hive
        s1.runnerToRunnerDetail[_runner].hive = _hiveTimelock;
        // s1.hiveToRunners[_hiveTimelock].push(_runner); // note: depends on RunnerDetail.calculateCollectiveScore

        emit ApplicantApproved(msg.sender, _runner);
    }
}
