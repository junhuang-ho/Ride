//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/utils/AccessControl.sol";
import "../../../hub/libraries/utils/LibAccessControl.sol";

contract TestAccessControl is AccessControl {
    function sRolesAdmin(bytes32 _role) external view returns (bytes32) {
        return LibAccessControl._storageAccessControl().roles[_role].adminRole;
    }

    function sRolesMember(bytes32 _role, address _account)
        external
        view
        returns (bool)
    {
        return
            LibAccessControl._storageAccessControl().roles[_role].members[
                _account
            ];
    }

    function ssRoles(
        bytes32 _role,
        bytes32 _adminRole,
        address _account,
        bool _bool
    ) external {
        LibAccessControl
            ._storageAccessControl()
            .roles[_role]
            .adminRole = _adminRole;
        LibAccessControl._storageAccessControl().roles[_role].members[
            _account
        ] = _bool;
    }

    function getDefaultAdminRole_() external pure returns (bytes32) {
        return LibAccessControl.DEFAULT_ADMIN_ROLE;
    }

    function requireOnlyRole_(bytes32 _role) external view returns (bool) {
        LibAccessControl._requireOnlyRole(_role);
        return true;
    }

    function hasRole_(bytes32 _role, address _account)
        external
        view
        returns (bool)
    {
        return LibAccessControl._hasRole(_role, _account);
    }

    function getRoleAdmin_(bytes32 _role) external view returns (bytes32) {
        return LibAccessControl._getRoleAdmin(_role);
    }

    function setRoleAdmin_(bytes32 _role, bytes32 _adminRole) external {
        LibAccessControl._setRoleAdmin(_role, _adminRole);
    }

    function grantRole_(bytes32 _role, address _account) external {
        LibAccessControl._grantRole(_role, _account);
    }

    function revokeRole_(bytes32 _role, address _account) external {
        LibAccessControl._revokeRole(_role, _account);
    }

    function setupRole_(bytes32 _role, address _account) external {
        LibAccessControl._setupRole(_role, _account);
    }
}
