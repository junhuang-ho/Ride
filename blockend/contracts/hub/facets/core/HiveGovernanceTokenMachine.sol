//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../templates/HiveGovernanceToken.sol";

contract HiveGovernanceTokenMachine {
    // note: required to be external, otherwise cannot get selector
    function createHiveGovernanceToken(
        bytes32 _salt,
        IERC20 _wrappedToken,
        string memory _name,
        string memory _symbol
    ) external returns (HiveGovernanceToken) {
        require(
            msg.sender == address(this),
            "HiveGovernanceTokenMachine: caller not this contract"
        );

        HiveGovernanceToken hiveGovernanceToken = new HiveGovernanceToken{
            salt: _salt
        }(_wrappedToken, _name, _symbol);

        return hiveGovernanceToken;
    }

    // function generateHiveGovernanceTokenAddress(
    //     bytes32 _salt,
    //     IERC20 _wrappedToken,
    //     string memory _name,
    //     string memory _symbol
    // ) public returns (address) {
    //     bytes memory bytecode = LibHiveGovernanceTokenMachine
    //         ._getHiveGovernanceTokenBytecode(_wrappedToken, _name, _symbol);
    //     return LibHiveFactory._getAddress(bytecode, _salt);
    // }
}
