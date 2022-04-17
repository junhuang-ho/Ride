//SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibRequestorDetail.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract RequestorDetail is IHubLibraryEvents {
    function getRequestorToRequestorDetail(address _requestor)
        external
        view
        returns (LibRequestorDetail.RequestorDetail memory)
    {
        return
            LibRequestorDetail
                ._storageRequestorDetail()
                .requestorToRequestorDetail[_requestor];
    }

    function calculateRequestorScore(address _requestor)
        external
        view
        returns (uint256)
    {
        return LibRequestorDetail._calculateRequestorScore(_requestor);
    }
}
