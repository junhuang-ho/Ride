//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../diamonds/facets/utils/RideAccessControl.sol";
import "../../diamonds/libraries/utils/RideLibAccessControl.sol";

contract RideTestAccessControl is RideAccessControl {
    function sRolesAdmin(bytes32 _role) external view returns (bytes32) {
        return
            RideLibAccessControl._storageAccessControl().roles[_role].adminRole;
    }

    function sRolesMember(bytes32 _role, address _account)
        external
        view
        returns (bool)
    {
        return
            RideLibAccessControl._storageAccessControl().roles[_role].members[
                _account
            ];
    }

    function ssRoles(
        bytes32 _role,
        bytes32 _adminRole,
        address _account,
        bool _bool
    ) external {
        RideLibAccessControl
            ._storageAccessControl()
            .roles[_role]
            .adminRole = _adminRole;
        RideLibAccessControl._storageAccessControl().roles[_role].members[
                _account
            ] = _bool;
    }

    function getDefaultAdminRole_() external pure returns (bytes32) {
        return RideLibAccessControl.DEFAULT_ADMIN_ROLE;
    }

    function requireOnlyRole_(bytes32 _role) external view returns (bool) {
        RideLibAccessControl._requireOnlyRole(_role);
        return true;
    }

    function hasRole_(bytes32 _role, address _account)
        external
        view
        returns (bool)
    {
        return RideLibAccessControl._hasRole(_role, _account);
    }

    function getRoleAdmin_(bytes32 _role) external view returns (bytes32) {
        return RideLibAccessControl._getRoleAdmin(_role);
    }

    function setupRole_(bytes32 _role, address _account) external {
        RideLibAccessControl._setupRole(_role, _account);
    }

    function setRoleAdmin_(bytes32 _role, bytes32 _adminRole) external {
        RideLibAccessControl._setRoleAdmin(_role, _adminRole);
    }

    function grantRole_(bytes32 _role, address _account) external {
        RideLibAccessControl._grantRole(_role, _account);
    }

    function revokeRole_(bytes32 _role, address _account) external {
        RideLibAccessControl._revokeRole(_role, _account);
    }
}
