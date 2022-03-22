//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../template/RideAllianceGovernor.sol";
import "../../libraries/utils/RideLibAllianceAccessControl.sol";

contract RideAlliancePrinterGovernor {
    // note: required to be external, otherwise cannot get selector
    function printAllianceGovernor(
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
        require(
            msg.sender == address(this),
            "RideAlliancePrinter: caller not this contract"
        );

        // TODO: test (check) the resulting name generated correctly or not
        RideAllianceGovernor rideAllianceGovernor = new RideAllianceGovernor{
            salt: _salt
        }(
            _nameGovernor,
            _rideAlliance,
            _rideAllianceTimelock,
            _rideHub,
            _votingDelay,
            _votingPeriod,
            _proposalThreshold,
            _quorumPercentage
        );

        return rideAllianceGovernor;
    }
}
