//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../alliance/facets/core/RideAlliancePrinterTimelock.sol";
import "../../../alliance/libraries/core/RideLibAlliancePrinterTimelock.sol";

contract RideTestAlliancePrinterTimelock is RideAlliancePrinterTimelock {
    function runPrintAllianceTimelock_(
        bytes32 _salt,
        uint256 _minDelay,
        address[] memory _proposers,
        address[] memory _executors
    ) external returns (RideAllianceTimelock) {
        return
            RideLibAlliancePrinterTimelock._runPrintAllianceTimelock(
                _salt,
                _minDelay,
                _proposers,
                _executors
            );
    }
}
