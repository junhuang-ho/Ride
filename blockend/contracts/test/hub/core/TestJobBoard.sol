//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/JobBoard.sol";
import "../../../hub/libraries/core/LibJobBoard.sol";

contract TestJobBoard is JobBoard {
    function sJobIdToJobDetail_(bytes32 _jobId)
        external
        view
        returns (LibJobBoard.JobDetail memory)
    {
        return LibJobBoard._storageJobBoard().jobIdToJobDetail[_jobId];
    }

    function sUserToJobIdCount_(address _user) external view returns (uint256) {
        return LibJobBoard._storageJobBoard().userToJobIdCount[_user];
    }

    function sJobLifespan_() external view returns (uint256) {
        return LibJobBoard._storageJobBoard().jobLifespan;
    }

    function sMinDisputeDuration_() external view returns (uint256) {
        return LibJobBoard._storageJobBoard().minDisputeDuration;
    }

    function sHiveToDisputeDuration_(address _hive)
        external
        view
        returns (uint256)
    {
        return LibJobBoard._storageJobBoard().hiveToDisputeDuration[_hive];
    }

    function ssJobIdToJobDetail_1(
        bytes32 _jobId,
        uint256 _state,
        address _requestor,
        address _runner,
        address _package,
        bytes32 _locationPackage,
        bytes32 _locationDestination,
        bytes32 _keyLocal,
        bytes32 _keyTransact
    ) external {
        LibJobBoard.StorageJobBoard storage s1 = LibJobBoard._storageJobBoard();

        s1.jobIdToJobDetail[_jobId].state = LibJobBoard.JobState(_state);
        s1.jobIdToJobDetail[_jobId].requestor = _requestor;
        s1.jobIdToJobDetail[_jobId].runner = _runner;
        s1.jobIdToJobDetail[_jobId].package = _package;
        s1.jobIdToJobDetail[_jobId].locationPackage = _locationPackage;
        s1.jobIdToJobDetail[_jobId].locationDestination = _locationDestination;
        s1.jobIdToJobDetail[_jobId].keyLocal = _keyLocal;
        s1.jobIdToJobDetail[_jobId].keyTransact = _keyTransact;
    }

    function ssJobIdToJobDetail_2(
        bytes32 _jobId,
        uint256 _metres,
        uint256 _value,
        uint256 _cancellationFee,
        uint256 _disputeExpiryTimestamp,
        bool _packageVerified,
        bool _dispute,
        bool _rated
    ) external {
        LibJobBoard.StorageJobBoard storage s1 = LibJobBoard._storageJobBoard();

        s1.jobIdToJobDetail[_jobId].metres = _metres;
        s1.jobIdToJobDetail[_jobId].value = _value;
        s1.jobIdToJobDetail[_jobId].cancellationFee = _cancellationFee;
        s1
            .jobIdToJobDetail[_jobId]
            .disputeExpiryTimestamp = _disputeExpiryTimestamp;
        s1.jobIdToJobDetail[_jobId].packageVerified = _packageVerified;
        s1.jobIdToJobDetail[_jobId].dispute = _dispute;
        s1.jobIdToJobDetail[_jobId].rated = _rated;
    }

    function ssUserToJobIdCount_(address _user, uint256 _count) external {
        LibJobBoard._storageJobBoard().userToJobIdCount[_user] = _count;
    }

    function ssJobLifespan_(uint256 _duration) external {
        LibJobBoard._storageJobBoard().jobLifespan = _duration;
    }

    function ssMinDisputeDuration_(uint256 _duration) external {
        LibJobBoard._storageJobBoard().minDisputeDuration = _duration;
    }

    function ssHiveToDisputeDuration_(address _hive, uint256 _duration)
        external
    {
        LibJobBoard._storageJobBoard().hiveToDisputeDuration[_hive] = _duration;
    }

    function requireNotActive_() external view returns (bool) {
        LibJobBoard._requireNotActive();
        return true;
    }

    function requireDisputePeriodExpired_(bytes32 _jobId) external {
        LibJobBoard._requireDisputePeriodExpired(_jobId);
    }

    function setJobLifespan_(uint256 _duration) external {
        LibJobBoard._setJobLifespan(_duration);
    }

    function setMinDisputeDuration_(uint256 _duration) external {
        LibJobBoard._setMinDisputeDuration(_duration);
    }

    function setHiveToDisputeDuration_(uint256 _duration) external {
        LibJobBoard._setHiveToDisputeDuration(_duration);
    }

    function setJobDisputeExpiry_(bytes32 _jobId) external {
        LibJobBoard._setJobDisputeExpiry(_jobId);
    }

    function clearJob_(bytes32 _jobId) external {
        LibJobBoard._clearJob(_jobId);
    }
}
