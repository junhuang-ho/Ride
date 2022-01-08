//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

import {RideLibBadge} from "../../libraries/core/RideLibBadge.sol";
import {RideLibTicket} from "../../libraries/core/RideLibTicket.sol";

library RideLibDriver {
    using Counters for Counters.Counter;

    bytes32 constant STORAGE_POSITION_DRIVER = keccak256("ds.driver");

    struct StorageDriver {
        Counters.Counter _driverIdCounter;
    }

    function _storageDriver() internal pure returns (StorageDriver storage s) {
        bytes32 position = STORAGE_POSITION_DRIVER;
        assembly {
            s.slot := position
        }
    }

    function requireDrvMatchTixDrv(address _driver) internal view {
        RideLibTicket.StorageTicket storage s1 = RideLibTicket._storageTicket();
        require(
            _driver == s1.tixIdToTicket[s1.addressToTixId[msg.sender]].driver,
            "drv not match tix drv"
        );
    }

    function requireIsDriver() internal view {
        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();
        require(
            s1.addressToDriverReputation[msg.sender].id != 0,
            "caller not driver"
        );
    }

    function requireNotDriver() internal view {
        RideLibBadge.StorageBadge storage s1 = RideLibBadge._storageBadge();
        require(
            s1.addressToDriverReputation[msg.sender].id == 0,
            "caller is driver"
        );
    }

    /**
     * _mint a driver ID
     *
     * @return driver ID
     */
    function _mint() internal returns (uint256) {
        StorageDriver storage s1 = _storageDriver();
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
        StorageDriver storage s1 = _storageDriver();
        assert(s1._driverIdCounter.current() == 0);
        s1._driverIdCounter.increment();
    }
}
