// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IRideAccessControl {
    event RoleAdminChanged(
        bytes32 indexed role,
        bytes32 indexed previousAdminRole,
        bytes32 indexed newAdminRole
    );

    event RoleGranted(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    event RoleRevoked(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    function hasRole(bytes32 _role, address _account)
        external
        view
        returns (bool);

    function getRoleAdmin(bytes32 _role) external view returns (bytes32);

    function grantRole(bytes32 _role, address _account) external;

    function revokeRole(bytes32 _role, address _account) external;

    function renounceRole(bytes32 _role) external;
}
