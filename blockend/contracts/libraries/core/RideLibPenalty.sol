//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

library RideLibPenalty {
    bytes32 constant STORAGE_POSITION_PENALTY = keccak256("ds.penalty");

    struct StoragePenalty {
        uint256 banDuration;
        mapping(address => uint256) addressToBanEndTimestamp;
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

    function requireNotBanned() internal view {
        StoragePenalty storage s1 = _storagePenalty();
        require(
            block.timestamp >= s1.addressToBanEndTimestamp[msg.sender],
            "still banned"
        );
    }

    event UserBanned(address indexed banned, uint256 from, uint256 to);

    /**
     * _temporaryBan user
     *
     * @param _address address to be banned
     *
     * @custom:event UserBanned
     */
    function _temporaryBan(address _address) internal {
        StoragePenalty storage s1 = _storagePenalty();
        uint256 banUntil = block.timestamp + s1.banDuration;
        s1.addressToBanEndTimestamp[_address] = banUntil;

        emit UserBanned(_address, block.timestamp, banUntil);
    }
}
