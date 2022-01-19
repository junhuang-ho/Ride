//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideDriver} from "../../facets/core/RideDriver.sol";
import {RideLibDriver} from "../../libraries/core/RideLibDriver.sol";

contract RideTestDriver is RideDriver {
    function requireDrvMatchTixDrv_(address _driver)
        external
        view
        returns (bool)
    {
        RideLibDriver._requireDrvMatchTixDrv(_driver);
        return true;
    }

    function requireIsDriver_() external view returns (bool) {
        RideLibDriver._requireIsDriver();
        return true;
    }

    function requireNotDriver_() external view returns (bool) {
        RideLibDriver._requireNotDriver();
        return true;
    }

    // acceptTicket(
    //     bytes32 _keyLocal,
    //     bytes32 _keyAccept,
    //     bytes32 _tixId,
    //     uint256 _useBadge);
    // cancelPickUp();
    // endTripDrv(bool _reached);
    // forceEndDrv();
}
