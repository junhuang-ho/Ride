// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRideHolding {
    event TokensDeposited(address indexed sender, uint256 amount);

    function depositTokens(bytes32 _key, uint256 _amount) external;

    function depositTokensPermit(
        bytes32 _key,
        uint256 _amount,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external;

    event TokensRemoved(address indexed sender, uint256 amount);

    function withdrawTokens(bytes32 _key, uint256 _amount) external;

    function getHolding(address _user, bytes32 _key)
        external
        view
        returns (uint256);

    event CurrencyTransferred(
        address indexed decrease,
        bytes32 indexed tixId,
        address increase,
        bytes32 key,
        uint256 amount
    );
}
