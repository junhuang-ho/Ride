//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibJobBoard.sol";
import "../../libraries/core/LibRunnerDetail.sol";
import "../../libraries/core/LibRequester.sol";
import "../../libraries/utils/LibAccessControl.sol";

library LibRater {
    bytes32 constant STORAGE_POSITION_RATER = keccak256("ds.rater");

    struct StorageRater {
        uint256 ratingMin;
        uint256 ratingMax;
    }

    function _storageRater() internal pure returns (StorageRater storage s) {
        bytes32 position = STORAGE_POSITION_RATER;
        assembly {
            s.slot := position
        }
    }

    event SetRatingBounds(address indexed sender, uint256 min, uint256 max);

    /**
     * setRatingBounds sets bounds for rating
     *
     * @param _min | unitless integer
     * @param _max | unitless integer
     */
    function _setRatingBounds(uint256 _min, uint256 _max) internal {
        LibAccessControl._requireOnlyRole(LibAccessControl.STRATEGIST_ROLE);
        require(_min > 0, "LibRater: cannot have zero rating bound");
        require(
            _max > _min,
            "LibRater: maximum rating must be more than minimum rating"
        );
        StorageRater storage s1 = _storageRater();
        s1.ratingMin = _min;
        s1.ratingMax = _max;

        emit SetRatingBounds(msg.sender, _min, _max);
    }

    event RatingGiven(address indexed sender, uint256 rating);

    function _giveRating(bytes32 _jobId, uint256 _rating) internal {
        LibRequester._requireMatchJobIdRequester(msg.sender, _jobId);

        LibJobBoard.StorageJobBoard storage s3 = LibJobBoard._storageJobBoard();

        require(
            !s3.jobIdToJobDetail[_jobId].rated,
            "LibRater: job already rated"
        );

        require(
            s3.jobIdToJobDetail[_jobId].state ==
                LibJobBoard.JobState.Completed ||
                s3.jobIdToJobDetail[_jobId].state ==
                LibJobBoard.JobState.Cancelled,
            "LibRater: job state not completed or cancelled"
        );

        LibRunnerDetail.StorageRunnerDetail storage s1 = LibRunnerDetail
            ._storageRunnerDetail();
        StorageRater storage s2 = _storageRater();

        // require(s2.ratingMax > 0, "maximum rating must be more than zero");
        // require(s2.ratingMin > 0, "minimum rating must be more than zero");
        // since remove greater than 0 check, makes pax call more gas efficient,
        // but make sure _setRatingBounds called at init
        require(
            _rating >= s2.ratingMin && _rating <= s2.ratingMax,
            "LibRater: rating must be within min and max ratings (inclusive)"
        );

        address runner = s3.jobIdToJobDetail[_jobId].runner;

        s1.runnerToRunnerDetail[runner].totalRating += _rating;
        s1.runnerToRunnerDetail[runner].countRating += 1;

        s3.jobIdToJobDetail[_jobId].rated = true;

        emit RatingGiven(msg.sender, _rating);
    }
}
