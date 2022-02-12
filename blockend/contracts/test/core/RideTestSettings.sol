//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../diamonds/facets/core/RideSettings.sol";
import "../../diamonds/libraries/core/RideLibSettings.sol";

contract RideTestSettings is RideSettings {
    function sAdministration_() external view returns (address) {
        return RideLibSettings._storageSettings().administration;
    }

    function setAdministrationAddress_(address _administration) external {
        RideLibSettings._setAdministrationAddress(_administration);
    }
}
