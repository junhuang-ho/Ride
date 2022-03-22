//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/RideLibAllianceForger.sol";
import "../../libraries/core/RideLibDriverRegistry.sol";
import "../../libraries/utils/RideLibAccessControl.sol";

contract RideAllianceForger {
    function forge(
        IERC20 _wrappedToken,
        string memory _name,
        string memory _symbol,
        uint256 _minDelay,
        uint256 _votingDelay,
        uint256 _votingPeriod,
        uint256 _proposalThreshold,
        uint256 _quorumPercentage,
        address[] memory _drivers,
        string[] memory _uris
    ) external {
        RideLibAccessControl._requireOnlyRole(
            RideLibAccessControl.STRATEGIST_ROLE
        );

        uint256 applicantCount = _drivers.length;
        require(
            applicantCount == _uris.length,
            "RideAllianceForger: drivers array does not match URIs array"
        );

        address allianceTimelock = RideLibAllianceForger._deploy(
            _wrappedToken,
            _name,
            _symbol,
            _minDelay,
            _votingDelay,
            _votingPeriod,
            _proposalThreshold,
            _quorumPercentage
        );

        for (uint256 i = 0; i < applicantCount; i++) {
            RideLibDriverRegistry._approveApplicant(
                _drivers[i],
                _uris[i],
                allianceTimelock
            );
        }
    }

    function getSalt(string memory _name, string memory _symbol)
        external
        view
        returns (bytes32)
    {
        return RideLibAllianceForger._getSalt(_name, _symbol);
    }

    function getAllianceKey(string memory _name, string memory _symbol)
        external
        pure
        returns (bytes32)
    {
        return RideLibAllianceForger._getAllianceKey(_name, _symbol);
    }

    function getCount() external view returns (uint256) {
        return RideLibAllianceForger._getCount();
    }

    function getAllianceGovernanceToken(bytes32 _key)
        external
        view
        returns (address)
    {
        return
            RideLibAllianceForger
                ._storageAllianceForger()
                .allianceKeyToAllianceGovernanceToken[_key];
    }

    function getAllianceTimelock(bytes32 _key) external view returns (address) {
        return
            RideLibAllianceForger
                ._storageAllianceForger()
                .allianceKeyToAllianceTimelock[_key];
    }

    function getAllianceGovernor(bytes32 _key) external view returns (address) {
        return
            RideLibAllianceForger
                ._storageAllianceForger()
                .allianceKeyToAllianceGovernor[_key];
    }
}
