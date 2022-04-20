//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../../hub/facets/core/RequesterDetail.sol";
import "../../../hub/libraries/core/LibRequesterDetail.sol";

contract TestRequesterDetail is RequesterDetail {
    function sRequesterToRequesterDetail_(address _requester)
        external
        view
        returns (LibRequesterDetail.RequesterDetail memory)
    {
        return
            LibRequesterDetail
                ._storageRequesterDetail()
                .requesterToRequesterDetail[_requester];
    }

    function ssRequesterToRequesterDetail_(
        address _requester,
        uint256 _countStart,
        uint256 _countEnd
    ) external {
        LibRequesterDetail.StorageRequesterDetail
            storage s1 = LibRequesterDetail._storageRequesterDetail();

        s1.requesterToRequesterDetail[_requester].countStart = _countStart;
        s1.requesterToRequesterDetail[_requester].countEnd = _countEnd;
    }

    function calculateRequesterScore_(address _requester)
        external
        view
        returns (uint256)
    {
        return LibRequesterDetail._calculateRequesterScore(_requester);
    }
}
