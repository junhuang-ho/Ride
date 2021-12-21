//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "../ride/RideDriver.sol";

contract TestRideDriver is RideDriver {
    function isDriver_() public view isDriver returns (bool) {
        return true;
    }

    // TODO: can't call as counter is private??
    function _mint_() public returns (uint256) {
        return _mint();
    }

    // TODO: can't call as counter is private??
    function _burnFirstDriverId_() public {
        _burnFirstDriverId();
    }
}
// TODO: add setters as needed
