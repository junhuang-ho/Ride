//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../templates/RideAllianceTimelock.sol";
import "../../facets/core/RideAllyTimelockPrinter.sol";

library RideLibAllyTimelockPrinter {
    function _runPrintAllianceTimelock(
        bytes32 _salt,
        uint256 _minDelay,
        address[] memory _proposers,
        address[] memory _executors
    ) internal returns (RideAllianceTimelock) {
        bytes memory data = abi.encodeWithSelector(
            RideAllyTimelockPrinter.printAllianceTimelock.selector,
            _salt,
            _minDelay,
            _proposers,
            _executors
        );

        (bool success, bytes memory result) = address(this).call(data);
        require(success, "RideLibAllyTimelockPrinter: call failed");

        return abi.decode(result, (RideAllianceTimelock));
    }
}
