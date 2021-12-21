//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "../ride/RideBadge.sol";

contract TestRideBadge is RideBadge {
    function badgesCount_() public pure returns (uint256) {
        return badgesCount;
    }

    function _getBadge_(uint256 _score) public view returns (uint256) {
        return _getBadge(_score);
    }
}
