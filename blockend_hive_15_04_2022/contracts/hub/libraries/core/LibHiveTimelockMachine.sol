//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../templates/HiveTimelock.sol";
import "../../facets/core/HiveTimelockMachine.sol";

library LibHiveTimelockMachine {
    function _copyHiveTimelock(
        bytes32 _salt,
        uint256 _minDelay,
        address[] memory _proposers,
        address[] memory _executors
    ) internal returns (HiveTimelock) {
        bytes memory data = abi.encodeWithSelector(
            HiveTimelockMachine.createHiveTimelock.selector,
            _salt,
            _minDelay,
            _proposers,
            _executors
        );

        (bool success, bytes memory result) = address(this).call(data);
        require(success, "LibHiveTimelockMachine: call failed");

        return abi.decode(result, (HiveTimelock));
    }

    // function _getHiveTimelockBytecode(
    //     uint256 _minDelay,
    //     address[] memory _proposers,
    //     address[] memory _executors
    // ) internal pure returns (bytes memory) {
    //     bytes memory bytecode = type(HiveTimelock).creationCode;

    //     return
    //         abi.encodePacked(
    //             bytecode,
    //             abi.encode(_minDelay, _proposers, _executors)
    //         );
    // }
}
