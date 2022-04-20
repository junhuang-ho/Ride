//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibRequesterDetail.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract RequesterDetail is IHubLibraryEvents {
    function getRequesterToRequesterDetail(address _requester)
        external
        view
        returns (LibRequesterDetail.RequesterDetail memory)
    {
        return
            LibRequesterDetail
                ._storageRequesterDetail()
                .requesterToRequesterDetail[_requester];
    }

    function calculateRequesterScore(address _requester)
        external
        view
        returns (uint256)
    {
        return LibRequesterDetail._calculateRequesterScore(_requester);
    }
}
