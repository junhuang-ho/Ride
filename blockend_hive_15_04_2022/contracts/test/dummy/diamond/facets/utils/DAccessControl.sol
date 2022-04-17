// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "../../libraries/utils/DLibAccessControl.sol";

contract DAccessControl {
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

    function getDefaultAdminRole() external pure returns (bytes32) {
        return DLibAccessControl.DEFAULT_ADMIN_ROLE;
    }

    function getRole(string memory _role) external pure returns (bytes32) {
        return keccak256(abi.encode(_role));
    }

    function hasRole(bytes32 _role, address _account)
        external
        view
        returns (bool)
    {
        return DLibAccessControl._hasRole(_role, _account);
    }

    function getRoleAdmin(bytes32 _role) external view returns (bytes32) {
        return DLibAccessControl._getRoleAdmin(_role);
    }

    function grantRole(bytes32 _role, address _account) external {
        DLibAccessControl._requireOnlyRole(
            DLibAccessControl._getRoleAdmin(_role)
        );
        return DLibAccessControl._grantRole(_role, _account);
    }

    function revokeRole(bytes32 _role, address _account) external {
        DLibAccessControl._requireOnlyRole(
            DLibAccessControl._getRoleAdmin(_role)
        );
        return DLibAccessControl._revokeRole(_role, _account);
    }

    function renounceRole(bytes32 _role) external {
        return DLibAccessControl._revokeRole(_role, msg.sender);
    }
}
