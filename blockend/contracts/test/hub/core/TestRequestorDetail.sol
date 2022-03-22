//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/RequestorDetail.sol";
import "../../../hub/libraries/core/LibRequestorDetail.sol";

contract TestRequestorDetail is RequestorDetail {
    function sRequestorToRequestorDetail_(address _requestor)
        external
        view
        returns (LibRequestorDetail.RequestorDetail memory)
    {
        return
            LibRequestorDetail
                ._storageRequestorDetail()
                .requestorToRequestorDetail[_requestor];
    }

    function ssRequestorToRequestorDetail_(
        address _requestor,
        uint256 _countStart,
        uint256 _countEnd
    ) external {
        LibRequestorDetail.StorageRequestorDetail
            storage s1 = LibRequestorDetail._storageRequestorDetail();

        s1.requestorToRequestorDetail[_requestor].countStart = _countStart;
        s1.requestorToRequestorDetail[_requestor].countEnd = _countEnd;
    }

    function calculateRequestorScore_(address _requestor)
        external
        view
        returns (uint256)
    {
        return LibRequestorDetail._calculateRequestorScore(_requestor);
    }
}
