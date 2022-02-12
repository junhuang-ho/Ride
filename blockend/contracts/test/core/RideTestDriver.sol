//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../diamonds/facets/core/RideDriver.sol";
import "../../diamonds/libraries/core/RideLibDriver.sol";

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
}
