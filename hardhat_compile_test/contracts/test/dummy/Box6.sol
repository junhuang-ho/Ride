// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./BoxLib.sol";

contract Box6 {
    // Emitted when the stored value changes
    event ValueChanged(uint256 newValue);

    // Stores a new value in the contract
    function store6Add(uint256 newValue) external {
        BoxLib._storageBoxLib().value = newValue + getOperationValue();
        emit ValueChanged(newValue);
    }

    // Stores a new value in the contract
    function store6Minus(uint256 newValue) external {
        require(newValue < BoxLib._storageBoxLib().value);
        BoxLib._storageBoxLib().value =
            BoxLib._storageBoxLib().value -
            newValue;
        emit ValueChanged(newValue);
    }

    // Reads the last stored value
    function retrieve6() external view returns (uint256) {
        return BoxLib._storageBoxLib().value;
    }

    function getOperationValue() public view returns (uint256) {
        return 6;
    }
}
