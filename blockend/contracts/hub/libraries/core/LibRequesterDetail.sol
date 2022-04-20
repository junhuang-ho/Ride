//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "./LibRater.sol";
import "../../libraries/utils/LibAccessControl.sol";

library LibRequesterDetail {
    bytes32 constant STORAGE_POSITION_REQUESTORDETAIL =
        keccak256("ds.requesterdetail");

    /**
     * lifetime cumulative values of Requesters
     */
    struct RequesterDetail {
        uint256 countStart;
        uint256 countEnd;
    }

    struct StorageRequesterDetail {
        mapping(address => RequesterDetail) requesterToRequesterDetail;
    }

    function _storageRequesterDetail()
        internal
        pure
        returns (StorageRequesterDetail storage s)
    {
        bytes32 position = STORAGE_POSITION_REQUESTORDETAIL;
        assembly {
            s.slot := position
        }
    }

    /**
     * _calculateScore calculates score from requester's reputation detail (see params of function)
     *
     *
     * @return Requester's score | unitless integer
     *
     * Derive Requester's Score Formula:-
     *
     */
    function _calculateRequesterScore(address _requester)
        internal
        view
        returns (uint256)
    {
        StorageRequesterDetail storage s1 = _storageRequesterDetail();

        uint256 countStart = s1
            .requesterToRequesterDetail[_requester]
            .countStart;
        uint256 countEnd = s1.requesterToRequesterDetail[_requester].countEnd;

        if (countStart == 0) {
            return 0;
        } else {
            return countEnd / countStart;
        }
    }
}
