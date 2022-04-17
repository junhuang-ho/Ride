//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibPenalty.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract Penalty is IHubLibraryEvents {
    function _getUserToHiveToBanEndTimestamp(address _user, address _hive)
        external
        view
        returns (uint256)
    {
        LibPenalty._storagePenalty().userToHiveToBanEndTimestamp[_user][_hive];
    }

    function banUsers(address[] memory _user, uint256[] memory _duration)
        external
    {
        require(_user.length == _duration.length, "Penalty: array not match");

        for (uint256 i = 0; i < _user.length; i++) {
            LibPenalty._setUserToHiveToBanEndTimestamp(_user[i], _duration[i]);
        }
    }
}
