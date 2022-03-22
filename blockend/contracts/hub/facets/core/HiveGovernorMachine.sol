//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../templates/HiveGovernor.sol";

contract HiveGovernorMachine {
    // note: required to be external, otherwise cannot get selector
    function createHiveGovernor(
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
        require(
            msg.sender == address(this),
            "HiveGovernorMachine.sol: caller not this contract"
        );

        // TODO: test (check) the resulting name generated correctly or not
        HiveGovernor hiveGovernor = new HiveGovernor{salt: _salt}(
            _nameGovernor,
            _hiveGovernanceToken,
            _hiveTimelock,
            _underlyingContract,
            _votingDelay,
            _votingPeriod,
            _proposalThreshold,
            _quorumPercentage
        );

        return hiveGovernor;
    }

    // function generateHiveGovernorAddress(
    //     bytes32 _salt,
    //     string memory _nameGovernor,
    //     ERC20Votes _hiveGovernanceToken,
    //     TimelockController _hiveTimelock,
    //     address _underlyingContract,
    //     uint256 _votingDelay,
    //     uint256 _votingPeriod,
    //     uint256 _proposalThreshold,
    //     uint256 _quorumPercentage
    // ) public returns (address) {
    //     bytes memory bytecode = LibHiveGovernorMachine._getHiveGovernorBytecode(
    //         _nameGovernor,
    //         _hiveGovernanceToken,
    //         _hiveTimelock,
    //         _underlyingContract,
    //         _votingDelay,
    //         _votingPeriod,
    //         _proposalThreshold,
    //         _quorumPercentage
    //     );
    //     return LibHiveFactory._getAddress(bytecode, _salt);
    // }
}
