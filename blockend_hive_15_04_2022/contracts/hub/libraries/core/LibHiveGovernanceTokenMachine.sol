//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../templates/HiveGovernanceToken.sol";
import "../../facets/core/HiveGovernanceTokenMachine.sol";

library LibHiveGovernanceTokenMachine {
    function _copyHiveGovernanceToken(
        bytes32 _salt,
        IERC20 _wrappedToken,
        string memory _name,
        string memory _symbol
    ) internal returns (HiveGovernanceToken) {
        bytes memory data = abi.encodeWithSelector(
            HiveGovernanceTokenMachine.createHiveGovernanceToken.selector,
            _salt,
            _wrappedToken,
            _name,
            _symbol
        );

        (bool success, bytes memory result) = address(this).call(data);
        require(success, "LibHiveGovernanceTokenMachine: call failed");

        return abi.decode(result, (HiveGovernanceToken));
    }

    // function _getHiveGovernanceTokenBytecode(
    //     IERC20 _wrappedToken,
    //     string memory _name,
    //     string memory _symbol
    // ) internal pure returns (bytes memory) {
    //     bytes memory bytecode = type(HiveGovernanceToken).creationCode;

    //     return
    //         abi.encodePacked(
    //             bytecode,
    //             abi.encode(_wrappedToken, _name, _symbol)
    //         );
    // }
}
