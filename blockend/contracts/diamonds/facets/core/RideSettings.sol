//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../interfaces/core/IRideSettings.sol";
import "../../libraries/core/RideLibSettings.sol";

contract RideSettings is IRideSettings {
    function setAdministrationAddress(address _administration)
        external
        override
    {
        RideLibSettings._setAdministrationAddress(_administration);
    }

    function getAdministrationAddress()
        external
        view
        override
        returns (address)
    {
        return RideLibSettings._storageSettings().administration;
    }
}
