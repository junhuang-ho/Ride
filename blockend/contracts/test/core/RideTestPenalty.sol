//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../diamondRideHub/facets/core/RidePenalty.sol";
import "../../diamondRideHub/libraries/core/RideLibPenalty.sol";

contract RideTestPenalty is RidePenalty {
    function sBanDuration_() external view returns (uint256) {
        return RideLibPenalty._storagePenalty().banDuration;
    }

    function sUserToBanEndTimestamp_(address _user)
        external
        view
        returns (uint256)
    {
        return RideLibPenalty._storagePenalty().userToBanEndTimestamp[_user];
    }

    function ssUserToBanEndTimestamp_(address _user, uint256 _endTime)
        external
    {
        RideLibPenalty._storagePenalty().userToBanEndTimestamp[
            _user
        ] = _endTime;
    }

    function requireNotBanned_() external view returns (bool) {
        RideLibPenalty._requireNotBanned();
        return true;
    }

    function setBanDuration_(uint256 _banDuration) external {
        RideLibPenalty._setBanDuration(_banDuration);
    }

    function temporaryBan_(address _address) external {
        RideLibPenalty._temporaryBan(_address);
    }

    // getBanDuration() returns (uint256);
    // getUserToBanEndTimestamp(address _user) returns (uint256);
}
