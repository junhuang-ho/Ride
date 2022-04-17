//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/HoneyPot.sol";
import "../../../hub/libraries/core/LibHoneyPot.sol";

contract TestHoneyPot is HoneyPot {
    function sHiveToHoney_(address _hive) external view returns (uint256) {
        return LibHoneyPot._storageHoneyPot().hiveToHoney[_hive];
    }

    function sRunnerToHiveToContribution_(address _runner, address _hive)
        external
        view
        returns (uint256)
    {
        return
            LibHoneyPot._storageHoneyPot().runnerToHiveToContribution[_runner][
                _hive
            ];
    }

    function ssHiveToHoney_(address _hive, uint256 _amount) external {
        LibHoneyPot._storageHoneyPot().hiveToHoney[_hive] = _amount;
    }

    function ssRunnerToHiveToContribution_(
        address _runner,
        address _hive,
        uint256 _amount
    ) external {
        LibHoneyPot._storageHoneyPot().runnerToHiveToContribution[_runner][
                _hive
            ] = _amount;
    }
}
