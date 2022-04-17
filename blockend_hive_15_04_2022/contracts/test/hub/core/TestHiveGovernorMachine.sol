//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/HiveGovernorMachine.sol";
import "../../../hub/libraries/core/LibHiveGovernorMachine.sol";

contract TestHiveGovernorMachine is HiveGovernorMachine {
    function copyHiveGovernor_(
        bytes32 _salt,
        string memory _nameGovernor,
        ERC20Votes _hiveGovernanceToken,
        TimelockController _hiveTimelock,
        address _underlyingContract,
        uint256 _votingDelay,
        uint256 _votingPeriod,
        uint256 _proposalThreshold,
        uint256 _quorumPercentage
    ) external returns (HiveGovernor) {
        return
            LibHiveGovernorMachine._copyHiveGovernor(
                _salt,
                _nameGovernor,
                _hiveGovernanceToken,
                _hiveTimelock,
                _underlyingContract,
                _votingDelay,
                _votingPeriod,
                _proposalThreshold,
                _quorumPercentage
            );
    }
}
