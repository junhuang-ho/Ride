# Ride - Decentralized Ride-Hailing Platform

### RIDE - Right Implementation of Decentralized e-Hailing


concepts: https://drive.google.com/file/d/1X_cKidSHa8rusZzfMmBAWRBCW4Max90r/view?usp=sharing

wallet concept: https://drive.google.com/file/d/1Ck_wjPYNB9G-w7sXwUZpCdCkmnnQFH1T/view?usp=sharing

useful links:

https://rinkeby.etherscan.io/

https://eth-converter.com/

https://www.epochconverter.com/

wallet integrate with Polygon: https://docs.polygon.technology/docs/integrate/quickstart/

EIP1559 way of sending transactions for wallet: https://docs.polygon.technology/docs/develop/eip1559-transactions/how-to-send-eip1559-transactions

Polygon gas station: https://docs.polygon.technology/docs/develop/tools/polygon-gas-station

in addition to google maps, check out 
1. HERE we go (strong competitor to google maps): https://developer.here.com/
2. 2. OpenStreetMaps (open source maps): https://www.openstreetmap.org/#map=7/3.464/101.635

### RIDE Token Specs

 1. ERC20
 2. ERC20Permit (single transaction)
 3. ERC20Votes (governance compatible)
 4. Non-Upgradable (no proxy, no diamond)
 5. if want extend functionality in future, use ERC20Wrapper
 
Typical way to increase allowance is to call approve more than once. Safe way to do is call approve then increaseAllowance/decreaseAllowance.

TODOs:

1. ERC20: Test if can straight away call increaseAllowance/decreaseAllowance on first call.
2. ERC20Permit: Test permit actually transfers/deposits the token into "calling contract".
3. ERC20Permit: Test if calling increaseAllowance/decreaseAllowance works with permit as well? i.e calling permit then increase/decrease.
4. ERC20Permit: can just call permit multiple times to act as increasing allowance as well? (besides transferring)
5. Change RideHub to use SafeERC20/SafeERC20Permit libraries.
6. Implement RIDE Token Specs as above.
7. ERC20Votes: Test governance on Box.sol.

8. Study if need add special functions to Ride.sol if in future want make it mappable/bridgeable to Ethereum: https://docs.polygon.technology/docs/develop/ethereum-polygon/mintable-assets#what-are-the-requirements-to-be-satisfied
Ans: yes need add special fns, and need a child contract in Ethereum as well.
Ans2: this is like ERC20Wrapper?

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

1. internal getter fn vs no internal getter fn (concept applies beyond internal fns)
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
