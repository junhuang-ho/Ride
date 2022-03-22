//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../template/RideAlliance.sol";
import "../../template/RideAllianceTimelock.sol";
import "../../template/RideAllianceGovernor.sol";
import "../../libraries/core/RideLibAlliancePrinter.sol";
import "../../libraries/core/RideLibAlliancePrinterTimelock.sol";
import "../../libraries/core/RideLibAlliancePrinterGovernor.sol";
import "../../libraries/core/RideLibAllianceForger.sol";
import "../../libraries/utils/RideLibAllianceAccessControl.sol";

contract RideAllianceForger {
    event AllianceForged(
        address indexed sender,
        bytes32 allianceKey,
        address alliance,
        address timelock,
        address governor
    );

    function forge(
        IERC20 _wrappedToken,
        string memory _name,
        string memory _symbol,
        uint256 _minDelay,
        address _rideHub,
        uint256 _votingDelay,
        uint256 _votingPeriod,
        uint256 _proposalThreshold,
        uint256 _quorumPercentage
    ) external {
        RideLibAllianceAccessControl._requireOnlyRole(
            RideLibAllianceAccessControl.STRATEGIST_ROLE
        );

        // string memory nameGovernor = string(
        //     abi.encodePacked(_name, "Governor")
        // );
        bytes32 salt = getSalt(_name, _symbol);
        bytes32 allianceKey = getAllianceKey(_name, _symbol);

        RideLibAllianceForger.StorageAllianceForger
            storage s1 = RideLibAllianceForger._storageAllianceForger();

        require(
            s1.allianceKeyToAlliance[allianceKey] == address(0),
            "RideAllianceForger: alliance exists!"
        );

        RideAlliance rideAlliance = RideLibAlliancePrinter._runPrintAlliance(
            salt,
            _wrappedToken,
            _name,
            _symbol
        );

        RideAllianceTimelock rideAllianceTimelock = RideLibAlliancePrinterTimelock
                ._runPrintAllianceTimelock(
                    salt,
                    _minDelay,
                    s1.proposers,
                    s1.executors
                );

        RideAllianceGovernor rideAllianceGovernor = RideLibAlliancePrinterGovernor
                ._runPrintAllianceGovernor(
                    salt,
                    string(abi.encodePacked(_name, "Governor")),
                    rideAlliance,
                    rideAllianceTimelock,
                    _rideHub,
                    _votingDelay,
                    _votingPeriod,
                    _proposalThreshold,
                    _quorumPercentage
                );

        s1.allianceKeyToAlliance[allianceKey] = address(rideAlliance);
        s1.allianceKeyToAllianceTimelock[allianceKey] = address(
            rideAllianceTimelock
        );
        s1.allianceKeyToAllianceGovernor[allianceKey] = address(
            rideAllianceGovernor
        );

        s1.count += 1;

        emit AllianceForged(
            msg.sender,
            allianceKey,
            address(rideAlliance),
            address(rideAllianceTimelock),
            address(rideAllianceGovernor)
        );
    }

    function getSalt(string memory _name, string memory _symbol)
        public
        view
        returns (bytes32)
    {
        return keccak256(abi.encode(getCount(), _name, _symbol));
    }

    function getAllianceKey(string memory _name, string memory _symbol)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(_name, _symbol));
    }

    function getCount() public view returns (uint256) {
        return RideLibAllianceForger._storageAllianceForger().count;
    }

    function getAlliance(bytes32 _key) external view returns (address) {
        return
            RideLibAllianceForger
                ._storageAllianceForger()
                .allianceKeyToAlliance[_key];
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
