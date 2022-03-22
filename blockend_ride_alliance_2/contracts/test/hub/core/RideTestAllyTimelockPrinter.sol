//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/RideAllyTimelockPrinter.sol";
import "../../../hub/libraries/core/RideLibAllyTimelockPrinter.sol";

contract RideTestAllyTimelockPrinter is RideAllyTimelockPrinter {
    function runPrintAllianceTimelock_(
        bytes32 _salt,
        uint256 _minDelay,
        address[] memory _proposers,
        address[] memory _executors
    ) external returns (RideAllianceTimelock) {
        return
            RideLibAllyTimelockPrinter._runPrintAllianceTimelock(
                _salt,
                _minDelay,
                _proposers,
                _executors
            );
    }
}
