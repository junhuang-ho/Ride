//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../interfaces/core/IRidePenalty.sol";
import "../../libraries/core/RideLibPenalty.sol";

contract RidePenalty is IRidePenalty {
    /**
     * setBanDuration sets user ban duration
     *
     * @param _banDuration | unit in unix timestamp | https://docs.soliditylang.org/en/v0.8.10/units-and-global-variables.html#time-units
     */
    function setBanDuration(uint256 _banDuration) external override {
        RideLibPenalty._setBanDuration(_banDuration);
    }

    //////////////////////////////////////////////////////////////////////////////////
    ///// ---------------------------------------------------------------------- /////
    ///// -------------------------- getter functions -------------------------- /////
    ///// ---------------------------------------------------------------------- /////
    //////////////////////////////////////////////////////////////////////////////////

    function getBanDuration() external view override returns (uint256) {
        return RideLibPenalty._storagePenalty().banDuration;
    }

    function getUserToBanEndTimestamp(address _user)
        external
        view
        override
        returns (uint256)
    {
        return RideLibPenalty._storagePenalty().userToBanEndTimestamp[_user];
    }
}
