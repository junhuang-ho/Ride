//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/RideAllyGovernorPrinter.sol";
import "../../../hub/libraries/core/RideLibAllyGovernorPrinter.sol";

contract RideTestAllyGovernorPrinter is RideAllyGovernorPrinter {
    function runPrintAllianceGovernor_(
        bytes32 _salt,
        string memory _nameGovernor,
        ERC20Votes _rideAllianceGovernanceToken,
        TimelockController _rideAllianceTimelock,
        uint256 _votingDelay,
        uint256 _votingPeriod,
        uint256 _proposalThreshold,
        uint256 _quorumPercentage
    ) external returns (RideAllianceGovernor) {
        return
            RideLibAllyGovernorPrinter._runPrintAllianceGovernor(
                _salt,
                _nameGovernor,
                _rideAllianceGovernanceToken,
                _rideAllianceTimelock,
                _votingDelay,
                _votingPeriod,
                _proposalThreshold,
                _quorumPercentage
            );
    }
}
