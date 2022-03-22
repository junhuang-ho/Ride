//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../templates/RideAllianceGovernanceToken.sol";

contract RideAllyGovernanceTokenPrinter {
    // note: required to be external, otherwise cannot get selector
    function printAllianceGovernanceToken(
        bytes32 _salt,
        IERC20 _wrappedToken,
        string memory _name,
        string memory _symbol
    ) external returns (RideAllianceGovernanceToken) {
        require(
            msg.sender == address(this),
            "RideAllyGovernanceTokenPrinter: caller not this contract"
        );

        RideAllianceGovernanceToken rideAllianceGovernanceToken = new RideAllianceGovernanceToken{
                salt: _salt
            }(_wrappedToken, _name, _symbol);

        return rideAllianceGovernanceToken;
    }
}
