//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../alliance/facets/core/RideAlliancePrinterGovernor.sol";
import "../../../alliance/libraries/core/RideLibAlliancePrinterGovernor.sol";

contract RideTestAlliancePrinterGovernor is RideAlliancePrinterGovernor {
    function runPrintAllianceGovernor_(
        bytes32 _salt,
        string memory _nameGovernor,
        ERC20Votes _rideAlliance,
        TimelockController _rideAllianceTimelock,
        address _rideHub,
        uint256 _votingDelay,
        uint256 _votingPeriod,
        uint256 _proposalThreshold,
        uint256 _quorumPercentage
    ) external returns (RideAllianceGovernor) {
        return
            RideLibAlliancePrinterGovernor._runPrintAllianceGovernor(
                _salt,
                _nameGovernor,
                _rideAlliance,
                _rideAllianceTimelock,
                _rideHub,
                _votingDelay,
                _votingPeriod,
                _proposalThreshold,
                _quorumPercentage
            );
    }
}
