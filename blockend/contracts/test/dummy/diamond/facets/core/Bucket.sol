// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.2;

import "../../libraries/core/LibBucket.sol";

import "../../interfaces/IHubLibraryEvents.sol";

contract Bucket is IHubLibraryEvents {
    // event StoreBucket(uint256 newValue);

    function storeBucket(uint256 newValue) external {
        LibBucket._bucketIt(newValue);

        // emit StoreBucket(newValue);
    }

    function retrieveBucket() external view returns (uint256) {
        return LibBucket._storageBucket().value1;
    }
}
