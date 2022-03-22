//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../templates/RideAllianceGovernanceToken.sol";
import "../../facets/core/RideAllyGovernanceTokenPrinter.sol";

library RideLibAllyGovernanceTokenPrinter {
    function _runPrintAllianceGovernanceToken(
        bytes32 _salt,
        IERC20 _wrappedToken,
        string memory _name,
        string memory _symbol
    ) internal returns (RideAllianceGovernanceToken) {
        bytes memory data = abi.encodeWithSelector(
            RideAllyGovernanceTokenPrinter
                .printAllianceGovernanceToken
                .selector,
            _salt,
            _wrappedToken,
            _name,
            _symbol
        );

        (bool success, bytes memory result) = address(this).call(data);
        require(success, "RideLibAllyGovernanceTokenPrinter: call failed");

        return abi.decode(result, (RideAllianceGovernanceToken));
    }
}
