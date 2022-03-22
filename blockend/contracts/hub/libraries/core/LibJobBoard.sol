//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "./LibHolding.sol";
import "./LibRunnerDetail.sol";
import "../utils/LibAccessControl.sol";

library LibJobBoard {
    bytes32 constant STORAGE_POSITION_JOBBOARD = keccak256("ds.jobboard");

    enum JobState {
        Pending,
        Accepted,
        Cancelled,
        Collected,
        Delivered,
        Completed
    }

    struct JobDetail {
        JobState state;
        address requestor;
        address runner;
        address package;
        bytes32 locationPackage;
        bytes32 locationDestination;
        bytes32 keyLocal;
        bytes32 keyTransact;
        uint256 metres;
        uint256 value;
        uint256 cancellationFee;
        uint256 disputeExpiryTimestamp;
        bool packageVerified;
        bool dispute;
        bool rated;
    }

    struct StorageJobBoard {
        mapping(bytes32 => JobDetail) jobIdToJobDetail;
        mapping(address => uint256) userToJobIdCount;
        uint256 jobLifespan;
        uint256 minDisputeDuration;
        mapping(address => uint256) hiveToDisputeDuration;
    }

    function _storageJobBoard()
        internal
        pure
        returns (StorageJobBoard storage s)
    {
        bytes32 position = STORAGE_POSITION_JOBBOARD;
        assembly {
            s.slot := position
        }
    }

    function _requireNotActive() internal view {
        require(
            _storageJobBoard().userToJobIdCount[msg.sender] == 0,
            "LibJobBoard: caller is active"
        );
    }

    function _requireDisputePeriodExpired(bytes32 _jobId) internal view {
        require(
            block.timestamp >
                _storageJobBoard()
                    .jobIdToJobDetail[_jobId]
                    .disputeExpiryTimestamp,
            "LibJobBoard: dispute period not expired"
        );
    }

    event JobLifespanSet(address indexed sender, uint256 duration);

    function _setJobLifespan(uint256 _duration) internal {
        LibAccessControl._requireOnlyRole(LibAccessControl.STRATEGIST_ROLE);

        _storageJobBoard().jobLifespan = _duration;

        emit JobLifespanSet(msg.sender, _duration);
    }

    event MinDisputeDurationSet(address indexed sender, uint256 duration);

    function _setMinDisputeDuration(uint256 _duration) internal {
        LibAccessControl._requireOnlyRole(LibAccessControl.STRATEGIST_ROLE);

        _storageJobBoard().minDisputeDuration = _duration;

        emit MinDisputeDurationSet(msg.sender, _duration);
    }

    event HiveDisputeDurationSet(address indexed sender, uint256 duration);

    function _setHiveToDisputeDuration(uint256 _duration) internal {
        LibAccessControl._requireOnlyRole(LibAccessControl.HIVE_ROLE);

        StorageJobBoard storage s1 = _storageJobBoard();

        require(
            _duration >= s1.minDisputeDuration,
            "LibJobBoard: duration less than minimum duration"
        );

        s1.hiveToDisputeDuration[msg.sender] = _duration;

        emit HiveDisputeDurationSet(msg.sender, _duration);
    }

    function _setJobDisputeExpiry(bytes32 _jobId) internal {
        StorageJobBoard storage s1 = _storageJobBoard();

        uint256 disputeDuration = s1.hiveToDisputeDuration[
            LibRunnerDetail
                ._storageRunnerDetail()
                .runnerToRunnerDetail[msg.sender]
                .hive
        ];

        if (disputeDuration < s1.minDisputeDuration) {
            disputeDuration = s1.minDisputeDuration;
        }

        s1.jobIdToJobDetail[_jobId].disputeExpiryTimestamp =
            block.timestamp +
            disputeDuration;
    }

    event JobCleared(address indexed sender, bytes32 indexed jobId);

    function _clearJob(bytes32 _jobId) internal {
        StorageJobBoard storage s1 = _storageJobBoard();

        delete s1.jobIdToJobDetail[_jobId];

        emit JobCleared(msg.sender, _jobId);
    }
}
