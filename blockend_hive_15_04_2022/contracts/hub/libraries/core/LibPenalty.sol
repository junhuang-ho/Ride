//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../utils/LibAccessControl.sol";

library LibPenalty {
    bytes32 constant STORAGE_POSITION_PENALTY = keccak256("ds.penalty");

    struct StoragePenalty {
        mapping(address => mapping(address => uint256)) userToHiveToBanEndTimestamp;
    }

    function _storagePenalty()
        internal
        pure
        returns (StoragePenalty storage s)
    {
        bytes32 position = STORAGE_POSITION_PENALTY;
        assembly {
            s.slot := position
        }
    }

    function _requireNotBanned(address _hive) internal view {
        require(
            block.timestamp >=
                _storagePenalty().userToHiveToBanEndTimestamp[msg.sender][
                    _hive
                ],
            "LibPenalty: still banned"
        );
    }

    event UserBanned(address indexed sender, address user, uint256 banDuration);

    function _setUserToHiveToBanEndTimestamp(address _user, uint256 _duration)
        internal
    {
        LibAccessControl._requireOnlyRole(LibAccessControl.HIVE_ROLE);

        _storagePenalty().userToHiveToBanEndTimestamp[_user][msg.sender] =
            block.timestamp +
            _duration;

        emit UserBanned(msg.sender, _user, _duration);
    }
}
