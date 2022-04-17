//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/RunnerDetail.sol";
import "../../../hub/libraries/core/LibRunnerDetail.sol";

contract TestRunnerDetail is RunnerDetail {
    function sRunnerToRunnerDetail_(address _runner)
        external
        view
        returns (LibRunnerDetail.RunnerDetail memory)
    {
        return
            LibRunnerDetail._storageRunnerDetail().runnerToRunnerDetail[
                _runner
            ];
    }

    function ssRunnerToRunnerDetail_(
        address _runner,
        uint256 _id,
        string memory _uri,
        address _hive,
        uint256 _maxMetresPerTrip,
        uint256 _metresTravelled,
        uint256 _countStart,
        uint256 _countEnd,
        uint256 _totalRating,
        uint256 _countRating
    ) external {
        LibRunnerDetail.StorageRunnerDetail storage s1 = LibRunnerDetail
            ._storageRunnerDetail();
        s1.runnerToRunnerDetail[_runner].id = _id;
        s1.runnerToRunnerDetail[_runner].uri = _uri;
        s1.runnerToRunnerDetail[_runner].hive = _hive;
        s1.runnerToRunnerDetail[_runner].maxMetresPerTrip = _maxMetresPerTrip;
        s1.runnerToRunnerDetail[_runner].metresTravelled = _metresTravelled;
        s1.runnerToRunnerDetail[_runner].countStart = _countStart;
        s1.runnerToRunnerDetail[_runner].countEnd = _countEnd;
        s1.runnerToRunnerDetail[_runner].totalRating = _totalRating;
        s1.runnerToRunnerDetail[_runner].countRating = _countRating;
    }

    function calculateRunnerScore_(address _runner)
        external
        view
        returns (uint256)
    {
        return LibRunnerDetail._calculateRunnerScore(_runner);
    }

    function getRunnerScoreDetail_(address _runner)
        external
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return LibRunnerDetail._getRunnerScoreDetail(_runner);
    }
}
