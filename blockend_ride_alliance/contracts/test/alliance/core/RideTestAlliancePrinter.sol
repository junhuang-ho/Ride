//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../alliance/facets/core/RideAlliancePrinter.sol";
import "../../../alliance/libraries/core/RideLibAlliancePrinter.sol";

contract RideTestAlliancePrinter is RideAlliancePrinter {
    function runPrintAlliance_(
        bytes32 _salt,
        IERC20 _wrappedToken,
        string memory _name,
        string memory _symbol
    ) external returns (RideAlliance) {
        return
            RideLibAlliancePrinter._runPrintAlliance(
                _salt,
                _wrappedToken,
                _name,
                _symbol
            );
    }
}
