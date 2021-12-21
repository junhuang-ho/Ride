//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "../ride/RidePassenger.sol";

contract TestRidePassenger is RidePassenger {
    function paxMatchTixPax_(bytes32 _tixId, address _passenger)
        public
        view
        paxMatchTixPax(_tixId, _passenger)
        returns (bool)
    {
        return true;
    }

    function _giveRating_(address _driver, uint256 _rating) public {
        return _giveRating(_driver, _rating);
    }
}
// TODO: add setters as needed
