//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../templates/HiveGovernor.sol";
import "../../facets/core/HiveGovernorMachine.sol";

library LibHiveGovernorMachine {
    function _copyHiveGovernor(
        bytes32 _salt,
        string memory _nameGovernor,
        ERC20Votes _hiveGovernanceToken,
        TimelockController _hiveTimelock,
        address _underlyingContract,
        uint256 _votingDelay,
        uint256 _votingPeriod,
        uint256 _proposalThreshold,
        uint256 _quorumPercentage
    ) internal returns (HiveGovernor) {
        bytes memory data = abi.encodeWithSelector(
            HiveGovernorMachine.createHiveGovernor.selector,
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

        (bool success, bytes memory result) = address(this).call(data);
        require(success, "LibHiveGovernorMachine: call failed");

        return abi.decode(result, (HiveGovernor));
    }

    // function _getHiveGovernorBytecode(
    //     string memory _nameGovernor,
    //     ERC20Votes _hiveGovernanceToken,
    //     TimelockController _hiveTimelock,
    //     address _underlyingContract,
    //     uint256 _votingDelay,
    //     uint256 _votingPeriod,
    //     uint256 _proposalThreshold,
    //     uint256 _quorumPercentage
    // ) internal pure returns (bytes memory) {
    //     bytes memory bytecode = type(HiveGovernor).creationCode;

    //     return
    //         abi.encodePacked(
    //             bytecode,
    //             abi.encode(
    //                 _nameGovernor,
    //                 _hiveGovernanceToken,
    //                 _hiveTimelock,
    //                 _underlyingContract,
    //                 _votingDelay,
    //                 _votingPeriod,
    //                 _proposalThreshold,
    //                 _quorumPercentage
    //             )
    //         );
    // }
}
