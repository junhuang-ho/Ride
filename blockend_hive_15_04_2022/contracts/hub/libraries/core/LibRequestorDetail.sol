//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "./LibRater.sol";
import "../../libraries/utils/LibAccessControl.sol";

library LibRequestorDetail {
    bytes32 constant STORAGE_POSITION_REQUESTORDETAIL =
        keccak256("ds.requestordetail");

    /**
     * lifetime cumulative values of Requestors
     */
    struct RequestorDetail {
        uint256 countStart;
        uint256 countEnd;
    }

    struct StorageRequestorDetail {
        mapping(address => RequestorDetail) requestorToRequestorDetail;
    }

    function _storageRequestorDetail()
        internal
        pure
        returns (StorageRequestorDetail storage s)
    {
        bytes32 position = STORAGE_POSITION_REQUESTORDETAIL;
        assembly {
            s.slot := position
        }
    }

    /**
     * _calculateScore calculates score from requestor's reputation detail (see params of function)
     *
     *
     * @return Requestor's score | unitless integer
     *
     * Derive Requestor's Score Formula:-
     *
     */
    function _calculateRequestorScore(address _requestor)
        internal
        view
        returns (uint256)
    {
        StorageRequestorDetail storage s1 = _storageRequestorDetail();

        uint256 countStart = s1
            .requestorToRequestorDetail[_requestor]
            .countStart;
        uint256 countEnd = s1.requestorToRequestorDetail[_requestor].countEnd;

        if (countStart == 0) {
            return 0;
        } else {
            return countEnd / countStart;
        }
    }
}
