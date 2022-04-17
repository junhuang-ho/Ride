//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../templates/HiveTimelock.sol";

contract HiveTimelockMachine {
    // note: required to be external, otherwise cannot get selector
    function createHiveTimelock(
        bytes32 _salt,
        uint256 _minDelay,
        address[] memory _proposers,
        address[] memory _executors
    ) external returns (HiveTimelock) {
        require(
            msg.sender == address(this),
            "HiveTimelockMachine: caller not this contract"
        );

        HiveTimelock hiveTimelock = new HiveTimelock{salt: _salt}(
            _minDelay,
            _proposers,
            _executors
        );

        return hiveTimelock;
    }

    // function generateHiveTimelockAddress(
    //     bytes32 _salt,
    //     uint256 _minDelay,
    //     address[] memory _proposers,
    //     address[] memory _executors
    // ) public returns (address) {
    //     bytes memory bytecode = LibHiveTimelockMachine._getHiveTimelockBytecode(
    //         _minDelay,
    //         _proposers,
    //         _executors
    //     );
    //     return LibHiveFactory._getAddress(bytecode, _salt);
    // }
}
