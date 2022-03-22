//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../template/RideAllianceTimelock.sol";
import "../../libraries/utils/RideLibAllianceAccessControl.sol";

contract RideAlliancePrinterTimelock {
    // note: required to be external, otherwise cannot get selector
    function printAllianceTimelock(
        bytes32 _salt,
        uint256 _minDelay,
        address[] memory _proposers,
        address[] memory _executors
    ) external returns (RideAllianceTimelock) {
        require(
            msg.sender == address(this),
            "RideAlliancePrinter: caller not this contract"
        );

        RideAllianceTimelock rideAllianceTimelock = new RideAllianceTimelock{
            salt: _salt
        }(_minDelay, _proposers, _executors);

        return rideAllianceTimelock;
    }
}
