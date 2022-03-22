//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../template/RideAlliance.sol";
import "../../libraries/utils/RideLibAllianceAccessControl.sol";

contract RideAlliancePrinter {
    // note: required to be external, otherwise cannot get selector
    function printAlliance(
        bytes32 _salt,
        IERC20 _wrappedToken,
        string memory _name,
        string memory _symbol
    ) external returns (RideAlliance) {
        require(
            msg.sender == address(this),
            "RideAlliancePrinter: caller not this contract"
        );

        RideAlliance rideAlliance = new RideAlliance{salt: _salt}(
            _wrappedToken,
            _name,
            _symbol
        );

        return rideAlliance;
    }
}
