//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../templates/RideAllianceGovernor.sol";
import "../../facets/core/RideAllyGovernorPrinter.sol";

library RideLibAllyGovernorPrinter {
    function _runPrintAllianceGovernor(
        bytes32 _salt,
        string memory _nameGovernor,
        ERC20Votes _rideAllianceGovernanceToken,
        TimelockController _rideAllianceTimelock,
        uint256 _votingDelay,
        uint256 _votingPeriod,
        uint256 _proposalThreshold,
        uint256 _quorumPercentage
    ) internal returns (RideAllianceGovernor) {
        bytes memory data = abi.encodeWithSelector(
            RideAllyGovernorPrinter.printAllianceGovernor.selector,
            _salt,
            _nameGovernor,
            _rideAllianceGovernanceToken,
            _rideAllianceTimelock,
            _votingDelay,
            _votingPeriod,
            _proposalThreshold,
            _quorumPercentage
        );

        (bool success, bytes memory result) = address(this).call(data);
        require(success, "RideLibAllyGovernorPrinter: call failed");

        return abi.decode(result, (RideAllianceGovernor));
    }
}
