// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./BoxLib.sol";

contract Box5 {
    // Emitted when the stored value changes
    event ValueChanged(uint256 newValue);

    // Stores a new value in the contract
    function store5Add(uint256 newValue) external {
        BoxLib._storageBoxLib().value = newValue + getOperationValue();
        emit ValueChanged(newValue);
    }

    // // Stores a new value in the contract
    // function store5Minus(uint256 newValue) public {
    //     BoxLib._storageBoxLib().value = newValue - getOperationValue();
    //     emit ValueChanged(newValue);
    // }

    // Reads the last stored value
    function retrieve5() external view returns (uint256) {
        return BoxLib._storageBoxLib().value;
    }

    function getOperationValue() public view returns (uint256) {
        return 5;
    }
}
