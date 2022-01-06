// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRideUser {
    function placeDeposit(uint256 _amount) external;

    function removeDeposit() external;

    function getTokenAddress() external view returns (address);

    function getAddressToDeposit(address _address)
        external
        view
        returns (uint256);
}
