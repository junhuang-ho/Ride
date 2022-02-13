// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "../../interfaces/utils/IRideAccessControl.sol";
import "../../libraries/utils/RideLibAccessControl.sol";

abstract contract RideAccessControl is IRideAccessControl {
    function hasRole(bytes32 _role, address _account)
        external
        view
        override
        returns (bool)
    {
        return RideLibAccessControl._hasRole(_role, _account);
    }

    function getRoleAdmin(bytes32 _role)
        external
        view
        override
        returns (bytes32)
    {
        return RideLibAccessControl._getRoleAdmin(_role);
    }

    function grantRole(bytes32 _role, address _account) external override {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl._getRoleAdmin(_role)
        );
        return RideLibAccessControl._grantRole(_role, _account);
    }

    function revokeRole(bytes32 _role, address _account) external override {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl._getRoleAdmin(_role)
        );
        return RideLibAccessControl._revokeRole(_role, _account);
    }

    function renounceRole(bytes32 _role) external override {
        return RideLibAccessControl._revokeRole(_role, msg.sender);
    }
}
