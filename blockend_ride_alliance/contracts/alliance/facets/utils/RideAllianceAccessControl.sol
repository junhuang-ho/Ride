// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "../../libraries/utils/RideLibAllianceAccessControl.sol";

contract RideAllianceAccessControl {
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
        return RideLibAllianceAccessControl.DEFAULT_ADMIN_ROLE;
    }

    function getRole(string memory _role) external pure returns (bytes32) {
        return keccak256(abi.encode(_role));
    }

    function hasRole(bytes32 _role, address _account)
        external
        view
        returns (bool)
    {
        return RideLibAllianceAccessControl._hasRole(_role, _account);
    }

    function getRoleAdmin(bytes32 _role) external view returns (bytes32) {
        return RideLibAllianceAccessControl._getRoleAdmin(_role);
    }

    function grantRole(bytes32 _role, address _account) external {
        RideLibAllianceAccessControl._requireOnlyRole(
            RideLibAllianceAccessControl._getRoleAdmin(_role)
        );
        return RideLibAllianceAccessControl._grantRole(_role, _account);
    }

    function revokeRole(bytes32 _role, address _account) external {
        RideLibAllianceAccessControl._requireOnlyRole(
            RideLibAllianceAccessControl._getRoleAdmin(_role)
        );
        return RideLibAllianceAccessControl._revokeRole(_role, _account);
    }

    function renounceRole(bytes32 _role) external {
        return RideLibAllianceAccessControl._revokeRole(_role, msg.sender);
    }
}
