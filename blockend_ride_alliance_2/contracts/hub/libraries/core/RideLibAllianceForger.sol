//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../templates/RideAllianceGovernanceToken.sol";
import "../../templates/RideAllianceTimelock.sol";
import "../../templates/RideAllianceGovernor.sol";
import "./RideLibAllyGovernanceTokenPrinter.sol";
import "./RideLibAllyTimelockPrinter.sol";
import "./RideLibAllyGovernorPrinter.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

library RideLibAllianceForger {
    bytes32 constant STORAGE_POSITION_ALLIANCEFORGER =
        keccak256("ds.allianceforger");

    struct StorageAllianceForger {
        uint256 count;
        mapping(bytes32 => address) allianceKeyToAllianceGovernanceToken;
        mapping(bytes32 => address) allianceKeyToAllianceTimelock;
        mapping(bytes32 => address) allianceKeyToAllianceGovernor;
        address[] proposers; // empty
        address[] executors; // empty
    }

    function _storageAllianceForger()
        internal
        pure
        returns (StorageAllianceForger storage s)
    {
        bytes32 position = STORAGE_POSITION_ALLIANCEFORGER;
        assembly {
            s.slot := position
        }
    }

    event AllianceDeployed(
        address indexed sender,
        bytes32 allianceKey,
        address alliance,
        address timelock,
        address governor
    );

    function _deploy(
        IERC20 _wrappedToken,
        string memory _name,
        string memory _symbol,
        uint256 _minDelay,
        uint256 _votingDelay,
        uint256 _votingPeriod,
        uint256 _proposalThreshold,
        uint256 _quorumPercentage
    ) internal returns (address) {
        // string memory nameGovernor = string(
        //     abi.encodePacked(_name, "Governor")
        // );
        bytes32 salt = _getSalt(_name, _symbol);
        bytes32 allianceKey = _getAllianceKey(_name, _symbol);

        StorageAllianceForger storage s1 = _storageAllianceForger();

        require(
            s1.allianceKeyToAllianceGovernanceToken[allianceKey] == address(0),
            "RideLibAllianceForger: alliance exists!"
        );

        RideAllianceGovernanceToken rideAllianceGovernanceToken = RideLibAllyGovernanceTokenPrinter
                ._runPrintAllianceGovernanceToken(
                    salt,
                    _wrappedToken,
                    _name,
                    _symbol
                );

        RideAllianceTimelock rideAllianceTimelock = RideLibAllyTimelockPrinter
            ._runPrintAllianceTimelock(
                salt,
                _minDelay,
                s1.proposers,
                s1.executors
            );

        RideAllianceGovernor rideAllianceGovernor = RideLibAllyGovernorPrinter
            ._runPrintAllianceGovernor(
                salt,
                string(abi.encodePacked(_name, "Governor")),
                rideAllianceGovernanceToken,
                rideAllianceTimelock,
                _votingDelay,
                _votingPeriod,
                _proposalThreshold,
                _quorumPercentage
            );

        s1.allianceKeyToAllianceGovernanceToken[allianceKey] = address(
            rideAllianceGovernanceToken
        );
        s1.allianceKeyToAllianceTimelock[allianceKey] = address(
            rideAllianceTimelock
        );
        s1.allianceKeyToAllianceGovernor[allianceKey] = address(
            rideAllianceGovernor
        );

        s1.count += 1;

        emit AllianceDeployed(
            msg.sender,
            allianceKey,
            address(rideAllianceGovernanceToken),
            address(rideAllianceTimelock),
            address(rideAllianceGovernor)
        );

        return address(rideAllianceTimelock);
    }

    function _getSalt(string memory _name, string memory _symbol)
        internal
        view
        returns (bytes32)
    {
        return keccak256(abi.encode(_getCount(), _name, _symbol));
    }

    function _getAllianceKey(string memory _name, string memory _symbol)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(_name, _symbol));
    }

    function _getCount() internal view returns (uint256) {
        return _storageAllianceForger().count;
    }
}
