//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/HiveTimelockMachine.sol";
import "../../../hub/libraries/core/LibHiveTimelockMachine.sol";

contract TestHiveTimelockMachine is HiveTimelockMachine {
    function copyHiveTimelock_(
        bytes32 _salt,
        uint256 _minDelay,
        address[] memory _proposers,
        address[] memory _executors
    ) external returns (HiveTimelock) {
        return
            LibHiveTimelockMachine._copyHiveTimelock(
                _salt,
                _minDelay,
                _proposers,
                _executors
            );
    }
}
