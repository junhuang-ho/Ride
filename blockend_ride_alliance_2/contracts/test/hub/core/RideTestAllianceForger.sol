//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/RideAllianceForger.sol";
import "../../../hub/libraries/core/RideLibAllianceForger.sol";

contract RideTestAllianceForger is RideAllianceForger {
    function sCount_() external view returns (uint256) {
        return RideLibAllianceForger._storageAllianceForger().count;
    }

    function ssCount_(uint256 _count) external {
        RideLibAllianceForger._storageAllianceForger().count = _count;
    }

    function sAllianceKeyToAlliance_(bytes32 _key)
        external
        view
        returns (address)
    {
        return
            RideLibAllianceForger
                ._storageAllianceForger()
                .allianceKeyToAllianceGovernanceToken[_key];
    }

    function ssAllianceKeyToAlliance_(bytes32 _key, address _address) external {
        RideLibAllianceForger
            ._storageAllianceForger()
            .allianceKeyToAllianceGovernanceToken[_key] = _address;
    }

    function sAllianceKeyToAllianceTimelock_(bytes32 _key)
        external
        view
        returns (address)
    {
        return
            RideLibAllianceForger
                ._storageAllianceForger()
                .allianceKeyToAllianceTimelock[_key];
    }

    function ssAllianceKeyToAllianceTimelock_(bytes32 _key, address _address)
        external
    {
        RideLibAllianceForger
            ._storageAllianceForger()
            .allianceKeyToAllianceTimelock[_key] = _address;
    }

    function sAllianceKeyToAllianceGovernor_(bytes32 _key)
        external
        view
        returns (address)
    {
        return
            RideLibAllianceForger
                ._storageAllianceForger()
                .allianceKeyToAllianceGovernor[_key];
    }

    function ssAllianceKeyToAllianceGovernor_(bytes32 _key, address _address)
        external
    {
        RideLibAllianceForger
            ._storageAllianceForger()
            .allianceKeyToAllianceGovernor[_key] = _address;
    }
}
