//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../template/RideAllianceGovernor.sol";
import "../../facets/core/RideAlliancePrinterGovernor.sol";

library RideLibAlliancePrinterGovernor {
    function _runPrintAllianceGovernor(
        bytes32 _salt,
        string memory _nameGovernor,
        ERC20Votes _rideAlliance,
        TimelockController _rideAllianceTimelock,
        address _rideHub,
        uint256 _votingDelay,
        uint256 _votingPeriod,
        uint256 _proposalThreshold,
        uint256 _quorumPercentage
    ) internal returns (RideAllianceGovernor) {
        bytes memory data = abi.encodeWithSelector(
            RideAlliancePrinterGovernor.printAllianceGovernor.selector,
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

        (bool success, bytes memory result) = address(this).call(data);
        require(success, "RideLibAlliancePrinterGovernor: call failed");

        return abi.decode(result, (RideAllianceGovernor));
    }
}
