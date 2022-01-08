// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRideUser {
    event TokensDeposited(address indexed sender, uint256 amount);

    function placeDeposit(uint256 _amount) external;

    event TokensRemoved(address indexed sender, uint256 amount);

    function removeDeposit() external;

    function getTokenAddress() external view returns (address);

    function getAddressToDeposit(address _address)
        external
        view
        returns (uint256);

    event TokensTransferred(
        address indexed decrease,
        bytes32 indexed tixId,
        address increase,
        uint256 amount
    );
}
