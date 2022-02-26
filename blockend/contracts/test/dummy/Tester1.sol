// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./Tester1Lib.sol";

import "./Tester2Lib.sol";

contract Tester1 {
    uint256 public myNum;

    function setNum(uint256 _num1, uint256 _num2) public {
        myNum = Tester1Lib.calculate(_num1, _num2);
    }
}
