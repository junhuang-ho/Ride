//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {RideLibPenalty} from "../../libraries/core/RideLibPenalty.sol";
import {RideLibOwnership} from "../../libraries/utils/RideLibOwnership.sol";

import {IRidePenalty} from "../../interfaces/core/IRidePenalty.sol";

contract RidePenalty is IRidePenalty {
    event SetBanDuration(address indexed sender, uint256 _banDuration);

    /**
     * setBanDuration sets user ban duration
     *
     * @param _banDuration | unit in unix timestamp | https://docs.soliditylang.org/en/v0.8.10/units-and-global-variables.html#time-units
     */
    function setBanDuration(uint256 _banDuration) public override {
        RideLibOwnership.requireIsContractOwner();
        RideLibPenalty.StoragePenalty storage s1 = RideLibPenalty
            ._storagePenalty();
        s1.banDuration = _banDuration;

        emit SetBanDuration(msg.sender, _banDuration);
    }

    //////////////////////////////////////////////////////////////////////////////////
    ///// ---------------------------------------------------------------------- /////
    ///// -------------------------- getter functions -------------------------- /////
    ///// ---------------------------------------------------------------------- /////
    //////////////////////////////////////////////////////////////////////////////////

    function getBanDuration() external view override returns (uint256) {
        return RideLibPenalty._storagePenalty().banDuration;
    }

    function getAddressToBanEndTimestamp(address _address)
        external
        view
        override
        returns (uint256)
    {
        return
            RideLibPenalty._storagePenalty().addressToBanEndTimestamp[_address];
    }
}
