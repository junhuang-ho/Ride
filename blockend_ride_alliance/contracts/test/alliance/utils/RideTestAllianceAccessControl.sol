//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../alliance/facets/utils/RideAllianceAccessControl.sol";
import "../../../alliance/libraries/utils/RideLibAllianceAccessControl.sol";

contract RideTestAllianceAccessControl is RideAllianceAccessControl {
    function sRolesAdmin(bytes32 _role) external view returns (bytes32) {
        return
            RideLibAllianceAccessControl
                ._storageAllianceAccessControl()
                .roles[_role]
                .adminRole;
    }

    function sRolesMember(bytes32 _role, address _account)
        external
        view
        returns (bool)
    {
        return
            RideLibAllianceAccessControl
                ._storageAllianceAccessControl()
                .roles[_role]
                .members[_account];
    }

    function ssRoles(
        bytes32 _role,
        bytes32 _adminRole,
        address _account,
        bool _bool
    ) external {
        RideLibAllianceAccessControl
            ._storageAllianceAccessControl()
            .roles[_role]
            .adminRole = _adminRole;
        RideLibAllianceAccessControl
            ._storageAllianceAccessControl()
            .roles[_role]
            .members[_account] = _bool;
    }

    function getDefaultAdminRole_() external pure returns (bytes32) {
        return RideLibAllianceAccessControl.DEFAULT_ADMIN_ROLE;
    }

    function requireOnlyRole_(bytes32 _role) external view returns (bool) {
        RideLibAllianceAccessControl._requireOnlyRole(_role);
        return true;
    }

    function hasRole_(bytes32 _role, address _account)
        external
        view
        returns (bool)
    {
        return RideLibAllianceAccessControl._hasRole(_role, _account);
    }

    function getRoleAdmin_(bytes32 _role) external view returns (bytes32) {
        return RideLibAllianceAccessControl._getRoleAdmin(_role);
    }

    function setRoleAdmin_(bytes32 _role, bytes32 _adminRole) external {
        RideLibAllianceAccessControl._setRoleAdmin(_role, _adminRole);
    }

    function grantRole_(bytes32 _role, address _account) external {
        RideLibAllianceAccessControl._grantRole(_role, _account);
    }

    function revokeRole_(bytes32 _role, address _account) external {
        RideLibAllianceAccessControl._revokeRole(_role, _account);
    }

    function setupRole_(bytes32 _role, address _account) external {
        RideLibAllianceAccessControl._setupRole(_role, _account);
    }
}
