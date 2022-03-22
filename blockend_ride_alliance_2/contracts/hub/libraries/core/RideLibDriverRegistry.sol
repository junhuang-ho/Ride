//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./RideLibDriverDetails.sol";

library RideLibDriverRegistry {
    using Counters for Counters.Counter;

    bytes32 constant STORAGE_POSITION_DRIVERREGISTRY =
        keccak256("ds.driverregistry");

    struct StorageDriverRegistry {
        Counters.Counter _driverIdCounter;
    }

    function _storageDriverRegistry()
        internal
        pure
        returns (StorageDriverRegistry storage s)
    {
        bytes32 position = STORAGE_POSITION_DRIVERREGISTRY;
        assembly {
            s.slot := position
        }
    }

    /**
     * _mint a driver ID
     *
     * @return driver ID
     */
    function _mint() internal returns (uint256) {
        StorageDriverRegistry storage s1 = _storageDriverRegistry();
        uint256 id = s1._driverIdCounter.current();
        s1._driverIdCounter.increment();
        return id;
    }

    /**
     * _burnFirstDriverId burns driver ID 0
     * can only be called at RideHub deployment
     *
     * TODO: call at init ONLY
     */
    function _burnFirstDriverId() internal {
        StorageDriverRegistry storage s1 = _storageDriverRegistry();
        require(
            s1._driverIdCounter.current() == 0,
            "RideLibDriverRegistry: Must be zero"
        );
        s1._driverIdCounter.increment();
    }

    event ApplicantApproved(address indexed applicant);

    function _approveApplicant(
        address _driver,
        string memory _uri,
        address _allianceTimelock
    ) internal {
        RideLibDriverDetails.StorageDriverDetails
            storage s1 = RideLibDriverDetails._storageDriverDetails();

        require(
            s1.driverToDriverDetails[_driver].alliance == address(0),
            "RideLibDriverRegistry: alliance exist for applicant"
        );
        s1.driverToDriverDetails[_driver].uri = _uri; // note: possible to override URI when joining new alliance
        s1.driverToDriverDetails[_driver].alliance = _allianceTimelock;
        // s1.allianceToDrivers[_allianceTimelock].push(_driver); // note: depends on RideDriverDetails.calculateCollectiveScore

        emit ApplicantApproved(_driver);
    }
}
