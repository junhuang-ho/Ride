//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/utils/RideLibOwnership.sol";

library RideLibPenalty {
    bytes32 constant STORAGE_POSITION_PENALTY = keccak256("ds.penalty");

    struct StoragePenalty {
        uint256 banDuration;
        mapping(address => uint256) userToBanEndTimestamp;
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

    function _requireNotBanned() internal view {
        require(
            block.timestamp >=
                _storagePenalty().userToBanEndTimestamp[msg.sender],
            "still banned"
        );
    }

    event SetBanDuration(address indexed sender, uint256 _banDuration);

    /**
     * setBanDuration sets user ban duration
     *
     * @param _banDuration | unit in unix timestamp | https://docs.soliditylang.org/en/v0.8.10/units-and-global-variables.html#time-units
     */
    function _setBanDuration(uint256 _banDuration) internal {
        RideLibOwnership._requireIsOwner();
        _storagePenalty().banDuration = _banDuration;

        emit SetBanDuration(msg.sender, _banDuration);
    }

    event UserBanned(address indexed user, uint256 from, uint256 to);

    /**
     * _temporaryBan user
     *
     * @param _user address to be banned
     *
     * @custom:event UserBanned
     */
    function _temporaryBan(address _user) internal {
        StoragePenalty storage s1 = _storagePenalty();
        uint256 banUntil = block.timestamp + s1.banDuration;
        s1.userToBanEndTimestamp[_user] = banUntil;

        emit UserBanned(_user, block.timestamp, banUntil);
    }
}
