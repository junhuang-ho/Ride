//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/RideAllyGovernanceTokenPrinter.sol";
import "../../../hub/libraries/core/RideLibAllyGovernanceTokenPrinter.sol";

contract RideTestAllyGovernanceTokenPrinter is RideAllyGovernanceTokenPrinter {
    function runPrintAllianceGovernanceToken_(
        bytes32 _salt,
        IERC20 _wrappedToken,
        string memory _name,
        string memory _symbol
    ) external returns (RideAllianceGovernanceToken) {
        return
            RideLibAllyGovernanceTokenPrinter._runPrintAllianceGovernanceToken(
                _salt,
                _wrappedToken,
                _name,
                _symbol
            );
    }
}
