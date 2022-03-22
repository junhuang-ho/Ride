//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibRunnerRegistry.sol";
import "../../libraries/core/LibRunnerDetail.sol";
import "../../libraries/core/LibJobBoard.sol";
import "../../libraries/core/LibRunner.sol";
import "../../libraries/utils/LibAccessControl.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract RunnerRegistry is IHubLibraryEvents {
    event RegisteredAsRunner(address indexed sender);

    /**
     * registerRunner registers approved applicants (has passed background check)
     *
     * @param _maxMetresPerTrip | unit in metre
     *
     * @custom:event RegisteredAsRunner
     */
    // TODO: test this not callable for runner switching hives (after registered for second hive)
    function registerAsRunner(uint256 _maxMetresPerTrip) external {
        LibRunnerRegistry._requireNotRunner();
        LibJobBoard._requireNotActive(); // ok use of requireNotActive
        LibRunnerDetail.StorageRunnerDetail storage s1 = LibRunnerDetail
            ._storageRunnerDetail();
        require(
            bytes(s1.runnerToRunnerDetail[msg.sender].uri).length != 0,
            "RunnerRegistry: URI not set"
        );
        require(msg.sender != address(0), "RunnerRegistry: Zero address");

        s1.runnerToRunnerDetail[msg.sender].id = LibRunnerRegistry._mint();
        s1
            .runnerToRunnerDetail[msg.sender]
            .maxMetresPerTrip = _maxMetresPerTrip;

        emit RegisteredAsRunner(msg.sender);
    }

    event MaxMetresUpdated(address indexed sender, uint256 metres);

    /**
     * updateMaxMetresPerTrip updates maximum metre per trip of runner
     *
     * @param _maxMetresPerTrip | unit in metre
     */
    function updateMaxMetresPerTrip(uint256 _maxMetresPerTrip) external {
        LibRunnerRegistry._requireIsRunner();
        LibJobBoard._requireNotActive(); // ok use of requireNotActive
        LibRunnerDetail
            ._storageRunnerDetail()
            .runnerToRunnerDetail[msg.sender]
            .maxMetresPerTrip = _maxMetresPerTrip;

        emit MaxMetresUpdated(msg.sender, _maxMetresPerTrip);
    }

    function approveApplicant(address _runner, string memory _uri) external {
        LibAccessControl._requireOnlyRole(LibAccessControl.HIVE_ROLE); // hive timelock

        LibRunnerRegistry._approveApplicant(_runner, _uri, msg.sender);
    }

    // note: in case URI set wrongly
    function resetURI(address _runner, string memory _uri) external {
        LibAccessControl._requireOnlyRole(LibAccessControl.HIVE_ROLE); // hive timelock

        LibRunnerDetail
            ._storageRunnerDetail()
            .runnerToRunnerDetail[_runner]
            .uri = _uri;
    }

    event SecededFromHive(address indexed sender, address hive);

    function secedeFromHive() external {
        LibRunnerRegistry._requireIsRunner();
        LibJobBoard._requireNotActive(); // ok use of requireNotActive

        LibRunnerDetail.StorageRunnerDetail storage s1 = LibRunnerDetail
            ._storageRunnerDetail();

        address hive = s1.runnerToRunnerDetail[msg.sender].hive;
        require(hive != address(0), "RunnerRegistry: caller not in hive");

        s1.runnerToRunnerDetail[msg.sender].hive = address(0);

        emit SecededFromHive(msg.sender, hive);
    }
}
