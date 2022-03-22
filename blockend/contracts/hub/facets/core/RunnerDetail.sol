//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibRunnerDetail.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract RunnerDetail is IHubLibraryEvents {
    function getRunnerToRunnerDetail(address _runner)
        external
        view
        returns (LibRunnerDetail.RunnerDetail memory)
    {
        return
            LibRunnerDetail._storageRunnerDetail().runnerToRunnerDetail[
                _runner
            ];
    }

    function calculateRunnerScore(address _runner)
        external
        view
        returns (uint256)
    {
        return LibRunnerDetail._calculateRunnerScore(_runner);
    }

    // note: calculate externally
    // function calculateCollectiveScore(address _hive)
    //     external
    //     view
    //     returns (uint256)
    // {
    //     address[] memory runners = LibRunnerDetail
    //         ._storageRunnerDetail()
    //         .hiveToRunners[_hive];
    //     uint256 metresTravelled;
    //     uint256 countStart;
    //     uint256 countEnd;
    //     uint256 totalRating;
    //     uint256 countRating;
    //     uint256 maxRating;
    //     for (uint256 i = 0; i < runners.length; i++) {
    //         (
    //             uint256 _metresTravelled,
    //             uint256 _countStart,
    //             uint256 _countEnd,
    //             uint256 _totalRating,
    //             uint256 _countRating,
    //             uint256 _maxRating
    //         ) = LibRunnerDetail._getRunnerScoreDetail(runners[i]);
    //         metresTravelled += _metresTravelled;
    //         countStart += _countStart;
    //         countEnd += _countEnd;
    //         totalRating += _totalRating;
    //         countRating += _countRating;
    //         maxRating += _maxRating;
    //     }
    //     if (countStart == 0) {
    //         return 0;
    //     } else {
    //         return
    //             (metresTravelled * countEnd * totalRating) /
    //             (countStart * countRating * maxRating);
    //     }
    // }
}
