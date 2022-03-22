//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibJobBoard.sol";

import "../../libraries/utils/LibAccessControl.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract JobBoard is IHubLibraryEvents {
    function setJobLifespan(uint256 _duration) external {
        LibJobBoard._setJobLifespan(_duration);
    }

    function setMinDisputeDuration(uint256 _duration) external {
        LibJobBoard._setMinDisputeDuration(_duration);
    }

    function setHiveToDisputeDuration(uint256 _duration) external {
        LibJobBoard._setHiveToDisputeDuration(_duration);
    }

    function getJobLifespan() external view returns (uint256) {
        return LibJobBoard._storageJobBoard().jobLifespan;
    }

    function getMinDisputeDuration() external view returns (uint256) {
        return LibJobBoard._storageJobBoard().minDisputeDuration;
    }

    function getHiveToDisputeDuration(address _hive)
        external
        view
        returns (uint256)
    {
        return LibJobBoard._storageJobBoard().hiveToDisputeDuration[_hive];
    }

    function getJobIdToJobDetail(bytes32 _jobId)
        external
        view
        returns (LibJobBoard.JobDetail memory)
    {
        return LibJobBoard._storageJobBoard().jobIdToJobDetail[_jobId];
    }

    function getUserToJobIdCount(address _user)
        external
        view
        returns (uint256)
    {
        return LibJobBoard._storageJobBoard().userToJobIdCount[_user];
    }

    // note: cronjob
    // note: use JobCleared event in internal fn to check the remaining jobIds
    function clearJobs(bytes32[] memory _jobIds) external {
        LibAccessControl._requireOnlyRole(LibAccessControl.MAINTAINER_ROLE);

        LibJobBoard.StorageJobBoard storage s1 = LibJobBoard._storageJobBoard();

        for (uint256 i = 0; i < _jobIds.length; i++) {
            if (
                (s1.jobIdToJobDetail[_jobIds[i]].state ==
                    LibJobBoard.JobState.Cancelled ||
                    s1.jobIdToJobDetail[_jobIds[i]].state ==
                    LibJobBoard.JobState.Completed) &&
                (block.timestamp >=
                    s1.jobIdToJobDetail[_jobIds[i]].disputeExpiryTimestamp +
                        s1.jobLifespan ||
                    s1.jobIdToJobDetail[_jobIds[i]].rated)
            ) {
                LibJobBoard._clearJob(_jobIds[i]);
            }
        }
    }
}
