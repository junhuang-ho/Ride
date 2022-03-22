//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/RidePenalty.sol";
import "../../../hub/libraries/core/RideLibPenalty.sol";

contract RideTestPenalty is RidePenalty {
    function sBanDuration_(address _alliance) external view returns (uint256) {
        return
            RideLibPenalty._storagePenalty().allianceToBanDuration[_alliance];
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

    function temporaryBan_(address _alliance, address _user) external {
        RideLibPenalty._temporaryBan(_alliance, _user);
    }

    // getBanDuration() returns (uint256);
    // getUserToBanEndTimestamp(address _user) returns (uint256);
}
