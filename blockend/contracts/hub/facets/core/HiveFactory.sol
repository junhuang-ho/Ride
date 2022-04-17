//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../templates/HiveTimelock.sol";
import "../../libraries/core/LibHiveFactory.sol";
import "../../libraries/core/LibHiveGovernanceTokenMachine.sol";
import "../../libraries/core/LibRunnerRegistry.sol";
import "../../libraries/utils/LibAccessControl.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract HiveFactory is IHubLibraryEvents {
    function setHiveCreationCount(uint256 _count) external {
        LibHiveFactory._setHiveCreationCount(_count);
    }

    function clearUnfinishedHive() external {
        LibAccessControl._requireOnlyRole(LibAccessControl.STRATEGIST_ROLE);

        LibHiveFactory._requireCorrectOrder(0);

        LibHiveFactory.StorageHiveFactory storage s1 = LibHiveFactory
            ._storageHiveFactory();

        delete s1.hiveKeyToHiveGovernanceToken[s1.currentHiveKey];
        delete s1.hiveKeyToHiveTimelock[s1.currentHiveKey];
        delete s1.hiveKeyToHiveGovernor[s1.currentHiveKey];

        LibHiveFactory._resetHiveOrder();
    }

    event HiveCreationInitialized(
        address indexed sender,
        uint256 orderCount,
        bytes32 salt,
        bytes32 hiveKey
    );

    function initializeHiveGeneration(
        string memory _name,
        string memory _symbol
    ) external {
        LibAccessControl._requireOnlyRole(LibAccessControl.STRATEGIST_ROLE);

        LibHiveFactory.StorageHiveFactory storage s1 = LibHiveFactory
            ._storageHiveFactory();

        LibHiveFactory._requireCorrectOrder(0);

        s1.currentSalt = LibHiveFactory._getSalt(_name, _symbol);
        s1.currentHiveKey = LibHiveFactory._getHiveKey(_name, _symbol);

        LibHiveFactory._incrementOrder();

        emit HiveCreationInitialized(
            msg.sender,
            s1.hiveCurrentOrder,
            s1.currentSalt,
            s1.currentHiveKey
        );
    }

    event HiveComponentDeployed(
        address indexed sender,
        uint256 orderCount,
        address component
    );

    function deployHiveGovernanceToken(
        IERC20 _wrappedToken,
        string memory _name,
        string memory _symbol
    ) external {
        LibAccessControl._requireOnlyRole(LibAccessControl.STRATEGIST_ROLE);

        LibHiveFactory._requireCorrectOrder(1);

        LibHiveFactory.StorageHiveFactory storage s1 = LibHiveFactory
            ._storageHiveFactory();

        require(
            s1.hiveKeyToHiveGovernanceToken[s1.currentHiveKey] == address(0),
            "HiveFactory: HiveGovernanceToken exists!"
        );

        HiveGovernanceToken hiveGovernanceToken = LibHiveGovernanceTokenMachine
            ._copyHiveGovernanceToken(
                s1.currentSalt,
                _wrappedToken,
                _name,
                _symbol
            );

        s1.hiveKeyToHiveGovernanceToken[s1.currentHiveKey] = address(
            hiveGovernanceToken
        );

        LibHiveFactory._incrementOrder();

        emit HiveComponentDeployed(
            msg.sender,
            s1.hiveCurrentOrder,
            address(hiveGovernanceToken)
        );
    }

    function deployHiveTimelock(
        uint256 _minDelay,
        address[] memory _proposers,
        address[] memory _executors
    ) external {
        LibAccessControl._requireOnlyRole(LibAccessControl.STRATEGIST_ROLE);

        LibHiveFactory._requireCorrectOrder(2);

        LibHiveFactory.StorageHiveFactory storage s1 = LibHiveFactory
            ._storageHiveFactory();

        require(
            s1.hiveKeyToHiveTimelock[s1.currentHiveKey] == address(0),
            "HiveFactory: HiveTimelock exists!"
        );

        HiveTimelock hiveTimelock = LibHiveTimelockMachine._copyHiveTimelock(
            s1.currentSalt,
            _minDelay,
            _proposers,
            _executors
        );

        s1.hiveKeyToHiveTimelock[s1.currentHiveKey] = address(hiveTimelock);

        LibHiveFactory._incrementOrder();

        emit HiveComponentDeployed(
            msg.sender,
            s1.hiveCurrentOrder,
            address(hiveTimelock)
        );
    }

    function deployHiveGovernor(
        string memory _name,
        ERC20Votes _hiveGovernanceToken,
        TimelockController _hiveTimelock,
        address _underlyingContract,
        uint256 _votingDelay,
        uint256 _votingPeriod,
        uint256 _proposalThreshold,
        uint256 _quorumPercentage
    ) external {
        LibAccessControl._requireOnlyRole(LibAccessControl.STRATEGIST_ROLE);

        LibHiveFactory._requireCorrectOrder(3);

        LibHiveFactory.StorageHiveFactory storage s1 = LibHiveFactory
            ._storageHiveFactory();

        require(
            s1.hiveKeyToHiveGovernor[s1.currentHiveKey] == address(0),
            "HiveFactory: HiveGovernor exists!"
        );

        HiveGovernor hiveGovernor = LibHiveGovernorMachine._copyHiveGovernor(
            s1.currentSalt,
            string(abi.encodePacked(_name, "Governor")),
            _hiveGovernanceToken,
            _hiveTimelock,
            _underlyingContract,
            _votingDelay,
            _votingPeriod,
            _proposalThreshold,
            _quorumPercentage
        );

        s1.hiveKeyToHiveGovernor[s1.currentHiveKey] = address(hiveGovernor);

        LibHiveFactory._incrementOrder();

        emit HiveComponentDeployed(
            msg.sender,
            s1.hiveCurrentOrder,
            address(hiveGovernor)
        );
    }

    event HiveActivated(
        address indexed sender,
        uint256 hiveCount,
        bytes32 hiveKey
    );

    /** NOTE
     * requires some initial runners for voting otherwise nothing can be approved,
     * see templates/HiveGovernor.sol, can just put the administrative addresses
     * and these addresses should have sufficient voting power to make proposals
     */
    function activateHive(
        address[] memory _administrators,
        string[] memory _uris
    ) external {
        LibAccessControl._requireOnlyRole(LibAccessControl.STRATEGIST_ROLE);

        LibHiveFactory._requireCorrectOrder(4);

        uint256 applicantCount = _administrators.length;
        require(
            applicantCount == _uris.length,
            "HiveFactory: runners array does not match URIs array"
        );

        LibHiveFactory.StorageHiveFactory storage s1 = LibHiveFactory
            ._storageHiveFactory();

        require(
            s1.hiveCurrentOrder == s1.hiveCreationCount,
            "HiveFactory: correct hive creation count not reached"
        );

        s1.count += 1;

        // setup

        address hiveTimelockAddress = s1.hiveKeyToHiveTimelock[
            s1.currentHiveKey
        ];

        HiveTimelock hiveTimelockContract = HiveTimelock(
            payable(hiveTimelockAddress)
        );
        hiveTimelockContract.grantRole(
            hiveTimelockContract.PROPOSER_ROLE(),
            s1.hiveKeyToHiveGovernor[s1.currentHiveKey]
        );
        hiveTimelockContract.grantRole(
            hiveTimelockContract.EXECUTOR_ROLE(),
            address(0)
        );
        hiveTimelockContract.renounceRole(
            hiveTimelockContract.TIMELOCK_ADMIN_ROLE(),
            address(this)
        ); // note: address(this) == hub address

        for (uint256 i = 0; i < applicantCount; i++) {
            LibRunnerRegistry._approveApplicant(
                _administrators[i],
                _uris[i],
                hiveTimelockAddress
            );
        }

        LibAccessControl._setupRole(
            LibAccessControl.HIVE_ROLE,
            hiveTimelockAddress
        );

        LibHiveFactory._resetHiveOrder();

        emit HiveActivated(msg.sender, s1.count, s1.currentHiveKey);
    }

    function getSalt(string memory _name, string memory _symbol)
        external
        view
        returns (bytes32)
    {
        return LibHiveFactory._getSalt(_name, _symbol);
    }

    function getHiveKey(string memory _name, string memory _symbol)
        external
        pure
        returns (bytes32)
    {
        return LibHiveFactory._getHiveKey(_name, _symbol);
    }

    function getCount() external view returns (uint256) {
        return LibHiveFactory._getCount();
    }

    function getHiveGovernanceToken(bytes32 _key)
        external
        view
        returns (address)
    {
        return
            LibHiveFactory._storageHiveFactory().hiveKeyToHiveGovernanceToken[
                _key
            ];
    }

    function getHiveTimelock(bytes32 _key) external view returns (address) {
        return LibHiveFactory._storageHiveFactory().hiveKeyToHiveTimelock[_key];
    }

    function getHiveGovernor(bytes32 _key) external view returns (address) {
        return LibHiveFactory._storageHiveFactory().hiveKeyToHiveGovernor[_key];
    }
}
