//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/HiveGovernanceTokenMachine.sol";
import "../../../hub/libraries/core/LibHiveGovernanceTokenMachine.sol";

contract TestHiveGovernanceTokenMachine is HiveGovernanceTokenMachine {
    function copyHiveGovernanceToken_(
        bytes32 _salt,
        IERC20 _wrappedToken,
        string memory _name,
        string memory _symbol
    ) external returns (HiveGovernanceToken) {
        return
            LibHiveGovernanceTokenMachine._copyHiveGovernanceToken(
                _salt,
                _wrappedToken,
                _name,
                _symbol
            );
    }
}
