// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibBoxers.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract Boxers is IHubLibraryEvents {
    // event ValueChanged(uint256 newValue);

    // function store(uint256 newValue) external {
    //     LibBoxers._store(newValue);
    // }

    event ValueChanged2(uint256 newValue);

    function store2(uint256 newValue) external {
        LibBoxers._store(newValue);
        LibBoxers._storageBoxers().value2 = newValue;

        emit ValueChanged2(newValue);
    }

    function retrieve() external view returns (uint256) {
        return LibBoxers._storageBoxers().value1;
    }
}
