# Ride - Decentralized Ride-Hailing Platform

### RIDE - Right Implementation of Decentralized e-Hailing


concepts: https://drive.google.com/file/d/1X_cKidSHa8rusZzfMmBAWRBCW4Max90r/view?usp=sharing

wallet concept: https://drive.google.com/file/d/1Ck_wjPYNB9G-w7sXwUZpCdCkmnnQFH1T/view?usp=sharing

useful links:

https://rinkeby.etherscan.io/

https://eth-converter.com/

https://www.epochconverter.com/

## Testing
```
~$ cd blockend
~$ npx hardhat test
```
or for a summary of contract test coverage
```
~$ cd backend
~$ npx hardhat coverage
```

## Helpful Tasks

1. check contract size
```
~$ yarn run hardhat size-contracts
```

## gas efficiency tests

1. for getter fn vs no getter fn
```
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

library TestLib {
    bytes32 constant STORAGE_POSITION_BADGE = keccak256("ds.badge");

    struct StorageBadge {
        mapping(uint256 => uint256) badgeToBadgeMaxScore;
    }

    function _storageBadge() internal pure returns (StorageBadge storage s) {
        bytes32 position = STORAGE_POSITION_BADGE;
        assembly {
            s.slot := position
        }
    }

    function _setBadgeToBadgeMaxScore(uint256 _index, uint256 _value) internal {
        StorageBadge storage s1 = _storageBadge();
        s1.badgeToBadgeMaxScore[_index] = _value;
    }

    function _getBadgeMaxScore(uint256 _badge) internal view returns (uint256) {
        return _storageBadge().badgeToBadgeMaxScore[_badge];
    }
}

contract Test1 {
    function getBadgeMaxScore1(uint256 _badge) external view returns (uint256) {
        return TestLib._storageBadge().badgeToBadgeMaxScore[_badge];
    }
}

contract Test2 {
    function getBadgeMaxScore1(uint256 _badge) external view returns (uint256) {
        return TestLib._getBadgeMaxScore(_badge);
    }
}
// Deploy Test1: 135019 gas
// Deploy Test2: 138901 gas

// Execute Test1: 24004 gas
// Execute Test2: 24047 gas
```
