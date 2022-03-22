//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../template/RideAlliance.sol";
import "../../facets/core/RideAlliancePrinter.sol";

library RideLibAlliancePrinter {
    function _runPrintAlliance(
        bytes32 _salt,
        IERC20 _wrappedToken,
        string memory _name,
        string memory _symbol
    ) internal returns (RideAlliance) {
        bytes memory data = abi.encodeWithSelector(
            RideAlliancePrinter.printAlliance.selector,
            _salt,
            _wrappedToken,
            _name,
            _symbol
        );

        (bool success, bytes memory result) = address(this).call(data);
        require(success, "RideLibAlliancePrinter: call failed");

        return abi.decode(result, (RideAlliance));
    }
}
