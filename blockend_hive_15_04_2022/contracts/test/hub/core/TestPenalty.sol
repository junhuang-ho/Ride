//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/Penalty.sol";
import "../../../hub/libraries/core/LibPenalty.sol";

contract TestPenalty is Penalty {
    function sUserToHiveToBanEndTimestamp_(address _user, address _hive)
        external
        view
        returns (uint256)
    {
        return
            LibPenalty._storagePenalty().userToHiveToBanEndTimestamp[_user][
                _hive
            ];
    }

    function ssUserToHiveToBanEndTimestamp_(
        address _user,
        address _hive,
        uint256 _endTime
    ) external {
        LibPenalty._storagePenalty().userToHiveToBanEndTimestamp[_user][
                _hive
            ] = _endTime;
    }

    function requireNotBanned_(address _hive) external view returns (bool) {
        LibPenalty._requireNotBanned(_hive);
        return true;
    }

    function setUserToHiveToBanEndTimestamp_(
        address _user,
        uint256 _banDuration
    ) external {
        LibPenalty._setUserToHiveToBanEndTimestamp(_user, _banDuration);
    }
}
